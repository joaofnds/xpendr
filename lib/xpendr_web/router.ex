defmodule XpendrWeb.Router do
  use XpendrWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :auth do
    plug XpendrWeb.SessionManager.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", XpendrWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index

    resources "/users", UserController, only: [:new, :create]
    get "/login", SessionController, :new
    post "/login", SessionController, :login
    get "/logout", SessionController, :logout
  end

  scope "/", XpendrWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    resources "/users", UserController, except: [:new, :create]
    resources "/wallets", WalletController
    resources "/transactions", TransactionController
  end
end
