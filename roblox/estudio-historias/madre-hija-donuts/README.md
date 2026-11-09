# Madre e hija: reto de donuts

## Historia de 23 segundos

Con el decorado y el ajuste de suelo y luz ya instalados, pegar **todo** `03_INSTALAR_HISTORIA_DONUTS.txt` en Script > Comando, con Stop. Debe terminar con `[HR DONUTS] HISTORIA INSTALADA: madre, hija, 18 donuts, 23 segundos y 22 planos.` Guardar con Ctrl+S, cerrar las pestanas de codigo y pulsar F5. La cuenta atras dura tres segundos.

- **R**: repetir la escena con cuenta atras, incluyendo los donuts, sus mordiscos, expresiones y confeti.
- **G**: mostrar u ocultar el dialogo de referencia para grabar limpio.
- **P**: devolver la camara al jugador.
- **Stop**: volver al estado de edicion.

Se crean dieciocho donuts rosas con virutas, usando geometria nativa de Roblox. La madre y la hija se copian de las plantillas R15 ya preparadas. Las nuevas copias de revision quedan detras de la mesa. En Play se dirigen copias independientes, se aparcan las galerias anteriores y se ocultan las marcas. Los objetos escogidos se llevan con el brazo derecho hasta la boca; un mordisco retira parte de su geometria. El segundo donut produce confeti y una reaccion con salto. La secuencia se repite sin elecciones aleatorias.

El instalador actualiza los controladores existentes `HR_PruebaRepartoServidor` y `HR_PruebaRepartoCamara`; reutiliza `Interpretacion`. Conserva el cliente `HR_CarasMarcos` que estaba instalado, cambiando exclusivamente su lista de actores de tres a dos. Se respalda su fuente completa y las fuentes/estados de los otros controladores antes de escribir. Si la estructura facial no se reconoce, se detiene antes de modificar el proyecto. Al repetir la instalacion conserva las copias y los donuts existentes. `VOLVER_A_MARCOS.txt` restaura las fuentes y estados originales; la sala nueva queda al lado.

El agarre se resuelve geometricamente sobre Shoulder, Elbow y Wrist, respetando sus longitudes y las articulaciones Motor6D existentes. No usa IDs nuevos de animacion, catalogo ni texturas de caras. El soporte del donut se deriva de la mano resuelta; si un objetivo quedase fuera de alcance, ambos permanecen juntos y Salida pide revisar el alcance. Las normales y el contacto visual definitivo se revisan en la primera captura.

El dialogo de pantalla es una **guia sin audio**. `VOZ_MADRE.txt` y `VOZ_HIJA.txt` contienen las frases separadas para generar las voces. `DIALOGOS_REFERENCIA.srt` y `GUION_DONUTS.json` usan los tiempos previstos de la animacion, pendientes de alinear a las voces recibidas. Musica, efectos sonoros, emojis y aros de eleccion se montan en el editor. No se incluye sincronizacion labial.

La camara calcula encuadres para proteger el centro 9:16, aunque la ventana de Studio sea horizontal. Esto no cambia el formato de la grabacion ni exporta por si mismo un MP4 1080x1920. Los objetos de la mesa y los dos actores permanecen visibles durante los detalles, sin ocultado de actores por corte que haga desaparecer una mano o un donut.

### Comprobaciones

Compilacion Luau de modulos, controladores, instalador y restaurador. Linea de tiempo de 23 segundos y 22 planos contiguos. IK contrastada con los Motor6D y las medidas de los dos rigs presentes en `Base_Historias.rbxl`: objetivos alcanzables, objetivos lejanos limitados, longitudes de huesos, conexion del codo y los puntos concretos de agarre y mordisco. En un arbol simulado se comprueban la creacion de los 18 donuts, dos copias, la conservacion del codigo facial, reinstalacion sin duplicados, respaldo inicial estable, restauracion y reversion ante 16 fallos de escritura inyectados.

**Primera reproduccion en Roblox Studio pendiente:** revisar caras, encuadres, contacto de dedos y donut, ausencia de intersecciones, aspecto del confeti y dos repeticiones consecutivas con R. Las pruebas externas no sustituyen esa revision visual. El proyecto actual guardado por el usuario puede contener cambios que no figuran en el archivo base inspeccionado.

## Preparacion del decorado

Primera fase: decorado para la copia `Madre_Hija_Donuts.rbxl`.

Con Stop, pegar todo el contenido de `01_CREAR_SALA_Y_MESA.txt` en Script > Comando y ejecutar. Al terminar, la mesa queda seleccionada: pulsar F con el cursor sobre la vista 3D para enfocarla. Guardar con Ctrl+S.

Se crea `Workspace.HR_RetoDonuts` con sala azul pastel, suelo de madera, ventana, puerta decorativa, mesa y dos marcas de posicion para madre e hija. Se usan piezas nativas de Roblox sin recursos de catalogo. El frente permanece abierto para grabar.

El decorado queda a 65 studs de la galeria anterior, orientado como la hija cuando existe `HR_RevisionReparto.Hija`. En ausencia de esa referencia se usa una posicion y orientacion fijas. La creacion no mueve actores, cambia caras, modifica fuentes, activa controladores ni accede a `CurrentCamera`. Al repetir el comando conserva el decorado existente y selecciona la mesa. Los posibles errores durante la construccion retiran solo el modelo nuevo, antes de publicarlo en Workspace.

Esta fase contiene solo decorado. La colocacion de donuts y la nueva interaccion de mano y objeto se preparan por separado. La apariencia y el encuadre de este decorado quedan pendientes de comprobar en Roblox Studio.

## Ajuste de suelo y luz tras la primera captura

La captura del usuario muestra el suelo de ladrillo atravesando el suelo nuevo y la mesa bajo una sombra fuerte. Con Stop, ejecutar `02_AJUSTAR_SUELO_Y_LUZ.txt`. Nueve rayos verticales consultan la superficie bajo la sala, excluyendo su propio modelo y los avatares. Si es necesario, se eleva el decorado completo hasta dejar el suelo de madera 0,18 studs por encima de esa superficie. Se actualiza tambien `HR_Origen` para las siguientes fases.

Se anaden una luz de techo y un relleno frontal dentro de la sala. Repetir el ajuste reutiliza ambas luces. La altura no disminuye y no se vuelve a elevar si ya hay separacion suficiente. Se conservan los personajes, las fuentes de los controladores y la iluminacion global. Sintaxis comprobada con Luau; altura y aspecto de las luces pendientes de revision en la siguiente captura de Studio.
