# Correccion de las caras y la gorra

El usuario ha confirmado que el montaje, las posiciones y las animaciones funcionan. Las capturas muestran facciones cortadas por la cabeza y una mascara rectangular atravesada por la cara de Marcos.

## Aplicar solamente esta correccion

1. Stop en Studio y guarda la copia actual.
2. Abre `PEGAR_CORREGIR_CARAS.txt`, Ctrl+A y Ctrl+C.
3. Script > Comando: reemplaza el texto anterior, pega este bloque completo y pulsa Ejecutar.
4. Debe aparecer `[HR CARAS] CORRECCION INSTALADA`.
5. Guarda, cierra pestanas de codigo y pulsa F5.
6. En Salida, `[HR CARAS] Texturas listas sobre la cabeza` indica que se han creado y asignado las imagenes. Revisa una cara cercana de la madre y otra de Marcos. R permite repetir la toma.

No hay que reinstalar la historia completa. Este instalador solo actualiza `Interpretacion` y prepara un LocalScript de representacion facial, `HR_CarasMarcos`. No escribe en los scripts de camara, secuencia ni configuracion. Conserva literalmente las funciones de gestos y palidez de la version instalada, incluidos ajustes locales que sigan la estructura conocida. Si no reconoce esa estructura se detiene antes de escribir.

## Causa y cambio

La version anterior dibujaba con SurfaceGui sobre la caja de `Head`, pero estas cabezas usan `SpecialMesh` con `MeshType.Head`. Roblox documenta que este tipo de malla tiene una escala no estandar, y su superficie visible no coincide necesariamente con la caja del Part. Las facciones podian quedar dentro de la malla. Los bloques de mascara se dimensionaban usando esa misma caja, produciendo el hueco y el rectangulo que muestran las capturas.

Ahora las seis expresiones son imagenes RGBA generadas en el cliente y aplicadas como `Decal` a la cara. La proyeccion sobre la cabeza la realiza el motor de Roblox. La mascara se integra en la textura inferior de Marcos, con ojos y cejas libres; se retiran los bloques que atravesaban la cara. La gorra y visera se dimensionan a partir de HatAttachment y FaceFrontAttachment.

`PREVIA_EXPRESIONES.png` muestra los pixeles reales que genera Luau sobre un fondo de ejemplo. **Es una previa 2D, no una captura ni validacion del renderizado en Studio.** La parte inferior muestra las variantes con mascara. La forma final depende de la cabeza, el pelo y la iluminacion del proyecto.

## Requisitos y recuperacion

La generacion usa `AssetService:CreateEditableImage` y `Decal.ColorMapContent` en el cliente. Se ha preparado para grabar dentro de Studio. No carga caras de catalogo ni sube imagenes a Roblox. Se reutiliza un grupo de doce imagenes pequenas durante las repeticiones.

Si la generacion o asignacion no esta disponible, el script avisa en `[HR CARAS]` y mantiene la cara original. No deja una cabeza vacia ni detiene la escena. No cambia ajustes de seguridad. Para un juego publicado, EditableImage tiene requisitos adicionales descritos por Roblox; esta correccion no afirma habilitarlos.

El script facial sigue la ocultacion local de los personajes que ya controla la camara, para que sus caras no queden flotando cuando se oculta un actor entre planos.

## Comprobado fuera de Studio

- Compilacion Luau de fuentes e instaladores.
- Instalacion y repeticion del parche sin alterar las fuentes protegidas.
- Fallos en ambas escrituras con cliente nuevo o existente: se recupera el estado previo en el arbol simulado de prueba.
- Conservacion de un ajuste previo en un gesto y compilacion del modulo combinado.
- Los seis estados producen imagenes distintas, con fondo transparente y mascara inferior.
- Previa de las doce imagenes generada desde el rasterizador Luau entregado.
- Verificacion por hash: las fuentes de camara, servidor y configuracion, y las funciones Pose y Palidez canonicas, se conservan byte por byte.

**Pendiente:** probar en Studio la disponibilidad de EditableImage, el mapeado real del Decal, la gorra y la cara durante los cortes. Las pruebas locales no sustituyen esa revision visual.

Referencias: [escala de DataModelMesh](https://create.roblox.com/docs/reference/engine/classes/DataModelMesh#Scale), [EditableImage](https://create.roblox.com/docs/reference/engine/classes/EditableImage) y [Decal.ColorMapContent](https://create.roblox.com/docs/reference/engine/classes/Decal#ColorMapContent).
