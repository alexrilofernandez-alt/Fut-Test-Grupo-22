-- =====================================================================
-- 004_lado_resultado.sql · Fut-Test (Grupo 22)
-- Añade a "resultado" el lado del cuerpo con el que se hizo el test,
-- para poder comparar pierna derecha e izquierda (asimetrías).
--
-- Valores posibles:
--   'bilateral' -> test con las dos piernas (CMJ normal, sprint...). Es el
--                  valor por defecto, así que si no se indica nada se pone este.
--   'derecha'   -> test hecho solo con la pierna derecha.
--   'izquierda' -> test hecho solo con la pierna izquierda.
--
-- "lado" entra en la CLAVE PRIMARIA. Si no, un jugador no podría guardar
-- el mismo test, el mismo día y el mismo parámetro dos veces (una por
-- cada pierna): la segunda fila tendría la misma clave que la primera.
-- Aprobado por el grupo el 16/11/2026.
-- =====================================================================

begin;

alter table resultado
  add column lado text not null default 'bilateral'
    check (lado in ('bilateral', 'derecha', 'izquierda'));

alter table resultado drop constraint resultado_pkey;

alter table resultado
  add constraint resultado_pkey primary key (dni, nombre_test, fecha, parametro, lado);

commit;
