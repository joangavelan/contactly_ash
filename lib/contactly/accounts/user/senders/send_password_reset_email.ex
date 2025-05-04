defmodule Contactly.Accounts.User.Senders.SendPasswordResetEmail do
  @moduledoc """
  Sends a password reset email
  """
  use ContactlyWeb, :verified_routes
  use AshAuthentication.Sender

  import Swoosh.Email

  alias Contactly.Mailer

  @impl true
  def send(user, token, _opts) do
    new()
    |> from({"contactly", "support@contactly.test"})
    |> to(to_string(user.email))
    |> subject("Reset your password")
    |> html_body(body(token: token))
    |> Mailer.deliver!()
  end

  defp body(params) do
    url = url(~p"/password-reset/#{params[:token]}")

    """
    <p>Click this link to reset your password:</p>
    <p><a href="#{url}">#{url}</a></p>
    """
  end
end
