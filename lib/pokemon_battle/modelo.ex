defmodule PokemonBattle.Pokemon do
  # Estructura definida para pokemons
  defstruct [:id , :especie , :dueño_original, :rareza, :ataque, :defensa, movimientos: []]
end

# Nombre especifico para escalar los entrenadores
defmodule PokemonBattle.Trainer do
  defstruct [:id, :usuario, :clave , victorias: 0, monedas_actuales: 0, monedas_acumuladas: 0, sobres_pendientes: 0, inventario: [], equipos: []]
end
