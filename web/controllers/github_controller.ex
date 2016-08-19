defmodule GithubWebhooks.GithubController do
  use GithubWebhooks.Web, :controller
  require Logger

  def index(conn, params) do
    IO.inspect conn.private
    IO.inspect params
    text conn, "thanks, GitHub"
  end

end
