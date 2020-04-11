defmodule Homecooked.Repo.Migrations.FixUserTable do
  use Ecto.Migration

  def change do
    rename table(:users), :username, to: :user_name
  end
end
