defmodule Hangman.Impl.Game do

  alias Hangman.Type

  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters: [],
    used: MapSet.new
  )

  @type t :: %__MODULE__{
    turns_left: integer,
    game_state: Type.state,
    letters: list(String.t),
    used: MapSet.t(String.t)
  }

  @spec new_game(String.t) :: t
  def new_game(word) do
    %__MODULE__{
      letters: word |> String.codepoints
    }
  end

  @spec new_game() :: t
  def new_game do
    new_game( Dictionary.random_word )
  end

  @spec make_move(t, String.t) :: {t, Type.tally}

  def make_move(game,guess)
  when (guess < "a" or guess > "z") do
    %{game | game_state: :invalid}
    |> return_with_tally
  end

  def make_move(game = %{game_state: state}, _guess)
  when state in [:won, :lost] do
    game
    |> return_with_tally
  end

  def make_move(game, guess) do
    guess = guess |> String.codepoints |> hd
    accept_move(game, guess, MapSet.member?(game.used, guess))
    |> return_with_tally
  end

  ###############################################################

  def accept_move(game, _guess, _already_used = true) do
    %{game | game_state: :already_used }
  end

  def accept_move(game, guess, _new_guess) do
    %{game | used: MapSet.put(game.used, guess)}
    |> score_move( Enum.member?(game.letters, guess))

  end

  def score_move( game, _good_guess = true) do
    new_state = check_win(MapSet.subset?(MapSet.new(game.letters), game.used))
    %{game | game_state: new_state}
  end

  def score_move( game = %{turns_left: 1}, _bad_guess) do
    %{game | game_state: :lost, turns_left: 0}
  end

  def score_move( game, _bad_guess) do
    %{game | game_state: :bad_guess, turns_left: game.turns_left - 1}
  end


  def check_win(true), do: :won
  def check_win(_),    do: :good_guess

  def return_with_tally(game) do
    { game, tally(game) }
  end

  def tally(game) do
    %{ 
      turns_left: game.turns_left,
      game_state: game.game_state,
      letters: show_letters(game),
      used: game.used |> MapSet.to_list |> Enum.sort
    }
  end

  def show_letters(game) do
    game.letters
    |> Enum.map( fn letter ->  MapSet.member?(game.used, letter) |> show?(letter) end)
  end

  def show?(true,letter), do: letter
  def show?(_, _),        do: "_"

end

