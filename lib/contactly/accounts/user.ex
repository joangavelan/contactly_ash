defmodule Contactly.Accounts.User do
  use Ash.Resource,
    otp_app: :contactly,
    domain: Contactly.Accounts,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [AshAuthentication],
    data_layer: AshPostgres.DataLayer

  authentication do
    add_ons do
      log_out_everywhere do
        apply_on_password_change? true
      end

      confirmation :confirm_new_user do
        monitor_fields [:email]
        confirm_on_create? true
        confirm_on_update? false
        require_interaction? true
        confirmed_at_field :confirmed_at
        auto_confirm_actions [:reset_password_with_token]
        sender Contactly.Accounts.User.Senders.SendNewUserConfirmationEmail
      end
    end

    tokens do
      enabled? true
      token_resource Contactly.Accounts.Token
      signing_secret Contactly.Secrets
      store_all_tokens? true
      require_token_presence_for_authentication? true
    end

    strategies do
      password :password do
        identity_field :email
        sign_in_tokens_enabled? false
        require_confirmed_with :confirmed_at

        resettable do
          sender Contactly.Accounts.User.Senders.SendPasswordResetEmail
          # these configurations will be the default in a future release
          password_reset_action_name :reset_password_with_token
          request_password_reset_action_name :request_password_reset_token
        end
      end
    end
  end

  postgres do
    table "users"
    repo Contactly.Repo
  end

  actions do
    defaults [:read, :update]

    read :get_by_subject do
      description "Get a user by the subject claim in a JWT"
      argument :subject, :string, allow_nil?: false
      get? true
      prepare AshAuthentication.Preparations.FilterBySubject
    end

    update :change_password do
      # Use this action to allow users to change their password by providing
      # their current password and a new password.

      require_atomic? false
      accept []
      argument :current_password, :string, sensitive?: true, allow_nil?: false

      argument :password, :string,
        sensitive?: true,
        allow_nil?: false,
        constraints: [min_length: 8, max_length: 72]

      argument :password_confirmation, :string, sensitive?: true, allow_nil?: false

      validate confirm(:password, :password_confirmation)

      validate {AshAuthentication.Strategy.Password.PasswordValidation,
                strategy_name: :password, password_argument: :current_password}

      change {AshAuthentication.Strategy.Password.HashPasswordChange, strategy_name: :password}
    end

    read :sign_in_with_password do
      description "Attempt to sign in using a email and password."
      get? true

      argument :email, :ci_string do
        description "The email to use for retrieving the user."
        allow_nil? false
      end

      argument :password, :string do
        description "The password to check for the matching user."
        allow_nil? false
        sensitive? true
      end

      # validates the provided email and password and generates a token
      prepare AshAuthentication.Strategy.Password.SignInPreparation

      metadata :token, :string do
        description "A JWT that can be used to authenticate the user."
        allow_nil? false
      end
    end

    create :register_with_password do
      description "Register a new user with a email and password."

      argument :first_name, :string do
        allow_nil? false
        constraints min_length: 3, max_length: 50
      end

      argument :last_name, :string do
        allow_nil? false
        constraints min_length: 3, max_length: 50
      end

      argument :email, :ci_string do
        allow_nil? false
      end

      argument :password, :string do
        description "The proposed password for the user, in plain text."
        allow_nil? false
        constraints min_length: 8, max_length: 72
        sensitive? true
      end

      argument :password_confirmation, :string do
        description "The proposed password for the user (again), in plain text."
        allow_nil? false
        sensitive? true
      end

      # Sets the first name from the argument
      change set_attribute(:first_name, arg(:first_name))

      # Sets the last name from the argument
      change set_attribute(:last_name, arg(:last_name))

      # Sets the email from the argument
      change set_attribute(:email, arg(:email))

      # Hashes the provided password
      change AshAuthentication.Strategy.Password.HashPasswordChange

      # Generates an authentication token for the user
      change AshAuthentication.GenerateTokenChange

      # validates that the password matches the confirmation
      validate AshAuthentication.Strategy.Password.PasswordConfirmationValidation

      metadata :token, :string do
        description "A JWT that can be used to authenticate the user."
        allow_nil? false
      end
    end

    action :request_password_reset_token do
      description "Send password reset instructions to a user if they exist."

      argument :email, :ci_string do
        allow_nil? false
      end

      # creates a reset token and invokes the relevant senders
      run {AshAuthentication.Strategy.Password.RequestPasswordReset, action: :get_user_by_email}
    end

    read :get_user_by_email do
      description "Looks up a user by their email"
      get? true

      argument :email, :ci_string do
        allow_nil? false
      end

      filter expr(email == ^arg(:email))
    end

    update :reset_password_with_token do
      argument :reset_token, :string do
        allow_nil? false
        sensitive? true
      end

      argument :password, :string do
        description "The proposed password for the user, in plain text."
        allow_nil? false
        constraints min_length: 8, max_length: 72
        sensitive? true
      end

      argument :password_confirmation, :string do
        description "The proposed password for the user (again), in plain text."
        allow_nil? false
        sensitive? true
      end

      # validates the provided reset token
      validate AshAuthentication.Strategy.Password.ResetTokenValidation

      # validates that the password matches the confirmation
      validate AshAuthentication.Strategy.Password.PasswordConfirmationValidation

      # Hashes the provided password
      change AshAuthentication.Strategy.Password.HashPasswordChange

      # Generates an authentication token for the user
      change AshAuthentication.GenerateTokenChange
    end
  end

  policies do
    bypass AshAuthentication.Checks.AshAuthenticationInteraction do
      authorize_if always()
    end

    policy action([
             :register_with_password,
             :sign_in_with_password,
             :request_password_reset_token,
             :get_user_by_email
           ]) do
      authorize_if always()
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :first_name, :string do
      allow_nil? false
      public? true
      constraints min_length: 3, max_length: 50
    end

    attribute :last_name, :string do
      allow_nil? false
      public? true
      constraints min_length: 3, max_length: 50
    end

    attribute :email, :ci_string do
      allow_nil? false
      public? true
    end

    attribute :hashed_password, :string do
      allow_nil? false
      sensitive? true
    end

    attribute :confirmed_at, :utc_datetime_usec

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  identities do
    identity :unique_email, [:email]
  end
end
