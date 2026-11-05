# Fase 2: prueba corta de madre, hija y novio

Requiere la fase 1 ya creada y revisada visualmente en la copia `Madre_Hija_Novio.rbxl` de Base_Historias. **Es una prueba de 10 segundos, no la historia completa de 24 segundos.** Las apariencias siguen siendo las provisionales de la fase 1; no incorpora aun la gorra, la mascara, el pantalon de tiro bajo ni las expresiones de susto y palidez.

## Ejecutar

1. Pulsa Stop. Guarda la copia con Ctrl+S.
2. Abre `PEGAR_PRUEBA_TRES_ACTORES.txt` como texto. Ctrl+A y Ctrl+C.
3. Studio > Script > Comando. Dentro de la barra, Ctrl+A, Ctrl+V y Ejecutar.
4. En Salida debe aparecer `[HR PRUEBA] INSTALADA` sin errores posteriores de instalacion.
5. Guarda, cierra pestanas de codigo y pulsa F5. Espera la preparacion de animaciones y la cuenta atras de tres segundos.
6. Observa: entrada del novio, saludo del novio, saludo de la hija y gesto de la madre; cuatro encuadres. El plano final queda fijo. P restaura la camara de jugador; Stop termina la prueba.
7. Envia un clip corto y las lineas `[HR PRUEBA]` / `[HR CAMARA PRUEBA]`. Si funciona, comprueba una segunda vez Stop > F5 antes de ampliar la historia.

## Que comprobar

- Aparecen exactamente los tres actores de revision sin el avatar del jugador ni los originales detras.
- El novio entra orientado hacia su desplazamiento y llega junto al grupo.
- Saluda el novio y despues la hija; la madre mueve la cabeza.
- Se alternan grupo, novio, madre/hija y grupo desde otro angulo.
- Se conserva espacio para recortar el centro a 9:16. La ventana de Studio puede seguir horizontal: el sistema no cambia el formato del archivo de grabacion.
- La Salida indica si se cargaron realmente las pistas. `Pista cargada` confirma que la pista devuelve duracion; el movimiento y su aspecto aun requieren revision visual.

## Compatibilidad de acciones

Se prueban dos referencias reales del archivo original: correr `616140816` y saludar `507770239`. Los permisos y la carga efectiva dependen de Roblox y de la experiencia. Si una pista no carga, la Salida avisa y se usa un gesto procedural de respaldo. **Un respaldo visible no da por validada la animacion de catalogo.**

Las pistas pertenecen a este controlador y solo se detienen al cambiar de accion. No se llama a detener todas las pistas del Animator en cada fotograma. Las poses de respaldo modifican C0; no se reconstruyen articulaciones ni se copian rigs nuevos del catalogo.

La entrada usa desplazamiento guiado por PivotTo sobre el escenario actual. No es busqueda de caminos ni deteccion de obstaculos; no sustituye la validacion de rutas de una historia distinta.

## Conservacion y vuelta al video anterior

El instalador identifica mediante atributos los dos controladores HR_Cine anteriores y guarda su estado Enabled en referencias. Los pausa y activa dos controladores nuevos, con nombres distintos. Sus fuentes permanecen intactas. Las plantillas de personajes tampoco se sustituyen.

Dentro de Play se clonan los tres personajes y se aparca temporalmente la galeria y las dos originales. Stop restaura el estado de edicion. El personaje del jugador y los perros se ocultan solo para esa camara; P restaura su visibilidad.

Para volver al video anterior: Stop, ejecuta en Comando el contenido de `VOLVER_HISTORIA_ANTERIOR.txt`, guarda y F5. Esto restaura los estados anteriores de los controladores y aparca la galeria en ServerStorage para que no salga detras. Para reactivar la prueba, vuelve a ejecutar su instalador; conserva el respaldo inicial y recupera la galeria.

Si se interrumpe una escritura del instalador, intenta revertir las fuentes propias y los estados que haya cambiado. Si un destino no tiene los atributos esperados se detiene; no sobrescribe objetos desconocidos.

## Validacion realizada

- Compilacion Luau de configuracion, servidor, camara, instalador y restaurador.
- Ejecucion del instalador y restaurador en un modelo simulado del arbol de servicios: instalacion, repeticion sin duplicar, restauracion y reactivacion.
- Fallos inyectados en cada una de las tres escrituras de fuente: se conserva el estado inicial de los controladores anteriores y se retiran los objetos nuevos de una primera instalacion.
- Rechazo de un destino ajeno sin modificar sus fuentes.
- Comprobacion de que las fuentes incrustadas en el instalador coinciden con los archivos revisables.

**No se ha ejecutado Roblox Studio aqui.** La carga de las animaciones, el aspecto del saludo en estos cuerpos, los encuadres y la segunda reproduccion quedan pendientes de la prueba del usuario. Las nuevas caras, ropa y accesorios se preparan despues de comprobar el arranque de los tres actores.

## Fuentes

`Configuracion.luau`, `Servidor.luau` y `Camara.luau` son las fuentes incrustadas en el instalador directo. Los scripts de construccion y comprobacion se guardan en `validacion/`; no se pegan en Studio.
