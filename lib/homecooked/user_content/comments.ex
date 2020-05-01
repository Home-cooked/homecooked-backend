defmodule Homecooked.UserContent.HostPostComment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homecooked.Accounts.User
  alias Homecooked.UserContent.HostPost
  
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "host_post_comments" do
    field :message, :string


    # Need to add cascading, need to enforce non-null
    field :user_id, :binary_id
    belongs_to :user, User, define_field: false
    
    field :host_post_id, :binary_id
    belongs_to :host_post, HostPost, define_field: false

    
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:message, :host_post_id, :user_id])
    |> validate_required([:message, :host_post_id, :user_id])
  end
end
