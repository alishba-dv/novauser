

defmodule ApiWeb.UserJSON do
  def usercreated(%{message: message, status: status}) do
    %{
      status: status,
      message: message
    }
  end

  def viewusers(%{users: %{users: users}}) when is_list(users) do
    %{
      status: "Success",
      message: "Fetched users successfully",
      users: Enum.map(users, fn u ->
        u
        |> Map.from_struct()
        |> Map.take([:name, :email, :role,:business])
      end)

    }
  end

  def viewusers((%{users: %{error: message}})) do
    %{message: message}
  end



end
