defmodule HomecookedWeb.HostPostCommentView do
  use HomecookedWeb, :view
  alias HomecookedWeb.HostPostCommentView
  alias Homecooked.SignedUrl

  def render("index.json", %{comments: comments}) do    
    %{data: render_many(comments, HostPostCommentView, "host_post_comment.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{data: render_one(comment, HostPostCommentView, "host_post_comment.json")}
  end

  def render("host_post_comment.json", %{host_post_comment: comment}) do
    %{
      id: comment.id,
      user_id: comment.user_id,
      user_name: comment.user.user_name,
      full_name: "#{comment.user.first_name} #{comment.user.last_name}",
      pic: (if comment.user.pic, do: SignedUrl.get("#{comment.user_id}/#{comment.user.pic}")),
      host_post_id: comment.host_post_id,
      message: comment.message,
      created_at: comment.inserted_at
    }
  end
end
