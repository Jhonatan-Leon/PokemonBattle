defmodule PokemonBattle.Interfaz do
  def start(_type, _args) do
    main()
    {:ok, self()}
  end

  def main do
    store = PokemonBattle.Persistencia.load_store()
    trainers = PokemonBattle.Persistencia.load_trainer()

    IO.puts("\nBienvenido a Pokémon Battle")
    IO.puts("1. Iniciar sesión")
    IO.puts("2. Registrarse")
    IO.puts("3. Salir")

    case get_input("Selecciona la opción: ") do
      "1" ->
        login_flow(trainers, store)

      "2" ->
        register_flow(trainers, store)

      "3" ->
        IO.puts("Hasta luego")

      _ ->
        IO.puts("Opción no válida")
        main()
    end
  end

  defp login_flow(trainers, store) do
    usuario = IO.gets("Usuario: ") |> String.trim()
    contraseña = IO.gets("Contraseña: ") |> String.trim() |> String.to_integer()

    case PokemonBattle.GestorEntrenadores.login(trainers, store, usuario, contraseña) do
      {:ok, trainer} ->
        IO.puts("Inicio de sesión correcto")
        menu(trainer, store)

      {:error, razon} ->
        IO.puts("Error al iniciar sesión: #{razon}")
        main()
    end
  end

  defp register_flow(trainers, store) do
    IO.puts("\nRegistro de nuevo entrenador")
    usuario = IO.gets("Usuario: ")
    contraseña = IO.gets("Contraseña: ")

    case PokemonBattle.GestorEntrenadores.register(trainers, store, usuario, contraseña) do
      {:ok, trainer} ->
        IO.puts("Registro completado correctamente")
        menu(trainer, store)

      {:error, reason} ->
        IO.puts("No se pudo registrar: #{reason}")
        main()
    end
  end

  def menu(trainer, store) do
    IO.puts("\nBienvenido a Pokémon Battle, #{trainer.usuario}")
    IO.puts("1. Ver perfil")
    IO.puts("2. Ingresar al inventario")
    IO.puts("3. Ver equipos guardados")
    IO.puts("4. Clasificación")
    IO.puts("5. Tienda")
    IO.puts("6. Intercambio de Pokémon")
    IO.puts("7. Entrar en batalla 1v1")
    IO.puts("8. Cerrar sesión")

    case get_input("Selecciona la opción: ") do
      "1" ->
        PokemonBattle.GestorEntrenadores.perfil(trainer)
        menu(trainer, store)

      "2" ->
        PokemonBattle.GestorEntrenadores.inventario(trainer)
        menu(trainer, store)

      "3" ->
        PokemonBattle.GestorEntrenadores.equipos_guardados(trainer)
        menu(trainer, store)

      "4" ->
        PokemonBattle.GestorEntrenadores.clasificacion(store)
        menu(trainer, store)

      "5" ->
        PokemonBattle.GestorTienda.menu(trainer, store)
        menu(trainer, store)

      "6" ->
        PokemonBattle.GestorIntercambio.intercambiar_pokemon(trainer, store)
        menu(trainer, store)

      "7" ->
        PokemonBattle.GestorBatallas.sala_batalla_1v1(trainer, store)
        menu(trainer, store)

      "8" ->
        IO.puts("Cerrando sesión")
        main()

      _ ->
        IO.puts("Opción no válida")
        menu(trainer, store)
    end
  end

  defp get_input(prompt) do
    case IO.gets("#{prompt}") do
      nil -> ""
      input -> String.trim(input)
    end
  end
end
