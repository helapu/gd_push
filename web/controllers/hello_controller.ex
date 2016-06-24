defmodule GdPush.HelloController do
  use GdPush.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def show(conn, %{"messenger" => messenger}) do
    conn
    |> put_flash(:info, "你好，欢迎登陆Hello")
    |> render "show.html", messenger: messenger
    #
    # |> put_status(404)
    # |> send_resp(404, "You com to the lonely island")
  end

end
