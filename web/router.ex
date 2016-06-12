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

    get    "/login",  SessionController, :new
    post   "/login",  SessionController, :create
    get    "/logout", SessionController, :delete
    delete "/logout", SessionController, :delete

    resources "/users", UserController

    get    "/wikir-list", ArticleController, :index
    get    "/:title/versions", ArticleController, :versions
    get    "/:title/versions/:id", ArticleController, :version
    resources "/", ArticleController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Wikir do
  #   pipe_through :api
  # end
end
