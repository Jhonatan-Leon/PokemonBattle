defmodule PokemonBattle.GestorEntrenadores do
  def login(sesion, store) do
    # Solicitar datos para los usuarios
    user = IO.gets("Ingrese su usuario: ") |> String.trim()
    password = IO.gets("Ingrese su contraseña: ") |> String.trim() |> String.to_integer()

    # Buscamos al entrenador
    trainer = Enum.find(sesion, fn e -> e.usuario == user && e.clave == password end)

    if trainer do
      # menu(sesion, store)
      IO.puts("Inicio sesión")
      PokemonBattle.Interfaz.menu(trainer, store)
    else
      IO.puts("Credenciales incorrectas ")
      login(sesion, store)
      # Implementar lógica para registro automatico
    end
  end

  def register(sesion, store) do
    IO.puts("Ya que no cuenta con una cuenta se realizara un registro automático ")

    username = IO.gets("Ingrese su usuario: ") |> String.trim()
    password = IO.gets("Ingrese una clave: ") |> String.trim()

    new_user = Enum.find(sesion, fn e -> e.usuario == username end)

    if !new_user do
      %PokemonBattle.Trainer {
        usuario: username,
        clave: password
      }
      |>PokemonBattle.Persistencia.save_trainer()
    else
      IO.puts("El usuario ya existe")
      register(sesion, store)
    end
  end

  def perfil(trainer) do
    Enum.map(trainer, fn t ->
      IO.puts("--Perfil de #{ t.usuario}")
      IO.puts("Monedas: #{Enum.sum(t.monedas_actuales)}")
      IO.puts("Sobres pendientes: #{Enum.sum(t. sobres_pendientes)}")
      IO.puts("Pókemon en inventario: #{Enum.sum(t.inventario)}")
    end)
  end
end
