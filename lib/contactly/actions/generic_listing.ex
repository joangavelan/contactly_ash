defmodule Contactly.Actions.GenericListing do
  use Ash.Resource.Actions.Implementation

  require Ash.Query

  import Ash.Expr

  @impl true
  def run(input, opts, context) do
    resource = opts[:resource]
    search_by = opts[:search_by]
    serializer = opts[:serializer]

    # Base query
    query = Ash.Query.new(resource)

    # Apply search filter if provided
    query =
      if search_query = input.arguments[:search] do
        filter = build_search_filter(search_by, search_query)
        Ash.Query.filter(query, ^filter)
      else
        query
      end

    # Apply sorting if provided
    query =
      if sort = input.arguments[:sort] do
        Ash.Query.sort_input(query, sort)
      else
        query
      end

    # Calculate pagination
    limit = 10
    current_page = input.arguments[:page] |> String.to_integer()
    offset = (current_page - 1) * limit

    # Apply pagination
    query = Ash.Query.page(query, limit: limit, offset: offset, count: true)

    # Execute the query
    case Ash.read(query, actor: context.actor) do
      {:ok, page} ->
        total_pages = ceil(page.count / page.limit)

        result = %{
          data: apply(ContactlyWeb.Serializers, serializer, [page.results]),
          pagination: Contactly.Pagination.build_pagination(current_page, total_pages)
        }

        {:ok, result}

      {:error, error} ->
        {:error, error}
    end
  end

  defp build_search_filter([key], search) do
    expr(
      contains(
        string_downcase(^ref(key)),
        string_downcase(^search)
      )
    )
  end

  defp build_search_filter(keys, search) when is_list(keys) do
    # Turn each key into an Ash.Expr.t()
    [first | rest] = Enum.map(keys, &build_search_filter([&1], search))

    # Fold them into one big OR expression
    Enum.reduce(rest, first, fn next_filter, acc ->
      expr(^acc or ^next_filter)
    end)
  end
end
