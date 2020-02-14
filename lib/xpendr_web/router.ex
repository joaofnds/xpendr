defmodule XpendrWeb.Router do
  use XpendrWeb, :router

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

  scope "/", XpendrWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/users", UserController
    resources "/wallets", WalletController
  end

  # Other scopes may use custom stacks.
  # scope "/api", XpendrWeb do
  #   pipe_through :api
  # end
end
