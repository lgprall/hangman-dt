defmodule B2Web.Live.Game.Result do

  use B2Web, :live_component

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class = "result">
      The word was: "<%= @word %>"
    </div>
    """


  end
end
