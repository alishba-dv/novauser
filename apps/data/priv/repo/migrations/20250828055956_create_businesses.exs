defmodule Data.Repo.Migrations.CreateBusinesses do
  use Ecto.Migration

  def change do
    create table(:businesses) do
      add :name, :string


      timestamps()
    end

    create unique_index(:businesses, [:name])
  end

end
