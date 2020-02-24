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
    field :provider, :string

    timestamps()
  end
  
  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:user_name, :first_name, :last_name])
    |> validate_required([:user_name, :first_name, :last_name])
    |> unique_constraint(:username)

  end
end
