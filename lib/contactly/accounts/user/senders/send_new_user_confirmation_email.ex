defmodule Contactly.Accounts.User.Senders.SendNewUserConfirmationEmail do
  @moduledoc """
  Sends an email for a new user to confirm their email address.
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
    |> subject("Confirm your email address")
    |> html_body(body(token: token))
    |> Mailer.deliver!()
  end

  defp body(params) do
    url = url(~p"/confirm-user/#{params[:token]}")

    """
    <p>Click this link to confirm your email:</p>
    <p><a href="#{url}">#{url}</a></p>
    """
  end
end
