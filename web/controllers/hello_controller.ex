defmodule GdPush.HelloController do
  use GdPush.Web, :controller

  def index(conn, _params) do

    # conn = put_session(conn, :message, "new stuff we just set in the session")
    # message = get_session(conn, :message)
    # System.cmd "say", [message]

    conn
    |> put_flash(:info, message = "欢迎访问")
    |> render "index.html"

    # |> put_status(404)
    # |> send_resp(404, "You com to the lonely island")
  end

end
