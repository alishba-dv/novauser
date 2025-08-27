defmodule Data.Schema.Business do
  use Ecto.Schema
  import Ecto.Changeset


  schema "businesses" do
    field :name, :string
    field :address, :string
    field :email, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(business, attrs) do
    business
    |> cast(attrs, [:name, :address, :email])
    |> validate_required([:name, :address, :email])
    |>unique_constraint(:email,message: "Email must be unique")
  end
end
