defmodule Data.Schema.Business do
  use Ecto.Schema
  import Ecto.Changeset


  schema "businesses" do
    field :name, :string
#    field :address, :string
#    field :email, :string

    many_to_many :user, Data.Schema.User,join_through: "user_businesses", on_replace: :delete

    timestamps(type: :utc_datetime)
  end
  def changeset(business, attrs) do
    business
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |>unique_constraint(:name,message: "name must be unique")
  end
end
