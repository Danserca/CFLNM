# ------------------------------------------------------------------
# Funciones auxiliares del sitio del curso.
#
# El cronograma vive en datos/calendario.csv y datos/unidades.csv.
# Para cambiar fechas, temas o lecturas se edita el CSV: el programa
# y la página de clases se regeneran solas al reconstruir el sitio.
#
# El nombre empieza con "_" para que rmarkdown NO lo copie a docs/.
# ------------------------------------------------------------------

MESES <- c("enero", "febrero", "marzo", "abril", "mayo", "junio",
           "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre")

DIAS <- c("domingo", "lunes", "martes", "miércoles", "jueves", "viernes", "sábado")

#' Formatea una fecha ISO en español, sin depender del locale del sistema
#' (importante: en Windows el locale en español no siempre está disponible).
fecha_larga <- function(x, con_anio = FALSE) {
  x <- as.Date(x)
  out <- paste0(as.integer(format(x, "%d")), " de ", MESES[as.integer(format(x, "%m"))])
  if (con_anio) out <- paste0(out, " de ", format(x, "%Y"))
  out
}

#' "lunes 24 de agosto"
fecha_con_dia <- function(x) {
  x <- as.Date(x)
  paste0(DIAS[as.integer(format(x, "%w")) + 1], " ", fecha_larga(x))
}

cargar_calendario <- function(ruta = "datos/calendario.csv") {
  d <- read.csv(ruta, stringsAsFactors = FALSE, encoding = "UTF-8", na.strings = "")
  d$lunes  <- as.Date(d$lunes)
  d$jueves <- as.Date(d$jueves)
  d
}

cargar_unidades <- function(ruta = "datos/unidades.csv") {
  read.csv(ruta, stringsAsFactors = FALSE, encoding = "UTF-8", na.strings = "")
}

#' Texto de las fechas de una semana, marcando las sesiones suspendidas.
#' Devuelve p. ej. "L 2 nov. (suspensión) · J 5 de noviembre"
fechas_semana <- function(fila, breve = FALSE) {
  partes <- character(0)
  susp   <- ifelse(is.na(fila$suspension), "", fila$suspension)

  if (!is.na(fila$lunes)) {
    t <- paste0("L ", fecha_larga(fila$lunes))
    if (susp == "lunes") t <- paste0("~~", t, "~~ *(asueto)*")
    partes <- c(partes, t)
  }
  if (!is.na(fila$jueves)) {
    t <- paste0("J ", fecha_larga(fila$jueves))
    if (susp == "jueves") t <- paste0("~~", t, "~~ *(asueto)*")
    partes <- c(partes, t)
  }
  paste(partes, collapse = if (breve) " · " else " &nbsp;·&nbsp; ")
}

#' Tabla resumen del semestre (una fila por semana).
tabla_calendario <- function(cal, unidades) {
  fechas <- vapply(seq_len(nrow(cal)),
                   function(i) fechas_semana(cal[i, ]), character(1))
  resumen <- data.frame(
    Semana  = paste0("**", cal$semana, "**"),
    Sesiones = fechas,
    Unidad  = paste0("U", cal$unidad),
    Tema    = cal$tema,
    check.names = FALSE
  )
  # Divs con ":::" (fenced divs de pandoc) en lugar de <div> crudo: así el
  # markdown de adentro (enlaces, negritas, tablas) sí se procesa.
  cat("::: {.tabla-scroll}\n\n")
  print(knitr::kable(resumen, format = "pipe", align = c("c", "l", "c", "l"),
                     row.names = FALSE))
  cat("\n:::\n\n")
}

#' Tarjetas detalladas: una por semana, con lecturas y actividades.
tarjetas_calendario <- function(cal, unidades) {
  for (i in seq_len(nrow(cal))) {
    fila <- cal[i, ]
    u    <- unidades[unidades$unidad == fila$unidad, ]
    susp <- ifelse(is.na(fila$suspension), "", fila$suspension)
    clase <- if (susp != "") ".semana .semana-suspendida" else ".semana"

    cat(sprintf("::: {%s}\n", clase))
    cat(sprintf('<span class="etiqueta">Unidad %s &middot; %s</span>\n\n',
                fila$unidad, u$nombre))
    cat(sprintf("### Semana %s. %s\n\n", fila$semana, fila$tema))
    cat(sprintf('[%s]{.fechas}\n\n', fechas_semana(fila)))
    cat(sprintf("**Lecturas.** %s\n\n", fila$lecturas))
    cat(sprintf("**Actividades.** %s\n\n", fila$actividades))
    if (susp != "") {
      cat(sprintf(
        "*La sesión del %s no se imparte por día de asueto oficial de la UNAM; el contenido se cubre en la otra sesión de la semana.*\n\n",
        susp))
    }
    cat(":::\n\n")
  }
}
