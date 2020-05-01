defmodule Homecooked.Repo.Migrations.CascadingDelete do
  use Ecto.Migration

  def change do
    execute "ALTER TABLE host_post DROP CONSTRAINT host_post_user_id_fkey"
    
    alter table("host_post") do
      modify :user_id,
        references("users", type: :binary_id, on_delete: :delete_all),
        null: false
    end

    execute "ALTER TABLE host_post_comments DROP CONSTRAINT host_post_comments_user_id_fkey"
    execute "ALTER TABLE host_post_comments DROP CONSTRAINT host_post_comments_host_post_id_fkey"
    alter table("host_post_comments") do
      modify :user_id,
        references("users", type: :binary_id, on_delete: :delete_all),
        null: false
      modify :host_post_id,
        references("host_post", type: :binary_id, on_delete: :delete_all),
        null: false
    end

  end
end
