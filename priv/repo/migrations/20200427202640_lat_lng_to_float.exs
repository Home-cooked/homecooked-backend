defmodule Homecooked.Repo.Migrations.LatLngToFloat do
  use Ecto.Migration

  def change do
    alter table("host_post") do
      modify :lat, :float
      modify :lng, :float
    end
  end
end
