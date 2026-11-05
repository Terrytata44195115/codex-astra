# Comprobaciones fuera de Studio

No pegar estos archivos en Comando. Requieren Python 3, Node y `luau-web` instalado en un entorno de desarrollo.

Desde este directorio:

```sh
python build.py
python build-face-fix.py
python exportar_guion.py
node check-installer.mjs
node check-face-fix.mjs
```

Si `luau-web` esta instalado en otra carpeta, se puede proporcionar su entrada mediante `LUAU_WEB_ENTRY` (ruta de modulo o URL file de Node).

El harness simula el arbol de servicios para comprobar instalacion, actualizacion, repeticion y restauracion, incluidos fallos en las cinco escrituras del instalador completo y las dos del parche facial. No simula fisica, permisos de assets, Animator, EditableImage ni renderizado de camaras.

Los controles de tiempos ejecutan la configuracion Luau real y comprueban continuidad, limite de 24 segundos, personajes y cambios clave de la historia. El exportador genera el guion del editor, el SRT y el JSON de escenas/planos desde las entradas de esa misma configuracion.

`render-faces.mjs <carpeta_temporal>` exporta doce buffers RGBA de 256x256 generados por el rasterizador Luau real, para inspeccion 2D. No ejecuta Studio ni demuestra el mapeado final de los Decal.
