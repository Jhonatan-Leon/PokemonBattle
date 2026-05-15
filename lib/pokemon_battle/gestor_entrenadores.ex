defmodule PokemonBattle.GestorEntrenadores do
  def login(trainers, store, user, password) do
    # Buscamos al entrenador
    trainer = Enum.find(trainers, fn e -> e.usuario == user && e.clave == password end)

    if trainer do
      # menu(sesion, store)
      IO.puts("Inicio sesión")
      PokemonBattle.Interfaz.menu(trainer, store)
    else
      IO.puts("Credenciales incorrectas ")
      register(trainers, store, user, password)
      # Implementar lógica para registro automatico
    end
  end

  def register(trainers, store, user, password) do
    case PokemonBattle.Trainer.nuevo(user, password) do
      {:ok, new_trainer} ->
        if Map.has_key?(trainers, new_trainer) do
          {:error, "No se puede registrar"}
        else
          trainer = %{new_trainer | usuario: user}
          list = Map.put(trainers, user, trainer)
          PokemonBattle.Interfaz.menu(trainer, store)
          {:ok, list}
        end
    end
  end

  def get_trainer(trainers, usuario) do
    case Map.get(trainers, usuario) do
      nil -> {:error, "No encontrado"}
      trainer -> {:ok, trainer}
    end
  end

  def inventario(trainer) do
    total_pokemon = length(trainer.inventario)
    IO.puts("\n=== Inventario de #{trainer.usuario} (#{total_pokemon} Pokémon) ===")

    Enum.each(trainer.inventario, fn i ->
      tipos = Enum.join(i["tipos"] || [], ", ")

      movimientos =
        i["movimientos"]
        |> Enum.map(fn m -> "#{m["nombre"]}(#{m["poder_base"]})" end)
        |> Enum.join(", ")

      IO.puts("
      [#{i["id"]}] #{i["especie"]} (#{tipos})  [#{i["rareza"]}]
      Ataque: #{i["ataque"]} | Defensa: #{i["defensa"]} | Velocidad: #{i["velocidad"]}
      Movimientos: #{movimientos}")
    end)
  end

  def perfil(trainer) do
    total_inventario = length(trainer.inventario)
    IO.puts("=== Perfil de #{trainer.usuario} === ")
    IO.puts("Monedas: #{trainer.monedas_actuales}")
    IO.puts("Pokemon en inventario: #{total_inventario}   ")
  end

  def equipos_guardados(trainer) do
    IO.puts("Equipos guardados: ")

    Enum.map(trainer.equipos_guardados, fn e ->
      pokemon_str = buscar_pokemon(trainer, e["pokemon_ids"], "", length(e["pokemon_ids"]))
      IO.puts("
      #{e["nombre"]} [#{length(e["pokemon_ids"])} / #{length(e["pokemons_ids"])}]: #{pokemon_str}
      ")
    end)

  end

  @spec buscar_pokemon(any(), list(), any(), any()) :: {:error, <<_::184>>}
  def buscar_pokemon(_, [],_, _), do: {:error, "No hay equipos formados"}

  def buscar_pokemon(trainer, [head | tail], "", num_pokemons) do
    pokemon = Enum.find(trainer.inventario, fn p -> p["id"] == head end)
    guardado_str = Enum.map(pokemon, fn p -> " #{p["id"]} #{p["especie"]} " end) |> Enum.join(", ")
    buscar_pokemon(trainer.inventario, tail, guardado_str, num_pokemons - 1)
  end

  def buscar_pokemon(_, [], guardado_str, num_pokemons) when num_pokemons < 0 do
    guardado_str
  end
end
