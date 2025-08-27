defmodule Data.Schema.User do
  use Ecto.Schema
  import Ecto.Changeset
  @roles ["admin", "user"]
  @businesses ["service", "product", "tech"]

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string
    field :business, :string
    field :role, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password, :business, :role])
    |> validate_required([:name, :email, :password, :business, :role])
    |>unique_constraint(:email,message: "Email must be unique")
    |>validate_inclusion(:role, @roles,message: "Role should be either user or admin")
    |>validate_inclusion(:business,@businesses,message: "Businesses should be among product,service or tech")

  end
end
