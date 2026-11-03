# Final: nuestro conjunto de siempre

Anade una toma de 7,2 segundos al final del rango actual de la historia. Conserva los avatares, las plantillas y el inicio existentes. Respalda los tres scripts antes de actualizar mediante ScriptEditorService.

## Instalar

1. Stop.
2. Descarga y extrae DESCARGAR_FINAL_AMIGOS.zip.
3. Workspace > Insertar > Importar modelo Roblox > HR_FinalAmigos.rbxmx.
4. Copia ACTIVAR_FINAL.txt en Comando y pulsa Ejecutar.
5. Espera [HR FINAL] INSTALADO. Guarda, cierra las pestanas de codigo y pulsa F5.

## Toma final

- 0–1,3: X abre brazos: «¡Pues vamos guapisimos!».
- 1,3–4,8: B abre brazos, responde: «¡Pues queda decidido! Este sera nuestro conjunto de siempre».
- 4,8: plano fijo de ambos.
- 4,95–5,2: anticipacion del salto.
- 5,2–5,85: salto simultaneo, con brazos elevados y piernas flexionadas.
- 5,85–6,1: recepcion.
- 6,1–7,2: gesto final sonriente para anadir risas en el editor.

No se genera voz ni sonido. Las frases y risas se anaden en CapCut.

El salto es una coreografia cinematografica por posiciones y motores, no una accion de juego controlada por Humanoid.Jump. No desplaza a los actores horizontalmente. No requiere IDs de animacion. Las manos R15 rigidas no abren dedos: se mueven brazos y munecas.

## Expresiones

El cierre usa la sonrisa clasica incluida con Roblox, rbxasset://textures/face.png, sin inventar un ID de catalogo. Se comprueba su carga desde el cliente y se conserva la cara original si falla. Se permite explicitamente esa ruta en el controlador facial. La expresion enfadada conserva la configuracion existente. No se anaden texturas no confirmadas de sorpresa, pensamiento o llanto.

## Camara y repeticion

La camara del inicio no cambia. El plano de ambos durante el salto protege el recorte central 9:16 y queda fijo para que el salto no se oculte por seguimiento vertical. El ajuste pone Modo=COMPLETA para anadir el cierre al rango actual. Para grabar solo este final, cambia Modo a ESCENA y Escena al ultimo indice de Escenas en el bloque final de Configuracion. En la historia de 8 escenas, el final nuevo es la escena 9; en la variante de 6, es la 7. En PAUSAS tambien recibe preparacion y pausa como las demas tomas.

Stop > F5 repite la grabacion. No se reinstala entre tomas. El paquete comprueba sus marcadores para evitar anadir el mismo final varias veces al reinstalar.

## Validacion

Se compilo el aplicador y el resultado combinado con los controladores de las variantes V6 y Ropa. Se ejecutaron comprobaciones de duracion, corte previo al salto y expresion final. No se ha ejecutado Roblox Studio en este entorno: hay que verificar el aspecto del rostro, los brazos, la flexion y el salto sobre los avatares reales.
