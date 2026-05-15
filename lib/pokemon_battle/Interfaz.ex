defmodule PokemonBattle.Interfaz do

  def start(_type, _args) do
    main()
    {:ok, self()}
  end

  def main do
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
        main();
      _ ->
        IO.puts("Opción no válida")
        # Habiliar opción para registro automatico
    end
  end

  def menu(trainer, store) do
    IO.puts("Bienvenido a Pokemon Battle #{trainer.usuario}")
    opcion = IO.gets("Menu de juego: \n
    1. Ver perfil
    2. Ingresar al inventario
    3. Ver equipos guardados
    4. Clasificación
    5. Tienda
    6. Intercambio de pokemon
    7. Entrar en Batalla
    : ") |> String.trim()

    case opcion do
      "1" ->
        PokemonBattle.GestorEntrenadores.perfil(trainer);
        menu(trainer, store)
      "7" ->
        PokemonBattle.Servidor.menu_unirse_batallas(trainer)
      _ ->
        IO.puts("La opción no es valida")
        menu(trainer, store)
    end

  end
end
