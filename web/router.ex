defmodule Wikir.Router do
  use Wikir.Web, :router

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

  scope "/", Wikir do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/", ArticleController

    resources "/users", UserController

    get    "/login",  SessionController, :new
    post   "/login",  SessionController, :create
    delete "/logout", SessionController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", Wikir do
  #   pipe_through :api
  # end
end
