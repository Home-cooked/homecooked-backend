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

  def render("host_post.json", %{host_post: host_post}) do
    %{
      id: host_post.id,
      title: host_post.title,
      body: host_post.body,
      address: host_post.address,
      lat: host_post.lat,
      lng: host_post.lng,
      event_time: host_post.event_time,
      max_size: host_post.max_size,
      wanted: host_post.wanted,
      pic: (if host_post.pic, do: SignedUrl.get("#{host_post.user_id}/#{host_post.pic}")),
      user_id: host_post.user_id,
      submit_groups: host_post.submit_groups
      |> Enum.map(fn g -> %{
                         id: g.id,
                         note: g.note,
                         users: g.users
                         |> Enum.map(fn u -> %{
                                            id: u.id,
                                            pic: (if u.pic, do: SignedUrl.get("#{u.id}/#{u.pic}")),
                                            full_name: "#{u.first_name} #{u.last_name}",
                                            first_name: u.first_name,
                                            user_name: u.user_name
                                        } end)
                     } end)
    }
  end
end
