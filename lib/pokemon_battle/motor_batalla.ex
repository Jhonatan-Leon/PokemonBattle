defmodule TiposPokemon do
  # Inmunidades (Daño x0)
  defp es_inmune?("Normal", "Fantasma"), do: true
  defp es_inmune?("Lucha", "Fantasma"), do: true
  defp es_inmune?("Tierra", "Volador"), do: true
  defp es_inmune?("Psíquico", "Siniestro"), do: true
  defp es_inmune?("Fantasma", "Normal"), do: true
  defp es_inmune?("Dragón", "Hada"), do: true
  defp es_inmune?("Veneno", "Acero"), do: true
  defp es_inmune?("Eléctrico", "Tierra"), do: true
  defp es_inmune?(_, _), do: false

  # El primer argumento es el tipo que ATACA, el segundo es el que DEFIENDE.
  # Si devuelve true, el daño es x2.0

  defp es_fuerte?("Fuego", tipo_def), do: tipo_def in ["Planta", "Hielo", "Bicho", "Acero"]
  defp es_fuerte?("Agua", tipo_def), do: tipo_def in ["Fuego", "Roca", "Tierra"]
  defp es_fuerte?("Planta", tipo_def), do: tipo_def in ["Agua", "Roca", "Tierra"]
  defp es_fuerte?("Eléctrico", tipo_def), do: tipo_def in ["Agua", "Volador"]
  defp es_fuerte?("Hielo", tipo_def), do: tipo_def in ["Planta", "Tierra", "Volador", "Dragón"]
  defp es_fuerte?("Lucha", tipo_def), do: tipo_def in ["Normal", "Hielo", "Roca", "Siniestro", "Acero"]
  defp es_fuerte?("Veneno", tipo_def), do: tipo_def in ["Planta", "Hada"]
  defp es_fuerte?("Tierra", tipo_def), do: tipo_def in ["Fuego", "Eléctrico", "Veneno", "Roca", "Acero"]
  defp es_fuerte?("Volador", tipo_def), do: tipo_def in ["Planta", "Lucha", "Bicho"]
  defp es_fuerte?("Psíquico", tipo_def), do: tipo_def in ["Lucha", "Veneno"]
  defp es_fuerte?("Bicho", tipo_def), do: tipo_def in ["Planta", "Psíquico", "Siniestro"]
  defp es_fuerte?("Roca", tipo_def), do: tipo_def in ["Fuego", "Hielo", "Volador", "Bicho"]
  defp es_fuerte?("Fantasma", tipo_def), do: tipo_def in ["Psíquico", "Fantasma"]
  defp es_fuerte?("Dragón", tipo_def), do: tipo_def in ["Dragón"]
  defp es_fuerte?("Siniestro", tipo_def), do: tipo_def in ["Psíquico", "Fantasma"]
  defp es_fuerte?("Acero", tipo_def), do: tipo_def in ["Hielo", "Roca", "Hada"]
  defp es_fuerte?("Hada", tipo_def), do: tipo_def in ["Lucha", "Dragón", "Siniestro"]

  defp es_fuerte?(_, _), do: false

  def obtener_modificador(tipo_mov, tipo_def) do
    cond do
      es_inmune?(tipo_mov, tipo_def) -> 0.0
      es_fuerte?(tipo_mov, tipo_def) -> 2.0
      es_fuerte?(tipo_def, tipo_mov) -> 0.5
      true -> 1.0
    end
  end
end

defmodule MotorBatalla do
  def calcular_efectividad_ataque(tipo_mov, tipos_def) do
    # Multiplica los modificadores por cada tipo del defensor
    Enum.reduce(tipos_def, 1.0, fn tipo_individual, acumulado ->
      acumulado * TiposPokemon.obtener_modificador(tipo_mov, tipo_individual)
    end)
  end

  # Cálculo de STAB (Sección 7.6) [cite: 280]
  def definir_stab(tipo_mov, tipos_atacante) do
    # El multiplicador es x1.5 si el tipo del movimiento coincide con algún tipo del atacante [cite: 280]
    if Enum.any?(tipos_atacante, fn tipo -> tipo == tipo_mov end) do
      1.5
    else
      1.0
    end
  end

  # Fórmula Final de Daño
  def calcular_dano_total(dano_base, tipo_mov, tipos_defensor, tipos_atacante) do
    efectividad = calcular_efectividad_ataque(tipo_mov, tipos_defensor)
    stab = definir_stab(tipo_mov, tipos_atacante)

    factor_aleatorio = 0.85 + (:rand.uniform() * 0.15)

    trunc(dano_base * efectividad * stab * factor_aleatorio)
  end

  def determinar_quien_inicia(p1,p2) do # pokemon 1 y pókemon 2
    cond do
      p1.velocidad_base > p2.velocidad_base -> {p1,p2} # esto es el orden por como se tome la tupla
      p2.velocidad_base > p1.velocidad_base -> {p2,p1}
      true ->
      [p1, p2]
      |> Enum.shuffle()
      |> List.to_tuple()
    end
  end

  # INTERFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ

  def iniciar_proceso_batalla(e1, e2) do
    spawn(fn -> loop_batalla(e1,e2,1) end) #entrenador 1 y el entrenador 2
  end

  def loop_batalla(e1,e2,turno) do

    p1 = Enum.find(e1.equipo, fn pokemon -> pokemon.salud_maxima > 0 end) # AJUSTAR LA LOGICA DEPENDIENDO DE COMO MANEJEMOS LA SELECCION
    p2 = Enum.find(e2.equipo, fn pokemon -> pokemon.salud_maxima > 0 end) # DEL EQUIPO

    cond do
  #    is_nil(p1) -> finalizar_batalla(e2,e1) # HACER LA LOGICA DEL FINALZAR BATLLA
   #   is_nil(p2) -> finalizar_batalla(e1,e2)
      true ->
        IO.puts("\n=== TURNO #{turno} ====")
        # me parece mejor ir por nombres en vez de rival y tal
        IO.puts("#{e1.usuario}: #{p1.nombre} (#{p1.hp} HP)")
        IO.puts("#{e2.usuario}: #{p2.nombre} (#{p2.hp} HP)")

    end
  end
end
