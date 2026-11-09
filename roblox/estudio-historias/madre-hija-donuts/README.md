# Madre e hija: seis donuts y el ultimo picante

## Version actual: 25 segundos

El usuario descarta copiar la partida completa de 2:24. La historia actual usa seis donuts: la hija presume de comerselos todos, los cinco primeros pasan en un montaje rapido y el sexto es picante. La madre lo habia advertido y remata preguntando si quiere otro. Se conservan los personajes y el cliente de caras que ya funcionaban.

**Si ya instalaste la historia de 18 donuts**, con Stop pega todo `04_RETO_6_DONUTS.txt` en Script > Comando. Debe terminar con `[HR DONUTS] RETO PICANTE INSTALADO: 6 donuts, madre e hija, 25 segundos y 14 planos frontales.` Guarda con Ctrl+S y pulsa F5. La cuenta atras dura tres segundos.

**Si empiezas desde el decorado sin actores ni donuts**, instala 03 primero y despues 04. No hay que rehacer la sala ni importar comida del catalogo. La actualizacion 04 guarda los donuts anteriores y cambia los controladores existentes: no activa otra camara en paralelo.

- **R**: repetir con cuenta atras, reponiendo los seis donuts y el color de la hija.
- **G**: mostrar u ocultar dialogos y contador de referencia.
- **P**: devolver la camara al jugador.
- **Stop**: volver a edicion.

## Acciones y encuadres

Seis donuts rosas con virutas, en dos filas de tres. Los cinco primeros se comen mediante jump cuts que representan un salto de tiempo; el sexto muestra el alcance, agarre, elevacion y mordisco completos. Al morder el ultimo, la hija se sonroja, aparece una nube de vapor anaranjado y da un salto. La escena es guionizada y repetible.

La camara mantiene **una posicion y un eje frontal** calculados al empezar. Los 14 cambios son de zoom mediante FOV, conservando a madre e hija y la mesa. Se eliminan las camaras individuales, los cambios laterales, los detalles cenitales y el seguimiento de la mano del primer montaje. Un cambio de tamano de la ventana recalcula el ajuste para proteger el centro 9:16.

El mordisco usa la misma geometria de soporte facial y las mismas coordenadas de boca del cliente instalado. El borde posterior elevado del donut toca el centro de la boca. El agarre usa el `RightGripAttachment` real de la mano; se conservan las longitudes de brazo y sus Motor6D. Durante la accion se fija el cuello al frente para evitar que la comida siga un giro hacia el otro personaje. La mesa se ajusta a la cintura de la hija para dejar visible el torso. Esta geometria aun requiere comprobar su aspecto en la captura real.

## Guion y audio

| Segundos | Accion o dialogo |
| --- | --- |
| 0-2,5 | Hija: «¡A que me como los seis!» |
| 2,5-4,5 | Madre: «El ultimo no lo toques». |
| 4,5-8,5 | Cinco bocados en montaje rapido; contador de seis a uno. |
| 8,5-10,5 | Hija: «¡Solo queda uno!» |
| 10,5-12,5 | Madre: «Te he dicho que ese no». |
| 12,5-14,7 | Hija: «¡Pues tambien me lo como!» |
| 14,7-17 | Hija, al morder el sexto: «¡Mama, esto pica!» |
| 17-20 | Madre: «Ese era el mio. ¡Extra picante!» |
| 20-22,5 | Hija: «¡Agua, agua!» |
| 22,5-25 | Madre: «¿Te guardo otro?»; la hija niega. |

El dialogo de pantalla es una **guia sin audio**. `VOZ_MADRE.txt` y `VOZ_HIJA.txt` contienen las nuevas frases para generar las voces. `DIALOGOS_REFERENCIA.srt` y `GUION_DONUTS.json` reflejan los tiempos previstos, pendientes de alinear con las voces recibidas. Se descarta el audio de la referencia larga para esta nueva historia. Musica y sonidos de mordisco se montan en la edicion. El codigo no exporta un MP4 ni realiza sincronizacion labial.

## Conservacion y pruebas

04 escribe Configuracion, Donuts, BrazoDonut y los controladores existentes de servidor y camara. Conserva byte a byte los clientes de caras y el modulo Interpretacion. Guarda las fuentes anteriores y los donuts retirados en `ServerStorage.HR_DonutsAntesRetoPicante`. Repetirlo no acumula comida ni altera ese primer respaldo. `VOLVER_A_MARCOS.txt` conserva la restauracion de la historia anterior que habia antes de instalar donuts.

Comprobaciones externas: compilacion Luau; 25 segundos y 14 planos contiguos; proyeccion del encuadre frontal dentro del centro 9:16; objetivos de agarre y mordisco sobre las medidas y articulaciones de ambos rigs extraidos de Base_Historias; longitudes y conexion de codos; contacto del borde del donut con el punto central de la boca dibujada; creacion de seis donuts; sustitucion de 18 por seis; actualizacion repetida sin duplicados ni nuevos cambios de altura; codigo facial sin cambios; restauracion; reversion ante 21 fallos de escritura inyectados.

**Pendiente en Studio:** comprobar la nueva captura con el proyecto actual del usuario, especialmente el agarre real, el mordisco, las intersecciones, el vapor y las dos repeticiones con R. La primera version no coincidia con el estilo de camara solicitado; estas pruebas geometricas no garantizan por si solas que el resultado visual sea identico al ejemplo.

## Preparacion del decorado

Primera fase: decorado para la copia `Madre_Hija_Donuts.rbxl`.

Con Stop, pegar todo el contenido de `01_CREAR_SALA_Y_MESA.txt` en Script > Comando y ejecutar. Al terminar, la mesa queda seleccionada: pulsar F con el cursor sobre la vista 3D para enfocarla. Guardar con Ctrl+S.

Se crea `Workspace.HR_RetoDonuts` con sala azul pastel, suelo de madera, ventana, puerta decorativa, mesa y dos marcas de posicion para madre e hija. Se usan piezas nativas de Roblox sin recursos de catalogo. El frente permanece abierto para grabar.

El decorado queda a 65 studs de la galeria anterior, orientado como la hija cuando existe `HR_RevisionReparto.Hija`. En ausencia de esa referencia se usa una posicion y orientacion fijas. La creacion no mueve actores, cambia caras, modifica fuentes, activa controladores ni accede a `CurrentCamera`. Al repetir el comando conserva el decorado existente y selecciona la mesa. Los posibles errores durante la construccion retiran solo el modelo nuevo, antes de publicarlo en Workspace.

Esta fase contiene solo decorado. La colocacion de donuts y la nueva interaccion de mano y objeto se preparan por separado. La apariencia y el encuadre de este decorado quedan pendientes de comprobar en Roblox Studio.

## Ajuste de suelo y luz tras la primera captura

La captura del usuario muestra el suelo de ladrillo atravesando el suelo nuevo y la mesa bajo una sombra fuerte. Con Stop, ejecutar `02_AJUSTAR_SUELO_Y_LUZ.txt`. Nueve rayos verticales consultan la superficie bajo la sala, excluyendo su propio modelo y los avatares. Si es necesario, se eleva el decorado completo hasta dejar el suelo de madera 0,18 studs por encima de esa superficie. Se actualiza tambien `HR_Origen` para las siguientes fases.

Se anaden una luz de techo y un relleno frontal dentro de la sala. Repetir el ajuste reutiliza ambas luces. La altura no disminuye y no se vuelve a elevar si ya hay separacion suficiente. Se conservan los personajes, las fuentes de los controladores y la iluminacion global. Sintaxis comprobada con Luau; altura y aspecto de las luces pendientes de revision en la siguiente captura de Studio.
