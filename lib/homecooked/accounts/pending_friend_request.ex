defmodule Homecooked.Accounts.PendingFriendRequest do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homecooked.Accounts.User

  @primary_key false
  schema "pending_friend_requests" do
    # Assoc is on user table (find out how to enforce on insert)
    field :from_id, :binary_id, primary_key: true
    field :to_id, :binary_id, primary_key: true
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:from_id, :to_id])
    |> validate_required([:from_id, :to_id])
  end
end
