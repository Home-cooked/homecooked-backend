defmodule Homecooked.Repo.Migrations.UniqueEmail do
  use Ecto.Migration

  def change do
    alter table "users" do
      modify :email, :text, null: false
    end
    create index("users", :email, unique: true)
  end
end
