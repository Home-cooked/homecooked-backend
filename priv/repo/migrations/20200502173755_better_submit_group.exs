defmodule Homecooked.Repo.Migrations.BetterSubmitGroup do
  use Ecto.Migration

  def change do
    # Primary id not generated "uniquely" accourding to dbeaver, but migration
    # looks good. Lets try again just in case
    drop table(:submit_group)

    create table(:submit_group, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :host_post_id, references("host_post", type: :binary_id, on_delete: :delete_all),
        null: false
      add :note, :string
      timestamps()
    end
      
    create table(:submit_group_users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :submit_group_id, references("submit_group", type: :binary_id, on_delete: :delete_all),
        null: false
      add :user_id, references("users", type: :binary_id, on_delete: :delete_all),
        null: false      
    end
    
  end
end
