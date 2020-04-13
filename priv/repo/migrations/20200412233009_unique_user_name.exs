defmodule Homecooked.Repo.Migrations.UniqueUserName do
  use Ecto.Migration

  def change do
    unique_index("users", [:user_name])
  end
end
