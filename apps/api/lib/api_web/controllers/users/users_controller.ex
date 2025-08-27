defmodule ApiWeb.UserController do

  use ApiWeb, :controller
  use PhoenixSwagger

  alias Data.Context.CreateUser
  alias Data.Context.ViewUsers
 alias Data.Context.DeleteUser

#  ===================================================

swagger_path :create_user do


  post("/api/user")

  summary("Create a new user")
  description("A new user is created")
  produces "application/json"
  consumes "application/json"


  parameters do
    user :body, Schema.ref(:user), "User created successfully",required: true
  end

  response 200, "Success", Schema.ref(:user)
  response 400, "Bad request"
end

swagger_path :view_users do


  get("/api/users")
  summary("View list of users ")
  description("A list of users is shown")
  produces "application/json"
  consumes "application/json"

  parameters do

business(:query, :string, "Business Name",required: false, enum: ["service","tech","product"])
role(:query, :string, "Role Name", required: false, enum: ["user", "admin"])
name(:query,:string, "Name",required: false)
order :query, :string, "Order by Name in ASC or DESC", required: false, enum: ["Ascending","Descending"]
email :query, :string, "Email of user", required: false
page_size :query, :string, "Number of entries in a page", required: false


  end

  response 200, "Success", Schema.ref(:viewusers)
  response 400, "Bad request"

end

swagger_path :delete_user do

  delete("/api/user/{id}")
  summary("Delete a user by its id")
  description("A user with dedeicated id will be deleted")
  produces "application/json"
  consumes "application/json"
#
  parameters do
          id :path, :integer, "User ID", required: true
        end

        response 200, "Success", Schema.ref(:deleteuser)
        response 404, "Bad request"
end
def swagger_definitions do


  %{

  user: swagger_schema do

    title  "User"
    description " A user record"
    properties do

       email :string, "Email", required: true
      name :string,  "Name", required: true
      password :string, "Password", required: true
      business :string, "Business", required: true
      role :string, "Role", required: true
      page_size :string, "Page Size", required: false


    end

    example %{

    email: "Example@gmail.com",
    name: "Example",
    password: "password123",
    business: "service",
    role: "user"



    }
  end,


viewusers: swagger_schema do
    title "User"
    description "A user"

    properties do
      email :string, "Email address", required: true
      name :string, "Full name", required: true
      business :string, "Business name", required: false
      role :string, "User role", required: true
    end

    example %{
      email: "example@gmail.com",
      name: "example",
      business: "service",
      role: "user"
    }
  end,

  deleteuser: swagger_schema do

    title "User"
    description "Delete a user by id"
    properties do
      id :integer, "id", required: true
    end

    example %{
    id: 1,
    }
    end



  }




end

#  =====================================================

  def create_user(conn,params) do

    user=params

    case CreateUser.createusers(user) do

      {:ok,_user} ->
        conn
        |> put_status(:ok)
        |> render(:usercreated,

             %{
             status: :ok,
               message: "user created successfully"

             })



      {:error, changeset} ->
      error=
        Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
          Enum.reduce(opts, msg, fn {key, value}, acc ->
            String.replace(acc, "%{#{key}}", to_string(value))
          end)
        end)

      json(conn,

             %{
               status: :error,
               message: error


             })





  end
end


def view_users(conn,params) do


    name=  params["name"]
    email=  params["email"]
    role=  (params["role"])
    order=  params["order"]
    business=  params["business"]

    page_size =
      Map.get(params, "page_size", "10")
      |> to_string()
      |> String.to_integer()

#
    result=ViewUsers.viewusers(name,email,order,business,role,page_size)
#
    case result do
      []-> conn
      |>put_status(400)
      |>render(:viewusers,%{status: "Error", message: "No user found with given filters",
      error: []})
      _-> conn |> render(:viewusers, %{users: result})

    end

#    conn
#    |> put_status(:ok)
#    |> json(%{
#      users: result.entries,
#      page_number: result.page_number,
#      page_size: result.page_size,
#      total_pages: result.total_pages,
#      total_entries: result.total_entries
#    })


end


def delete_user(conn,%{"id"=>sid}) do


    id = String.to_integer(sid)


    case DeleteUser.deleteUser(id) do

   {:ok, :deleted} ->
     conn
     |> put_status(:ok)
     |> json(%{message: "User deleted successfully"})

   {:error, :not_found} ->
     conn
     |> put_status(:not_found)
     |> json(%{error: "User not found"})

   {:error, :failed} ->
     conn
     |> put_status(:internal_server_error)
     |> json(%{error: "Failed to delete user"})

 end
end
end