defmodule ContactlyWeb.Serializers do
  def serialize_user(user) when is_map(user) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email
    }
  end

  def serialize_user(_), do: nil

  def serialize_contact(contact) when is_map(contact) do
    %{
      id: contact.id,
      name: contact.name,
      email: contact.email,
      phone: contact.phone
    }
  end

  def serialize_contacts(contacts) when is_list(contacts) do
    Enum.map(contacts, &serialize_contact/1)
  end
end
