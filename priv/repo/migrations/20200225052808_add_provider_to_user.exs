defmodule Homecooked.Repo.Migrations.AddProviderToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :email, :string
      add :oauth_id, :string
    end
  end
end
