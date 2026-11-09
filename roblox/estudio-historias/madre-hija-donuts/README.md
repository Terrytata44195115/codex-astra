# Madre e hija: susurro y penultimo donut picante

## Version actual: 20 segundos

Seis donuts. Madre e hija empiezan saltando, dando una vuelta y senalando la comida. La madre aparece sola en primer plano, lleva ambas manos junto a la boca y revela al espectador: «Hay uno que pica, pero mi hija no lo sabe». La hija come cuatro en un montaje rapido; el quinto, penultimo, es picante. La reaccion muestra dos saltos, cara roja, expresion enfadada y un primer plano frontal. Queda un donut intacto para el remate.

**Sobre la escena ya instalada**, con Stop pegar todo `05_SUSURRO_PICANTE_Y_LUZ.txt` en Script > Comando. Debe terminar con `[HR DONUTS] SUSURRO INSTALADO: 20 segundos; salto, giro, susurro y penultimo donut picante.` Guardar con Ctrl+S y pulsar F5. La cuenta atras dura tres segundos. No hay que rehacer el decorado ni preparar otros personajes.

Para una copia que aun solo contiene el decorado, instalar 03 primero y despues 05. El archivo 04 se mantiene como alias de la actualizacion actual. No hace falta ejecutarlos ambos.

- **R**: repetir, reponiendo comida, poses, color y expresiones.
- **G**: mostrar u ocultar dialogos y contador de referencia.
- **P**: devolver la camara al jugador.
- **Stop**: volver a edicion.

## Guion y camara

| Tiempo | Accion y dialogo |
| --- | --- |
| 0-2,4 | Ambas saltan, giran y senalan. Hija: «¡Mama, mira esos donuts!» |
| 2,4-6,1 | Primer plano de madre sola, manos ahuecadas junto a la boca. «Hay uno que pica, pero mi hija no lo sabe». |
| 6,1-7,6 | Hija: «¡Me los voy a comer!» |
| 7,6-10,4 | Cuatro bocados en montaje rapido. |
| 10,4-12,5 | Agarre y elevacion completos del quinto. Hija: «¡Que ricos!» |
| 12,5-13,85 | Mordisco, vapor, cara roja y enfadada, dos saltos. «¡Mama, esto pica!» Plano medio con margen de salto. |
| 13,85-15,3 | Primer plano de la hija enfadada. |
| 15,3-17,6 | Madre en primer plano: «¿Te guardo el ultimo?» |
| 17,6-20 | Hija: «¡Ni loca! ¡Agua!» Niega con la cabeza; vuelta al conjunto al final. |

Se conservan los ejes frontales. Hay primeros planos intencionados para el susurro y las reacciones. En las individuales se oculta solo al otro actor, manteniendo la comida y el decorado. El cliente facial ya instalado sigue la visibilidad de cada cabeza. Los planos de la cara usan el volumen visible de cabeza y manos en lugar de incluir toda la trenza hasta la cintura. Los conjuntos son mas cercanos que en la version anterior.

Los margenes negros delimitan el centro 9:16 en una ventana horizontal. Son una guia de encuadre, no una exportacion de video: la grabacion aun debe recortarse y exportarse a 1080x1920 en el editor.

## Iluminacion y colores

La captura del usuario estaba sobreexpuesta. La base conservaba Bloom y una iluminacion global intensa, y el primer ajuste habia anadido focos de techo y frontal excesivos. La actualizacion desactiva esos focos y los postefectos de Lighting, elimina la niebla interior, fija brillo 1 y exposicion -0,30, reduce los reflejos ambientales y aplica una paleta azul gris y madera mate tomada como referencia del clip. El techo deja de ser blanco puro y los donuts usan un glaseado rosa mas suave.

Se guardan los valores previos y referencias de cada objeto en `ServerStorage.HR_DonutsAspectoOriginal`. El color de piel original se conserva; solo se mezcla hacia rojo durante el picante. La revision visual de este nuevo perfil necesita la captura de Studio: la prueba externa no demuestra un ajuste de color identico al video de referencia.

## Agarre y susurro

Los brazos se resuelven sobre sus Motor6D existentes, usando el RightGripAttachment y LeftGripAttachment de las manos. El borde posterior elevado del donut llega al centro de la boca dibujada. La cabeza se mantiene frontal durante el mordisco. Para susurrar, ambas manos llegan a los lados de la boca; las comprobaciones geometricas mantienen sus cajas por debajo de los ojos. Se conserva el cliente de caras y el modulo de interpretacion original.

El quinto donut se coloca en el sitio alcanzable junto a la hija. Los cuatro anteriores se resuelven con jump cuts intencionados. El sexto no se come. La mesa se ajusta a la altura de la cintura y los donuts previos se conservan en el respaldo.

## Voces y edicion

El dialogo en Roblox es una **guia sin audio**, no sincronizacion labial. `VOZ_MADRE.txt` y `VOZ_HIJA.txt` contienen las frases nuevas. La primera frase de madre se interpreta como susurro complice; la ultima en tono burlon normal. La hija pasa de entusiasmo a enfado comico. El SRT usa tiempos previstos, pendientes de alinear con las voces recibidas. Musica, sonidos de mordisco y efectos de edicion se montan despues.

## Conservacion y comprobaciones

05 actualiza Configuracion, Donuts, BrazoDonut y los controladores existentes de servidor y camara. No escribe el cliente de caras ni Interpretacion. Antes de escribir verifica los dos rigs y sus cadenas de mano. Las fuentes anteriores y los donuts retirados quedan en `ServerStorage.HR_DonutsAntesSusurro`. La copia de aspecto conserva sus primeros valores aunque se repita el instalador.

Comprobaciones externas: compilacion Luau; 20 segundos y 14 planos; coherencia de quinto picante y sexto intacto; proyeccion del centro 9:16; agarre y mordisco en ambos rigs extraidos de Base_Historias; susurro con dos manos alcanzables y por debajo de los ojos; sustitucion de comida sin duplicados; perfil de luz sin Bloom ni focos locales; respaldo inicial estable; restauracion y rollback ante 21 fallos de escritura de fuentes y un fallo parcial de escritura de iluminacion.

**Pendiente en Studio:** comprobar el resultado con la copia actual del usuario: exposicion y tonos, giro inicial, manos junto a la boca, aislamiento del primer plano, mordisco, rojo de la hija y dos repeticiones con R. Las pruebas geometricas y de instalacion no equivalen a ver la animacion renderizada.

## Preparacion del decorado

Primera fase: decorado para la copia `Madre_Hija_Donuts.rbxl`.

Con Stop, pegar todo el contenido de `01_CREAR_SALA_Y_MESA.txt` en Script > Comando y ejecutar. Al terminar, la mesa queda seleccionada: pulsar F con el cursor sobre la vista 3D para enfocarla. Guardar con Ctrl+S.

Se crea `Workspace.HR_RetoDonuts` con sala azul pastel, suelo de madera, ventana, puerta decorativa, mesa y dos marcas de posicion para madre e hija. Se usan piezas nativas de Roblox sin recursos de catalogo. El frente permanece abierto para grabar.

El decorado queda a 65 studs de la galeria anterior, orientado como la hija cuando existe `HR_RevisionReparto.Hija`. En ausencia de esa referencia se usa una posicion y orientacion fijas. La creacion no mueve actores, cambia caras, modifica fuentes, activa controladores ni accede a `CurrentCamera`. Al repetir el comando conserva el decorado existente y selecciona la mesa. Los posibles errores durante la construccion retiran solo el modelo nuevo, antes de publicarlo en Workspace.

Esta fase contiene solo decorado. La colocacion de donuts y la nueva interaccion de mano y objeto se preparan por separado. La apariencia y el encuadre de este decorado quedan pendientes de comprobar en Roblox Studio.

## Ajuste de suelo y luz tras la primera captura

La captura del usuario muestra el suelo de ladrillo atravesando el suelo nuevo y la mesa bajo una sombra fuerte. Con Stop, ejecutar `02_AJUSTAR_SUELO_Y_LUZ.txt`. Nueve rayos verticales consultan la superficie bajo la sala, excluyendo su propio modelo y los avatares. Si es necesario, se eleva el decorado completo hasta dejar el suelo de madera 0,18 studs por encima de esa superficie. Se actualiza tambien `HR_Origen` para las siguientes fases.

Se anaden una luz de techo y un relleno frontal dentro de la sala. Repetir el ajuste reutiliza ambas luces. La altura no disminuye y no se vuelve a elevar si ya hay separacion suficiente. Se conservan los personajes, las fuentes de los controladores y la iluminacion global. Sintaxis comprobada con Luau; altura y aspecto de las luces pendientes de revision en la siguiente captura de Studio.
