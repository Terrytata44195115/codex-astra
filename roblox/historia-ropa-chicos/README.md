# Segunda historia: ropa copiada, dos chicos

Version independiente de la historia con perros. Conserva los clips ya grabados y los modelos originales. El paquete actualiza los tres controladores propios de HR_Cine y respalda sus textos anteriores antes de hacerlo.

## Instalar

1. Pulsa **Stop** en Studio.
2. Descarga [HR_EntregaRopa.rbxmx](HR_EntregaRopa.rbxmx) con **Download raw file**.
3. Importalo mediante **Workspace > Insertar > Importar modelo Roblox**. Debe aparecer la carpeta `HR_EntregaRopa`.
4. Abre [ACTIVAR_ROPA_CHICOS.txt](ACTIVAR_ROPA_CHICOS.txt), pulsa **Raw**, copia TODO, pegalo en **Comando** y pulsa **Ejecutar**.
5. Espera: Roblox debe generar dos bases R15. Si termina correctamente, aparece **[HR ROPA] INSTALADO**. Si falla la generacion, envia el error; no se sustituyen los tres controladores antes de terminar de crear las bases.
6. Guarda con **Ctrl+S**, cierra las pestanas de los tres scripts y pulsa **F5**.

No es necesario reinstalar entre tomas: **Stop > F5** vuelve a reproducirla. El comando instalador solo se ejecuta con el juego detenido.

## Apariencia de los chicos

No se han elegido ni inventado IDs de catalogo. Roblox crea dos rigs R15 estandar y el modulo les anade una base visual sencilla de estilo anime: pelo geometrico oscuro, mechones de distinto color, uniforme oscuro con camisa/corbata y gafas para B. Son bases procedurales, no avatares otaku de catalogo ni una reproduccion profesional de un personaje de anime.

Las bases estan en **ServerStorage > HR_AvataresRopa > chicoX / chicoB**. Pueden personalizarse en una tarea posterior sin reescribir la coreografia, conservando R15 y los nombres. No cambies las articulaciones.

Durante Play se crean copias de esos chicos en las posiciones de las chicas, corrigiendo la altura de los pies para las nuevas proporciones. Las chicas se ocultan solo durante Play y reaparecen al pulsar Stop. No se cambian sus skins, pelo, ropa ni texturas guardadas. Los perros existentes no participan y no se borran. Los objetos del decorado anterior llamados `perroX` y `perroB` tambien se ocultan y anclan solo durante Play; no se asignan identidades de dueno y reaparecen con Stop. Los nombres se pueden editar en `OcultarDurantePlay`.

## Guion: 31,9 segundos

| Escena | Duracion | Accion/dialogo |
| --- | --- | --- |
| 1 | 6,5 s | X entra corriendo. Desde el segundo 2: «¡ME HAS COPIADO LA ROPA!» |
| 2 | 4,8 s | B piensa brevemente. «¡NOOO! ¡YO NO TE HE COPIADO!» Abre brazos, niega y se explica. |
| 3 | 5 s | «¡PERO SI LO HABLAMOS AYER!» X solloza; toma de B pensando entre 1,8 y 3,5 segundos. |
| 4 | 4,6 s | B piensa en silencio antes de «ESPERA… ¿AYER?», desde el segundo 1,6. |
| 5 | 6 s | «YO PENSE QUE ERAMOS AMIGOS… UN AMIGO NO ME HACE ESTO». |
| 6 | 5 s | «¡ES LA MISMA ROPA! ¡TE LO CONTE AYER!» Reaccion de B y decepcion de X. |

La mano de B usa IK con un objetivo junto a la barbilla, adaptado al tamano de la cabeza, y un objetivo de codo. Si el rig no contiene la cadena necesaria, informa y conserva el gesto por motores.

## Camara y grabacion

Los encuadres dejan espacio al cuerpo y las manos. Cambian entre protagonista, ambos personajes y reaccion del interlocutor. No hay acercamientos automaticos. El calculo protege una zona central **9:16**, aunque Studio este horizontal; no cambia por si mismo el formato de salida de OBS.

Usa una vista vertical o recorta el centro a 9:16 en OBS. Haz los acercamientos en CapCut. Si recortas mucho, necesitaras suficiente resolucion para conservar detalle. No se anaden dialogos en pantalla ni audio: las voces, sonidos y textos se editan despues.

## Reutilizar

En **ReplicatedStorage > HR_Cine > Configuracion**:

- `Modo="COMPLETA"`: todas las escenas del rango DesdeEscena..HastaEscena.
- `Modo="ESCENA"`: solo el numero `Escena`, con estado inicial propio.
- `Modo="PAUSAS"`: rango con cuenta atras de 3 segundos y pausa de 2 segundos por toma.
- `Camara.ParaEditar=true`: planos abiertos, sin acercamiento automatico.
- `Camara.AspectoObjetivo=9/16`: zona vertical protegida.
- `Personajes`: nombres de los dos actores.
- `CrearAvatares=true`: usa las plantillas de los chicos y oculta las chicas solo en Play.

## Caras pendientes

La textura ENFADADA usa el ID proporcionado, con precarga y vuelta a la cara original si falla. B intenta esa cara al defenderse y vuelve a la original para las expresiones pendientes. Las texturas SORPRENDIDA, PENSATIVA, PREOCUPADA y LLORANDO siguen sin confirmar: se conserva la cara original y se avisa. Por tanto, no se promete un cambio facial de sorpresa, pensamiento o llanto. El pensamiento y los sollozos se representan corporalmente. FELIZ permanece desactivada por el fallo de carga previo.

## Validacion

Se compilaron con Luau los cuatro modulos y el activador. Se verificaron las seis escenas, su duracion total, el orden de cortes, las tomas de pensamiento y que ninguna accion requiere perros. Se verifico que el XML conserva completos los cuatro textos y desactiva los scripts ejecutables del paquete.

No se ha ejecutado Roblox Studio en el entorno de preparacion. La creacion de rigs mediante el servicio de Roblox, el aspecto de los accesorios geometricos, las pisadas y el ajuste final de la mano deben comprobarse en Studio. Los errores de scripts ajenos, como Workspace.Part.Script o badgeId, requieren revision separada y no se modifican aqui.
