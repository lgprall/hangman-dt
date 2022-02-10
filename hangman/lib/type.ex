defmodule Hangman.Type do

  @type state :: :initializing | :won | :lost | :good_move | :bad_move | :already_used | :invalid

  @type tally :: %{
    turns_left: integer,
    game_state: state,
    letters:    list(String.t),
    used:       list(String.t)
  }

end
