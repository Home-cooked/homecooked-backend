defmodule HomecookedWeb.HostPostView do
  use HomecookedWeb, :view
  alias HomecookedWeb.HostPostView
  alias Homecooked.SignedUrl

  def render("index.json", %{host_posts: host_posts}) do
    %{data: render_many(host_posts, HostPostView, "host_post.json")}
  end

  def render("show.json", %{host_post: host_post}) do
    %{data: render_one(host_post, HostPostView, "host_post.json")}
  end

  defp user_map(user) do
    user
    |> Enum.map(fn u -> %{
                          id: u.id,
                          pic: (if u.pic, do: SignedUrl.get("#{u.id}/#{u.pic}")),
                          full_name: "#{u.first_name} #{u.last_name}",
                          user_name: u.user_name,
                          first_name: u.first_name,
                      } end)
  end

  
  def render("host_post.json", %{host_post: host_post}) do
    %{
      id: host_post.id,
      title: host_post.title,
      body: host_post.body,
      address: host_post.address,
      lat: host_post.lat,
      lng: host_post.lng,
      event_time: host_post.event_time |> DateTime.to_unix(),
      max_size: host_post.max_size,
      wanted: host_post.wanted,
      pic: (if host_post.pic, do: SignedUrl.get("#{host_post.user_id}/#{host_post.pic}")),
      user_id: host_post.user_id,
      user: (if Ecto.assoc_loaded?(host_post.user), do:
        %{
          id: host_post.user.id,
          user_name: host_post.user.user_name,
          first_name: host_post.user.first_name,
          full_name: "#{host_post.user.first_name} #{host_post.user.last_name}",
          pic: (if host_post.user.pic, do: SignedUrl.get("#{host_post.user.id}/#{host_post.user.pic}")),
        }),
      submit_groups: if Ecto.assoc_loaded?(host_post.submit_groups) do
        host_post.submit_groups
        |> Enum.map(fn g -> %{
                         id: g.id,
                         note: g.note,
                         users: user_map(g.users)
                       } end)
      else
        []
      end,
      comments: (if Ecto.assoc_loaded?(host_post.comments), do: Enum.map(host_post.comments, &(%{
      id: &1.id,
      user_id: &1.user_id,
      user_name: &1.user.user_name,
      full_name: "#{&1.user.first_name} #{&1.user.last_name}",
      pic: (if &1.user.pic, do: SignedUrl.get("#{&1.user_id}/#{&1.user.pic}")),
      message: &1.message,
      created_at: &1.inserted_at
                                                                                               }))),
      attending: if Ecto.assoc_loaded?(host_post.attending) do user_map(host_post.attending) else [] end
    }
  end
end
