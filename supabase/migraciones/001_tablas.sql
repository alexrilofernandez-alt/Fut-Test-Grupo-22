-- =====================================================================
-- 001_tablas.sql · Fut-Test (Grupo 22)
-- Traducción a PostgreSQL del modelo entidad-relación de docs/modelo-er.png
--
-- Convenciones:
--   * Nombres en español, en minúsculas y sin tildes.
--   * Las unidades van en el nombre de la columna (altura_cm, peso_kg...).
--   * ON UPDATE CASCADE en todas las claves foráneas: como las claves son
--     "naturales" (DNI, nombre del test, fecha...), si corregís un DNI o
--     renombráis un test, el cambio se copia solo a las tablas que lo usan.
-- =====================================================================

begin;

-- ---------------------------------------------------------------------
-- ENTIDADES PRINCIPALES
-- ---------------------------------------------------------------------

create table jugador (
  dni               text primary key,
  nombre_apellidos  text not null,
  dorsal            smallint check (dorsal between 1 and 99),
  altura_cm         numeric(5,1) check (altura_cm > 0),
  peso_kg           numeric(5,1) check (peso_kg > 0),
  posicion          text,
  pierna_dominante  text check (pierna_dominante in ('derecha', 'izquierda', 'ambas'))
);

create table test (
  nombre_test  text primary key,
  objetivo     text,
  explicacion  text,
  material     text
);

create table sesion (
  fecha         date primary key,
  duracion_min  integer check (duracion_min > 0),
  objetivo      text
);

-- ---------------------------------------------------------------------
-- RESULTADO
-- Jugador 1:N Resultado (REGISTRA)
-- Test    1:N Resultado (CORRESPONDE)
-- Sesion  1:N Resultado (PERTENECE)
-- Un mismo test puede medir varios parámetros (p. ej. altura y tiempo de
-- vuelo), por eso "parametro" forma parte de la clave primaria.
-- ---------------------------------------------------------------------

create table resultado (
  dni          text    not null,
  nombre_test  text    not null,
  fecha        date    not null,
  parametro    text    not null,
  resultado    numeric not null,
  primary key (dni, nombre_test, fecha, parametro),
  foreign key (dni)         references jugador (dni)         on update cascade on delete cascade,
  foreign key (nombre_test) references test (nombre_test)    on update cascade on delete restrict,
  foreign key (fecha)       references sesion (fecha)        on update cascade on delete restrict
);

-- ---------------------------------------------------------------------
-- REALIZA: Jugador N:M Sesion, con el RPE de ese jugador en esa sesión
-- ---------------------------------------------------------------------

create table realiza (
  dni    text not null,
  fecha  date not null,
  rpe    smallint check (rpe between 0 and 10),   -- escala CR-10 de Borg
  primary key (dni, fecha),
  foreign key (dni)   references jugador (dni)  on update cascade on delete cascade,
  foreign key (fecha) references sesion (fecha) on update cascade on delete cascade
);

-- ---------------------------------------------------------------------
-- CATÁLOGOS DE TAREAS (una tabla por tipo, como en el diagrama)
-- ---------------------------------------------------------------------

create table tarea_resistencia (
  nombre_tarea  text primary key,
  explicacion   text,
  material      text
);

create table tarea_fuerza (
  nombre_tarea  text primary key,
  explicacion   text,
  material      text,
  video_url     text            -- enlace al vídeo (YouTube, Drive...)
);

create table tarea_salto (
  nombre_tarea  text primary key,
  explicacion   text,
  material      text
);

create table tarea_cambio_direccion (
  nombre_tarea  text primary key,
  explicacion   text,
  material      text
);

create table tarea_sprint (
  nombre_tarea  text primary key,
  explicacion   text,
  material      text
);

-- ---------------------------------------------------------------------
-- INCLUYE: Sesion N:M cada tipo de tarea, con la carga de esa tarea
-- en esa sesión. Clave primaria = (fecha, nombre_tarea).
-- ---------------------------------------------------------------------

create table incluye_resistencia (
  fecha                     date not null,
  nombre_tarea              text not null,
  tiempo_min                numeric(6,2) check (tiempo_min > 0),
  prescripcion_intensidad   text,          -- p. ej. "85-90 % FCmax"
  primary key (fecha, nombre_tarea),
  foreign key (fecha)        references sesion (fecha)                    on update cascade on delete cascade,
  foreign key (nombre_tarea) references tarea_resistencia (nombre_tarea)  on update cascade on delete restrict
);

create table incluye_fuerza (
  fecha                     date not null,
  nombre_tarea              text not null,
  series                    smallint check (series > 0),
  repeticiones              smallint check (repeticiones > 0),
  prescripcion_intensidad   text,          -- p. ej. "70 % 1RM" o "RIR 2"
  primary key (fecha, nombre_tarea),
  foreign key (fecha)        references sesion (fecha)               on update cascade on delete cascade,
  foreign key (nombre_tarea) references tarea_fuerza (nombre_tarea)  on update cascade on delete restrict
);

create table incluye_salto (
  fecha         date not null,
  nombre_tarea  text not null,
  series        smallint check (series > 0),
  repeticiones  smallint check (repeticiones > 0),
  primary key (fecha, nombre_tarea),
  foreign key (fecha)        references sesion (fecha)              on update cascade on delete cascade,
  foreign key (nombre_tarea) references tarea_salto (nombre_tarea)  on update cascade on delete restrict
);

create table incluye_cambio_direccion (
  fecha         date not null,
  nombre_tarea  text not null,
  repeticiones  smallint check (repeticiones > 0),
  descanso_seg  integer  check (descanso_seg >= 0),
  primary key (fecha, nombre_tarea),
  foreign key (fecha)        references sesion (fecha)                         on update cascade on delete cascade,
  foreign key (nombre_tarea) references tarea_cambio_direccion (nombre_tarea)  on update cascade on delete restrict
);

create table incluye_sprint (
  fecha         date not null,
  nombre_tarea  text not null,
  repeticiones  smallint     check (repeticiones > 0),
  carga_kg      numeric(5,1) check (carga_kg >= 0),   -- 0 = sprint sin carga
  distancia_m   numeric(6,1) check (distancia_m > 0),
  descanso_seg  integer      check (descanso_seg >= 0),
  primary key (fecha, nombre_tarea),
  foreign key (fecha)        references sesion (fecha)               on update cascade on delete cascade,
  foreign key (nombre_tarea) references tarea_sprint (nombre_tarea)  on update cascade on delete restrict
);

-- ---------------------------------------------------------------------
-- ÍNDICES en las claves foráneas que no son la primera columna de la
-- clave primaria (aceleran búsquedas como "todos los resultados de un
-- test" y los borrados/actualizaciones en cascada).
-- ---------------------------------------------------------------------

create index resultado_nombre_test_idx           on resultado (nombre_test);
create index resultado_fecha_idx                 on resultado (fecha);
create index realiza_fecha_idx                   on realiza (fecha);
create index incluye_resistencia_tarea_idx       on incluye_resistencia (nombre_tarea);
create index incluye_fuerza_tarea_idx            on incluye_fuerza (nombre_tarea);
create index incluye_salto_tarea_idx             on incluye_salto (nombre_tarea);
create index incluye_cambio_direccion_tarea_idx  on incluye_cambio_direccion (nombre_tarea);
create index incluye_sprint_tarea_idx            on incluye_sprint (nombre_tarea);

commit;
