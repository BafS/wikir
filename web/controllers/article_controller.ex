defmodule Wikir.ArticleController do
  use Wikir.Web, :controller

  alias Wikir.Article
  alias Wikir.Version

  # plug :scrub_params, "article" when action in [:create, :update]

  def index(conn, _params) do
    articles = Repo.all(Article)
    versions = Repo.all(Version)
    render(conn, "index.html", articles: versions)
  end

  def new(conn, _params) do
    changeset = Article.changeset(%Article{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"article" => article_params}) do
    changeset = Article.changeset(%Article{}, article_params)

    case Repo.insert(changeset) do
      {:ok, _article} ->
          #article = Repo.one(from a in Article, where: a.title == ^article_params[:title])
          article_params = Map.put(article_params, "article_id", _article.id)
          changeset2 = Version.changeset(%Version{}, article_params)
          Repo.insert(changeset2)
        conn
        |> put_flash(:info, "Article created successfully.")
        |> redirect(to: article_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => title}) do
    # Get last version (by updated_at)
    version = Repo.one(from v in Version, where: v.title == ^title, order_by: [desc: :updated_at], limit: 1)

    render(conn, "show.html", version: version)
  end

  def edit(conn, %{"id" => title}) do
    version_last = Repo.one(from v in Version, where: v.title == ^title, order_by: [desc: :updated_at], limit: 1)
    article = Repo.get!(Article, version_last.article_id)

    changeset = Version.changeset(version_last)

    render(conn, "edit.html", version: version_last, article: article, changeset: changeset)
  end

  def update(conn, %{"id" => id, "version" => article_params}) do
    article = Repo.get!(Article, id)
    version_last = Repo.one(from v in Version, where: v.article_id == ^id, order_by: [desc: :updated_at], limit: 1)
    article_params = Map.put(article_params, "article_id", id)
    IO.puts ">> DEBUG <<"
    IO.inspect article_params
    changeset = Version.changeset(%Version{}, article_params)
    # changeset = Article.changeset(article, article_params)

    # Version.new(conn, %{"id" => id, "article" => article_params})
    # Repo.insert!(%Version{title: "Main", content: "# Main page with updated content"})

    case Repo.insert(changeset) do
      {:ok, article} ->
        conn
        |> put_flash(:info, "Article updated successfully.")
        |> redirect(to: article_path(conn, :show, article.title))
      {:error, changeset} ->
        render(conn, "edit.html", article: article, version: version_last, changeset: changeset)
        # render(conn, "edit.html", article: article, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    article = Repo.get!(Article, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(article)

    conn
    |> put_flash(:info, "Article deleted successfully.")
    |> redirect(to: article_path(conn, :index))
  end
end
