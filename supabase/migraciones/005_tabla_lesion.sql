-- =====================================================================
-- 005_tabla_lesion.sql · Fut-Test (Grupo 22)
-- Crea la tabla "lesion": cada fila es una lesión de un jugador.
--
-- Relación en el modelo E-R: JUGADOR (0,N) — sufre — (1,1) LESIÓN
--   - Un jugador puede no tener lesiones o tener muchas (opcional).
--   - Cada lesión es de un solo jugador y siempre tiene que tenerlo
--     (obligatoria): por eso "dni" es NOT NULL.
--
-- Columnas:
--   id             -> número que se pone solo; identifica cada lesión.
--   dni            -> de quién es la lesión (tiene que existir en "jugador").
--   fecha_lesion   -> cuándo se lesionó (obligatorio).
--   fecha_alta     -> cuándo volvió; vacía mientras siga lesionado.
--                     Días de baja = fecha_alta - fecha_lesion.
--   zona_corporal  -> isquiotibiales, tobillo, rodilla... (obligatorio).
--   lado           -> bilateral / derecha / izquierda, igual que en "resultado".
--   tipo           -> muscular, tendinosa, ligamentosa, articular, osea,
--                     contusion u otra (opcional).
--   mecanismo      -> contacto / sin_contacto (opcional).
--   contexto       -> entrenamiento / partido / otro (opcional).
--   recaida        -> si es la misma lesión que se repite (por defecto no).
--   observaciones  -> texto libre.
--
-- OJO: esta migración YA ESTÁ APLICADA en Supabase (18/11/2026). Se aplicó
-- sin pasar antes por Pull Request (error de Claude). Este archivo deja el
-- repositorio igual que la base de datos para que el grupo lo revise.
-- Si el grupo no la aprueba, se borrará la tabla con una migración nueva.
-- =====================================================================

create table public.lesion (
  id bigint generated always as identity primary key,
  dni text not null references public.jugador(dni),
  fecha_lesion date not null check (fecha_lesion >= '1900-01-01'::date),
  fecha_alta date check (fecha_alta >= fecha_lesion),
  zona_corporal text not null,
  lado text not null default 'bilateral'
    check (lado in ('bilateral','derecha','izquierda')),
  tipo text check (tipo in ('muscular','tendinosa','ligamentosa','articular','osea','contusion','otra')),
  mecanismo text check (mecanismo in ('contacto','sin_contacto')),
  contexto text check (contexto in ('entrenamiento','partido','otro')),
  recaida boolean not null default false,
  observaciones text
);

comment on table public.lesion is 'Lesiones de cada jugador (relación "sufre": jugador 0,N - lesión 1,1)';
comment on column public.lesion.fecha_alta is 'Vacía mientras el jugador siga lesionado; días de baja = fecha_alta - fecha_lesion';

-- Índice para buscar rápido las lesiones de un jugador.
create index lesion_dni_idx on public.lesion (dni);

-- Seguridad: igual que el resto de tablas, solo usuarios con sesión iniciada.
alter table public.lesion enable row level security;

create policy "usuarios con sesion gestionan lesiones"
  on public.lesion for all to authenticated
  using (true) with check (true);
