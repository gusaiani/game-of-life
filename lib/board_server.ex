defmodule GameOfLife.BoardServer do
  use GenServer
  require Logger

  @name {:global, __MODULE__}

  @game_speed 1000

  # Client

  def start_link(alive_cells) do
    case GenServer.start_link(__MODULE__, {alive_cells, nil, 0}, name: @name) do
      {:ok, pid} ->
        Logger.info "Started #{__MODULE__} master"
        {:ok, pid}
      {:error, {:already_started, pid}} ->
        Logger.info "Started #{__MODULE__} slave"
        {:ok, pid}
    end
  end

  def alive_cells do
    GenServer.call(@name, :alive_cells)
  end

  def generation_counter do
    GenServer.call(@name, :generation_counter)
  end

  def state do
    GenServer.call(@name, :state)
  end

  @doc """
  Clears board and adds only new cells.
  Generation counter is reset.
  """
  def set_alive_cells(cells) do
    GenServer.call(@name, {:set_alive_cells, cells})
  end

  def add_cells(cells) do
    GenServer.call(@name, {:add_cells, cells})
  end

  def tick do
    GenServer.cast(@name, :tick)
  end

  def start_game(speed \\ @game_speed) do
    GenServer.call(@name, {:start_game, speed})
  end

  def stop_game do
    GenServer.call(@name, :stop_game)
  end

  def change_speed(speed) do
    stop_game
    start_game(speed)
  end
end
