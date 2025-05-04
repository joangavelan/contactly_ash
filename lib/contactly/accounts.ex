defmodule Contactly.Accounts do
  use Ash.Domain,
    otp_app: :contactly

  resources do
    resource Contactly.Accounts.Token

    resource Contactly.Accounts.User do
      define :register_with_password
      define :sign_in_with_password
      define :request_password_reset_token
      define :reset_password_with_token
      define :get_user_by_email, args: [:email]
      define :get_by_subject
      define :change_password
    end
  end

  def generate_user_confirmation_token(user) do
    now = DateTime.utc_now()
    changeset = Ash.Changeset.for_update(user, :update, %{"confirmed_at" => now})

    Contactly.Accounts.User
    |> AshAuthentication.Info.strategy!(:confirm_new_user)
    |> AshAuthentication.AddOn.Confirmation.confirmation_token(changeset, user)
  end

  def confirm_user(token) do
    Contactly.Accounts.User
    |> AshAuthentication.Info.strategy!(:confirm_new_user)
    |> AshAuthentication.AddOn.Confirmation.Actions.confirm(%{"confirm" => token})
  end
end
