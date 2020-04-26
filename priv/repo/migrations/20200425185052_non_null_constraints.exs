defmodule Homecooked.Repo.Migrations.NonNullConstraints do
  use Ecto.Migration

  def change do
    alter table "host_post" do
      modify :user_id, references("users", type: :binary_id), null: false,
      from: references("users", type: :binary_id)
    end

    alter table "submit_group" do
      modify :host_post_id, references("host_post", type: :binary_id), null: false,
      from: references("host_post", type: :binary_id)
    end

  end
end
