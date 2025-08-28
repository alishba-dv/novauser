defmodule Data.Context.DeleteUser do

  alias Data.Repo
  import Ecto.Query
  alias Data.Schema.User


  def deleteUser(id) do

   user= Repo.get!(User,id)

  case  Repo.delete(user) do

               {:error,changeset} ->  {:error,:not_found}

               {:ok,_user} -> {:ok,:deleted}

              _ -> {:error,:failed}
  end

  end
end