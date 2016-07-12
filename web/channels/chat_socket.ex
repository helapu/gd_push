defmodule GdPush.ChatSocket do
  use Phoenix.Socket
  require Logger

  channel "rooms:*", GdPush.RoomChannel

  transport :websocket, Phoenix.Transports.WebSocket
  transport :longpoll, Phoenix.Transports.LongPoll

  def connect(_params, socket) do
    Logger.debug "conneting---- user socket"
    {:ok, socket}
  end
  def id(_socket), do: nil

end
