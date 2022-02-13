defmodule ImplGameTest do
  use ExUnit.Case
  doctest Hangman

  alias Hangman.Impl.Game

  test "new_game delivers proper map" do
    game = Game.new_game("test")
    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert game.letters    == ["t","e","s","t"]
    assert game.used       == MapSet.new
  end

  test "make_move detects invalid characters" do
    game = Game.new_game()
    for guess <- ["@", "{", "M"] do
      {game, _tally} = Game.make_move(game, guess)
      assert game.game_state == :invalid
    end
  end

  test "make_move detects previously use guess" do
    game = Game.new_game
    {game,_tally} = Game.make_move(game, "x")
    assert game.game_state != :already_used
    {game,_tally} = Game.make_move(game, "y")
    assert game.game_state != :already_used
    {game,_tally} = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "make_move detects good guess" do
    game = Game.new_game("hello")
    {game,_tally} = Game.make_move(game, "e")
    assert game.game_state == :good_guess
  end

  test "make_move detects bad guess" do
    game = Game.new_game("hello")
    {game,_tally} = Game.make_move(game, "t")
    assert game.game_state == :bad_guess
  end

  test "make_move detects won game" do
    [# guess  turns   state        letters                 used
      [ "e",  7,      :good_guess, ["_","e","_","_","_"],  ["e"] ],
      [ "t",  6,      :bad_guess,  ["_","e","_","_","_"],  ["e","t"] ],
      [ "a",  5,      :bad_guess,  ["_","e","_","_","_"],  ["a","e","t"] ],
      [ "o",  5,      :good_guess, ["_","e","_","_","o"],  ["a","e","o","t"] ],
      [ "h",  5,      :good_guess, ["h","e","_","_","o"],  ["a","e","h","o","t"] ],
      [ "l",  5,      :won,        ["h","e","l","l","o"],  ["a","e","h","l","o","t"] ],
    ]
    |> run_series()
  end

  test "make_move detects lost game" do
    [# guess  turns   state        letters                 used
      [ "e",  7,      :good_guess, ["_","e","_","_","_"],  ["e"] ],
      [ "t",  6,      :bad_guess,  ["_","e","_","_","_"],  ["e","t"] ],
      [ "a",  5,      :bad_guess,  ["_","e","_","_","_"],  ["a","e","t"] ],
      [ "s",  4,      :bad_guess,  ["_","e","_","_","_"],  ["a","e","s","t"] ],
      [ "r",  3,      :bad_guess,  ["_","e","_","_","_"],  ["a","e","r","s","t"] ],
      [ "u",  2,      :bad_guess,  ["_","e","_","_","_"],  ["a","e","r","s","t","u"] ],
      [ "v",  1,      :bad_guess,  ["_","e","_","_","_"],  ["a","e","r","s","t","u","v"] ],
      [ "w",  0,      :lost,       ["_","e","_","_","_"],  ["a","e","r","s","t","u","v","w"] ],
    ]
    |> run_series()
  end

  def run_series(list) do
    game = Game.new_game("hello")
    Enum.reduce(list, game, &run_one/2)
  end

  def run_one([guess,turns,state,letters,used],game) do
    {game,tally} = Game.make_move(game, guess)
    assert tally.turns_left == turns
    assert tally.game_state == state
    assert tally.letters    == letters
    assert tally.used       == used

    game
  end


end
