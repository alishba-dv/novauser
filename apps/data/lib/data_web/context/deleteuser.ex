defmodule Data.Context.DeleteUser do

  alias Data.Repo
  import Ecto.Query
  alias Data.Schema.User


  def deleteUser(id) do

   query= from(u in User, where: u.id==^id)

  case  Repo.delete_all(query) do

               {0,_} ->  {:error,:not_found}

               {1,_} -> {:ok,:deleted}

              _ -> {:error,:failed}
  end

  end
end