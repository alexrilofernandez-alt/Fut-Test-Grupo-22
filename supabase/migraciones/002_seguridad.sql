-- =====================================================================
-- 002_seguridad.sql · Fut-Test (Grupo 22)
-- Row Level Security (RLS) y políticas iniciales.
--
-- Idea general (versión inicial, sencilla):
--   * "anon" = cualquiera que abra la web sin iniciar sesión.
--     -> NO puede ver ni tocar nada. Hay datos personales (DNI, peso,
--        altura, RPE) que no deben ser públicos.
--   * "authenticated" = usuario que ha iniciado sesión con Supabase Auth
--     (el entrenador / los miembros del grupo).
--     -> Puede leer, crear, modificar y borrar en todas las tablas.
--
-- IMPORTANTE: con esto, CUALQUIER cuenta que inicie sesión tiene acceso
-- total. Por eso hay que desactivar el registro libre en Supabase
-- (Authentication > Sign In / Providers > "Allow new users to sign up")
-- y crear a mano solo las cuentas del grupo.
-- =====================================================================

begin;

-- ---------------------------------------------------------------------
-- 1) Activar RLS en todas las tablas.
--    Con RLS activado y sin políticas, NADIE puede acceder a las filas
--    desde la web: cada política de abajo "abre" un permiso concreto.
-- ---------------------------------------------------------------------

alter table jugador                  enable row level security;
alter table test                     enable row level security;
alter table sesion                   enable row level security;
alter table resultado                enable row level security;
alter table realiza                  enable row level security;
alter table tarea_resistencia        enable row level security;
alter table tarea_fuerza             enable row level security;
alter table tarea_salto              enable row level security;
alter table tarea_cambio_direccion   enable row level security;
alter table tarea_sprint             enable row level security;
alter table incluye_resistencia      enable row level security;
alter table incluye_fuerza           enable row level security;
alter table incluye_salto            enable row level security;
alter table incluye_cambio_direccion enable row level security;
alter table incluye_sprint           enable row level security;

-- ---------------------------------------------------------------------
-- 2) Permisos de tabla (GRANT). Es la "primera puerta": qué rol puede
--    siquiera intentar leer/escribir. RLS es la "segunda puerta".
--    Quitamos todo a "anon" y damos lo necesario a "authenticated".
-- ---------------------------------------------------------------------

revoke all on
  jugador, test, sesion, resultado, realiza,
  tarea_resistencia, tarea_fuerza, tarea_salto, tarea_cambio_direccion, tarea_sprint,
  incluye_resistencia, incluye_fuerza, incluye_salto, incluye_cambio_direccion, incluye_sprint
from anon;

grant select, insert, update, delete on
  jugador, test, sesion, resultado, realiza,
  tarea_resistencia, tarea_fuerza, tarea_salto, tarea_cambio_direccion, tarea_sprint,
  incluye_resistencia, incluye_fuerza, incluye_salto, incluye_cambio_direccion, incluye_sprint
to authenticated;

-- ---------------------------------------------------------------------
-- 3) Políticas. Una por tabla: "for all" = select, insert, update y delete.
--    using (...)      -> qué filas puede VER / modificar / borrar.
--    with check (...) -> qué filas puede GUARDAR (insertar o dejar tras un update).
--    "to authenticated" hace que la política solo se aplique a usuarios
--    con sesión iniciada; "anon" no tiene ninguna y no ve nada.
-- ---------------------------------------------------------------------

create policy "usuarios con sesion gestionan jugadores"
  on jugador for all to authenticated using (true) with check (true);

create policy "usuarios con sesion gestionan test"
  on test for all to authenticated using (true) with check (true);

create policy "usuarios con sesion gestionan sesiones"
  on sesion for all to authenticated using (true) with check (true);

create policy "usuarios con sesion gestionan resultados"
  on resultado for all to authenticated using (true) with check (true);

create policy "usuarios con sesion gestionan realiza"
  on realiza for all to authenticated using (true) with check (true);

create policy "usuarios con sesion gestionan tareas de resistencia"
  on tarea_resistencia for all to authenticated using (true) with check (true);

create policy "usuarios con sesion gestionan tareas de fuerza"
  on tarea_fuerza for all to authenticated using (true) with check (true);

create policy "usuarios con sesion gestionan tareas de salto"
  on tarea_salto for all to authenticated using (true) with check (true);

create policy "usuarios con sesion gestionan tareas de cambio de direccion"
  on tarea_cambio_direccion for all to authenticated using (true) with check (true);

create policy "usuarios con sesion gestionan tareas de sprint"
  on tarea_sprint for all to authenticated using (true) with check (true);

create policy "usuarios con sesion gestionan incluye_resistencia"
  on incluye_resistencia for all to authenticated using (true) with check (true);

create policy "usuarios con sesion gestionan incluye_fuerza"
  on incluye_fuerza for all to authenticated using (true) with check (true);

create policy "usuarios con sesion gestionan incluye_salto"
  on incluye_salto for all to authenticated using (true) with check (true);

create policy "usuarios con sesion gestionan incluye_cambio_direccion"
  on incluye_cambio_direccion for all to authenticated using (true) with check (true);

create policy "usuarios con sesion gestionan incluye_sprint"
  on incluye_sprint for all to authenticated using (true) with check (true);

commit;
