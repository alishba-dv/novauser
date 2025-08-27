defmodule Data.Context.GetRoles do

  alias Data.Repo
  import Ecto.Query
  alias Data.Schema.Role


  def getroles() do

    case Repo.all(Role) do

      roles -> {:ok,roles}
      _-> {:error, "Error"}

    end

    end

end