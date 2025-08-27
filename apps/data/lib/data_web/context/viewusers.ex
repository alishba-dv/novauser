defmodule Data.Context.ViewUsers do

  import Ecto.Query
  alias Data.Repo
  alias Data.Schema.User


  def viewusers(name \\nil, email \\nil, order \\nil, business \\nil, role \\nil ) do

    filter=
      dynamic([u],true)

    filter = if name, do:  dynamic([u], ^filter and  u.name == ^ name ), else: filter
#
    filter = if email, do: dynamic([u], ^filter and u.email == ^ email), else: filter
#
#
    filter = if business, do: dynamic([u], ^filter and u.business == ^ business),else: filter
    filter = if role, do: dynamic([u], ^filter and u. role == ^role),else: filter
#
    query= from u in User, where: ^filter
#
#
query=
case order do
  "Ascending" -> from u in query, order_by: [asc: u.name]
  "Descending" -> from u in query, order_by: [desc: u.name]
  _ -> query
end
#
users=Repo.all(query)
#
if users==[] do
  %{error: "No user found with given filters"}
  else

  %{users: users}
end
  end
end