defmodule Homecooked.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Homecooked.Repo

  alias Homecooked.Accounts.User
  alias Homecooked.Accounts.PendingFriendRequest
  alias Homecooked.Accounts.Words

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_friends!(id) do
    user = Repo.get!(User, id)
    if user.friends do
      Repo.all(from u in User, where: u.id in ^(user.friends), select: [:id, :pic, :first_name, :last_name, :user_name])
    else
      []
    end
  end

  def get_incoming_friends!(id) do
    user = Repo.get!(User, id)
    res = Repo.all Ecto.assoc(user, :incoming_friend_requests)
  end

  def get_pending_friends!(id) do
    user = Repo.get!(User, id)
    res = Repo.all Ecto.assoc(user, :pending_friend_requests)
  end

  def request_friend!(from, to) do
    Repo.get!(User, to)
    
    %PendingFriendRequest{}
    |> PendingFriendRequest.changeset(%{from_id: from.id, to_id: to})
    |> Repo.insert!()
  end

  def respond_to_friend(from, to, val) do
    # Need to wrap in transaction
    Repo.get_by!(PendingFriendRequest, %{from_id: from, to_id: to.id})
    |> Repo.delete!()

    if val do
      from_user = Repo.get!(User, from)
      to_user = to

      from_user
      |> User.changeset(%{ friends: if from_user.friends do [to_user.id | from_user.friends] else [to_user.id] end})
      |> Repo.update!()

      res = to_user
      |> User.changeset(%{ friends: if to_user.friends do [from_user.id | to_user.friends] else [from_user.id] end})
      |> Repo.update!()
    else
      to
    end
  end

  def unfriend!(from, to) do
    # Need to wrap in transaction

    from_user = from
    to_user = Repo.get!(User, to)

    to_user
    |> User.changeset(%{ friends: if to_user.friends
                         do Enum.filter(to_user.friends, fn x -> x != from.id end) else [] end})
    |> Repo.update!()

    from_user
    |> User.changeset(%{ friends: if from_user.friends
                           do Enum.filter(from_user.friends, fn x -> x != to_user.id end) else [] end})
    |> Repo.update()
      
  end


  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    user_name = Words.gen_user_name()
    case check_user_name(user_name) do
      true -> create_user(attrs)
      false ->
        {:ok, user } = %User{}
        |> User.changeset(Map.put(attrs, :user_name, user_name))
        |> Repo.insert()
        user
    end
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def get_or_create_user(%{} = user) do
    email = Map.fetch!(user, :email)
    case Repo.exists?(from u in User, where: u.email == ^email) do
      true -> Repo.get_by(User, email: email)
      false -> create_user(user)
    end
  end

  def check_user_name(user_name) do
    Repo.all(from u in "users", select: u.user_name)
    |> MapSet.new()
    |> MapSet.member?(user_name)
  end
end
