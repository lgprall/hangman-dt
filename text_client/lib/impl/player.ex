defmodule TextClient.Impl.Player do
  @typep game :: Hangman.game()
  @typep tally :: Hangman.tally()
  @typep stats :: %{
           games:   integer,
           wins:    integer,
           letters: integer,
           guesses: integer
         }

  @spec start :: :ok
  def start do
    game  = Hangman.new_game()
    tally = Hangman.tally(game)
    stats = %{games: 0, wins: 0, letters: 0, guesses: 0, flag: 0}

    interact(game, tally, stats)
  end

  @spec interact(game, tally, stats) :: :ok

  def interact(game = %{game_state: :won}, _tally, stats) do
    IO.puts("Congratulations, you won!
      The word was \"#{IO.ANSI.format([:green, game.letters])}\".")

    stats = %{
      stats
      | games:   stats.games + 1,
        wins:    stats.wins + 1,
        letters: stats.letters + length(game.letters),
        guesses: stats.guesses + 7 - game.turns_left
    }

    again(prompt("\nAnother game? ") == "y", stats)
  end

  def interact(game = %{game_state: :lost}, _tally, stats) do
    IO.puts("Sorry. You lost.
      The word was \"#{IO.ANSI.format([:green, game.letters])}\".")

    stats = %{
      stats
      | games:   stats.games + 1,
        letters: stats.letters + length(game.letters),
        guesses: stats.guesses + 7 - game.turns_left
    }

    again(prompt("\nTry again? ") == "y", stats)
  end

  def interact(game, _tally, stats = %{flag: 0}) do
    stats = %{stats | flag: 1}
    feedback_for(game, stats)
    guess = prompt("\nGuess the first letter: ")
    {game, tally} = Hangman.make_move(game, guess)

    interact(game, tally, stats)
  end

  def interact(game, tally, stats) do
    feedback_for(game, stats)
    IO.puts(IO.ANSI.format(show_stats(tally)))
    guess = prompt("Next guess: ")
    {game, tally} = Hangman.make_move(game, guess)

    interact(game, tally, stats)
  end

  def show_stats(tally) do
    guesses = "#{int2wd(tally.turns_left)} turn#{plural(tally.turns_left)}"

    [
      [:green, "    The word so far: #{tally.letters |> Enum.join(" ")}\n"],
      [:red, "    You have #{guesses} left.\n"],
      [:cyan, "    You have used the following letters: #{tally.used |> Enum.join(",")}\n"]
    ]
  end

  def prompt(prompt) do
    IO.gets(prompt)
    |> String.trim()
    |> String.codepoints()
    |> hd
    |> String.downcase()
  end

  def feedback_for(game = %{game_state: :initializing}, _stats = %{games: 0}) do
    IO.puts("\nWelcome to the game!")
    IO.puts("I'm thinking of a word of #{int2wd(length(game.letters))} letters.")
  end

  def feedback_for(game = %{game_state: :initializing}, _stats) do
    IO.puts("\nThis time I'm thinking of a word of #{int2wd(length(game.letters))} letters.")
  end

  def feedback_for(_game = %{game_state: :invalid}, _stats) do
    IO.puts("That is an invalid guess. It must be lowercase letter from \"a\" to \"z\".")
  end

  def feedback_for(_game = %{game_state: :already_used}, _stats) do
    IO.puts("You've already used that letter.")
  end

  def feedback_for(_game = %{game_state: :good_guess}, _stats) do
    IO.puts("Good guess.")
  end

  def feedback_for(_game = %{game_state: :bad_guess}, _stats) do
    IO.puts("Sorry. That letter is not in the word.")
  end

  def again(true, stats) do
    game = Hangman.new_game()
    tally = Hangman.tally(game)
    interact(game, tally, stats)
  end

  def again(_no, stats) do
    games = "game" <> plural(stats.games)
    IO.puts("
      Very well.
      You played #{int2wd(stats.games)} #{games} and won #{int2wd(stats.wins)}.
      The average word length was #{Float.round(stats.letters / stats.games, 1)} letters.
      You used an average of #{Float.round(stats.guesses / stats.games, 1)} of your allocated guesses.
      See you next time!")
  end

  def plural(1), do: ""
  def plural(_), do: "s"

  def int2wd(0), do: "none"
  def int2wd(1), do: "one"
  def int2wd(2), do: "two"
  def int2wd(3), do: "three"
  def int2wd(4), do: "four"
  def int2wd(5), do: "five"
  def int2wd(6), do: "six"
  def int2wd(7), do: "seven"
  def int2wd(8), do: "eight"
  def int2wd(9), do: "nine"
  def int2wd(10), do: "ten"
  def int2wd(11), do: "eleven"
  def int2wd(12), do: "twelve"
  def int2wd(13), do: "thirteen"
  def int2wd(14), do: "fourteen"
  def int2wd(15), do: "fifteen"
  def int2wd(16), do: "sixteen"
  def int2wd(17), do: "seventeen"
  def int2wd(18), do: "eighteen"
  def int2wd(19), do: "nineteen"
  def int2wd(20), do: "twenty"
  def int2wd(n), do: n
end
