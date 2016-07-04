defmodule GdPush.RoomChannel do
  use Phoenix.Channel
  require Logger

  def join("rooms:boom", msg, socket) do
    Logger.debug "room channel join #{msg["user"]}"
    if msg["user"] == "helapu" do
      send(self, :after_join)
      {:ok, socket}
    else
      {:error , %{reason: "用户名错误"}}
    end

  end

  def join("rooms:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_info(:after_join, socket) do
    Logger.debug "room channel after join"
    push socket, "join", %{status: "connected"}
    push socket, "new:msg", %{user: "SYSTEM", body: "ping"}

    {:ok, conn} = Redix.start_link()
    {:ok, cnt} = Redix.command(conn, ~w(INCR WebSocket))
    broadcast! socket, "count:online", %{online: cnt}

    {:noreply, socket}
  end

  def terminate(reason, socket) do
    Logger.debug"> leave #{inspect reason}"
    {:ok, conn} = Redix.start_link()
    {:ok, cnt} = Redix.command(conn, ~w(DECR WebSocket))
    broadcast! socket, "count:online", %{online: cnt}

    :ok
  end

  def handle_in("new:msg", msg, socket) do
    # Logger.debug "收到客户端的信息: #{msg["user"]} -- #{msg["body"]}"
    # System.cmd "say", ["收到 #{msg["user"]} 的消息 #{msg["body"]} "]

    broadcast! socket, "new:msg", %{user: msg["user"], body: msg["body"]}
    {:reply, {:ok, %{msg: msg["body"]}}, assign(socket, :user, msg["user"])}
  end

  def handle_out("new:msg", payload, socket) do
    push socket, "new:msg", payload
    {:noreply, socket}
  end

end
