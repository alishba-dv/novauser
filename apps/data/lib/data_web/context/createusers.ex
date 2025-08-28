defmodule Data.Context.CreateUser do

  alias Data.Repo
  import Ecto.Query
  alias Data.Schema.User
  alias Data.Schema.Role
  alias Data.Schema.Business



  def createusers(params) do
    roles =
      case Map.get(params, "roles_id") do
        nil -> []
        id -> Repo.all(from r in Role, where: r.id in ^id)
      end

    businesses =
      case Map.get(params, "businesses_id") do
        nil -> []
        id -> Repo.all(from b in Business, where: b.id in ^id)
      end
    user=
    %User{}
    |>User.changeset(params)
    |> Ecto.Changeset.put_assoc(:roles, roles)
    |> Ecto.Changeset.put_assoc(:businesses, businesses)

    case Repo.insert(user) do

      {:ok,user} -> {:ok,user}
      {:error,changeset} -> {:error,changeset}


    end




  end

end