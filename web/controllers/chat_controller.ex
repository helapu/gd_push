defmodule GdPush.ChatController do
  use GdPush.Web, :controller

  def index(conn, _params) do

    # conn = put_session(conn, :message, "new stuff we just set in the session")
    # message = get_session(conn, :message)
    # System.cmd "say", [message]
    render conn, "index.html"

  end

end
