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
end
