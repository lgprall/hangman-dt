defmodule TextClient.Impl.Player do

  @typep game   :: Hangman.game
  @typep tally  :: Hangman.tally
  @typep status :: %{
    games:   integer,
    wins:    integer,
    letters: integer,
    guesses: integer
  }

  @spec start :: :ok
  def start do 
    game  = Hangman.new_game
    tally = Hangman.tally(game)
    status = %{games: 0, wins: 0, letters: 0, guesses: 0}

    interact(game, tally, status)
  end

  @spec interact(game,tally,status) :: :ok

  def interact(game = %{game_state: :won}, _tally, status) do
    IO.puts("Congratulations, you won!
      The word was \"#{game.letters}\".")
    status = %{status |
      games: status.games + 1,
      wins:  status.games + 1,
      letters: status.letters + length(game.letters),
      guesses: status.guesses + 7 - game.turns_left
    }
    again(prompt("Another game? ") == "y", status)
  end

  def interact(game = %{game_state: :lost}, _tally, status) do
    IO.puts("Sorry. You lost.
      The word was \"#{game.letters}\",")
    status = %{status |
      games: status.games + 1,
      letters: status.letters + length(game.letters),
      guesses: status.guesses + 7 - game.turns_left
    }
    again(prompt("Try again? ") == "y", status)
  end

  def interact(game, tally, status) do
    feedback_for(game, status)
    IO.puts IO.ANSI.format(show_status(tally))
    guess = prompt("Next guess: ")
    {game,tally} = Hangman.make_move(game,guess)

    interact(game,tally,status)
  end

  def show_status(tally) do
    guesses = "#{int_to_word(tally.turns_left)} turn#{check_plural(tally.turns_left)}"
    [
      [:green, "    The word so far: #{tally.letters |> Enum.join(" ")}\n"],
      [:red,   "    You have #{guesses} left.\n"],
      [:cyan,  "    You have used the following letters: #{tally.used |> Enum.join(",")}\n"]
    ]
  end

  def prompt(prompt) do
    IO.gets(prompt)
    |> String.trim
    |> String.downcase
  end

  def feedback_for(game = %{game_state: :initializing}, _status = %{games: 0}) do
    IO.puts("\nWelcome to the game!")
    IO.puts("I'm thinking of a word of #{int_to_word(length(game.letters))} letters.")
  end

  def feedback_for(game = %{game_state: :initializing}, _status) do
    IO.puts("\nThis time I'm thinking of a word of #{int_to_word(length(game.letters))} letters.")
  end

  def feedback_for(_game = %{game_state: :invalid}, _status) do
    IO.puts("That is an invalid guess. It must be lowercase letter from \"a\" to \"z\".")
  end

  def feedback_for(_game = %{game_state: :already_used}, _status) do
    IO.puts("You've already used that letter.")
  end

  def feedback_for(_game = %{game_state: :good_guess}, _status) do
    IO.puts("Good guess.")
  end

  def feedback_for(_game = %{game_state: :bad_guess}, _status) do
    IO.puts("Sorry. That letter is not in the word.")
  end

  def again(true, status) do
    game  = Hangman.new_game
    tally = Hangman.tally(game)
    interact(game, tally, status)
  end

  def again(_no, status) do
    games = "game" <> check_plural(status.games)
    IO.puts("\nVery well.\nYou played #{int_to_word(status.games)} #{games} and won #{int_to_word(status.wins)}.\nThe average word length was #{Float.round((status.letters/status.games), 1)} letters.\nYou used an average of #{Float.round((status.guesses/status.games), 1)} of your allocated guesses.\n    See you next time!")
  end

  def check_plural(1), do: ""
  def check_plural(_), do: "s"
    
  def int_to_word(0), do: "none"
  def int_to_word(1), do: "one"
  def int_to_word(2), do: "two"
  def int_to_word(3), do: "three"
  def int_to_word(4), do: "four"
  def int_to_word(5), do: "five"
  def int_to_word(6), do: "six"
  def int_to_word(7), do: "seven"
  def int_to_word(8), do: "eight"
  def int_to_word(9), do: "nine"
  def int_to_word(10), do: "ten"
  def int_to_word(11), do: "eleven"
  def int_to_word(12), do: "twelve"
  def int_to_word(13), do: "thirteen"
  def int_to_word(14), do: "fourteen"
  def int_to_word(15), do: "fifteen"
  def int_to_word(16), do: "sixteen"
  def int_to_word(17), do: "seventeen"
  def int_to_word(18), do: "eighteen"
  def int_to_word(19), do: "nineteen"
  def int_to_word(20), do: "twenty"
  def int_to_word(n), do: n

end

