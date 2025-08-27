
defmodule Data.Context.CreateUser do

  alias Data.Repo
#  import Ecto.Query
  alias Data.Schema.User


  def createusers(params) do

    user=
    %User{}
    |>User.changeset(params)

    case Repo.insert(user) do

      {:ok,user} -> {:ok,user}
      {:error,changeset} -> {:error,changeset}


    end




  end

end