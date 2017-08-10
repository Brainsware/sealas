defmodule SealasSso.Router do
  use SealasSso, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SealasSso do
    pipe_through :api

    resources "/user", UserController
  end
end
