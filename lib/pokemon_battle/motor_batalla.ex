defmodule TiposPokemon do
  # basicmente estos metodos devuelven true si es alguno de los de la derecha
  # adicional todo caso inverso deberia significar un ataque debil, es decir, un x0.5
  defp es_fuerte?("Fuego", def), do: def in ["Planta", "Hielo", "Bicho"]
  defp es_fuerte?("Agua", def), do: def in ["Fuego", "Roca", "Tierra"]
  defp es_fuerte?("Planta", def), do: def in ["Agua", "Roca", "Tierra"]
  defp es_fuerte?("Eléctrico", def), do: def in ["Agua", "Volador"]
  defp es_fuerte?("Roca", def), do: def in ["Fuego", "Hielo", "Volador", "Bicho"]
  # Este atrapa todo por fuera de las demas combinaciones, por lo que seria un x1
  defp es_fuerte?(_, _), do: false

  def obtener_modificador(tipo_mov, tipo_def) do
    cond do
      es_fuerte?(tipo_mov, tipo_def) -> 2.0
      es_fuerte?(tipo_def, tipo_mov) -> 0.5
      true -> 1.0
    end
  end
end

defmodule MotorBatalla do
  def calcular_efectividad_ataque(tipo_mov, tipos_def) do
    # ejemplo de funcionamiento del metodo
    # Charizard(ataque tipo fuego) vs Snover(tipo planta/hielo)
    # charizar ataca a snover entonces primero se toma el modificador del primer tipo de que daria un x2 porque es fuerte,
    # porsteriormente se recorre el segundo tipo que tambien daria x2, ese x2 se suma al x2 anterior, dando como resultado que
    # un ataque tipo fuego de charizard le daria un daño x4 a Snover
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
      p1.velocidad_base == p2.velocidad_base -> Enum.shuffle([p1, p2])
      |> List.to_tuple() #si son iguales se vuelve aleatorio el primer turno
    end
  end

  def iniciar_proceso_batalla(e1, e2) do
    spawn(fn -> loop_batalla(e1,e2,1) end) #entrenador 1 y el entrenador 2
  end

  def loop_batalla(e1,e2,turno) do
    IO.puts("\n=== TURNO #{turno} ====")

  end
end
