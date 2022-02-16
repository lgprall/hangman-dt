defmodule TextClient.Impl.Player do

  @typep game :: Hangman.game
  @typep tally :: Hangman.tally
  @typep stats :: %{
    games:   integer,
    wins:    integer,
    letters: integer,
    guesses: integer,
    flag:    integer
  }
    

  @spec start(game) :: :ok
  def start(game) do
    tally = Hangman.tally(game)
    stats = %{ games: 0, wins: 0, letters: 0, guesses: 0, flag: 0 }

    interact( game, tally, stats)
  end

  @spec interact(game, tally, stats) :: :ok

  def interact(game, tally = %{game_state: :initializing}, stats = %{ flag: 0 }) do
    IO.puts( "Welcome to the game!" )
    IO.puts( "I'm thinking of a word with #{int2wd(length(tally.letters))} letters.
")
    guess = prompt("What is your guess for the first letter? ")
    tally = Hangman.make_move(game, guess)
    stats = %{stats | flag: 1}

    interact(game, tally, stats)
  end

  def interact(game, tally = %{game_state: :initializing}, stats ) do
    IO.puts("This time I'm thinking of a word with #{int2wd(length(tally.letters))} letters.
")
    guess = prompt("What is your guess for the first letter? ")
    tally = Hangman.make_move(game, guess)

    interact(game, tally, stats)
  end

  def interact(game, tally = %{game_state: :won}, stats ) do
    letters = (:sys.get_state(game)).letters
    IO.puts("Congratulatons, you won!
The word was \"#{IO.ANSI.format([:green, letters])}\".")
    stats = %{
      stats |
        games:   stats.games + 1,
        wins:    stats.wins + 1,
        letters: stats.letters + length(tally.letters),
        guesses: stats.guesses + 7 - tally.turns_left
      }

    (prompt("\nPlay another game? ") == "y")
    |> again(stats)

  end

  def interact(game, tally = %{game_state: :lost}, stats )do
    letters = (:sys.get_state(game)).letters
    IO.puts("Sorry. You lost.
The word was \"#{IO.ANSI.format([:green, letters])}\".")
    stats = %{
      stats |
        games:   stats.games + 1,
        letters: stats.letters + length(tally.letters),
        guesses: stats.guesses + 7 - tally.turns_left
      }

    (prompt("\nTry again? ") == "y")
    |> again(stats)
  end

  def interact(game,tally, stats) do
    IO.puts(feedback(tally,stats))
    IO.puts IO.ANSI.format(show_stats(tally))
    guess = prompt("Next guess: ")
    tally = Hangman.make_move(game, guess)

    interact(game, tally, stats)
  end

  def show_stats(tally) do
    guesses = "#{int2wd(tally.turns_left)} turn#{plural(tally.turns_left)}"
    [
      [:green, "  The word so far: #{tally.letters|> Enum.join(" ")}\n"],
      [:red,   "  You have #{guesses} left.\n"],
      [:cyan,  "  You have used these letters: #{tally.used |> Enum.join(",")}\n"],
    ]
  end
  

  def feedback(_tally = %{game_state: :invalid}, _stats), do: "That is not a vaid entry. It must be a lowercase \"a\" to \"z\"."
  def feedback(_tally = %{game_state: :already_used}, _stats), do: "You have already used that letter."
  def feedback(_tally = %{game_state: :good_guess}, _stats), do: "Good guess."
  def feedback(_tally = %{game_state: :bad_guess}, _stats), do: "Sorry. That letter is not in the word."

  def again(_another = true, stats) do
    game = :rpc.call(:hangman@habu, Hangman, :new_game, [])
    tally = Hangman.tally(game)
    
    interact(game, tally, stats)
  end

  def again(_no_more, stats) do
    games = "game" <> plural(stats.games)
    IO.puts("
     Very well.
     You played #{int2wd(stats.games)} #{games} and won #{int2wd(stats.wins)}.
     The average word length was #{Float.round(stats.letters/stats.games, 1)} letters.
     You used an average of #{Float.round(stats.guesses/stats.games, 1)} of your allocated guesses.
     See you next time!
")
  end

  def prompt(string) do
    IO.gets(string)
    |> String.codepoints
    |> hd
    |> String.downcase
  end

  defp plural(1), do: ""
  defp plural(_), do: "s"

  defp int2wd(0), do: "none"
  defp int2wd(1), do: "one"
  defp int2wd(2), do: "two"
  defp int2wd(3), do: "three"
  defp int2wd(4), do: "four"
  defp int2wd(5), do: "five"
  defp int2wd(6), do: "six"
  defp int2wd(7), do: "seven"
  defp int2wd(8), do: "eight"
  defp int2wd(9), do: "nine"
  defp int2wd(10), do: "ten"
  defp int2wd(11), do: "eleven"
  defp int2wd(12), do: "twelve"
  defp int2wd(13), do: "thirteen"
  defp int2wd(14), do: "fourteen"
  defp int2wd(15), do: "fifteen"
  defp int2wd(16), do: "sixteen"
  defp int2wd(17), do: "seventeen"
  defp int2wd(18), do: "eighteen"
  defp int2wd(19), do: "nineteen"
  defp int2wd(20), do: "twenty"
  defp int2wd(n),  do: n

end
