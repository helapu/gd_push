defmodule GdPush.WechatController do
  use GdPush.Web, :controller
  require Logger

  def index(conn, _params) do
    # 根据不同的ID显示不同的QA
    ua = get_req_header(conn, "user-agent")
    Logger.debug "user-agent #{ua}"

    if String.match? "#{ua}", ~r/MicroMessenger/ do
      conn
      |> put_layout("wechat.html")
      |>render("index.html")
    else
      conn
      |> put_layout("wechat.html")
      |>render("index.html")
      # |>render("onlymobile.html")
    end
  end

  def qa(conn, %{"qa" => qa}) do
    Logger.debug "answer #{qa}"
    conn
  end

  def qa(conn, _params) do
    conn
    |> put_layout("wechat.html")
    |> render("qa.html")
  end

  def statistics(conn, _params) do
    conn
    |> put_layout("wechat.html")
    |> render("statistics.html", result: "你好")
  end
end
