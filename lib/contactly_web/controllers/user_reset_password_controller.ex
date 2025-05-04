defmodule ContactlyWeb.UserResetPasswordController do
  use ContactlyWeb, :controller

  alias Contactly.Accounts
  alias Contactly.Accounts.User

  def new(conn, _params) do
    render_inertia(conn, "ForgotPassword")
  end

  def create(conn, params) do
    Accounts.request_password_reset_token(params)

    conn
    |> put_flash(
      :info,
      "If your email is in our system, you will receive an email with instructions to reset your password."
    )
    |> redirect(to: ~p"/login")
  end

  def edit(conn, %{"reset_token" => reset_token}) do
    conn
    |> assign_prop(:reset_token, reset_token)
    |> render_inertia("ResetPassword")
  end

  def update(conn, params) do
    with {:ok, claims, _resource} <- AshAuthentication.Jwt.verify(params["reset_token"], User),
         {:ok, user} <- Accounts.get_by_subject(%{subject: claims["sub"]}, authorize?: false),
         {:ok, _user} <- Accounts.reset_password_with_token(user, params, authorize?: false) do
      conn
      |> put_flash(:success, "Password reset successful.")
      |> redirect(to: ~p"/login")
    else
      {:error, %Ash.Error.Invalid{} = error} ->
        conn
        |> assign_errors(error)
        |> redirect(to: ~p"/password-reset/#{params["reset_token"]}")

      _ ->
        conn
        |> put_flash(:error, "The token is invalid or expired. Please request a new one.")
        |> redirect(to: ~p"/password-reset")
    end
  end
end
