defmodule Homecooked.Repo.Migrations.UserDetailsAndText do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :pic, :string
      add :about_me, :text
    end

    alter table("host_post") do
      modify :body, :text
    end

  end
end
