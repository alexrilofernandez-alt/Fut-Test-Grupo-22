-- =====================================================================
-- 007_permisos_lesion_bienestar.sql · Fut-Test (Grupo 22)
-- PENDIENTE DE APROBACIÓN. NO está aplicada en Supabase.
--
-- Qué hace: deja los permisos de "lesion" y "bienestar" igual que los
-- del resto de tablas (ver 002_seguridad.sql).
--
-- Por qué: al crear una tabla nueva, Supabase da permisos por defecto al
-- usuario anónimo ("anon", alguien que entra en la web sin iniciar sesión).
-- En 002 se los quitamos a todas las tablas: es la "primera puerta".
-- Los datos de lesion y bienestar ya están protegidos por RLS (la
-- "segunda puerta": solo deja pasar a usuarios con sesión), pero así
-- seguimos el mismo diseño en todas las tablas y no dependemos de una
-- sola protección. Esto importa más aquí porque son datos de salud.
--
-- Cómo comprobarlo después: en el SQL Editor de Supabase,
--   select table_name, grantee, privilege_type
--   from information_schema.role_table_grants
--   where table_name in ('lesion', 'bienestar') and grantee = 'anon';
-- tiene que salir vacío.
-- =====================================================================

begin;

revoke all on lesion, bienestar from anon;

grant select, insert, update, delete on lesion, bienestar to authenticated;

commit;
