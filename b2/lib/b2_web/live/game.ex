defmodule B2Web.Live.Game do

  use B2Web, :live_view

  def mount(_params, _session, socket) do
    game = Hangman.new_game
    tally = Hangman.tally(game)
    {rg, _pid} = :sys.get_state(game)
    word = rg.letters |> Enum.join
    socket = socket |> assign(%{ game: game, tally: tally, word: word })
    {:ok, socket}
  end

  def handle_event("make_move", %{ "key" => key }, socket) do
    tally = Hangman.make_move(socket.assigns.game, key)
    {:noreply, assign(socket, tally: tally) }
  end

  def render(assigns) do
    ~H"""
    <div class="game-holder" phx-window-keyup="make_move">
      <div id="game" class="row">
        <div class="column">
          <%= live_component(__MODULE__.Figure, tally: assigns.tally, id: 1) %>
        </div>
        <div class="column">
          <%= live_component(__MODULE__.Alphabet, tally: assigns.tally, id: 2) %>
          <%= live_component(__MODULE__.WordSoFar, tally: assigns.tally, id: 3) %> 
      <%= if assigns.tally.game_state in [:won,:lost] do %>
          <%= live_component(__MODULE__.Result, tally: assigns.tally, word: assigns.word, id: 4) %> 
      <% end %>
        </div>
      </div>
    </div>
    """
  end
end

