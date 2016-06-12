defmodule Wikir.ArticleController do
  use Wikir.Web, :controller

  alias Wikir.Article
  alias Wikir.Version

  # plug :scrub_params, "article" when action in [:create, :update]

  def index(conn, _params) do
    versions = Repo.all from v in Version, group_by: v.article_id, preload: [:user]
    render(conn, "index.html", versions: versions)
  end

  def new(conn, _params) do

    # IO.inspect _params
    # case _params do
      # {:title, _params} -> ptitle = "aaa"
    # end
    # if _params do
    #   %{ "title" => ptitle } = _params
    # end
    # #
    # unless ptitle do
    # end

    changeset = Article.changeset(%Version{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"version" => article_params}) do
    changeset = Article.changeset(%Article{}, article_params)

    case Repo.insert(changeset) do
      {:ok, _article} ->
          #article = Repo.one(from a in Article, where: a.title == ^article_params[:title])
          article_params = Map.put(article_params, "article_id", _article.id)

          # If a user is logged, we add `user_id`
          if current_user(conn) do
            article_params = Map.put(article_params, "user_id", current_user(conn).id)
            IO.inspect article_params
          end

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
    title = URI.decode_www_form(title)

    # Get last version (by updated_at)
    version_last = Repo.one(from v in Version, where: v.title == ^title, order_by: [desc: :updated_at], limit: 1)

    unless version_last do
      conn
      |> redirect(to: article_path(conn, :new))
    end

    render(conn, "show.html", version: version_last)
  end

  def edit(conn, %{"id" => title}) do
    title = URI.decode_www_form(title)
    version_last = Repo.one(from v in Version, where: v.title == ^title, order_by: [desc: :updated_at], limit: 1)

    unless version_last do
      conn
      |> redirect(to: article_path(conn, :new))
    end

    article = Repo.get!(Article, version_last.article_id)

    changeset = Version.changeset version_last

    render conn, "edit.html", article: article, changeset: changeset
  end

  def update(conn, %{"id" => id, "version" => article_params}) do
    article = Repo.get!(Article, id)
    version_last = Repo.one(from v in Version, where: v.article_id == ^id, order_by: [desc: :updated_at], limit: 1)
    article_params = Map.put(article_params, "article_id", id)

    # If a user is logged, we add `user_id`
    if current_user(conn) do
      article_params = Map.put(article_params, "user_id", current_user(conn).id)
      IO.inspect article_params
    end

    changeset = Version.changeset(%Version{}, article_params)

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

  # None CRUD method

  # Show all version history
  def versions(conn, %{"title" => title}) do
    title = URI.decode_www_form(title)

    # Select the last version
    version_last = Repo.one from v in Version, where: v.title == ^title, order_by: [desc: :updated_at], limit: 1

    # Select all versions with the same article_id
    versions = Repo.all from v in Version, where: v.article_id == ^version_last.article_id, preload: [:user]

    render(conn, "versions.html", versions: versions)
  end

  # Show specific version
  def version(conn, %{"title" => title, "id" => id}) do
    version = Repo.one from v in Version, where: v.id == ^id

    render(conn, "version.html", version: version)
  end
end
