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

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
  end

  scope "/", XpendrWeb do
    pipe_through :browser

    get "/", PageController, :index

    scope "/" do
      pipe_through :protected

      resources "/users", UserController, except: [:index]
      get "/user/show", UserController, :show
      get "/user/edit", UserController, :edit
      put "/user", UserController, :update
      resources "/wallets", WalletController
      resources "/transactions", TransactionController
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", XpendrWeb do
  #   pipe_through :api
  # end
end
