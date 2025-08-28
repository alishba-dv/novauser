defmodule Data.Schema.User do
  use Ecto.Schema
  import Ecto.Changeset
#  @roles ["admin", "user"]
#  @businesses ["service", "product", "tech"]

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string
#    field :business, :string
#    field :role, :string

    many_to_many  :businesses, Data.Schema.Business, join_through: "user_businesses",on_replace: :delete
    many_to_many  :roles , Data.Schema.Role, join_through: "user_roles",on_replace: :delete    ##bridge tablelss


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |>unique_constraint(:email,message: "Email must be unique")
    |>validate_format(:email, ~r/@/)
#    |>Ecto.Changeset.put_assoc(:roles, roles)
#    |>Ecto.Changeset.put_assoc(:businesses, businesses)

  end
end
