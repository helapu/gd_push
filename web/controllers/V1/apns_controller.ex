defmodule  GdPush.V1.ApnsController do
  use GdPush.Web, :controller
  require Logger
  alias GdPush.Device



  def connect(conn, connect_params) do
    # 更新设备的token
    token = connect_params["token"]
    uid = connect_params["uid"]

    Logger.debug "device_token: #{token}"
    Logger.debug "uid: #{uid}"

    device_params = %{uid: uid, token: token}

    query = from u in Device,
      where: u.uid == ^uid,
      select: u
    device =  Repo.one(query)
    Logger.debug "#{device.uid}"
    Logger.debug "#{device.token}"

    changeset = Device.changeset(device, device_params)

    case Repo.update(changeset) do
      {:ok, device} ->
        Logger.debug "update successfully"
      {:error, changeset} ->
        Logger.debug "updaet failed"
        render(conn, "edit.html", device: device, changeset: changeset)
    end

    send_resp(conn, :no_content, "")
  end

  def push(conn, push_params) do
    Logger.debug("开始推送")

    token = push_params["push"]["device_token"]
    alert_body = push_params["push"]["alert_body"]
    Logger.debug "device_token: #{token}"
    Logger.debug "alert_body: #{alert_body}"

    message = APNS.Message.new
    message = message
    |> Map.put(:token, "#{token}")
    |> Map.put(:alert, "#{alert_body}")
    |> Map.put(:badge, 42)
    |> Map.put(:extra, %{
      "var1" => "val1",
      "var2" => "val2"
    })
    APNS.push :app1_dev_pool, message

    send_resp(conn, :no_content, "")

  end
end
