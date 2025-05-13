defmodule Contactly.Pagination do
  def build_pagination(current_page, total_pages) do
    cond do
      total_pages <= 5 ->
        Enum.to_list(1..total_pages)

      current_page <= 3 ->
        [1, 2, 3, 4, :ellipsis, total_pages]

      current_page >= total_pages - 2 ->
        [1, :ellipsis, total_pages - 3, total_pages - 2, total_pages - 1, total_pages]

      true ->
        [1, :ellipsis, current_page - 1, current_page, current_page + 1, :ellipsis, total_pages]
    end
  end
end
