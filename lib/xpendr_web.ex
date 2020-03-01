defmodule XpendrWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use XpendrWeb, :controller
      use XpendrWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: XpendrWeb

      import Plug.Conn
      import XpendrWeb.Gettext
      import Canary.Plugs
      import XpendrWeb.SessionManager.Plug, only: [halt_unauthorized: 2, halt_not_found: 2]

      alias XpendrWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/xpendr_web/templates",
        namespace: XpendrWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import XpendrWeb.ErrorHelpers
      import XpendrWeb.Gettext
      alias XpendrWeb.Router.Helpers, as: Routes
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
      import XpendrWeb.Absinthe, only: [put_absinthe_context: 2]
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import XpendrWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
