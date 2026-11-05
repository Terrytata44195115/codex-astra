# Correccion de visibilidad facial V2

El usuario ha confirmado que el montaje, las posiciones, las animaciones y los 19 planos funcionan. La primera correccion registraba «Texturas listas», pero las capturas seguian mostrando los rostros vacios. Ese registro confirmaba creacion/asignacion, no renderizado visible. **Esta V2 esta preparada para comprobarse en Studio; no se afirma haberla ejecutado aqui.**

## Aplicar a la historia actual

1. Pulsa Stop y guarda la copia actual.
2. Abre `PEGAR_CORREGIR_VISIBILIDAD.txt`, Ctrl+A y Ctrl+C.
3. Script > Comando: reemplaza el texto anterior, pega este bloque completo y pulsa Ejecutar.
4. Debe aparecer `[HR CARAS V2] INSTALADO`.
5. Guarda, cierra pestanas de codigo y pulsa F5.
6. Revisa un primer plano de la hija o madre y otro de Marcos. R repite. La Salida registra el estado recibido por cada cara, por ejemplo `[HR CARAS V2] Madre / ALARMA`. Estos registros describen el dibujo preparado; la captura confirma si se ve correctamente.

Este instalador actualiza solo `StarterPlayerScripts.HR_CarasMarcos`. Lee y compara las fuentes de configuracion, interpretacion, servidor y camara. No escribe en ellas. Conserva los gestos, palidez, ropa, tiempos, movimientos y selecciones de plano ya aprobados.

## Como se representa la cara

Se usan trazos y formas de UI nativos, sin EditableImage, Decal dinamicos ni nuevas descargas de catalogo. El dibujo se proyecta sobre un Part transparente independiente de Head, colocado por delante de la superficie visual usando los attachments y la escala de la cabeza. Esto evita dibujar dentro de la caja fisica que causaba las facciones recortadas en la primera version.

El soporte sigue la cabeza despues de la actualizacion de la camara. Es local, anclado, sin colisiones, consultas ni contactos. Al estar fuera del modelo del actor no se incluye en el calculo de limites de los planos. Se oculta con su actor durante los cortes. `AlwaysOnTop=false` conserva la oclusion por pelo, manos y otros objetos.

La mascara se dibuja abajo, dejando libres los ojos y las cejas. La gorra permanece como en la correccion anterior. Los soportes son planos; hay que revisar desde los angulos de la historia que no parezcan separados de la piel. Las cabezas con otra malla requeriran revisar sus medidas.

Si el dibujo produce un error de UI, se conserva la cara original y se informa en `[HR CARAS V2]`. No se cambian ajustes de seguridad ni se publican imagenes.

## Comprobado

- Compilacion Luau del cliente y del instalador.
- Instalacion que modifica solo el cliente y revierte una escritura fallida.
- Fuentes de configuracion, servidor, camara e interpretacion conservadas byte por byte.
- Simulacion de tres soportes fuera de las cajas/mallas conocidas del proyecto, sin introducirlos en los modelos usados para encuadrar.
- Seguimiento de traslacion y giro de Head; cambio de dibujo al recibir otra expresion.
- Ocultacion y recuperacion entre planos, retirada de soportes y restauracion de las transparencias al eliminar la escena.

**Pendiente en Studio:** visibilidad real, ajuste sobre la superficie, contacto con pelo y manos y aspecto desde los diferentes angulos. Las pruebas simuladas no demuestran el renderizado del motor.

## Archivos anteriores

`PEGAR_CORREGIR_CARAS.txt` actualiza la biblioteca y el cliente completos de caras; tambien incorpora el cliente actual al reconstruirlo. Para esta historia ya instalada basta el parche reducido de visibilidad.

`PREVIA_EXPRESIONES.png` es una previa 2D de diseno generada durante el metodo anterior. No es una captura de Roblox ni demuestra el resultado de la V2. Los archivos de generacion de pixeles se conservan para referencia; el cliente V2 no los usa.
