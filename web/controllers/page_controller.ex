defmodule GdPush.PageController do
  use GdPush.Web, :controller
  require Logger

  def index(conn, _params) do
    render conn, "index.html"
  end
end
