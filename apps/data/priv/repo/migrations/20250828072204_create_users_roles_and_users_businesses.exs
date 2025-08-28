defmodule Data.Repo.Migrations.CreateUsersRolesAndUsersBusinesses do
  use Ecto.Migration

  def change do

    create table(:user_roles, primary_key: false) do
      add :user_id,  references(:users, on_delete: :delete_all)
      add :role_id, references(:roles, on_delete: :delete_all)

    end
    create unique_index(:user_roles, [:user_id,:role_id])

    create table(:user_businesses, primary_key: false) do

  add :user_id, references(:users, on_delete: :delete_all)
  add :business_id, references(:businesses, on_delete: :delete_all)
    end

    create unique_index(:user_businesses, [:user_id,:business_id])

  end
end
