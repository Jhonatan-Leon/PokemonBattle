defmodule Server do
  def start do
    store = PokemonBattle.Persistencia.load_store();
    trainers = PokemonBattle.Persistencia.load_trainer();

    IO.puts("Bievenido a Pokemon Battle: ");
    IO.puts("1. Iniciar sesión ")
    IO.puts("2. Salir")

    opcion = IO.gets("Selecciona la opción: ") |> String.trim();

    case opcion do
      "1" ->
        PokemonBattle.GestorEntrenadores.login(trainers, store);
      "2" ->
        IO.puts("Cerrando sesión")
        start();
      _ ->
        IO.puts("Opción no válida")
        # Habiliar opción para registro automatico
    end
  end
end


Server.start();
