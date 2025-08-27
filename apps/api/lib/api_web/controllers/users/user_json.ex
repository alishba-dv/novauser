

defmodule ApiWeb.UserJSON do
  def usercreated(%{message: message, status: status}) do
    %{
      status: status,
      message: message
    }
  end
end
