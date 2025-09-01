defmodule Api.Auth.Guardian do
  use Guardian, otp_app: :api

  alias Data.Schema.User
  alias Data.Repo

  def subject_for_token(%User{id: id}, _claims) do
    IO.puts(id)
    {:ok, to_string(id)}
  end

  def subject_for_token(_, _) do
    {:error, :invalid_resource}
  end
  def resource_from_claims(%{"sub" => id}) do
    IO.puts("ID #{id}")
    id = String.to_integer(id)  # convert token sub back to integer
    case Repo.get(User, id) do
      nil ->
        IO.puts("No user found with ID #{id}")
        {:error, :no_resource_found}
      user -> {:ok, user}
    end
  end

end
