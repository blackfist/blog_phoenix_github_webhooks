defmodule GithubWebhooks.GithubValidiator do
  import Plug.Conn

  def init(options), do: options
  def call(conn, options) do
    validate_github(conn, options)
  end

  def validate_github(conn, _options) do
   key = Application.get_env(:github_webhooks, :github_secret)
   body = conn.private.raw_body
   signature = get_signature(conn)
   hmac = :crypto.hmac(:sha, key, body) |> Base.encode16(case: :lower)

   case SecureCompare.compare(hmac, signature) do
     true -> IO.puts "Good signature from GitHub"
      conn
     _ -> IO.puts "Signature check failed"
      conn
      |> send_resp(401, "Not Authorized")
      |> halt
   end
  end

  def get_signature(conn) do
    case get_req_header(conn, "x-hub-signature") do
      ["sha1=" <> signature] -> signature
      _ -> "no signature"
    end
  end
end
