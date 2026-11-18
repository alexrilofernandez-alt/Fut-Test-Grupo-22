-- =====================================================================
-- 006_tabla_bienestar.sql · Fut-Test (Grupo 22)
-- Crea la tabla "bienestar": el cuestionario corto que cada jugador
-- rellena POR LAS MAÑANAS (índice de Hooper). Sirve para detectar si
-- un jugador llega cansado, mal dormido o cargado antes de entrenar.
--
-- Relación en el modelo E-R: JUGADOR (0,N) — rellena — (1,1) BIENESTAR
--   - Un jugador puede tener muchos cuestionarios o ninguno (opcional).
--   - Cada cuestionario es de un solo jugador (obligatoria).
--
-- Clave primaria: dni + fecha -> un cuestionario por jugador y día.
--
-- Columnas (escala 1 a 7: 1 = muy bien ... 7 = muy mal):
--   sueno, fatiga, dolor_muscular, estres -> obligatorias, para que no se
--     guarden cuestionarios a medias. La suma de las 4 (de 4 a 28) es el
--     índice de Hooper; no se guarda, se calcula.
--   horas_sueno -> opcional, de 0 a 24.
--
-- OJO: esta migración YA ESTÁ APLICADA en Supabase (18/11/2026). Se aplicó
-- sin pasar antes por Pull Request (error de Claude). Este archivo deja el
-- repositorio igual que la base de datos para que el grupo lo revise.
-- Si el grupo no la aprueba, se borrará la tabla con una migración nueva.
-- =====================================================================

create table public.bienestar (
  dni text not null references public.jugador(dni),
  fecha date not null,
  sueno smallint not null check (sueno between 1 and 7),
  fatiga smallint not null check (fatiga between 1 and 7),
  dolor_muscular smallint not null check (dolor_muscular between 1 and 7),
  estres smallint not null check (estres between 1 and 7),
  horas_sueno numeric check (horas_sueno >= 0 and horas_sueno <= 24),
  primary key (dni, fecha)
);

comment on table public.bienestar is 'Cuestionario de bienestar (índice de Hooper) que cada jugador rellena por la mañana; relación "rellena": jugador 0,N - bienestar 1,1';
comment on column public.bienestar.sueno is '1 = muy bien ... 7 = muy mal';

-- Seguridad: igual que el resto de tablas, solo usuarios con sesión iniciada.
alter table public.bienestar enable row level security;

create policy "usuarios con sesion gestionan bienestar"
  on public.bienestar for all to authenticated
  using (true) with check (true);
