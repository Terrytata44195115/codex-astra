# Ropa real y rig compatible para los chicos — V2

Corrige el bloqueo registrado: el generador anterior produjo AnimationConstraint y el controlador requiere Motor6D. Esta version clona los rigs originales de chicaX y chicaB, que ya funcionaban, y cambia SOLO la apariencia de las copias. No convierte ni sustituye sus articulaciones.

## Instalar

1. Stop en Studio. Las chicas originales deben estar de nuevo en Workspace.
2. Descarga y extrae DESCARGAR_SKINS_CATALOGO_V2.zip.
3. Workspace > Insertar > Importar modelo Roblox > HR_SkinsCatalogoV2.rbxmx.
4. Copia TODO ACTIVAR_SKINS_V2.txt en Comando y pulsa Ejecutar.
5. Espera el mensaje [HR SKINS V2] INSTALADO. Guarda y pulsa F5.

El adaptador SoloChicos previamente instalado utilizara las nuevas plantillas. No se cambian los scripts de animacion, las camaras ni el guion. Las plantillas anteriores se conservan renombradas en ServerStorage.

## Apariencia

Consulta el catalogo real de Roblox desde Studio para obtener camisa/sudadera anime azul-violeta o arcoiris, pantalones streetwear y dos pelos anime de colores diferentes. Los dos chicos comparten ropa para que tenga sentido la acusacion de copiar. Los IDs y nombres reales se imprimen en Salida y se guardan como atributos de las plantillas.

No se inventan IDs. No se compra ningun articulo. Los resultados dependen del catalogo y NO se han revisado visualmente desde este entorno. La ropa es clasica y se adapta a las proporciones de los rigs originales. Las caras conservan el comportamiento existente del guion.

El modelo temporal generado por Roblox solo resuelve los accesorios y texturas. Sus articulaciones no se usan. Las nuevas plantillas se comprueban para mantener los Motor6D de cintura, cuello, hombros, codos, munecas, caderas, rodillas y tobillos. Si falta ropa, pelo, texturas o motores, el proceso informa del error y no sustituye las bases anteriores.

Se comprobaron las firmas de SearchCatalogAsync y CreateHumanoidModelFromDescriptionAsync en el volcado actual de la API de Roblox. Se compilo el codigo con Luau. No se han ejecutado las consultas de catalogo ni el montaje visual dentro de Roblox Studio desde este entorno. Si aparece un error de servicio o de carga, enviarlo completo; no reinstalar el paquete antiguo como solucion.

## Revision V2: texturas no disponibles

La seleccion inicial pudo encontrar articulos con texturas que Roblox no cargo. La V2 recopila hasta seis candidatos por categoria, convierte unicamente los IDs reales de textura recibidos de Roblox al formato rbxassetid, y prueba las prendas individualmente. Si falla una, imprime el motivo y pasa a otra candidata. No elimina la comprobacion de carga ni instala cuerpos sin ropa. El pelo tambien se comprueba con alternativas.

La carpeta y el modulo V2 tienen nombres nuevos para que require no reutilice el modulo V1 guardado en cache. No es necesario borrar los paquetes anteriores.

Se compilo la V2 con Luau y se probaron la conversion de las dos URLs reales del error, el uso de una segunda candidata cuando falla la primera y el error explicito cuando ninguna carga. La disponibilidad real del catalogo se verifica al ejecutarlo en Studio.
