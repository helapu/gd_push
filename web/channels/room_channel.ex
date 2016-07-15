defmodule GdPush.RoomChannel do
  use Phoenix.Channel
  require Logger

  intercept ["new:msg"]

  def join("rooms:plan", payload, socket) do
    # 验证账户
    Logger.debug "join uuid: #{payload["uuid"]}, token: #{payload["token"]}"
    Logger.debug "join others: #{payload["body"]} #{payload["subject"]}"
    Logger.debug "ios: #{payload["message"]} #{payload["subject"]}"

    :timer.send_interval(5000, :ping)

    socket = assign(socket, :uuid, payload["uuid"])
    socket = assign(socket, :token, payload["token"])

    send(self, :after_join)
    {:ok, socket}

    # if true do
    #   send(self, :after_join)
    #   {:ok, socket}
    # else
    #   push socket, "error", %{error: "哎呀，你的用户名或者密码错啦"}
    #   {:error , %{reason: "用户名错误"}}
    # end
  end

  def join("rooms:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_info(:after_join, socket) do
    Logger.debug "room channel after join"
    push socket, "join", %{token: "uoeu--oeuseousuh4390heuoeubuoeueo"} # 这里可以返回udid登陆令牌
    push socket, "system", %{user: "SYSTEM", body: "ping"}

    {:ok, conn} = Redix.start_link()
    {:ok, cnt} = Redix.command(conn, ~w(INCR WebSocket))
    broadcast! socket, "count:online", %{online: cnt} # 通知所有连接，更新在线数

    {:noreply, socket}
  end

  def handle_info(:ping, socket) do
    push socket, "heartbeat", %{fromuuid: "SYSTEM", body: "ping"}
    {:noreply, socket}
  end

  def terminate(reason, socket) do
    Logger.debug"> leave #{inspect reason}"
    {:ok, conn} = Redix.start_link()
    {:ok, cnt} = Redix.command(conn, ~w(DECR WebSocket))
    broadcast! socket, "count:online", %{online: cnt}

    :ok
  end

  def handle_in("new:msg", payload, socket) do
    Logger.debug "收到客户端的信息: #{payload["fromuuid"]} -- #{payload["touuid"]} -- #{payload["msg"]}"
    broadcast! socket, "new:msg", payload
    {:reply, {:ok,  payload }, socket}
  end


  def handle_in("heartbeat", payload, socket) do
    # 回应客户端，服务器还在干活滴
    push socket, "heartbeat", %{user: "SYSTEM"}
    {:reply, {:ok,  payload }, socket}
  end


  def handle_out("new:msg", payload, socket) do
    from = payload["fromuuid"]
    uid = socket.assigns[:uuid]
    touser = payload["touuid"]
    msg = payload["msg"]

    Logger.debug "from: #{from}, uid: #{uid},  touser: #{touser}, msg: #{msg}"

    if from == "SYSTEM" do
      push socket, "heartbeat", payload
      {:noreply, socket}
    end

    if uid == touser or from == uid do
      push socket, "new:msg", payload
      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end

end
