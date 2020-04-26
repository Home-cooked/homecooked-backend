defmodule HomecookedWeb.HostPostView do
  use HomecookedWeb, :view
  alias HomecookedWeb.HostPostView

  def render("index.json", %{host_posts: host_posts}) do
    %{data: render_many(host_posts, HostPostView, "host_post.json")}
  end

  def render("show.json", %{host_post: host_post}) do
    %{data: render_one(host_post, HostPostView, "host_post.json")}
  end

  def render("host_post.json", %{host_post: host_post}) do
    %{
      title: host_post.title,
      body: host_post.body,
      location: host_post.location,
      event_time: host_post.event_time,
      max_size: host_post.max_size,
      wanted: host_post.wanted,
      pic: host_post.pic,
      user_id: host_post.user_id
    }
  end
end
