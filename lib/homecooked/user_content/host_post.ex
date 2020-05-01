defmodule Homecooked.UserContent.HostPost do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homecooked.Accounts.User
  
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "host_post" do
    field :title, :string
    field :body,  :string
    field :address, :string
    field :lat, :float
    field :lng, :float
    field :place_id, :string
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
    |> cast(attrs, [:title, :body, :event_time, :max_size, :wanted, :pic, :user_id, :lat, :lng, :address, :place_id])
    |> validate_required([:title, :body, :event_time, :max_size, :wanted, :pic, :user_id, :lat, :lng, :place_id, :address])
  end
end
