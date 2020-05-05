defmodule Homecooked.UserContent.Attending do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "host_post_attending" do
    field :host_post_id, :binary_id
    field :user_id, :binary_id
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:host_post_id, :user_id])
    |> validate_required([:host_post_id, :user_id])
  end
end
