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

  # API scope
  scope "/api", Wikir do
    pipe_through :api

    resources "/stats", StatisticController
  end

  scope "/", Wikir do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get    "/login",  SessionController, :new
    post   "/login",  SessionController, :create
    get    "/logout", SessionController, :delete
    delete "/logout", SessionController, :delete

    resources "/users", UserController

    get    "/wikir-stats", StatisticController, :index
    get    "/wikir-list", ArticleController, :index
    get    "/:title/versions", ArticleController, :versions
    get    "/:title/versions/:id", ArticleController, :version
    get    "/:id/new", ArticleController, :new_title
    resources "/", ArticleController
  end
end
