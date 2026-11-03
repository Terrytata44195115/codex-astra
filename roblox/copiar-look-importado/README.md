# Aplicar la apariencia del modelo elegido, conservando el rig que funciona

Para el modelo de chico seleccionado por la usuaria (easxvki, camisa azul y pantalon rojo/turquesa).

1. Stop en Studio. Las chicas originales deben reaparecer en Workspace.
2. Selecciona en Explorer el MODEL COMPLETO del chico importado, no su camisa ni su Humanoid.
3. Abre APLICAR_MODELO_SELECCIONADO.txt en GitHub > Raw, copia todo y ejecutalo en Comando.
4. Debe terminar con [HR LOOK] INSTALADO.
5. Guarda y pulsa F5. El adaptador SoloChicos ya instalado usa las nuevas plantillas.

El comando crea las dos plantillas a partir de los rigs de las chicas originales, valida sus Motor6D antes y despues, y copia Shirt, Pants, cara (si ambas tienen Decal), pelo y accesorios del modelo importado. Para distinguirlos, X omite el accesorio llamado Nerd Glasses y B lo conserva. Ambos llevan el mismo conjunto, coherente con el guion.

No usa el catalogo ni inventa IDs; copia las referencias de los elementos reales insertados. No se afirma que nuevas texturas sean accesibles hasta probarlas en la experiencia. Si el modelo ya se ve vestido en Studio, esa es la referencia visual que se intenta conservar.

Health, Animate, SprintScript y Sound del modelo de origen no se copian. Los scripts heredados en las plantillas se desactivan. Los scripts incluidos en accesorios copiados se eliminan solo de las copias nuevas. El modelo importado completo se guarda en ServerStorage al terminar para que no aparezca como tercer actor ni ejecute scripts dentro de Workspace. Las chicas originales permanecen intactas. Las plantillas anteriores se conservan renombradas.

Se admite Accessory y Hat antiguo; se conservan las uniones internas de cada accesorio. Si AddAccessory no crea la union al Head, se conserva el desplazamiento de la cabeza del modelo de origen como alternativa. Las proporciones de cabeza pueden exigir ajustar el pelo o las gafas al probarlo.

El comando se compilo con Luau; no se ha ejecutado Roblox Studio en este entorno. La comprobacion final es visual y de movimiento en la experiencia. No cambia los scripts de coreografia, los tiempos ni la camara.
