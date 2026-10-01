#!/bin/sh
# Genera las páginas del sitio a partir de los archivos en src/.
#
# Cada archivo de src/ contiene el <title>, los estilos, el marcado y el script,
# SIN <!doctype>/<html>/<head>/<body>. Eso permite publicar el mismo archivo como
# Artifact en claude.ai (la plataforma le pone ese envoltorio) y, aquí, generar la
# página estática agregándole el envoltorio para servirla por GitHub Pages.
#
# Para agregar una calculadora nueva: crea src/<nombre>.html y añade una línea
# a la lista de PAGINAS de abajo, con el formato  fuente:destino
set -e
cd "$(dirname "$0")"

PAGINAS="
portada.html:index.html
sueldo-liquido.html:sueldo-liquido/index.html
boleta-honorarios.html:boleta-honorarios/index.html
bono-liquido.html:bono-liquido/index.html
finiquito.html:finiquito/index.html
"

envolver() {
  descripcion="$2"
  cat <<HEAD
<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">
<meta name="description" content="$descripcion">
<style>
:root{color-scheme:light;padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px)}
body{margin:0;font:14px/1.5 system-ui,sans-serif;background:#fafaf9}
img{max-width:100%}
[hidden]{display:none!important}
</style>
HEAD
  cat "$1"
  printf '\n</body>\n</html>\n'
}

descripcion_de() {
  case "$1" in
    portada.html)        echo "Calculadoras laborales y previsionales para Chile, con los indicadores oficiales de Previred actualizados cada mes." ;;
    sueldo-liquido.html) echo "Calcula tu sueldo líquido en Chile desde el bruto: AFP, salud, seguro de cesantía e Impuesto Único, con los indicadores oficiales de Previred." ;;
    boleta-honorarios.html) echo "Convierte entre monto líquido y monto bruto de una boleta de honorarios en Chile, con la retención vigente del SII." ;;
    bono-liquido.html)   echo "Calcula el bono bruto necesario para que llegue un monto líquido exacto, considerando cotizaciones, topes imponibles e Impuesto Único." ;;
    finiquito.html)      echo "Calcula el finiquito en Chile: indemnización por años de servicio, mes de aviso, feriado proporcional y días del mes, según el Código del Trabajo." ;;
    *)                   echo "Calculadoras laborales y previsionales para Chile." ;;
  esac
}

echo "$PAGINAS" | while IFS=: read -r fuente destino; do
  [ -n "$fuente" ] || continue
  if [ ! -f "src/$fuente" ]; then
    echo "  falta src/$fuente — se omite" >&2
    continue
  fi
  mkdir -p "$(dirname "$destino")"
  envolver "src/$fuente" "$(descripcion_de "$fuente")" > "$destino"
  echo "  $destino  ($(wc -c < "$destino") bytes)"
done

echo "listo"
