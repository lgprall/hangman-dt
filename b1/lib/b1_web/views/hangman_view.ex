defmodule B1Web.HangmanView do
  use B1Web, :view
  
  def continue_or_try_again(conn, state) when state in [:won,:lost] do
    button( "Try again?", to: Routes.hangman_path(conn, :new))
  end

  def continue_or_try_again(conn, _ ) do
    form_for(conn, Routes.hangman_path(conn, :update), [ as: "make_move", method: :put ], fn f -> 
    [ text_input(f, :guess),
      " ",
      submit("Make next guess") 
    ]
    end) 
  end

  #############################################################################

  @status_fields %{
    initializing: { "initializing", "Guess the word, a letter at a time." },
    won:          { "won", "Congratulations, you won!" },
    lost:         { "lost", "Sorry, you lost." },
    good_guess:   { "good-guess", "Good guess." },
    bad_guess:    { "bad-guess", "Bad guess." },
    already_used: { "already-used", "You've already used that letter." },
    invalid:      { "invalid", "That's not a valid guess. Must be lower-case a-z." }
  }

  def move_status(state) do
    { class, msg } = @status_fields[state]
    "<div class='state #{class}'>#{msg}</div>"
  end

  #############################################################################

  defdelegate figure_for(turns_left), to: B1Web.HangmanView.Helpers.FigureFor
end
