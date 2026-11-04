# Revision del archivo Base_Historias.rbxl

Archivo recibido de la usuaria el 4 de noviembre de 2026. Se inspeccionaron su jerarquia, referencias, propiedades relevantes y codigo. No se modifico el archivo original ni se ejecuto Roblox Studio.

## Resultado

Es la version de chicos aunque los actores de Workspace conserven los nombres chicaX y chicaB. Al iniciar, el bloque HR_SOLO_CHICOS guarda las referencias originales y crea copias de ServerStorage.HR_AvataresRopa.chicoX y chicoB usando esos nombres. No hay que deducir el reparto a partir de sus nombres antiguos.

El archivo contiene 1.993 instancias, 119 clases y 23 objetos de codigo. Solo hay dos scripts habilitados en las rutas normales de ejecucion del sistema: ServerScriptService.HR_CineServidor y StarterPlayer.StarterPlayerScripts.HR_CineCamara. Los modulos del catalogo no se ejecutan por estar en Workspace; los scripts dentro de ServerStorage tampoco se consideran controladores activos de la escena. Las copias antiguas explican la acumulacion, pero no significa que 23 controladores esten compitiendo simultaneamente.

## Que se conserva

| Elemento | Evidencia del archivo | Uso propuesto |
| --- | --- | --- |
| Plantillas chicoX y chicoB | Ambas en HR_AvataresRopa, con 15 Motor6D y 16 piezas corporales conectadas desde HumanoidRootPart. Sin AnimationConstraint. | Biblioteca de actores; no generar otro esqueleto. |
| Originales chicaX y chicaB | Tambien R15 con 15 Motor6D y 16 piezas corporales conectadas. | Referencias y perfiles de chicas. |
| Aspecto de los chicos | Shirt, Pants, Ultra-Fabulous Hair; B conserva Nerd Glasses. Cara Decal frontal. | Perfiles de apariencia sobre rigs comprobados. |
| Escenario | Suelo, decorado, posiciones y perros presentes. | Base visual; mantener el original y usar copias para nuevas escenas. |
| Camara | Corte individual, plano de ambos, reaccion, seguimiento de entrada y cierre de salto; calculo central 9:16. | Conservar sus formulas de encuadre y convertirlas en presets parametrizados. |
| Reproduccion | COMPLETA, ESCENA, PAUSAS; 3 segundos de preparacion y 2 de pausa. | Conservar el comportamiento y convertirlo en un reproductor unico con reinicio controlado. |
| Gestos | Acusar, defender, negar, pensar, brazos cruzados, sollozar, carrera y cierre compartido. | Extraer como acciones, sin atarlas a una historia concreta. |

## Guion que realmente se ejecuta

Modo COMPLETA, rango 1..3, mas FinalAmigos. Hay nueve escenas definidas, pero actualmente se reproducen 1, 2, 3 y 9. Duracion calculada: 6,5 + 4,8 + 4,5 + 7,2 = 23 segundos, sin las pausas del modo de grabacion.

Las escenas 6..8 de perros siguen almacenadas. DobbyX y DobbyB tienen Value vacio. Cambiar HastaEscena a 8 activaria esos requisitos y podria detener el arranque. Deben separarse las historias por datos, en vez de conservar finales incompatibles dentro de un unico guion.

## Animaciones ya presentes

Hay 81 objetos Animation con 38 IDs distintos. El modelo importado ServerStorage.easxvki contiene 27 referencias, incluyendo caminar, correr, saltar, saludar, reir y bailar. Las otras referencias proceden de las bases antiguas archivadas. El Humanoid del easxvki importado tiene HipHeight=-1, mientras las plantillas funcionales tienen aproximadamente 1,998; tambien por eso conviene conservar los rigs actuales y extraer del importado solo recursos de apariencia o animacion. Se adjunta inventario con procedencia; **estar en el archivo no demuestra que carguen, tengan permisos ni encajen visualmente en los rigs finales**.

Ejemplos recuperados del modelo real, no inventados:

- Correr: 616140816.
- Caminar: 616146177.
- Saltar: 616139451.
- Saludar: 507770239.
- Reir: 507770818.
- Bailes: familias dance, dance2 y dance3 del Animate importado.

Tambien existe un Automatic Save de animacion con cinco keyframes y 0,6 segundos de duracion. No se considera por ello una biblioteca terminada de acciones.

## Que hay que reorganizar

### 1. Compatibilidad entre pistas y poses

En cada PreAnimation, el controlador actual detiene todas las pistas de Animator y restablece Motor6D.Transform. Esto esta hecho para controlar las poses procedurales, pero impide integrar sin mas un clip de carrera o baile.

El gesto thinking actual usa angulos de cuello, hombro y codo; este archivo no contiene un IK de mano hacia la barbilla. Ese objetivo debe incorporarse si se quiere contacto preciso entre mano y cara.

La carrera actual desplaza el modelo por una trayectoria y usa IK para las piernas; no esta reproduciendo RunAnim. El salto final tambien es una coreografia por posiciones y motores. No conviene borrar esas acciones como recurso provisional, pero deben distinguirse de los clips de Animator.

Propuesta: un gestor de acciones por actor. Decide si reproduce una pista de cuerpo entero, una pose superior o un objetivo de mirada/mano. Detiene exclusivamente las pistas que el propio sistema controla y gestiona los conflictos de forma explicita. No anadir otro script Animate competidor.

### 2. Reparto por referencias

El servidor y el cliente buscan literalmente chicaX y chicaB. Ese acoplamiento debe sustituirse por referencias de actor/rol. La misma escena podra usar Madre/Hija/Novio o Novio/Novia, y permitir un tercer actor. Los modelos no necesitan renombrarse para cada historia.

### 3. Acciones separadas del dialogo

Actualmente se concentran en un gran bloque if/elseif que conoce ACUSAR, DEFENDER, LLORAR, etc. Deben extraerse a funciones con parametros: actor, destinatario, intensidad y duracion. Asi un gesto nuevo se integra una vez y se reutiliza.

### 4. Camaras desde diferentes posiciones

El calculo actual parte de un frente comun entre dos actores. Cambia el encuadre y agrega desplazamientos pequenos, pero no ofrece un sistema completo de posiciones de camara.

Conservar el encuadre 9:16 y anadir: frontal, tres cuartos izquierdo/derecho, sobre hombro, plano de tres, travelling lateral y seguimiento. La posicion, el objetivo y la lente deben ser independientes de la accion. Cada accion puede tener varias tomas con la misma coreografia. Las nuevas posiciones necesitan comprobar obstaculos y no introducir cortes de eje sin una decision de montaje.

El plano fijo del salto esta en un segundo callback separado y su cache solo depende del indice de escena. Debe integrarse en el mismo director de camara y reiniciarse por toma para poder repetir sin reutilizar un encuadre viejo.

### 5. Historias independientes

FinalAmigos esta anadido al final del modulo y el reproductor llama a la ultima escena mediante #C.Escenas. Esto sirve para el parche actual, pero es fragil al incorporar otras historias. Cada historia necesita una lista explicita de escenas y un final propio.

### 6. Organizacion de archivos

Archivar copias antiguas y generadores fallidos fuera de las rutas de trabajo de la plantilla, sin destruirlos. Conservar los respaldos del proyecto recibido. El objetivo son dos puntos de entrada y bibliotecas de datos/funciones; los modulos no deben convertirse en controladores duplicados.

## Expresiones

Los chicos tienen un Decal frontal con textura 20418518, procedente del modelo easxvki. El original de las chicas tiene 4691186503. Son referencias extraidas del archivo, no garantia de disponibilidad en otra experiencia.

La configuracion aplica ENFADADA 2065228834 y la sonrisa clasica rbxasset://textures/face.png. SORPRENDIDA, PENSATIVA, SERIA, PREOCUPADA y LLORANDO siguen sin textura confirmada. Por eso el codigo conserva la cara original para esos estados. No se debe describir el llanto corporal como una cara de llanto ya disponible.

## Ruta de trabajo recomendada

1. Conservar este archivo como referencia y extraer los actores funcionales.
2. Crear una copia organizada con bibliotecas Actores, Caras, Acciones, Camaras e Historias, y un unico Reproductor.
3. Validar una escena equivalente a la actual antes de ampliar nada: mismos chicos, posiciones, gestos y encuadre.
4. Probar en Studio un clip existente de correr y otro de baile en un actor, con el gestor nuevo, verificando carga y movimiento real.
5. Grabar esa misma escena desde tres presets de camara; comprobar el reinicio y una escena aislada.
6. Incorporar el tercer actor y la historia madre/hija/novio.

No se propone otro generador de skins ni introducir IDs de animacion nuevos hasta comprobar los que ya contiene el proyecto.

## Comprobaciones realizadas

- Lectura de todos los bloques del archivo binario y correspondencia con las 119 clases y 1.993 instancias declaradas.
- Extraccion de 23 fuentes de codigo y de la jerarquia completa.
- Validacion estructural de los cuatro rigs: 15 motores, conexiones internas y 16 piezas corporales alcanzables desde la raiz; sin AnimationConstraint.
- Compilacion Luau del servidor activo, la camara activa y la configuracion activa extraidos del archivo.
- Ejecucion de la configuracion como datos y calculo del recorrido actual de 23 segundos.
- Inventario de 81 referencias de animacion y 38 IDs distintos, sin afirmar que se hayan cargado.

No se ha ejecutado Studio, probado la carga de animaciones en la experiencia, renderizado la geometria de Roblox ni verificado permisos de los recursos. Las propiedades binarias no necesarias para esta revision se conservaron en el archivo original y no se reescribieron.
