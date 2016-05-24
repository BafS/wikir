defmodule Wikir.ArticleController do
  use Wikir.Web, :controller

  alias Wikir.Article

  plug :scrub_params, "article" when action in [:create, :update]

  def index(conn, _params) do
    articles = Repo.all(Article)
    render(conn, "index.html", articles: articles)
  end

  def new(conn, _params) do
    changeset = Article.changeset(%Article{})
    render(conn, "new.html", changeset: changeset)
  end

  def show(conn, %{"title" => title}) do
    query = from v in Wikir.Version, where: v.title == ^title, order_by: v.inserted_at
    #article = Repo.get!(Article, id)
    render(conn, "show.html", version: Wikir.Repo.one(query))
  end

  def edit(conn, %{"id" => id}) do
    article = Repo.get!(Article, id)
    changeset = Article.changeset(article)
    render(conn, "edit.html", article: article, changeset: changeset)
  end
end
