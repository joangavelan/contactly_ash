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
