defmodule B2Web.Live.Game.Result do

  use B2Web, :live_component

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h4>
      The word was: <%= @word %>
    </h4>
    """


  end
end
