-- =====================================================================
-- 003_unidad_medida_resultado.sql · Fut-Test (Grupo 22)
-- Añade a la tabla "resultado" la unidad de medida de cada valor
-- (por ejemplo: cm, s, kg, W, m/s, km/h, repeticiones).
--
-- Va en "resultado" (y no en "test") porque un mismo test puede medir
-- varios parámetros con unidades distintas: en un CMJ, la altura va en
-- cm y la potencia en W.
--
-- Es opcional (puede quedar vacía) para no obligar a rellenarla si un
-- valor no tiene unidad, como una puntuación.
-- =====================================================================

begin;

alter table resultado
  add column unidad_medida text;

commit;
