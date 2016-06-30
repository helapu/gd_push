defmodule GdPush.RoomChannel do
  use Phoenix.Channel
  require Logger

  def join(_private, _message, socket) do
    Logger.debug "room channel join"
    send(self, :after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    Logger.debug "room channel after join"
    push socket, "join", %{status: "connected"}
    push socket, "new:msg", %{user: "SYSTEM", body: "ping"}

    {:noreply, socket}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    broadcast! socket, "new_msg", %{body: body}
    {:noreply, socket}
  end

  def handle_in("new:msg", msg, socket) do
    Logger.debug "收到客户端的信息: #{msg["user"]} -- #{msg["body"]}"

    broadcast! socket, "new:msg", %{user: msg["user"], body: msg["body"]}
    {:reply, {:ok, %{msg: msg["body"]}}, assign(socket, :user, msg["user"])}
  end

  def handle_out("new_msg", payload, socket) do
    push socket, "new_msg", payload
    {:noreply, socket}
  end

end
