defmodule Dictionary.Runtime.Server do

  use Agent

  alias Dictionary.Impl.WordList

  @type t :: pid

  @me __MODULE__

  @spec start_link(any) :: {:ok, pid}
  def start_link(_) do
    Agent.start_link(&WordList.word_list/0, name: @me)
  end

  @spec random_word :: String.t
  def random_word do
    Agent.get(@me, &WordList.random_word/1)
  end

end
