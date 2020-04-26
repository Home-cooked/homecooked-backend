defmodule Homecooked.UserContent.HostPost do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homecooked.Accounts.User
  
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "host_post" do
    field :title, :string
    field :body,  :string
    field :location, :map
    field :event_time, :time
    field :max_size, :integer
    field :wanted, {:array, :string}
    field :pic, :string

    # Need to add cascading, need to enforce non-null
    field :user_id, :binary_id
    belongs_to :user, User, define_field: false
    
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:title, :body, :location, :event_time, :max_size, :wanted, :pic, :user_id])
    |> validate_required([:title, :body, :location, :event_time, :max_size, :wanted, :pic, :user_id])
  end
end
