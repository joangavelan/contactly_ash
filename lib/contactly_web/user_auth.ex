defmodule ContactlyWeb.UserAuth do
  use ContactlyWeb, :verified_routes
  use AshAuthentication.Phoenix.Router, only: [load_from_session: 2]

  import Phoenix.Controller
  import Plug.Conn
  import Inertia.Controller
  import ContactlyWeb.Serializers

  def fetch_current_user(conn, _opts) do
    conn
    |> load_from_session([])
    |> then(&assign_prop(&1, :current_user, serialize_user(&1.assigns.current_user)))
  end

  def log_in(conn, user) do
    conn
    |> AshAuthentication.Phoenix.Plug.store_in_session(user)
    |> put_flash(:success, "Welcome back!")
    |> redirect(to: ~p"/contacts")
  end

  def log_out(conn) do
    conn
    |> clear_session()
    |> Inertia.Controller.clear_history(true)
    |> redirect(to: ~p"/login")
  end

  def require_authenticated_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access this page.")
      |> redirect(to: "/login")
      |> halt()
    end
  end

  def redirect_if_user_is_authenticated(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: ~p"/contacts")
      |> halt()
    else
      conn
    end
  end
end
