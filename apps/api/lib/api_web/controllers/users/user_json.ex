

defmodule ApiWeb.UserJSON do
  def usercreated(%{message: message, status: status}) do
    %{
      status: status,
      message: message
    }
  end

  def viewusers(%{users: %Scrivener.Page{} = page}) do

    if page.total_entries==0 do
      %{message: "No user found"}
    else
    %{
      status: "Success",
      message: "Fetched users successfully",
      users: Enum.map(page.entries, fn u ->
                                       u
                                       |> Map.take([:id, :name, :email, :role_name, :business_name])
      end),
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries
    }
  end
  end


  def getroles(%{roles: roles}) do
    %{
      status: :ok,
      roles: Enum.map(roles, fn u ->
        u
        |> Map.from_struct()
        |> Map.take([:id, :name, :description])
      end)
    }
  end

  def getbusiness(%{business: business}) do
    %{
      status: :ok,
      roles: Enum.map(business, fn u ->
        u
        |> Map.from_struct()
        |> Map.take([:id, :name])
      end)
    }
  end


  def viewusers((%{users: %{error: message}})) do
    %{message: message}
  end



end
