defmodule GithubWebhooks.Router do
  use GithubWebhooks.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", GithubWebhooks do
    pipe_through :api
    post "/github", GithubController, :index
  end
end
