defmodule XpendrWeb.Router do
  use XpendrWeb, :router
  use Pow.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated, error_handler: XpendrWeb.AuthErrorHandler
  end

  pipeline :not_authenticated do
    plug Pow.Plug.RequireNotAuthenticated, error_handler: XpendrWeb.AuthErrorHandler
  end

  scope "/", XpendrWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/", XpendrWeb do
    pipe_through [:browser]

    get "/signup", RegistrationController, :new, as: :signup
    post "/signup", RegistrationController, :create, as: :signup
    get "/login", SessionController, :new, as: :login
    post "/login", SessionController, :create, as: :login
    delete "/login", SessionController, :delete, as: :login
  end

  scope "/", XpendrWeb do
    pipe_through [:browser, :protected]

    resources "/users", UserController, except: [:index]
    get "/user/show", UserController, :show
    get "/user/edit", UserController, :edit
    put "/user", UserController, :update
    resources "/wallets", WalletController
    resources "/transactions", TransactionController
  end

  scope "/", XpendrWeb do
    pipe_through [:browser, :protected]

    delete "/logout", SessionController, :delete, as: :logout
  end
end
