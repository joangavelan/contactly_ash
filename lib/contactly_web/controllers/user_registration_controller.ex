defmodule ContactlyWeb.UserRegistrationController do
  use ContactlyWeb, :controller

  alias Contactly.Accounts

  def new(conn, _params) do
    render_inertia(conn, "Register")
  end

  def create(conn, params) do
    case Accounts.register_with_password(params) do
      {:ok, _user} ->
        conn
        |> redirect(to: ~p"/successfully-registered")

      {:error, error} ->
        conn
        |> assign_errors(error)
        |> redirect(to: ~p"/register")
    end
  end

  def success(conn, _params) do
    render_inertia(conn, "SuccessfullyRegistered")
  end
end
