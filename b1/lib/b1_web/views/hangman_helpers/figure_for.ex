defmodule B1Web.HangmanView.Helpers.FigureFor do

  def figure_for(0) do
    ~S{
      ┌───┐
      │   │
      O   │
     /|\  │
     / \  │
          │
    ══════╧══
    }
  end
  def figure_for(1) do
    ~S{
      ┌───┐
      │   │
      O   │
     /|\  │
     /    │
          │
    ══════╧══
    }
  end

  def figure_for(2) do
    ~S{
    ┌───┐
    │   │
    O   │
   /|\  │
        │
        │
  ══════╧══
}
  end

  def figure_for(3) do
    ~S{
    ┌───┐
    │   │
    O   │
   /|   │
        │
        │
  ══════╧══
}
  end

  def figure_for(4) do
    ~S{
    ┌───┐
    │   │
    O   │
    |   │
        │
        │
  ══════╧══
}
  end

  def figure_for(5) do
    ~S{
    ┌───┐
    │   │
    O   │
        │
        │
        │
  ══════╧══
}
  end

  def figure_for(6) do
    ~S{
    ┌───┐
    │   │
        │
        │
        │
        │
  ══════╧══
}
  end

  def figure_for(7) do
    ~S{
    ┌───┐
        │
        │
        │
        │
        │
  ══════╧══
}
  end

end
