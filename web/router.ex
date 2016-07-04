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
    resources "/users", UserController

  end

  # use scope like a resoure
  scope "/hello", GdPush do
    pipe_through :browser

    get "/", HelloController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", GdPush do
    pipe_through :api
    scope "/V1", V1 do
      resources "/books", BookController #, except: [:new, :edit]
    end
    resources "/books", BookController #, except: [:new, :edit]
  end
end
