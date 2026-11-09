# Madre e hija: reto de donuts

Primera fase: decorado para la copia `Madre_Hija_Donuts.rbxl`.

Con Stop, pegar todo el contenido de `01_CREAR_SALA_Y_MESA.txt` en Script > Comando y ejecutar. Al terminar, la mesa queda seleccionada: pulsar F con el cursor sobre la vista 3D para enfocarla. Guardar con Ctrl+S.

Se crea `Workspace.HR_RetoDonuts` con sala azul pastel, suelo de madera, ventana, puerta decorativa, mesa y dos marcas de posicion para madre e hija. Se usan piezas nativas de Roblox sin recursos de catalogo. El frente permanece abierto para grabar.

El decorado queda a 65 studs de la galeria anterior, orientado como la hija cuando existe `HR_RevisionReparto.Hija`. En ausencia de esa referencia se usa una posicion y orientacion fijas. La creacion no mueve actores, cambia caras, modifica fuentes, activa controladores ni accede a `CurrentCamera`. Al repetir el comando conserva el decorado existente y selecciona la mesa. Los posibles errores durante la construccion retiran solo el modelo nuevo, antes de publicarlo en Workspace.

Esta fase contiene solo decorado. La colocacion de donuts y la nueva interaccion de mano y objeto se preparan por separado. La apariencia y el encuadre de este decorado quedan pendientes de comprobar en Roblox Studio.

## Ajuste de suelo y luz tras la primera captura

La captura del usuario muestra el suelo de ladrillo atravesando el suelo nuevo y la mesa bajo una sombra fuerte. Con Stop, ejecutar `02_AJUSTAR_SUELO_Y_LUZ.txt`. Nueve rayos verticales consultan la superficie bajo la sala, excluyendo su propio modelo y los avatares. Si es necesario, se eleva el decorado completo hasta dejar el suelo de madera 0,18 studs por encima de esa superficie. Se actualiza tambien `HR_Origen` para las siguientes fases.

Se anaden una luz de techo y un relleno frontal dentro de la sala. Repetir el ajuste reutiliza ambas luces. La altura no disminuye y no se vuelve a elevar si ya hay separacion suficiente. Se conservan los personajes, las fuentes de los controladores y la iluminacion global. Sintaxis comprobada con Luau; altura y aspecto de las luces pendientes de revision en la siguiente captura de Studio.
