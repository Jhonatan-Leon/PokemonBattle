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

  test "Carga de entrenadores converseión de los datos JSON" do
    IO.puts("-------------------------------------------")
    trainers = PokemonBattle.Persistencia.load_trainer();
    IO.puts("Resultado: #{inspect(trainers)} " )

    #verificar lista de entrenadores
    assert is_list(trainers);

    #Verificación de datos no esten vacios
    assert length(trainers);

    # Verificación de resultado sean iguales
    trainer = hd(trainers);
    assert %PokemonBattle.Trainer{} = trainer;

    #Verificación de datos se puedan usar
    assert trainer.usuario == "Carlos";
    assert is_integer(trainer.clave);
  end

  test "Carga de datos " do
  IO.puts("----------------------------")
  sobres = PokemonBattle.Persistencia.load_store();
  IO.puts("Resultado: #{inspect(sobres)}");

  #Verificamos que sea una lista de sobres
  assert is_list(sobres);

  #Verificamos que los datos tenga un valor
  assert length(sobres)

  #Verificamos que sea exitoso la carga del archivo
  sobre = hd(sobres);
  assert %PokemonBattle.Store{} = sobre;

  # Confirmación de datos en uso
  assert sobre.precio > 0;
  assert sobre.tipo == "basico"
  end
end
