defmodule PokemonBattle.Mixproject do
  use Mix.Project

  def project do
    [
      # Nombre de aplicativo
      app: :pokemon_battle,
      version: "1.0.0",
      elixir: "~> 1.4", # versión de elixir a usar
      start_permanent: Mix.env() == :dev,
      deps: deps() # llamada de dependencias
    ]
  end

  # Configuración de aplicación
  def application do
    [
       mod: {PokemonBattle.Interfaz, []},
      extra_applications: [:logger]
    ]

  end

  # dependencias o librerias
  defp deps do
    [
      {
        :jason, "~> 1.4"
      }
    ]
  end
end
