# Ropa real y rig compatible para los chicos

Corrige el bloqueo registrado: el generador anterior produjo AnimationConstraint y el controlador requiere Motor6D. Esta version clona los rigs originales de chicaX y chicaB, que ya funcionaban, y cambia SOLO la apariencia de las copias. No convierte ni sustituye sus articulaciones.

## Instalar

1. Stop en Studio. Las chicas originales deben estar de nuevo en Workspace.
2. Descarga y extrae DESCARGAR_SKINS_CATALOGO.zip.
3. Workspace > Insertar > Importar modelo Roblox > HR_SkinsCatalogo.rbxmx.
4. Copia TODO ACTIVAR_SKINS.txt en Comando y pulsa Ejecutar.
5. Espera el mensaje [HR SKINS] INSTALADO. Guarda y pulsa F5.

El adaptador SoloChicos previamente instalado utilizara las nuevas plantillas. No se cambian los scripts de animacion, las camaras ni el guion. Las plantillas anteriores se conservan renombradas en ServerStorage.

## Apariencia

Consulta el catalogo real de Roblox desde Studio para obtener camisa/sudadera anime azul-violeta o arcoiris, pantalones streetwear y dos pelos anime de colores diferentes. Los dos chicos comparten ropa para que tenga sentido la acusacion de copiar. Los IDs y nombres reales se imprimen en Salida y se guardan como atributos de las plantillas.

No se inventan IDs. No se compra ningun articulo. Los resultados dependen del catalogo y NO se han revisado visualmente desde este entorno. La ropa es clasica y se adapta a las proporciones de los rigs originales. Las caras conservan el comportamiento existente del guion.

El modelo temporal generado por Roblox solo resuelve los accesorios y texturas. Sus articulaciones no se usan. Las nuevas plantillas se comprueban para mantener los Motor6D de cintura, cuello, hombros, codos, munecas, caderas, rodillas y tobillos. Si falta ropa, pelo, texturas o motores, el proceso informa del error y no sustituye las bases anteriores.

Se comprobaron las firmas de SearchCatalogAsync y CreateHumanoidModelFromDescriptionAsync en el volcado actual de la API de Roblox. Se compilo el codigo con Luau. No se han ejecutado las consultas de catalogo ni el montaje visual dentro de Roblox Studio desde este entorno. Si aparece un error de servicio o de carga, enviarlo completo; no reinstalar el paquete antiguo como solucion.
