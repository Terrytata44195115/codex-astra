# Doblaje de boda

[Descargar todas las voces y el guion](DOBLAJE_BODA_VOCES_Y_GUION.zip) · [Escuchar la mezcla de guía](MEZCLA_GUIA_14s.mp3)

Voces sintéticas nuevas en español para novia, novio, oficiante e invitada. El MP4 recibido (`videoplayback (22).mp4`, 9,77 segundos) **no contiene pista de audio**. El texto se recupera de sus subtítulos visibles; no se puede confirmar el diálogo audible que falte ni comparar estos timbres o interpretaciones con los originales.

## Archivos por personaje

- [Novia](POR_PERSONAJE/NOVIA.mp3): pregunta, susto, despertar y «¡Nooooo!».
- [Novio](POR_PERSONAJE/NOVIO.mp3): «Listo…».
- [Oficiante](POR_PERSONAJE/OFICIANTE.mp3): «Puede besar la novia», tal como aparece escrito en la referencia.
- [Invitada](POR_PERSONAJE/INVITADA.mp3): «¡Ey! ¡Yo me opongo!».

Cada personaje incluye también su WAV y su guion en TXT. Estas versiones contienen sus frases seguidas, con pequeñas pausas para editarlas. La carpeta `FRASES_SEPARADAS` contiene las siete intervenciones numeradas en WAV y MP3.

## Montar la escena de Roblox de 14 segundos

Importa los cuatro WAV de `PISTAS_SINCRONIZADAS_14S` y colócalos todos en el segundo cero de la historia, después de eliminar la cuenta atrás de Roblox. Incluyen los silencios y las entradas de cada personaje. Como alternativa, usa `MEZCLA_GUIA_14s.wav`, con las cuatro voces juntas. Los tiempos corresponden a [la escena de boda preparada en Studio](../../../roblox/estudio-historias/boda/README.md), de 14 segundos, y no a la duración del ejemplo de 9,77 segundos.

El texto «Monkey» se pronuncia «Monqui». La frase del despertar termina en «sue…». No hay música ni efectos de fondo. Los WAV son mono PCM de 16 bits a 48 kHz, a partir de síntesis a 24 kHz; los MP3 son mono de 192 kbps.

## Perfiles reutilizables

`GUION_Y_TIEMPOS.json` conserva las voces, las adaptaciones de pronunciación, los cambios de tono y los tiempos. Se ha utilizado Kokoro multilingüe v1.0 int8 con sherpa-onnx 1.12.40: `ef_dora` para la novia, `em_alex` para el novio, `em_santa` para la oficiante e `if_sara` para la invitada, con pronunciación española. Son voces de catálogo del modelo, sin clonación de la referencia.

`CONTROL_TECNICO.json` registra duración, frecuencia y picos de los WAV. Se ha comprobado la decodificación de los MP3, que las cuatro pistas sincronizadas duran 14 segundos y que los archivos no saturan. Esa comprobación no acredita semejanza con la referencia sin sonido.
