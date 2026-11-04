# Fase 1: reparto de madre, hija y novio

**Solo prepara personajes y referencias. No instala aun la historia ni reproduce las animaciones.** El guion propuesto dura 24 segundos. Se trabaja sobre el proyecto Base_Historias revisado, con las originales en Workspace y las plantillas de chicos en ServerStorage.

## Instalar esta fase

1. Stop en Studio.
2. Descarga y extrae DESCARGAR_FASE1_REPARTO.zip.
3. Workspace > Insertar > Importar modelo Roblox > HR_Fase1Reparto.rbxmx.
4. Copia ACTIVAR_FASE1.txt en Comando y pulsa Ejecutar. Espera las consultas opcionales de accesorios.
5. Debe aparecer [HR REPARTO] FASE 1 LISTA.
6. La previsualizacion queda seleccionada. Pulsa **F, solo F**, para encuadrarla. **No F5 ni Play en esta fase.** Envia una captura de los tres actores y las ultimas lineas [HR REPARTO].

## Que hace

- Valida las articulaciones del proyecto: R15, Motor6D no ambiguos, conexiones esperadas y ausencia de AnimationConstraint.
- Clona chicaB para Madre, chicaX para Hija y la plantilla chicoX para Novio. Las originales permanecen intactas.
- Prepara una madre provisional con las gafas ya disponibles y el pelo mas oscuro; la hija conserva su apariencia rubia. El novio reutiliza el conjunto de colores que ya funciona.
- Busca gorra negra y mascara facial en el catalogo real de Roblox. Solo usa los IDs devueltos por el servicio. El rig temporal del servicio se usa exclusivamente para extraer accesorios: sus articulaciones no se copian.
- Si los accesorios no pueden resolverse, el reparto se conserva y se indican pendientes. Un accesorio unido no equivale a comprobacion visual de su textura o ajuste; la previsualizacion sirve para esa revision.
- Marca el pantalon de tiro bajo como pendiente: no promete que el pantalon actual ya tenga ese corte.
- Desactiva scripts heredados en copias y elimina scripts de accesorios nuevos. No modifica scripts ajenos ni la coreografia anterior.

Los personajes quedan en `ServerStorage > HR_EstudioReparto > Personajes`. `Reparto > Madre / Hija / Novio` son ObjectValue que apuntan a esas plantillas; asi se pueden cambiar apariencias sin depender del nombre original del modelo de catalogo.

La galeria visible queda en `Workspace > HR_RevisionReparto`. Sus etiquetas son solo para revisar; no se incluyen en las plantillas. La fase del reproductor debera retirar u ocultar la galeria al grabar.

Repetir el activador conserva los personajes ya preparados y no los duplica ni sobrescribe una personalizacion. Para cambiar accesorios o regenerar un reparto incompleto hay que revisar el estado, no borrar carpetas a ciegas.

## Proximas fases

2. Escena de comprobacion con los tres actores: un gesto, una pista de caminar/saludar y un corte de camara. Verificar carga real de las animaciones ya encontradas antes de ampliar la biblioteca.
3. Preparar susto, vergüenza/palidez, mano a la cara y gesto hacia la gorra, con expresiones disponibles o estados pendientes claramente indicados.
4. Montar el guion completo de 24 segundos con plano de grupo, individuales, reacciones y sobre hombro.
5. Probar una escena aislada, la secuencia completa y Stop > Play dos veces. Solo entonces dar la version por preparada para grabar.

No se ha probado esta fase dentro de Roblox Studio en el entorno del asistente. Se compilo el modulo y el activador con Luau, se validaron los rigs de origen con sus conexiones extraidas del proyecto, se comprobo el rechazo de AnimationConstraint y se verifico que la secuencia propuesta suma exactamente 24 segundos. El XML conserva la fuente completa y no incluye scripts de arranque automatico.
