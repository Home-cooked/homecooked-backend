defmodule Homecooked.UserContent.SubmitGroupUser do
  use Ecto.Schema
  import Ecto.Changeset
  
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "submit_group_users" do
    field :submit_group_id, :binary_id

    field :user_id, :binary_id
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:submit_group_id, :user_id])
    |> validate_required([:submit_group_id, :user_id])
  end
end
