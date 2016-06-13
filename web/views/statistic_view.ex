defmodule Wikir.StatisticView do
  use Wikir.Web, :view

  def render("show.json", %{users: users, articles: articles, versions: versions}) do
    %{users: length(users),
      articles: length(articles),
      versions: length(versions)}
  end
end
