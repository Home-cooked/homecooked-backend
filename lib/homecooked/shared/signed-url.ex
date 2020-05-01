defmodule Homecooked.SignedUrl do
  use Agent
  alias ExAws.S3

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  defp sign(orig_path) do
    {:ok, dt} = DateTime.now("Etc/UTC")
    {:ok, url } =
        ExAws.Config.new(:s3)
        |> S3.presigned_url(:get, "homecooked-images", orig_path)
    Agent.update(__MODULE__, &(Map.put(&1, orig_path, [dt, url])))
    url
  end

  def get(url) when is_nil(url) do
    nil
  end
  
  def get(url) do
    map = Agent.get(__MODULE__, & &1)
    IO.puts "here"
    case Map.get(map, url) do
      nil -> sign(url)
      [dt, old_url] ->
        {:ok, dt2} = DateTime.now("Etc/UTC")
        if DateTime.diff(dt2, dt) > 3530 do
          sign(url)
        else
          old_url
        end
    end
  end

end
