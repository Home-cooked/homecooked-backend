defmodule Homecooked.Repo.Migrations.HostPostAttending do
  use Ecto.Migration

  def change do
    create table(:host_post_attending, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :host_post_id, references("host_post", type: :binary_id, on_delete: :delete_all),
        null: false
      add :user_id, references("users", type: :binary_id, on_delete: :delete_all),
        null: false
    end
  end
end
