defmodule Homecooked.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :user_name, :string
    field :email, :string
    field :pic, :string
    field :about_me, :string
    field :friends, {:array, :string}

    many_to_many :pending_friend_requests, __MODULE__, join_through: "pending_friend_requests", join_keys: [from_id: :id, to_id: :id]
    many_to_many :incoming_friend_requests, __MODULE__, join_through: "pending_friend_requests", join_keys: [to_id: :id, from_id: :id]

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:user_name, :first_name, :last_name, :email, :pic, :about_me, :friends])
    |> validate_required([:user_name, :first_name, :last_name, :email])
    |> unique_constraint(:email)
    |> unique_constraint(:user_name)
  end
end
