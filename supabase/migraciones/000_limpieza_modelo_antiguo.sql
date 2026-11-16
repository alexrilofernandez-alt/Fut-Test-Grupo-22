-- =====================================================================
-- 000_limpieza_modelo_antiguo.sql · Fut-Test (Grupo 22)
-- Borra las tablas de una versión anterior del modelo que había en el
-- proyecto de Supabase "fut-test" (estaban vacías: 0 filas en todas).
-- "if exists" hace que, en una base de datos nueva, no haga nada.
-- Se ejecuta ANTES de 001_tablas.sql.
-- =====================================================================

begin;

drop table if exists
  sesion_tarea_resistencia,
  sesion_tarea_fuerza,
  sesion_tarea_salto,
  sesion_tarea_cambio_direccion,
  sesion_tarea_sprint,
  resultado,
  realiza,
  tarea_resistencia,
  tarea_fuerza,
  tarea_salto,
  tarea_cambio_direccion,
  tarea_sprint,
  sesion,
  test,
  jugador;

commit;
