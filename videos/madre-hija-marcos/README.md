# Madre, hija y Marcos: montaje vertical

## Revision dinamica con musica

[Descargar el short dinamico con voces y musica](short_dinamico_con_musica_1080x1920.mp4).

La nueva revision dura **21,47 segundos**, frente a los 24,3 de la version anterior. Mantiene las diez intervenciones de madre, hija y Marcos, reduce la llegada a 0,8 segundos y reparte la historia en **29 planos**, con acercamientos mas marcados y cortes en las reacciones. El tono de las voces se conserva; su velocidad aumenta un 6 % para Marcos y un 9 % para madre e hija.

Los subtitulos aparecen en fragmentos mas cortos en la zona inferior. La entrada de Marcos lleva un rotulo animado, lineas de velocidad y efectos breves. Se conservan dos emojis en momentos concretos. El fondo musical procede del segundo video de referencia aportado por el usuario: se separa su instrumental, se monta en bucle y se reduce bajo las voces. No se mezcla la pista de dialogos del ejemplo. Los acentos sonoros adicionales se sintetizan para este montaje.

Formato **1080x1920, 9:16, 30 FPS**, H.264 y AAC estereo a 48 kHz. [Subtitulos SRT de esta revision](dialogos_dinamicos.srt), [plan de edicion](plan_dinamico.json) y [comprobaciones del archivo final](validacion_dinamica.json). La version anterior se conserva abajo.

## Version con las voces recibidas de ElevenLabs

- [Video con voces y subtitulos](short_con_voces_1080x1920.mp4).
- [Material de doblaje](material_doblaje.zip): video con voces sin texto, tres pistas WAV alineadas, mezcla MP3 y SRT actualizado.
- [Escuchar el doblaje](doblaje_mezclado.mp3).

Reparto comprobado por el contenido de los audios: **Jess es la madre, Cristina la hija y Marcelo interpreta a Marcos**. Se separan sus diez intervenciones y se colocan en el orden del guion. Se conservan tono y velocidad originales; se ajustan la duracion de los planos y los subtitulos para acomodar las frases. Se equilibran los niveles entre voces y se aplican fades muy cortos en los limites de los recortes.

La version doblada dura **24,3 segundos**, 1080x1920, 30 FPS, video H.264 y audio AAC estereo a 48 kHz. El audio codificado mide aproximadamente -15,6 LUFS y -1,45 dBTP. No se reutiliza el audio de fondo de la grabacion de escritorio ni se anade musica en esta version.

Los WAV del ZIP empiezan en 0:00 y contienen silencios en las partes de los otros personajes. Para usarlos por separado, silenciar el audio del MP4 incluido. [Alineacion de las frases](alineacion_doblaje.json) y [subtitulos actualizados](dialogos_con_voces.srt).

Comprobaciones: reparto y texto de las intervenciones revisados mediante transcripcion; limites de recorte conservadores y comprobacion de silencio en la cola retirada; voces sin superposicion; metadata 24,3 segundos y 729 fotogramas; decodificacion audiovisual completa sin errores; revision visual de los textos y cortes; niveles del AAC medidos despues de codificar. MP4 y ZIP individuales inferiores a 32 MiB.

## Montaje visual anterior, sin voces

Edicion de `eeeeeeee.mp4` y `weeweweewwe.mp4`, recibidos del usuario. La historia dura **24 segundos**, en **1080x1920, H.264, 30 FPS**.

- [Video con dialogos del guion y dos emojis](short_subtitulado_1080x1920.mp4).
- [Material para editar y doblar](material_edicion.zip): version limpia en MP4, SRT, guion por personaje, ASS y dos imagenes de emoji.
- [Guion de voces](guion_voces.txt) y [subtitulos SRT](dialogos.srt).

Se unen ambas partes y se eliminan interfaz y margenes de Studio. Los encuadres cambian por personaje, conservan los gestos y destacan las reacciones. El tramo sobre el hombro donde el pelo tapaba a Marcos se sustituye por dos encuadres de la llegada, aprovechando los 60 FPS de origen para una camara lenta breve. Se aplican acercamientos pequenos y cortes directos. El texto lleva palabras en amarillo, contorno y entrada/salida; aparecen dos emojis en momentos concretos.

**Ambas versiones estan sin audio.** La grabacion contenia sonido de fondo que no correspondia al dialogo y se ha retirado. No se han generado las voces solicitadas, musica ni efectos de sonido. Para finalizar el doblaje hacen falta los audios de madre, hija y Marcos. El SRT y los textos quemados siguen los tiempos previstos del guion; no afirman sincronizacion con voces que todavia no se han recibido.

Comprobaciones: 24 segundos, 720 fotogramas, relacion 9:16, 1080x1920, 30 FPS, ausencia de audio original y decodificacion completa sin errores. Se revisaron visualmente los encuadres, las reacciones y la legibilidad de subtitulos. Los MP4 individuales y el ZIP pesan menos de 32 MiB.

Los archivos originales, su audio y transcripciones internas no se publican. `plan_montaje.json` recoge los tiempos y recortes de la edicion.
