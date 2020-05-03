defmodule Homecooked.Repo.Migrations.SubmitGroupStringToText do
  use Ecto.Migration

  def change do
    alter table(:submit_group) do
      modify :note, :text
    end
  end
end
