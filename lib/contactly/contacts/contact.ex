defmodule Contactly.Contacts.Contact do
  use Ash.Resource,
    otp_app: :contactly,
    domain: Contactly.Contacts,
    authorizers: [Ash.Policy.Authorizer],
    data_layer: AshPostgres.DataLayer

  postgres do
    table "contacts"
    repo Contactly.Repo

    references do
      reference :user, on_delete: :delete, index?: true
    end
  end

  actions do
    default_accept [:name, :email, :phone]
    defaults [:read, :destroy, update: :*]

    action :list_contacts, :map do
      argument :search, :string
      argument :sort, :string
      argument :page, :string, default: "1"

      run {Contactly.Actions.GenericListing,
           resource: __MODULE__, search_by: [:name], serializer: :serialize_contacts}
    end

    action :upload_csv_contacts, :struct do
      argument :file_path, :string, allow_nil?: false

      run fn input, context ->
        result =
          input.arguments.file_path
          |> File.stream!()
          |> CSV.decode!(headers: true)
          |> Ash.bulk_create(__MODULE__, :create_contact, actor: context.actor)

        if result.status == :success do
          {:ok, result}
        else
          {:error, result.errors}
        end
      end
    end

    action :generate_csv_contacts, :string do
      run fn input, context ->
        contacts = Ash.read!(__MODULE__, actor: context.actor)

        headers = ["name", "email", "phone"]
        rows = Enum.map(contacts, &[&1.name, &1.email, &1.phone])

        csv =
          [headers | rows]
          |> CSV.encode()
          |> Enum.join()

        {:ok, csv}
      end
    end

    create :create_contact do
      change set_attribute(:user_id, actor(:id))
    end

    read :get_contact do
      get_by :id
    end
  end

  policies do
    policy action_type(:create) do
      authorize_if relating_to_actor(:user)
    end

    policy action_type([:read, :destroy, :update]) do
      authorize_if relates_to_actor_via(:user)
    end

    policy action([:upload_csv_contacts, :generate_csv_contacts]) do
      authorize_if actor_present()
    end

    policy action(:list_contacts) do
      authorize_if actor_present()
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      public? true
      allow_nil? false
      constraints min_length: 2, max_length: 100
    end

    attribute :email, :ci_string do
      public? true
      allow_nil? false
    end

    attribute :phone, :string do
      public? true
      allow_nil? false
      constraints min_length: 9, max_length: 20
    end

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :user, Contactly.Accounts.User do
      allow_nil? false
    end
  end

  identities do
    identity :unique_email, [:email]
    identity :unique_phone, [:phone]
  end
end
