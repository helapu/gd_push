defmodule GdPush.HelloController do
  use GdPush.Web, :controller

  def index(conn, _params) do
    conn = put_session(conn, :message, "new stuff we just set in the session")
    render conn, "index.html"
  end

  def show(conn, %{"messenger" => messenger}) do
    conn
    |> put_flash(:info, message = get_session(conn, :message) )
    |> render "show.html", messenger: messenger
    #
    # |> put_status(404)
    # |> send_resp(404, "You com to the lonely island")
  end

end
