defmodule Homecooked.Repo.Migrations.CommentsId do
  use Ecto.Migration

  def change do
    alter table("host_post_comments") do
      add :id, :binary_id, primary_key: true
    end
  end
end
