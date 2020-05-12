defmodule Homecooked.Repo.Migrations.DatetimmeToNormal do
  use Ecto.Migration

  def change do
    alter table(:host_post) do
      remove :event_time
      add :event_time, :utc_datetime, default: fragment("NOW()"), null: false
    end
  end
end
