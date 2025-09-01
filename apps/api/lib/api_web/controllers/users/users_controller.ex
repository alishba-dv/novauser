defmodule ApiWeb.UserController do

  use ApiWeb, :controller
  use PhoenixSwagger

  alias Data.Context.CreateUser
  alias Data.Context.ViewUsers
 alias Data.Context.DeleteUser
  alias Data.Context.GetRoles
  alias Data.Context.GetBusiness
  alias Api.Auth.Guardian



#  ===================================================
  swagger_path :login do


    post("/api/login")

    summary("Logs in a user")
    description("A  user is logged in")
    produces "application/json"
    consumes "application/json"


    parameters do
      user :body, Schema.ref(:login), "User logged in  successfully",required: true
    end

    response 200, "Success", Schema.ref(:login)
    response 400, "Bad request"
  end

swagger_path :create_user do


  post("/api/user")
  security [%{Bearer: []}]

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

    security [%{Bearer: []}]

  get("/api/users")
  summary("View list of users ")
  description("A list of users is shown")
  produces "application/json"
  consumes "application/json"

  parameters do

business(:query, :string, "Business Name",required: false, enum: ["1","2","3"])
role(:query, :string, "Role Name", required: false, enum: ["1", "2"])
name(:query,:string, "Name",required: false)
order :query, :string, "Order by Name in ASC or DESC", required: false, enum: ["Ascending","Descending"]
email :query, :string, "Email of user", required: false
page_size :query, :string, "Number of entries in a page", required: false
page :query, :string, "Page number to show ", required: false


  end

  response 200, "Success", Schema.ref(:viewusers)
  response 400, "Bad request"

end

swagger_path :delete_user do
    security [%{Bearer: []}]

  delete("/api/user/{id}")
  summary("Delete a user by its id")
  description("A user with dedicated id will be deleted")
  produces "application/json"
  consumes "application/json"
#
  parameters do
          id :path, :integer, "User ID", required: true
        end

        response 200, "Success", Schema.ref(:deleteuser)
        response 404, "Bad request"
end


swagger_path :get_roles do
    security [%{Bearer: []}]

  get("/api/roles")
  summary("Get a list of all roles enrolled")
  description("All roles available will be shown")
  produces "application/json"
  consumes "application/json"


  response 200, "success",Schema.ref(:viewroles)
  response 404, "Bad Request"



  end
  swagger_path :get_business do
    security [%{Bearer: []}]

    get("/api/business")
    summary("Get a list of all businesses enrolled")
    description("All businesses available will be shown")
    produces "application/json"
    consumes "application/json"


    response 200, "success",Schema.ref(:viewbusiness)
    response 404, "Bad Request"



  end



def swagger_definitions do

#
  %{
#Bearer: %{
#type: :http,
#scheme: :bearer,
#bearerFormat: "JWT"
#               },


    user: swagger_schema do

      title  "User"
      description " A user record"
#  security [%{Bearer: []}]
  properties do

        email :string, "Email", required: true
        name :string,  "Name", required: true
        password :string, "Password", required: true
        businesses_id :integer, "Business ID", required: true
        roles_id :integer, "Role ID", required: true
        page_size :string, "Page Size", required: false
        page :string, "Page", required: false
end

      end,

login: swagger_schema do

title  "Login User"
description " A user logs in "
properties do

email :string, "Email", required: true
password :string, "Password", required: true


end


example %{

    email: "Example@gmail.com",
    password: "password123",




    }
  end,

    viewroles: swagger_schema do


      title "roles"
      description "All roles"
      properties do
        name :string, "name", required: true
#        description :string, "Description", required: true
      end

      example%{
        name: "User",
#        description: "THis is user role"
      }


    end,

    viewbusiness: swagger_schema do
      title "Business"
      description "All Businesses"
      properties do
        name :string, "name", required: true
#        email :string, "Email", required: true
#        address :string, "Address",required: true
      end

      example%{
        name: "User",
#        email: "example@gmail.com",
#        address: "st#123 abc "
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
      business_name: "service",
      role_name: "user"
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


#
def login(conn,params) do
  email=params["email"]
  password=params["password"]


case Data.Context.ViewUsers.login(email,password) do
#
    {:ok, user} ->
      {:ok, token, _claims} = Api.Auth.Guardian.encode_and_sign(user)
      IO.inspect(conn)
      json(conn, %{token: token, user: %{id: user.id, name: user.name, email: user.email}})


         {:error,msg} -> json(conn,%{message: "Invalid credentials"})
end
end
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


def get_roles(conn,_params) do


  case GetRoles.getroles() do


    {:ok,roles} -> conn |> put_status(200) |> render(:getroles, %{message: "All roles fetched successfully",roles: roles})
    {:error,changeset} -> json(conn,%{message: "Error fetching roles", error: changeset.errors})
    end


end

def get_business(conn,params) do


  case GetBusiness.getbusiness() do


    {:ok,business} -> conn |> put_status(200) |> render(:getbusiness, %{message: "All businesses fetched successfully",business: business})
    {:error,changeset} -> json(conn,%{message: "Error fetching roles", error: changeset.errors})
    end


end


def view_users(conn,params) do
    IO.inspect(Guardian.Plug.current_token(conn), label: "Token from header")
    IO.inspect(Guardian.Plug.current_resource(conn), label: "Current user")
  token = Guardian.Plug.current_token(conn)
  current_user = Guardian.Plug.current_resource(conn)

  if token do
    IO.inspect(token, label: "Token sent by client")
  else
    IO.puts("No token sent!")
  end

  if current_user do
    IO.inspect(current_user, label: "Authenticated user")
  else
    IO.puts("User not authenticated")
  end


    name=  params["name"]
    email=  params["email"]
    roles_id=  (params["roles_id"])
    order=  params["order"]
    businesses_id=  params["businesses_id"]

    page_size =
      Map.get(params, "page_size", "10")
      |> to_string()
      |> String.to_integer()

      page=
      Map.get(params, "page", "1")
      |> to_string()
      |> String.to_integer()


    result=ViewUsers.viewusers(name,email,order,businesses_id,roles_id,page_size,page)

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

   {:error, :changeset} ->
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