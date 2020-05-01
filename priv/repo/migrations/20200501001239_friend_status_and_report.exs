defmodule Homecooked.Repo.Migrations.FriendStatusAndReport do
  use Ecto.Migration

  def change do
    create table(:pending_friend_requests, primary_key: false) do
      add :from_id, references("users", type: :binary_id, on_delete: :delete_all), primary_key: true
      add :to_id, references("users", type: :binary_id, on_delete: :delete_all), primary_key: true
    end

    alter table(:host_post) do
      add :reported, :boolean
    end

    alter table(:users) do
      add :reported, :boolean
    end
  end
end
