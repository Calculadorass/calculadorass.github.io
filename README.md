# Calculadoras

Calculadoras laborales y previsionales para Chile. Páginas estáticas, sin
dependencias ni backend, servidas por GitHub Pages.

🔗 **https://calculadorass.github.io/**

## Calculadoras

| | Estado | Dirección |
|---|---|---|
| **Sueldo líquido** | Disponible | [`/sueldo-liquido/`](https://calculadorass.github.io/sueldo-liquido/) |
| **Boleta de honorarios** | Disponible | [`/boleta-honorarios/`](https://calculadorass.github.io/boleta-honorarios/) |
| **Bono líquido** | Disponible | [`/bono-liquido/`](https://calculadorass.github.io/bono-liquido/) |
| **Finiquito** | Disponible | [`/finiquito/`](https://calculadorass.github.io/finiquito/) |

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
src/bono-liquido.html     fuente de la calculadora de bonos
src/finiquito.html        fuente de la calculadora de finiquito
build.sh                  genera las páginas agregando el envoltorio HTML
index.html                portada            (generado — no editar a mano)
sueldo-liquido/index.html sueldo líquido     (generado — no editar a mano)
boleta-honorarios/index.html honorarios      (generado — no editar a mano)
bono-liquido/index.html   bono líquido       (generado — no editar a mano)
finiquito/index.html      finiquito          (generado — no editar a mano)
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

## Feriados

`indicadores.json` guarda bajo `feriados.anios` la lista de feriados legales de
cada año, como fechas explícitas en vez de reglas. Los días móviles de la Ley
19.973 y los feriados de elecciones no siguen un patrón estable, así que una
lista verificada es más confiable que calcularlos.

La calculadora de finiquito los usa para proyectar el feriado proporcional en
el calendario. Si le toca un año que no está cargado, lo dice en pantalla y
cuenta solo sábados y domingos como inhábiles. La tarea mensual agrega el año
siguiente cuando falta.

## Costo del empleador

La calculadora de sueldo líquido muestra también lo que el trabajador le cuesta
a la empresa. Las tasas de cargo del empleador viven en `indicadores.json` bajo
`empleador`: tras la reforma previsional los aportes previsionales suman 3,5%
(SIS 1,78% + expectativa de vida 0,72% + rentabilidad protegida 0,90% + cuenta
individual 0,10%), más el seguro de cesantía y la mutual de la Ley 16.744, cuya
tasa adicional por riesgo se ingresa en la página porque varía por empresa.

## Plazos legales

El Código del Trabajo usa dos nociones distintas de "día hábil" y la calculadora
de finiquito las mantiene separadas: para el **feriado anual** el sábado es
inhábil (Art. 69), mientras que para los **plazos legales** se cuenta de lunes a
sábado y solo los domingos y festivos son inhábiles. Confundirlas corre las
fechas varios días.

Con esa regla y el calendario de feriados se calculan las fechas de la carta de
aviso (Art. 162), el pago del finiquito (Art. 177) y los plazos para demandar
(Art. 168).

## Compartir un cálculo

La calculadora de finiquito arma un link con todos los datos en el hash de la
URL, en texto plano y legible. No hay servidor ni almacenamiento: quien abre el
link recibe el mismo cálculo porque la página lo reconstruye desde el link.

## Redondeo

Los montos se llevan en pesos enteros y cada cotización se redondea al
calcularse, como en una liquidación real. Así el desglose que muestra cada
página suma exactamente el total, sin descuadrar por un peso.

## Alcance

Los resultados son una estimación referencial y no reemplazan una liquidación
de sueldo formal ni la asesoría de un contador. No se consideran APV, depósitos
convenidos, anticipos, préstamos, descuentos pactados con el empleador ni
regímenes especiales (trabajo pesado, trabajadores de casa particular,
afiliados al INP).
