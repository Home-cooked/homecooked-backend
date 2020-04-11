defmodule Homecooked.Repo.Migrations.DeleteMe do
  use Ecto.Migration

  def change do
    drop table(:users)

    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_name, :string
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :oauth_id, :string
      timestamps()
    end
  end
end
