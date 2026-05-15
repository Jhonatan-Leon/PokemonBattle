defmodule PokemonBattle.Servidor do
  use GenServer, restart: :temporary

  def start_link(id_batalla, e1) do #EL USUARIO CREA EL ID PARA CONECTARSE
    GenServer.start_link(__MODULE__, {id_batalla, e1}, name: via_tuple(id_batalla))
  end

  # Esto permite registrar el proceso con un nombre único en el sistema
  defp via_tuple(id_batalla), do: {:global, {:batalla, id_batalla}}

  def unirse(id_batalla, e2) do
    GenServer.call(via_tuple(id_batalla), {:unirse, e2})
  end

  @impl true
  def init({id_batalla, e1}) do
    IO.puts("Instancia de batalla #{id_batalla} creada por #{e1.usuario}")
    {:ok, %{id: id_batalla, e1: e1, e2: nil, turno: 1}}
  end

  @impl true
  def handle_call({:unirse, e2}, _from, estado) do
    IO.puts("¡#{e2.usuario} se ha unido a la batalla #{estado.id}!")

    send(self(), :comenzar_pelea)

    {:reply, :ok, %{estado | e2: e2}}
  end

  @impl true
  def handle_info(:comenzar_pelea, estado) do
    MotorBatalla.loop_batalla(estado.e1, estado.e2, estado.turno)
    {:noreply, estado}
  end

  def menu_unirse_batallas(entrenador_actual) do
  id = IO.gets("Ingrese el ID del servidor al que desea conectarse: ") |> String.trim()

  # Intenta unirse a un sv existente
  case GenServer.whereis({:global, {:batalla, id}}) do
    nil ->
      # Si no existe, este usuario crea el servidor por asi decirlo
      IO.puts("Servidor no encontrado. Creando servidor #{id}...")
      PokemonBattle.Servidor.start_link(id, entrenador_actual)
      IO.puts("Esperando oponente...")

    _pid ->
      # Si existe, nos unimos
      IO.puts("Conectando al servidor #{id}...")
      PokemonBattle.Servidor.unirse(id, entrenador_actual)
    end
  end
end
