defmodule ContactlyWeb.Serializers do
  def serialize_user(user) when is_map(user) do
    Map.take(user, [:id, :first_name, :last_name, :email])
  end

  def serialize_user(_), do: nil

  def serialize_contact(contact) when is_map(contact) do
    Map.take(contact, [:id, :name, :email, :phone])
  end

  def serialize_contacts(contacts) when is_list(contacts) do
    Enum.map(contacts, &serialize_contact/1)
  end
end
