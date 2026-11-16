# Fut-Test · Grupo 22

## Qué es la app

Fut-Test sirve para **reunir los datos de los test que hacen los jugadores de fútbol**
y, a partir de ellos, **proponer test y ejercicios de mejora**. El entrenador registra a
los jugadores, apunta los resultados de cada test, planifica sesiones con tareas
(resistencia, fuerza, salto, cambio de dirección y sprint) y anota el RPE de cada
jugador en cada sesión.

## Miembros del grupo

- Xavier
- Alejandro
- Daniel

## Tecnología

- **Página estática** hecha con HTML, CSS y JavaScript normales. **No hay paso de
  compilación**: no se usa npm, ni bundlers, ni frameworks. Lo que está en el
  repositorio es exactamente lo que se publica.
- **Base de datos: Supabase** (PostgreSQL). Desde el navegador se usa
  `supabase-js` cargado desde un CDN, por ejemplo:
  `<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>`
- **Publicación: Cloudflare Pages**, directamente desde este repositorio de GitHub.

### Conexión a Supabase

Proyecto de Supabase: **fut-test** (región París, `eu-west-3`, plan gratuito).
Estos dos valores son públicos por diseño y pueden ir en el código de la página:

- **Project URL:** `https://zvgqkhwbwewmsgueramu.supabase.co`
- **Publishable key:** `sb_publishable_gveFQF3Uw3biwSR5XVy-oA_lyjIsjJd`

```js
const supabase = window.supabase.createClient(
  'https://zvgqkhwbwewmsgueramu.supabase.co',
  'sb_publishable_gveFQF3Uw3biwSR5XVy-oA_lyjIsjJd'
);
```

La **secret key** NO se apunta aquí ni en ningún otro sitio del repositorio.
- Las migraciones SQL están en `supabase/migraciones/` y se numeran en orden
  (`000_...`, `001_...`, `002_...`). Una migración ya aplicada no se edita: los
  cambios van en una migración nueva. Aplicadas en Supabase el 16/11/2026: 000, 001, 002, 003 y 004.

## Modelo de datos (resumen)

El diagrama original está en `docs/modelo-er.png`. Todos los nombres van en español,
en minúsculas y sin tildes.

| Tabla | Clave primaria | Qué guarda |
|---|---|---|
| `jugador` | `dni` | Datos del jugador: nombre, dorsal, altura, peso, posición, pierna dominante |
| `test` | `nombre_test` | Catálogo de test: objetivo, explicación, material |
| `sesion` | `fecha` | Sesiones de entrenamiento: duración y objetivo |
| `resultado` | `dni` + `nombre_test` + `fecha` + `parametro` + `lado` | Resultado de un jugador en un test, dentro de una sesión (valor, unidad de medida y lado: bilateral, derecha o izquierda) |
| `realiza` | `dni` + `fecha` | Qué jugadores hicieron cada sesión y su RPE (N:M jugador–sesión) |
| `tarea_resistencia`, `tarea_fuerza`, `tarea_salto`, `tarea_cambio_direccion`, `tarea_sprint` | `nombre_tarea` | Catálogos de tareas por tipo |
| `incluye_resistencia`, `incluye_fuerza`, `incluye_salto`, `incluye_cambio_direccion`, `incluye_sprint` | `fecha` + `nombre_tarea` | Qué tareas tiene cada sesión y con qué carga (N:M sesión–tarea) |

Relaciones:
- Un jugador tiene muchos resultados; un test tiene muchos resultados; una sesión tiene muchos resultados.
- Jugador y sesión: N:M a través de `realiza`.
- Sesión y cada tipo de tarea: N:M a través de su tabla `incluye_*`.

## Reglas para Claude

1. **Explica cada cambio pensando en principiantes**: qué has cambiado, por qué y cómo
   comprobarlo. Evita la jerga, y si usas un término técnico, explícalo en una frase.
2. **No cambies tablas sin aprobación del grupo.** Esto incluye crear, borrar o
   modificar tablas, columnas, claves, políticas RLS y aplicar migraciones en
   Supabase. Primero se propone el SQL, el grupo lo revisa y, cuando lo aprueba, se aplica.
3. **No uses nunca la secret key de Supabase** (ni la antigua `service_role`): ni en el
   código, ni en el repositorio, ni en comandos. En la página solo se usa la
   **publishable key** (o la antigua `anon`), que es pública por diseño; la seguridad
   de los datos depende de las políticas RLS.
4. Trabaja siempre en una rama nueva y propone los cambios con un Pull Request; no
   hagas commits directamente en `main`.
