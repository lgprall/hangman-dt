defmodule Dictionary do

  alias Dictionary.Impl.WordList

  @spec word_list :: list(String.t)
  defdelegate word_list, to: WordList

  @spec random_word :: String.t
  defdelegate random_word, to: WordList

end
