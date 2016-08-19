defmodule GithubWebhooks.GithubValidiator do
  import Plug.Conn

  def init(options), do: options
  def call(conn, options) do
    validate_github(conn, options)
  end

  def validate_github(conn, options) do
   IO.inspect get_signature(conn)
  end

  def get_signature(conn) do
    case get_req_header(conn, "x-hub-signature") do
      ["sha1=" <> signature] -> signature
      _ -> "no signature"
    end
  end
end
