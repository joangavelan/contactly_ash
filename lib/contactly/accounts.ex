defmodule Contactly.Accounts do
  use Ash.Domain,
    otp_app: :contactly

  resources do
    resource Contactly.Accounts.Token
    resource Contactly.Accounts.User
  end
end
