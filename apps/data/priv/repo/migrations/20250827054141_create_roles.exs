defmodule Data.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:roles) do
      add :name, :string
      add :description, :string

      timestamps(type: :utc_datetime)
    end
  end
end
