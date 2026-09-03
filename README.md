# Consulta de Fuentes y Lectura Numérica del Mundo

Sitio web del curso **clave 2102**, primer semestre, Facultad de Ciencias
Políticas y Sociales, UNAM. Semestre **2027-1** (31 de agosto – 4 de diciembre
de 2026). Profesora: Dra. Daniela Serrano Campos.

**Sitio publicado:**
<https://danserca.github.io/CFLNM/>

Es un sitio de R Markdown (`rmarkdown::render_site`) que GitHub Pages sirve
desde la carpeta `docs/`.

---

## Cómo está organizado

| Archivo / carpeta | Qué es |
|---|---|
| `index.Rmd` | Portada: descripción, unidades, proyecto integrador, evaluación |
| `Programa_de_CFLNM.Rmd` | Programa completo y cronograma |
| `Clases.Rmd` | Material de cada semana (presentaciones, prácticas, guías) |
| `Recursos.Rmd` | Software, fuentes, datos y libros del curso |
| `Glosario.Rmd` | Glosario de términos, con buscador |
| `Profesores.Rmd` | Ficha de la profesora |
| `Disclamer.Rmd` | Aviso de responsabilidad sobre los ejemplos didácticos |
| `syllabus_z.Rmd` | Cronograma del semestre 2026-1 (archivo, no aparece en el menú) |
| `datos/calendario.csv` | **El cronograma. Una fila por semana.** |
| `datos/unidades.csv` | Las 6 unidades con su objetivo |
| `_funciones.R` | Funciones que convierten los CSV en tablas y tarjetas |
| `styles.css` | Estilos de todo el sitio (un solo archivo) |
| `_site.yml` | Nombre del sitio y menú de navegación |
| `*_cap*.Rmd`, `intro_met_ccss.Rmd` | Diapositivas (xaringan) |
| `images/` | Logo, portadas y guías en PDF |
| `docs/` | **Salida compilada. No se edita a mano.** |

Los archivos que empiezan con `_` (como `_funciones.R`) no se copian a `docs/`.

---

## Tareas frecuentes

### Cambiar una fecha, un tema o una lectura

Edita `datos/calendario.csv` y reconstruye el sitio. La tabla resumen, el
cronograma detallado del programa y los encabezados de la página de clases se
regeneran solos: no hay que tocar tres archivos como antes.

Columnas del CSV:

- `semana` — número de semana del programa (1 a 16)
- `unidad` — número de unidad (1 a 6), enlaza con `unidades.csv`
- `lunes`, `jueves` — fecha en formato `AAAA-MM-DD`; se deja vacío si esa
  semana no tiene sesión ese día
- `suspension` — `lunes`, `jueves` o vacío. Marca la sesión como día de asueto:
  aparece tachada y con una nota
- `tema`, `lecturas`, `actividades` — texto; **se puede usar markdown**, por
  ejemplo `[título](https://enlace)` o `*cursivas*`

### Publicar el material de una clase

Abre `Clases.Rmd` y busca el bloque `materiales <- list(`. Cada entrada usa el
número de semana como clave:

```r
"7" = '
**Presentación.** Título de la sesión

<div class="embed"><iframe src="mi_presentacion.html"></iframe></div>

**Actividad.** [Instrucciones](https://enlace-a-classroom)
',
```

Las semanas sin entrada muestran automáticamente "Material por publicar".

Para incrustar algo usa `<div class="embed">` (diapositivas, proporción
horizontal) o `<div class="embed embed-doc">` (PDF y formularios, más altos que
anchos). Ambos se ajustan solos al ancho de la pantalla, también en celular.

### Cambiar colores o tipografía

Todo está en `styles.css`, en las variables del bloque `:root` de arriba
(`--vino`, `--rosa`, `--arena`…). Antes este CSS estaba copiado dentro de cada
`.Rmd`; ahora se edita en un solo lugar.

---

## Compilar el sitio

1. Abre `LabJournalWebsite.Rproj` en RStudio.
2. Pestaña **Build** (arriba a la derecha) → **Build Website**.

O desde la consola de R:

```r
rmarkdown::render_site()          # todo el sitio
rmarkdown::render_site("Clases.Rmd")  # una sola página (más rápido)
```

Se necesitan los paquetes `rmarkdown`, `knitr` y `xaringan`.

## Publicar

`git add`, `git commit` y `git push`. GitHub Pages toma los archivos de `docs/` en la rama `main`
y actualiza el sitio en un par de minutos.

**Importante:** hay que hacer commit de `docs/` — es lo que se publica.
