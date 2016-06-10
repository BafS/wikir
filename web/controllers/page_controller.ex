defmodule Wikir.PageController do
  use Wikir.Web, :controller

  alias Wikir.Version

  def index(conn, _params) do
    # Get last version of "wikir_main"
    version = Repo.one(from v in Version, where: v.title == "wikir_main", order_by: [desc: :updated_at], limit: 1)

    # If the page was never create, we put a default message
    if !version do
      version = %Version{title: "wikir_main", content: "<h1>Welcome to Wikir !</h1><h3>Please click on <em>edit</em> to create this page</h3>", article_id: 1}
    end

    render conn, "index.html", article: version
  end
end
