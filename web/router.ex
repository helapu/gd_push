defmodule GdPush.Router do
  use GdPush.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GdPush do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    scope "chat" do
      get "/", ChatController, :index
    end

    scope "/wechat" do
      get "/", WechatController, :index
      get "/qa", WechatController, :qa
      get "/statistics", WechatController, :statistics
    end

    scope "apns" do
      get "/police", PoliceController, :index
      post "/police", PoliceController, :broadcast
    end

    resources "/qaes", QaController, except: [:new, :edit]
    resources "/devices", DeviceController
  end

  # Other scopes may use custom stacks.
  scope "/api", GdPush do
    pipe_through :api

    scope "/apns", V1 do
      get "/", ApnsController, :connect
      post "/", ApnsController, :push
    end
  end

end
