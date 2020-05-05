defmodule HomecookedWeb.UserView do
  use HomecookedWeb, :view
  alias HomecookedWeb.UserView
  alias Homecooked.SignedUrl

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      user_name: user.user_name,
      first_name: user.first_name,
      last_name: user.last_name,
      full_name: "#{user.first_name} #{user.last_name}",
      created_at: user.inserted_at,
      about_me: user.about_me,
      pic: (if user.pic, do: SignedUrl.get("#{user.id}/#{user.pic}")),
      friends: user.friends
    }
  end

  defp friend_map(friends) do
    friends
    |> Enum.map(fn f -> %{
                          id: f.id,
                          pic: (if f.pic, do: SignedUrl.get("#{f.id}/#{f.pic}")),
                          full_name: "#{f.first_name} #{f.last_name}",
                          user_name: f.user_name
                      } end)
  end

  
  def render("rich_user.json", %{user: user, preload: opts, extra: info}) do
    # TODO Refactor to go of assoc's like host_post_view
    %{
      id: user.id,
      user_name: user.user_name,
      first_name: user.first_name,
      last_name: user.last_name,
      full_name: "#{user.first_name} #{user.last_name}",
      created_at: user.inserted_at,
      about_me: user.about_me,
      pic: (if user.pic, do: SignedUrl.get("#{user.id}/#{user.pic}")),
      friends: user.friends,
      incoming_friends: if(:incoming_friend_requests in opts, do: user.incoming_friend_requests |> friend_map()),
      rich_friends: if(Map.get(info, :friends), do: Map.get(info, :friends) |> friend_map()),
      pending_friends: if(:pending_friend_requests in opts, do: user.pending_friend_requests |> friend_map()),
      attending: if(:attending in opts, do: user.attending |> Enum.map(&(%{
                              id: &1.id,
                              user_id: &1.user_id,
                              title: &1.title,
                              event_time: &1.event_time,
                              address: &1.address,
                              pic: (if &1.pic, do: SignedUrl.get("#{&1.user_id}/#{&1.pic}")),
                                                                         })))
    }
  end

end
