# Madre e hija: reto de donuts

Primera fase: decorado para la copia `Madre_Hija_Donuts.rbxl`.

Con Stop, pegar todo el contenido de `01_CREAR_SALA_Y_MESA.txt` en Script > Comando y ejecutar. Al terminar, la mesa queda seleccionada: pulsar F con el cursor sobre la vista 3D para enfocarla. Guardar con Ctrl+S.

Se crea `Workspace.HR_RetoDonuts` con sala azul pastel, suelo de madera, ventana, puerta decorativa, mesa y dos marcas de posicion para madre e hija. Se usan piezas nativas de Roblox sin recursos de catalogo. El frente permanece abierto para grabar.

El decorado queda a 65 studs de la galeria anterior, orientado como la hija cuando existe `HR_RevisionReparto.Hija`. En ausencia de esa referencia se usa una posicion y orientacion fijas. La creacion no mueve actores, cambia caras, modifica fuentes, activa controladores ni accede a `CurrentCamera`. Al repetir el comando conserva el decorado existente y selecciona la mesa. Los posibles errores durante la construccion retiran solo el modelo nuevo, antes de publicarlo en Workspace.

Esta fase contiene solo decorado. La colocacion de donuts y la nueva interaccion de mano y objeto se preparan por separado. La apariencia y el encuadre de este decorado quedan pendientes de comprobar en Roblox Studio.
