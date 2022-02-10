defmodule ImplGameTest do
  use ExUnit.Case
  doctest Hangman

  alias Hangman.Impl.Game

  test "new_game returns correct map" do
    game = Game.new_game("corn")
    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert game.letters    == ["c","o","r","n"]
  end

  test "recognize invalid character" do
    game = Game.new_game
    for guess <- ["@","{","A"] do
      {game,_tally} = Game.make_move(game, guess)
      assert game.game_state == :invalid
    end
  end

  test "recognize good guess" do
    game = Game.new_game("hello")
    {game,_tally} = Game.make_move(game,"e")
    assert game.game_state == :good_guess
  end

  test "recognize bad guess" do
    game = Game.new_game("hello") 
    {game,_tally} = Game.make_move(game, "t")
    assert game.game_state == :bad_guess
  end

  test "recognize won game" do
    [
      [ "e", 7, :good_guess, ["_","e","_","_","_"], ["e"] ],
      [ "t", 6, :bad_guess,  ["_","e","_","_","_"], ["e","t"] ],
      [ "a", 5, :bad_guess,  ["_","e","_","_","_"], ["a","e","t"] ],
      [ "o", 5, :good_guess, ["_","e","_","_","o"], ["a","e","o","t"] ],
      [ "h", 5, :good_guess, ["h","e","_","_","o"], ["a","e","h","o","t"] ],
      [ "l", 5, :won,        ["h","e","l","l","o"], ["a","e","h","l","o","t"] ],
    ]
    |> run_series
  end

  test "recognize lost game" do
    [
      [ "e", 7, :good_guess, ["_","e","_","_","_"], ["e"] ],
      [ "t", 6, :bad_guess,  ["_","e","_","_","_"], ["e","t"] ],
      [ "a", 5, :bad_guess,  ["_","e","_","_","_"], ["a","e","t"] ],
      [ "b", 4, :bad_guess,  ["_","e","_","_","_"], ["a","b","e","t"] ],
      [ "c", 3, :bad_guess,  ["_","e","_","_","_"], ["a","b","c","e","t"] ],
      [ "d", 2, :bad_guess,  ["_","e","_","_","_"], ["a","b","c","d","e","t"] ],
      [ "f", 1, :bad_guess,  ["_","e","_","_","_"], ["a","b","c","d","e","f","t"] ],
      [ "x", 0, :lost,       ["_","e","_","_","_"], ["a","b","c","d","e","f","t","x"] ],
    ]
    |> run_series
  end

  def run_series(script) do
    game = Game.new_game("hello")
    Enum.reduce(script, game, &run_single/2)
  end

  def run_single([guess, turns, state, letters, used], game) do
    {game, tally} = Game.make_move(game, guess)
    assert tally.turns_left == turns
    assert tally.game_state == state
    assert tally.letters    == letters
    assert tally.used       == used

    game

  end

end

