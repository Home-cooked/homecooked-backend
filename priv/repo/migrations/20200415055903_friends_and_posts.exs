defmodule Homecooked.Repo.Migrations.FriendsAndPosts do
  use Ecto.Migration

  def change do
    create table(:host_post, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references("users", type: :binary_id)
      add :title, :string
      add :body,  :string
      add :location, :json
      add :event_time, :time
      add :max_size, :integer
      add :wanted, :json
      add :pic, :string
      timestamps()
    end

    create table(:submit_group, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :host_post_id, references("host_post", type: :binary_id)
      add :users, :json
      add :note, :string
      timestamps()
    end

    
    alter table("users") do
      add :friends, :json 
    end

  end
end
