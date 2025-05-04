defmodule ContactlyWeb.UserSettingsController do
  use ContactlyWeb, :controller

  alias Contactly.Accounts

  def edit(conn, _params) do
    render_inertia(conn, "UserSettings")
  end

  def update(conn, params) do
    current_user = conn.assigns.current_user

    case Accounts.change_password(current_user, params, authorize?: false) do
      {:ok, _user} ->
        conn
        |> put_flash(:success, "Password updated successfully.")
        |> redirect(to: ~p"/contacts")

      {:error, error} ->
        conn
        |> assign_errors(error)
        |> redirect(to: ~p"/settings")
    end
  end
end
