defmodule Homecooked.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_name, :string
      add :first_name, :string
      add :last_name, :string

      timestamps()
    end

  end
end
