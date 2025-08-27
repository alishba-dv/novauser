defmodule Data.Repo.Migrations.CreateBusinesses do
  use Ecto.Migration

  def change do
    create table(:businesses) do
      add :name, :string
      add :address, :string
      add :email, :string

      timestamps(type: :utc_datetime)
    end
  end
end
