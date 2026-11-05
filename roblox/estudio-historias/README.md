# Base organizada para historias Roblox

Este directorio conserva el inventario del proyecto revisado y prepara la nueva base por fases. Incluye un preparador de reparto, una prueba corta de tres actores y la version narrativa de Marcos de 24 segundos, pendiente de validacion visual en Studio. **Todavia no contiene un panel terminado.** Los archivos originales y los paquetes anteriores se conservan.

## Objetivo

Un motor fijo de actores, acciones, caras y camaras. Cada video cambia una historia de datos: reparto, dialogos, acciones y tiempos. Se amplian acciones solo cuando una historia necesita un movimiento nuevo.

## Proyecto recibido

Ya se ha inspeccionado Base_Historias.rbxl, la version de chicos con cierre adicional. Consulta la [revision concreta](auditoria-base/REVISION.md). El archivo original permanece sin modificar. No hace falta volver a enviarlo para esta revision.

## Entregas por fases

- [Fase 1: reparto](fase1-reparto/README.md): tres apariencias provisionales sobre los rigs Motor6D del proyecto; el usuario ya ha mostrado la galeria de los tres actores. Gorra, mascara, tiro bajo y disenos definitivos siguen pendientes.
- [Fase 2: prueba corta](fase2-prueba/README.md): entrada, saludo y cuatro encuadres con centro protegido para recorte 9:16. Incluye instalador directo y restaurador del video anterior. Codigo e instalacion comprobados fuera de Studio; reproduccion visual y carga efectiva de las pistas pendientes.

- [Mama conoce a Marcos: 24 segundos](madre-hija-marcos/README.md): nueva apertura ilusionada, entrada corriendo, presentacion y reaccion palida de la madre. Diecinueve planos y gestos por frase. Caras dibujadas y complementos provisionales; conserva la ropa actual y el tiro bajo sigue pendiente. Actualiza los mismos controladores propios de fase 2. Incluye guion y SRT para editar las voces; no incluye audio sintetizado.

## Orden de trabajo

1. Inspeccionar la copia real: scripts actuales, rigs, apariencias, caras, escenario y posibles conflictos. No modificar scripts ajenos ni personajes originales sin identificar su funcion.
2. Extraer una base limpia desde los rigs que ya funcionan. No reinstalar los generadores antiguos. Asignar actores mediante referencias a modelos, no depender de los nombres que trae la Caja de herramientas.
3. Preparar un unico conjunto de componentes y una configuracion. Las bibliotecas no se ejecutan como controladores duplicados.
4. Validar en Studio una escena breve con dos actores: gesto, cambio facial disponible, reaccion, camara y final. Verificar Stop > Play dos veces y la reproduccion aislada de una escena.
5. Validar tres actores y la seleccion de apariencias sin reconstruir las articulaciones. Solo entonces guardar una version de la plantilla para reutilizar.
6. Anadir historias como datos. Cada entrega indica lo comprobado, lo pendiente y la version que requiere.

## Lo que cambia para cada video

- Reparto: referencias a madre, hija, hijo, pareja u otros personajes de la biblioteca.
- Dialogos: frases y pausas; voces y subtitulos siguen siendo parte de la edicion salvo que se desarrolle expresamente otro flujo.
- Acciones: combinaciones de hablar, senalar, negar, pensar, reaccionar, correr o saltar.
- Expresiones: solo perfiles disponibles y comprobados; las pendientes conservan la cara original.
- Camara: seleccion de planos existentes y sus tiempos, con zona segura vertical.

No se cambian por defecto el motor, el esqueleto, los nombres internos de las articulaciones, el escenario ni las caras disponibles. El movimiento nuevo se prepara una vez y se guarda, no se reconstruye en cada historia.

## Regla contra los errores acumulados

Una modificacion de biblioteca o motor se prueba antes de incorporarla a las historias. No encadenar parches sobre una version cuyo arranque no funciona. No confundir compilacion Luau con ejecucion en Studio. No afirmar que un recurso carga por estar listado en el catalogo.

## Archivos

- `biblioteca.json`: inventario de recursos y estados sustentados por el chat. **No equivale a validacion de una plantilla nueva.**
- `historia_ejemplo.json`: borrador de datos para madre, hija y novio. Es una especificacion, no un archivo ejecutable por los controladores actuales.

La duracion objetivo de una historia y las voces se ajustan tras comprobar los clips. El panel de seleccion es un objetivo futuro, no una funcion ya entregada.
