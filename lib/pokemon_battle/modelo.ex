defmodule PokemonBattle.Pokemon do
  # Estructura definida para pokemons
  defstruct [:id , :especie , :dueño_original, :rareza, :ataque, :defensa, :velocidad_base, movimientos: [], salud_maxima: 100]
end

# Nombre especifico para escalar los entrenadores
defmodule PokemonBattle.Trainer do
  @enforce_keys [:usuario, :clave]
  defstruct [:usuario, :clave , victorias: 0, monedas_actuales: 0, monedas_acumuladas: 0, sobres_pendientes: 0, inventario: [], equipos_guardados: [], equipo: []]

  def nuevo(nombre, password) do
    {:ok, %__MODULE__{usuario: nombre, clave: password}}
  end
end

defmodule PokemonBattle.Store do
  defstruct [:id, :precio, :tipo, probabilidad: [] ]
end

defmodule PokemonBattle.Moves do
  defstruct [:nombre, :tipo_poder, :poder_base]
end
