defmodule PokemonBattle.Persistencia do
  @path_pokemon "lib/data/pokemon.json"
  @path_trainer "lib/data/trainer.json"
  @path_store "lib/data/store.json"

  def load_pokemon do
    # Revisión de carpeta
    #IO.puts("Buscando archivo en: #{File.cwd!()}")
    # Lectura de archivo json
    case File.read!(@path_pokemon) do
      {:ok, content} ->
        #decodificación del json
        mapa = JSON.decode!(content)
        # definimos los mapas con la struct
        Enum.map(mapa, fn m ->
          map_a_pokemon(m)
        end)
      {:error,razon} ->
          IO.puts("Error al carga el archivo json #{inspect(razon)}")
        []
    end
  end

  #Conversión de mapa a struct
  defp map_a_pokemon (mapa) do
    %PokemonBattle.Pokemon {
      especie: String.to_atom(mapa["especie"]),
      ataque: mapa["ataque_base"],
      defensa: mapa["defensa_base"],
      velocidad_base: mapa["velocidad_base"]
    }
  end

  def load_trainer do
    case File.read(@path_trainer) do
    {:ok, content} ->
      JSON.decode!(content)
      |> Enum.map(fn m ->
        map_a_trainer(m)
      end)
    {:error, razon} ->
      IO.puts("Error en la carga de usuarios #{inspect(razon)}")
      []
    end
  end

  defp map_a_trainer (mapa) do
    %PokemonBattle.Trainer {
      usuario: mapa["usuario"],
      clave: String.to_integer(mapa["clave"]),
      victorias: mapa["victorias"],
      monedas_actuales: mapa["monedas_actuales"],
      monedas_acumuladas: mapa["monedas_acumuladas"],
      sobres_pendientes: mapa["sobres_pendientes"],
      inventario: mapa["inventario"],
      equipos_guardados: mapa["equipos"],
      equipo: mapa["equipo"]

    }
  end

  # Carga de sobres
  def load_store do
    case File.read(@path_store) do
    {:ok, content} ->
      JSON.decode!(content)
      |> Enum.map(fn m ->
        map_a_store(m)
      end)
    {:error, razon} ->
    IO.puts("Error al carga los sobres: #{inspect(razon)}")
    end
  end

  defp map_a_store(mapa) do
    %PokemonBattle.Store {
      id: mapa["id"],
      precio: mapa["precio"],
      tipo: mapa["tipo"],
      probabilidad: mapa["probabilidades"] || []
    }
  end

  def save_trainer (trainer) do
    list_trainers = load_trainer()
    # Agregamos al entrenador a la lista de entrenadores
    new_list = [trainer | list_trainers]
    # Convertimos toda la lista a mapas
    new_data = Enum.map(new_list, fn e -> Map.from_struct(e) end) |> Jason.encode!()
    # Guardamos en el archivo JSON
    File.write!(@path_trainer, new_data, :append)

  end

end
