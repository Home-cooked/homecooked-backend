defmodule Homecooked.Repo.Migrations.AdditionalStructuredLocation do
  use Ecto.Migration

  def change do
    alter table("host_post") do
      add :address, :string
      add :place_id, :string
    end
  end
end
