defmodule PokemonBattle.Persistencia do
  @path_pokemon "lib/data/pokemon.json"
  @path_trainer "lib/data/trainer.json"

  def load_pokemon do
    # Revisión de carpeta
    #IO.puts("Buscando archivo en: #{File.cwd!()}")
    # Lectura de archivo json
    case File.read(@path_pokemon) do
      {:ok, content} ->
        #decodificación del json
        mapa = JSON.decode!(content)
        # definimos los mapas con la struct
        Enum.map(mapa, fn m ->
          mapa_a_struct(m)
        end)
      {:error,razon} ->
          IO.puts("Error al carga el archivo json #{inspect(razon)}")
        []
    end
  end

  #Conversión de mapa a struct
  defp mapa_a_struct (mapa) do
    %PokemonBattle.Pokemon {
      especie: String.to_atom(mapa["especie"]),
      ataque: mapa["ataque_base"],
      defensa: mapa["defensa_base"]
    }
  end

  def load_trainer do
    case File.read(@path_trainer) do
    {:ok, content} ->
      JSON.decode!(content)
      |> Enum.map(fn m ->
        mapa_a_struct(m)
      end)
    {:error, razon} ->
      IO.puts("Error en la carga de usuarios #{inspect(razon)}")
      []
    end
  end
end
