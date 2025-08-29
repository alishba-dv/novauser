defmodule Api.Auth.ErrorHandler do
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, reason}, _opts) do
    body = Jason.encode!(%{error: to_string(type), message: to_string(reason)})
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, body)
  end
end
