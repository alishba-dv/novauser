defmodule Data.Context.ViewUsers do

  import Ecto.Query
  alias Data.Repo
  alias Data.Schema.User
  alias Data.Schema.Role
  alias Data.Schema.Business
  use Scrivener, page_size: 5


  def viewusers(name \\nil, email \\nil, order \\nil, business \\nil, role \\nil ,page_size \\ nil) do

    filter=
      dynamic([u],true)

    filter = if name, do:  dynamic([u], ^filter and  u.name == ^ name ), else: filter
#
    filter = if email, do: dynamic([u], ^filter and u.email == ^ email), else: filter
#
#
    filter = if business, do: dynamic([u], ^filter and u.business == ^ business),else: filter
    filter = if role, do: dynamic([u], ^filter and u. role == ^role),else: filter


    query= from u in User, where: ^filter,
                           join: r in Role, on: u.role == r.name,
                           join: b in Business, on: u.business == b.name,
                           select: %{
                             id: u.id,
                             name: u.name,
                             email: u.email,
                             role: r.name,
                             role_description: r.description,
                             business_name: b.name,
                            business_address: b.address,
                           business_email: b.email
                           }
#

query=
case order do
  "Ascending" -> from u in query, order_by: [asc: u.name]
  "Descending" -> from u in query, order_by: [desc: u.name]
  _ -> query
end


#
#users=Repo.all(query)
#
#
##
#if users==[] do
#  %{error: "No user found with given filters"}
#  else
#
#  %{users: users}
#end
    Repo.paginate(query, page: 1, page_size: page_size)

  end
end