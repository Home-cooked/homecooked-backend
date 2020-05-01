defmodule Homecooked.Repo.Migrations.Comments do
  use Ecto.Migration

  def change do
    create table(:host_post_comments, primary_key: false) do
      add :host_post_id, references("host_post", type: :binary_id)
      add :user_id, references("users", type: :binary_id)
      add :message, :text

      timestamps()
    end
  end
end
