defmodule Homecooked.UserContent.SubmitGroup do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homecooked.Accounts.User
  alias Homecooked.UserContent.HostPost
  alias Homecooked.UserContent.SubmitGroupUser

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "submit_group" do
    field :note, :string
    field :host_post_id, :binary_id
    belongs_to :host_post, HostPost, define_field: false

    # has_many :users, SubmitGroupUser
    many_to_many :users, User, join_through: "submit_group_users"
    
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:note, :host_post_id])
    |> validate_required([:note, :host_post_id])
  end
end
