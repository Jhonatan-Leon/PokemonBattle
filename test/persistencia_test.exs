defmodule PokemonBattle.PersistenciaTest do
  use ExUnit.Case # Habilita framework para uso

  test "cargar pokemons convierte los datos JSON" do
    # EJecutar
    pokemon = PokemonBattle.Persistencia.load_pokemon();
    IO.puts("Resultado: #{inspect(pokemon)}")
    # Verificamos que sea una lista
    assert is_list(pokemon)

    #Verificación que no este vacía
    assert length(pokemon) > 0;

    # Verificamos el resultado
      first_pokemon = hd(pokemon)
      assert %PokemonBattle.Pokemon{} = first_pokemon;

    # Verificación de datos correctos
    assert first_pokemon.especie == :charmander;
    assert is_integer(first_pokemon.ataque)
  end
end
