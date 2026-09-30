# Calculadoras

Calculadoras laborales y previsionales para Chile. Páginas estáticas, sin
dependencias ni backend, servidas por GitHub Pages.

🔗 **https://calculadorass.github.io/**

## Calculadoras

| | Estado | Dirección |
|---|---|---|
| **Sueldo líquido** | Disponible | [`/sueldo-liquido/`](https://calculadorass.github.io/sueldo-liquido/) |
| **Boleta de honorarios** | Disponible | [`/boleta-honorarios/`](https://calculadorass.github.io/boleta-honorarios/) |
| Bonos y aguinaldos | En preparación | — |

## Indicadores compartidos

Los valores que cambian cada mes viven en un solo archivo,
[`indicadores.json`](indicadores.json), en la raíz del sitio: UF, UTM, ingreso
mínimo, topes imponibles, comisiones de cada AFP y tramos de asignación familiar.
**Todas las calculadoras lo leen**, así que basta actualizarlo una vez.

La fuente es el PDF mensual de *Indicadores Previsionales* de Previred, y el
propio archivo guarda en `origen` la URL de la edición usada.

Una tarea programada lo actualiza el día 2 de cada mes. Si no logra obtener los
datos oficiales con certeza, no escribe nada y deja los del mes anterior.

Cada página trae además una copia de respaldo incrustada en su código, de modo
que siempre muestra un resultado aunque el archivo no cargue.

Los tramos del Impuesto Único están fijados por ley y no cambian mes a mes.

La tasa de retención de honorarios vive en el mismo archivo, bajo `honorarios`,
junto con el calendario de la Ley 21.133. Cambia **una vez al año**, cada 1 de
enero (15,25% en 2026, 16% en 2027, 17% en 2028), pero como la tarea corre todos
los meses, el cambio de enero queda cubierto.

## Estructura

```
src/portada.html          fuente de la portada
src/sueldo-liquido.html   fuente de la calculadora de sueldo
src/boleta-honorarios.html fuente de la calculadora de honorarios
build.sh                  genera las páginas agregando el envoltorio HTML
index.html                portada            (generado — no editar a mano)
sueldo-liquido/index.html sueldo líquido     (generado — no editar a mano)
boleta-honorarios/index.html honorarios      (generado — no editar a mano)
indicadores.json          valores del mes, compartidos
```

Los archivos de `src/` no llevan `<!doctype>`, `<html>`, `<head>` ni `<body>`:
así el mismo archivo sirve para generar la página del sitio y para publicarse
como Artifact en claude.ai, donde la plataforma pone ese envoltorio.

## Trabajar en el proyecto

Edita el archivo en `src/` y regenera:

```sh
./build.sh
```

Para ver el sitio:

```sh
python3 -m http.server 8000
```

Luego abre <http://localhost:8000>. Hace falta un servidor: con `file://` el
navegador no puede cargar `indicadores.json` y las páginas caen al respaldo.

## Agregar una calculadora nueva

1. Crea `src/<nombre>.html` — puede partir de una copia de `src/sueldo-liquido.html`.
2. Agrega su línea a la lista `PAGINAS` de `build.sh`:
   `<nombre>.html:<nombre>/index.html`
3. Agrega su descripción en la función `descripcion_de` del mismo archivo.
4. Añade su tarjeta en `src/portada.html`.
5. Ejecuta `./build.sh` y haz commit.

Si la calculadora necesita un indicador que hoy no está en `indicadores.json`,
agrégalo al archivo y actualiza la tarea programada para que lo mantenga al día.

## Alcance

Los resultados son una estimación referencial y no reemplazan una liquidación
de sueldo formal ni la asesoría de un contador. No se consideran APV, depósitos
convenidos, anticipos, préstamos, descuentos pactados con el empleador ni
regímenes especiales (trabajo pesado, trabajadores de casa particular,
afiliados al INP).
