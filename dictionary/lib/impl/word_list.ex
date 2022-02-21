defmodule Dictionary.Impl.WordList do

  @spec word_list :: list(String.t)
  def word_list do
    "../assets/words.txt"
    |> File.read!
    |> String.split(~r/\n/, trim: true)
  end

  @spec random_word :: String.t
  def random_word, do: word_list() |> Enum.random

end
