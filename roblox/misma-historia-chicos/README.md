# Misma historia y camara: cambiar solo a chicos

Este paquete conserva la secuencia, los tiempos, el rango de escenas, los modos de grabacion y el codigo de camara actualmente instalado. Anade un arranque que prepara dos chicos antes de comenzar la misma coreografia. No instala el guion alternativo de seis escenas de la carpeta `historia-ropa-chicos`.

## Instalacion

1. **Stop** en Studio.
2. Descarga [HR_SoloChicos.rbxmx](HR_SoloChicos.rbxmx) mediante **Download raw file**.
3. **Workspace > Insertar > Importar modelo Roblox**. Debe aparecer `HR_SoloChicos`.
4. Abre [ACTIVAR_MISMOS_MOVIMIENTOS.txt](ACTIVAR_MISMOS_MOVIMIENTOS.txt), pulsa **Raw**, copia todo, pegalo en **Comando** y pulsa **Ejecutar**.
5. Espera a Roblox: se crean o reutilizan dos bases R15 en `ServerStorage > HR_AvataresRopa`. El activador termina con **[HR CHICOS] INSTALADO**.
6. Guarda con **Ctrl+S**, cierra las pestanas de los scripts y pulsa **F5**.

Para grabar otra toma: **Stop > F5**. No reinstales entre tomas.

## Que conserva

- Codigo actual de movimientos y encuadres; se antepone un adaptador, no se reemplaza la coreografia.
- Posiciones X/Z y nivel de apoyo de los originales. Se ajusta la altura total de los chicos a los cuerpos de referencia.
- Configuracion de tiempos, escenas, pausas y distancias que ya has ajustado. Si estaba activo el generador de la otra version de chicos, solo se desactiva ese generador para evitar actores duplicados.
- Las chicas originales completas: durante Play se guardan en `ServerStorage > HR_OriginalesDurantePlay` y se usan copias de los chicos con los nombres que espera tu controlador. **Stop** restaura la escena de edicion.
- Las referencias de perros se conservan; este adaptador no les anade seguimiento ni cambia su participacion en el guion actual.

El activador respalda los textos originales en `ServerStorage > HR_AntesDeCambiarSkin_...`. No modifica scripts ajenos. Los clips ya grabados y la edicion anterior no se tocan.

## Apariencia

Bases R15 de estilo anime sencillo: pelo geometrico oscuro con mechones, uniforme oscuro y detalles distintos; B lleva gafas. No son skins de catalogo ni se ha inventado ningun ID de ropa/pelo. Si ya se habian creado esas bases con el paquete anterior, se reutilizan.

Las proporciones y la forma de la cabeza pueden introducir diferencias visuales de encuadre o de ajuste de las manos, aunque se conserven los movimientos y la camara. Hay que comprobarlas en Studio. Las expresiones no confirmadas conservan su comportamiento anterior; no se inventan caras nuevas.

## Edicion

[Guion para el editor](GUION_EDITOR.txt): mismo malentendido, voces masculinas, «¡Pues vamos guapisimos!» y respuesta de B sobre usar siempre el mismo conjunto.

Para dar mas energia, los cambios bruscos y acercamientos se realizan en CapCut sobre los planos existentes. El adaptador no cambia movimientos de camara ni duraciones automaticamente.

## Validacion

Se compilaron con Luau el generador, los dos bloques de arranque y el activador. Se compilaron combinados con los controladores V6 y la version Ropa, verificando que el cuerpo de los scripts existentes se conserva. Se comprobo la conservacion de la configuracion clasica y la desactivacion exclusiva del generador duplicado. El XML conserva completos sus textos y no importa Scripts ejecutables.

No se ha ejecutado Roblox Studio en el entorno de preparacion. La generacion de avatares por el servicio de Roblox, el aspecto geometrico, la adaptacion de proporciones, los apoyos y la grabacion se verifican en el proyecto real.
