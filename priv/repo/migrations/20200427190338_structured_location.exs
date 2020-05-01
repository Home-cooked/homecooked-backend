defmodule Homecooked.Repo.Migrations.StructuredLocation do
  use Ecto.Migration

  def change do
    alter table("host_post") do
      remove :location
      add :lat, :decimal
      add :lng, :decimal
    end
  end
end
