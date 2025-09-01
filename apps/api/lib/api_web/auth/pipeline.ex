defmodule Api.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
      otp_app: :api,
      module: Api.Auth.Guardian,
      error_handler: Api.Auth.ErrorHandler

  # 1️⃣ Verify the token
  plug Guardian.Plug.VerifyHeader, scheme: "Bearer"
  # 2️⃣ Load the resource into `conn.assigns.current_user`
  plug Guardian.Plug.LoadResource
  # 3️⃣ Ensure the resource is present
  plug Guardian.Plug.EnsureAuthenticated
end
