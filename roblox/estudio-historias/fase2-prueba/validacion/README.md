# Comprobaciones fuera de Studio

No pegar estos archivos en Comando. Requieren Python 3, Node y `luau-web` instalado en un entorno de desarrollo.

Desde este directorio:

```sh
python build.py
node check-installer.mjs
```

Si `luau-web` esta instalado en otra carpeta, se puede proporcionar su entrada mediante `LUAU_WEB_ENTRY` (ruta de modulo o URL file de Node). No se incluyen dependencias ni rutas del entorno de desarrollo en los archivos que se pegan en Studio.

El harness simula el arbol de servicios para comprobar la transaccion del instalador y su restauracion. No simula fisica, permisos de assets, Animator ni renderizado de camaras.
