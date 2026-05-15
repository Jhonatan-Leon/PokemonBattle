defmodule MotorBatallaTest do
  use ExUnit.Case
  alias MotorBatalla

  test "Efectividad: Eléctrico contra Agua debe ser x2.0" do
    assert MotorBatalla.calcular_efectividad_ataque("Eléctrico", ["Agua"]) == 2.0
  end

  test "Efectividad: Fuego contra Roca/Tierra debe ser x0.5" do
    assert MotorBatalla.calcular_efectividad_ataque("Fuego", ["Roca", "Tierra"]) == 0.5
  end

  test "STAB: debe aplicar 1.5 si el tipo coincide" do
    assert MotorBatalla.definir_stab("Eléctrico", ["Eléctrico"]) == 1.5
  end

  test "Daño Total: el resultado debe ser un entero y cumplir con el rango" do
    dano = MotorBatalla.calcular_dano_total(13, "Eléctrico", ["Agua"], ["Eléctrico"])
    assert is_integer(dano)
    assert dano >= 1
  end
end
