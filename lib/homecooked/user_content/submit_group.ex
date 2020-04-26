defmodule Homecooked.UserContent.SubmitGroup do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homecooked.UserContent.HostPost

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "submit_group" do
    field :users, {:array, :binary_id}
    field :note, :string

    field :host_post_id, :binary_id
    belongs_to :host_post, HostPost, define_field: false
    
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:users, :note, :host_post_id])
    |> validate_required([:users, :note, :host_post_id])
  end
end
