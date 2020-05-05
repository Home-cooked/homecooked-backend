defmodule HomecookedWeb.HostPostController do
  use HomecookedWeb, :controller
  alias Homecooked.UserContent

  action_fallback HomecookedWeb.FallbackController

  # Add load User for handlers
  def action(conn, _params) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, Guardian.Plug.current_resource(conn)])
  end

  def index(conn, %{"user_id" => user_id}, _user) do
    host_posts = UserContent.list_host_posts(user_id)
    render(conn, "index.json", host_posts: host_posts)
  end
  
  def index(conn, _params , _user) do
    host_posts = UserContent.list_host_posts(nil)
    render(conn, "index.json", host_posts: host_posts)
  end
  
  def create(conn, params, user) do
    {:ok, new_ts } = DateTime.from_unix(params["event_time"], :millisecond)
    IO.inspect new_ts
    {:ok, host_post} =
      params
      |> Map.put("user_id", user.id)
      |> Map.put("event_time", new_ts)
      |> UserContent.create_host_post()
    render(conn, "show.json", host_post: host_post)
  end

  def show(conn, %{"id" => host_post_id} = params, user) do
    options = %{
      "comments" => {:comments, [:user]},
      "user" => :user,
      "submit_groups" => {:submit_groups, [:users]},
      "attending" => :attending,
    }
    preload_options = MapSet.intersection(MapSet.new(Map.keys(options)), MapSet.new(Map.keys(params)))
    |> Enum.map(&(options[&1]))
    host_post = UserContent.get_host_post!(host_post_id, preload_options)
    render(conn, "show.json", host_post: host_post)
  end

  def map(conn, %{"lat" => lat, "lng" => lng} = params, user) do
    {radius, _} = params |> Map.get('radius', "1") |> Float.parse()
    {lat, _} = lat |> Float.parse()
    {lng, _} = lng |> Float.parse()
    posts = UserContent.search_host_posts(lat, lng, radius)
    render(conn,"index.json", host_posts: posts)
  end

  def submit_group(conn, params, user) do
    post = UserContent.submit_group!(%{ params | "users" => [user.id | params["users"]] })
    render(conn, "show.json", host_post: post)
  end

  def respond_to_group(conn, params, user) do
    host_post = UserContent.respond_to_group!(params)
    render(conn, "show.json", host_post: host_post)
  end
  
  def create_comment(conn, params, user) do
    {:ok, comment} = UserContent.create_comment(params |> Map.put("user_id", user.id))
    render(conn, "show.json", comment: comment)
  end

  def get_comments(conn, %{ "host_post_id" => host_post_id }, user) do
    comments = UserContent.get_post_comments!(host_post_id)
    render(conn, "index", comments: comments)
  end

  def delete_comment(conn, params, user) do
    
  end

end
