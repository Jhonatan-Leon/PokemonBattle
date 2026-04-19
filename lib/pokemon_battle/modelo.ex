defmodule PokemonBattle.Pokemon do
  # Estructura definida para pokemons
  defstruct [:id , :especie , :dueño_original, :rareza, :ataque, :defensa, :movimientos]
end

# Nombre especifico para escalar los entrenadores
defmodule PokemonBattle.Trainer do
  defstruct [:id, :nombre, :clave , :victorias, :monedas_actuales, :monedas_acumuladas, :inventario, :equipos]
end
