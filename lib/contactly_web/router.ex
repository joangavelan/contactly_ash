defmodule ContactlyWeb.Router do
  use ContactlyWeb, :router

  import ContactlyWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ContactlyWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug Inertia.Plug
  end

  scope "/", ContactlyWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/", ContactlyWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/register", UserRegistrationController, :new
    post "/register", UserRegistrationController, :create
    get "/successfully-registered", UserRegistrationController, :success
    get "/login", UserSessionController, :new
    post "/login", UserSessionController, :create
    get "/confirm-user", UserConfirmationController, :new
    post "/confirm-user", UserConfirmationController, :create
    get "/confirm-user/:token", UserConfirmationController, :edit
    put "/confirm-user/:token", UserConfirmationController, :update
    get "/password-reset", UserResetPasswordController, :new
    post "/password-reset", UserResetPasswordController, :create
    get "/password-reset/:reset_token", UserResetPasswordController, :edit
    put "/password-reset/:reset_token", UserResetPasswordController, :update
  end

  scope "/", ContactlyWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/contacts", ContactsController, :index

    get "/settings", UserSettingsController, :edit
    put "/settings", UserSettingsController, :update
  end

  scope "/", ContactlyWeb do
    pipe_through :browser

    delete "/logout", UserSessionController, :delete
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:contactly, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ContactlyWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
