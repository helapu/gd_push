defmodule GdPush.WechatView do
  use GdPush.Web, :view

  def local_ip() do
    # a is tuple {192,168,0,1}
    {:ok, [{ip_t, _, _}| _] } = :inet.getif
    ip_t |> Tuple.to_list |> Enum.join(".")
  end
end
