defmodule Data.Context.ViewUsers do

  import Ecto.Query
  alias Data.Repo
  alias Data.Schema.User
  alias Data.Schema.Role
  alias Data.Schema.Business
  use Scrivener, page_size: 5



  def login(email,password) do

    query= from u in User, where: u.email==^email and u.password==^password
    case Repo.one(query) do

      user -> {:ok,user}
      nil ->{:error,"User not found. Invalid credentials"}
    end

  end
  def get_user(id)   do

    case  Data.Repo.get(User,id) do
      nil -> {:error, "No user found"}
      user ->{:ok,user}
    end
  end

  def get_user(nil) do
    {:error, "User id not provided"}
  end


  def viewusers(name \\nil, email \\nil, order \\nil, businesses_id \\nil, roles_id \\nil ,page_size \\ nil,page \\nil) do

    filter=
      dynamic([u],true)

    filter = if name, do:  dynamic([u], ^filter and  u.name == ^ name ), else: filter

    filter = if email, do: dynamic([u], ^filter and u.email == ^ email), else: filter


    filter = if businesses_id, do: dynamic([u], ^filter and u.businesses_id == ^ businesses_id),else: filter
    filter = if roles_id, do: dynamic([u], ^filter and u. roles_id == ^roles_id),else: filter


    query =
      from u in User,
           where: ^filter,
           join: ur in "user_roles", on: ur.user_id == u.id,
           join: r in Role, on: ur.role_id == r.id,
           join: ub in "user_businesses", on: ub.user_id == u.id,
           join: b in Business, on: ub.business_id == b.id,
           select: %{
             id: u.id,
             name: u.name,
             email: u.email,
             role_name: r.name,
             business_name: b.name
           }


    query=
case order do
  "Ascending" -> from u in query, order_by: [asc: u.name]
  "Descending" -> from u in query, order_by: [desc: u.name]
  _ -> query
end



#users=Repo.all(query)



#if users==[] do
#  %{error: "No user found with given filters"}
#  else

#  %{users: users}
#end
    Repo.paginate(query, page: page, page_size: page_size)

  end
end