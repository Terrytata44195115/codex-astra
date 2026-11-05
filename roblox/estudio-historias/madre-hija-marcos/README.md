# Mama conoce a Marcos: version narrativa de 24 segundos

Actualiza la prueba de tres actores en la copia `Madre_Hija_Novio.rbxl`. Requiere el reparto de fase 1. **El codigo y el instalador se han comprobado fuera de Studio; la ejecucion visual de esta version esta pendiente.** No es una grabacion ni un archivo de audio ya editado.

El usuario ha confirmado el montaje y los movimientos de esta historia. Las caras originales de esta entrega quedaron parcialmente ocultas por la malla; para una historia ya instalada aplica [solo la correccion de caras](correccion-caras/README.md). El instalador completo tambien incorpora ahora esa correccion. La nueva representacion facial queda pendiente de revision en Studio.

## Instalar en la misma copia

1. Stop en Studio y Ctrl+S para guardar el estado actual.
2. Abre `PEGAR_HISTORIA_MARCOS.txt` como texto y copia todo con Ctrl+A, Ctrl+C.
3. Script > Comando. Dentro de la barra, Ctrl+A, Ctrl+V, Ejecutar.
4. Debe terminar con `[HR HISTORIA] INSTALADA: madre, hija y Marcos; 24 segundos y 19 planos.`
5. Guarda, cierra las pestanas de codigo y pulsa F5. Espera la carga y la cuenta atras.
6. R repite la toma con cuenta atras sin salir de Play. P devuelve la camara del jugador. Stop termina.

No hay que crear otro proyecto, importar otro modelo ni renombrar personajes. Esta entrega actualiza los controladores propios de la fase 2 y anade un modulo de interpretacion; no pone una segunda camara a competir con la primera. El reparto usa las referencias ya guardadas. `Novio` sigue siendo la clave interna; su nombre para la historia es Marcos.

## Secuencia

- 0-3,5 s: hija y madre, primero juntas y despues por separado. Estan ilusionadas por conocer a Marcos.
- 3,5-5,5 s: Marcos llega corriendo. Plano entero con seguimiento y corte sobre el hombro de la madre.
- 5,5-7,5 s: presentacion. El plano de los tres dura 0,9 segundos; sigue un plano de la hija.
- 7,5-10 s: saludo educado de Marcos y anticipo de la reaccion de la madre.
- 10-14 s: susto y palidez de la madre, manos a la cabeza y pequeno retroceso. Plano medio seguido de plano cercano. Pensamiento: «¿Donde me he metido? ¿Que me ha traido mi hija?».
- 14-16 s: la hija, avergonzada, pide que no empiece.
- 16-19 s: la madre senala; detalle del pantalon y reaccion de la hija tapandose la cara.
- 19-21,5 s: respuesta de Marcos, con las manos levantadas.
- 21,5-22,5 s: reaccion de la hija.
- 22,5-24 s: madre tajante y corte a Marcos llevando una mano a la gorra.

La configuracion guarda escenas, dialogos, gestos, expresiones y planos con tiempos propios. Permite introducir cortes de reaccion sin interrumpir la frase que el editor montara despues. Los personajes se colocan en triangulo y se orientan hacia sus interlocutores; no posan todos de frente como una foto de grupo.

## Camara y grabacion

Los cortes son directos, con acercamientos pequenos durante algunas tomas. Las individuales se encuadran desde la orientacion del personaje. La toma de llegada sigue el desplazamiento de Marcos. El encuadre de cada plano se calcula al cortarlo para evitar que la camara haga zoom continuamente al mover las manos.

Se protege el centro 9:16 con un margen; la ventana de Studio puede seguir horizontal. **Esto no cambia la resolucion de grabacion ni exporta un MP4 vertical**. El editor debe recortar el area del juego al centro y exportar 1080x1920. Las tomas cercanas dejan margen para ajustar el zoom al editar.

En planos individuales se ocultan localmente los actores ajenos a ese plano para que no tapen la cara desde la posicion de la camara. En el conjunto se muestran los tres y en el plano sobre hombro se muestra tambien la madre. P restituye su visibilidad para revisar el escenario.

`SubtitulosGuia=false` deja la captura limpia. Se puede activar en la configuracion para ensayar; las voces y subtitulos finales se montan en el editor.

## Apariencias y expresiones

El usuario confirmo que la primera correccion generaba imagenes, pero las caras seguian sin verse en la cabeza. El cliente actual dibuja las seis expresiones con elementos de UI nativos sobre un soporte transparente situado por delante de la superficie visual. El soporte sigue la traslacion y el giro de Head, usando FaceFrontAttachment, HatAttachment y la escala de la malla. No usa EditableImage ni carga caras de catalogo. Los soportes se crean fuera de los modelos para conservar los limites que utiliza la camara. Se ocultan con su actor en cada corte y respetan la oclusion del pelo y las manos. **El aspecto visual de esta segunda correccion sigue pendiente de comprobar en Studio.**

La palidez cambia progresivamente el color de cabeza y manos de la madre desde el segundo 10; la hija tiene un cambio mas suave desde el 14. No se cambian las texturas de ropa ni se aclara el pelo.

Marcos conserva el cuerpo y la ropa de colores elegidos antes. La gorra y visera **provisionales** se ajustan mediante los attachments de la cabeza. La mascara se dibuja en la parte inferior del soporte facial; los bloques de la version inicial se han retirado. Se retira el pelo solo de la copia de Play para que no atraviese la gorra. Son complementos de revision, no una skin final de catalogo. Se pueden sustituir desactivando `AccesoriosProvisionales` y preparando accesorios definitivos en su plantilla.

**El pantalon de tiro bajo no esta resuelto:** se conserva el pantalon actual. El detalle de camara y el gesto de senalarlo estan preparados, pero aun debe elegirse o confeccionarse la apariencia que corresponda. Las apariencias de madre e hija tambien siguen siendo las provisionales revisadas en la galeria.

## Acciones

Correr y saludar intentan cargar las pistas reales encontradas en Base_Historias. Si no devuelven duracion se registra un aviso y se usa el respaldo procedural. Una duracion valida no demuestra por si sola que la animacion tenga buen aspecto en este cuerpo; hay que ver la captura.

Los demas gestos se componen con los Motor6D existentes: ilusion, presentar, susto, incomodidad, negar, senalar, taparse la cara, manos levantadas y mano hacia la gorra. Los angulos, contacto de las manos y posibles intersecciones se revisan en Studio. La entrada es guiada por PivotTo; no esquiva obstaculos automaticamente.

No se detienen todas las pistas del Animator en cada fotograma. Solo se gestionan las pistas cargadas por este controlador al cambiar de accion. No se reconstruyen articulaciones ni se introduce un rig AnimationConstraint nuevo.

## Audio y entrega al editor

- `GUION_EDITOR.txt`: voces, dialogos, pensamiento de la madre y sugerencias de musica y efectos por tiempos.
- `DIALOGOS_MARCOS.srt`: diez intervenciones con sus intervalos de referencia.
- `GUION_Y_PLANOS.json`: escenas y diecinueve planos exportados de la configuracion.

No se incluyen voces sintetizadas, musica, efectos de audio ni sincronizacion labial. El SRT refleja la duracion prevista de las frases, no una alineacion con una voz ya grabada. Para la duracion exacta, monta las voces en esos intervalos o ajusta la configuracion antes de volver a grabar.

## Conservacion y restauracion

Las fuentes de HR_CineServidor y HR_CineCamara anteriores permanecen intactas y pausadas. Se conserva el respaldo de sus estados iniciales aunque el instalador se ejecute varias veces. Las fuentes de los controladores de prueba se actualizan mediante ScriptEditorService y se comparan con el texto instalado.

Durante Play se usan copias y se aparcan temporalmente la galeria y las dos originales. Stop recupera el estado de edicion. Las plantillas, ropa y caras originales no se sustituyen.

`VOLVER_HISTORIA_ANTERIOR.txt`, ejecutado con Stop, restaura los controladores de la historia anterior y aparca la galeria para que no se vea detras. Para volver a Marcos se ejecuta otra vez `PEGAR_HISTORIA_MARCOS.txt`. La fase 2 permanece archivada en el repositorio si se necesita recuperar su prueba corta.

## Comprobaciones realizadas

- Compilacion Luau de los componentes, cliente facial, instalador y restaurador.
- Pruebas de instalacion, repeticion sin duplicados, restauracion y reactivacion sobre un arbol de servicios simulado.
- Fallos inyectados en cada una de las cinco escrituras, tanto al instalar como al actualizar: se restituyen las fuentes y estados anteriores en el modelo de prueba.
- Rechazo de destinos con propietario ajeno.
- Lineas de tiempo de escenas y planos sin huecos ni solapamientos, cierre a los 24 segundos y presencia de los cambios solicitados de Marcos y la madre.
- Exportacion de guion, SRT y lista de planos a partir de la configuracion entregada.

**Pendiente en Studio:** carga efectiva y aspecto de pistas, colocacion de complementos y caras, contacto de manos, claridad de cada corte, encuadre despues del recorte y dos reproducciones consecutivas con R y Stop > F5. Estas comprobaciones fuera de Studio no sustituyen revisar el clip.
