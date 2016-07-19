defmodule GdPush.PoliceController do
  use GdPush.Web, :controller
  require Logger

  def index(conn, _params) do

    render conn, "index.html"
  end

  def broadcast(conn, params) do
    GdPush.Endpoint.broadcast! "rooms:plan", "new:msg", params["broadcast"]

    send_resp(conn, :no_content, "")
  end
end
