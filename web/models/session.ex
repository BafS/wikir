defmodule Wikir.Session do
  alias Wikir.User

  def login(params, repo) do
    # TODO String.downcase
    user = repo.get_by(User, username: params["username"])
    case authenticate(user, params["password"]) do
      true -> {:ok, user}
      _    -> :error
    end
  end

  defp authenticate(user, password) do
    case user do
      nil -> false
      _   -> password == user.password
      # _   -> Comeonin.Bcrypt.checkpw(password, user.password) # TODO
    end
  end

  def current_user(conn) do
    id = Plug.Conn.get_session(conn, :current_user)
    if id, do: Wikir.Repo.get(User, id)
  end

  def logged_in?(conn), do: !!current_user(conn)
end
