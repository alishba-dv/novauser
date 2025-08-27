defmodule ApiWeb.UserController do

  use ApiWeb, :controller
  use PhoenixSwagger

  alias Data.Context.CreateUser



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

business(:query, :string, "Business Name",required: false, enum: ["Service","Tech","Product"])
role(:query, :string, "Role Name", required: false, enum: ["User", "Admin"])
name(:query,:string, "Name",required: false)
order :query, :string, "Order by Name in ASC or DESC", required: false, enum: ["Ascending","Descending"]
email :query, :string, "Email of user", required: false


  end

  response 200, "Success", Schema.ref(:viewusers)
  response 400, "Bad request"

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



      {:error, _changeset} ->
        conn
        |> put_status(:error)
        |> render(:usercreated,

             %{
               status: :error,
               message: "error"


             })





  end
end


def view_users(conn,params) do


end
end