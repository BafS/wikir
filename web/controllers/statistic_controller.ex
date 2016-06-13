defmodule Wikir.StatisticController do
  use Wikir.Web, :controller

  alias Wikir.User
  alias Wikir.Article
  alias Wikir.Version

  plug :action

  def index(conn, _params) do
    render conn
  end

  def show(conn, %{"id" => ressource}) do
    if ressource == "count" do
      users = Repo.all User
      articles = Repo.all Article
      versions = Repo.all Version
      render conn, users: users, articles: articles, versions: versions
    end
  end

end
