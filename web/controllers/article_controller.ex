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
    article = Repo.get!(Article, version.article_id)
    # article = Repo.all assoc(version, :article_id)
    # post = List.last(Repo.all(from(v in Version, where: v.title == ^title, order_by: [desc: v.updated_at])))
    # post = List.last(Repo.all(from(v in Version, where: v.title == ^title)))
    # post = List.last(Repo.all(from(v in Version, where: v.title == ^title)))
    # comments = Repo.all assoc(post, :comments)

    render(conn, "show.html", version: version, article: article)
  end

  def edit(conn, %{"id" => id}) do
    article = Repo.get!(Article, id)
    version_last = Repo.one(from v in Version, where: v.article_id == ^id, order_by: [desc: :updated_at], limit: 1)
    # versions = Repo.all assoc(article, :id)
    # version = Repo.all assoc(article.id, :article_id)

    changeset = Version.changeset(version_last)
    render(conn, "edit.html", article: article, version: version_last, changeset: changeset)
  end

  def update(conn, %{"id" => id, "version" => article_params}) do
    article = Repo.get!(Article, id)
    version_last = Repo.one(from v in Version, where: v.article_id == ^id, order_by: [desc: :updated_at], limit: 1)
    changeset = Version.changeset(version_last, article_params)
    # changeset = Article.changeset(article, article_params)

    # Version.new(conn, %{"id" => id, "article" => article_params})
    # Repo.insert!(%Version{title: "Main", content: "# Main page with updated content"})

    case Repo.update(changeset) do
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
