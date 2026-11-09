from pathlib import Path
import json,re
p=Path(__file__).resolve().parent.parent
text=(p/'Instalador.plantilla.luau').read_text()
files={'CONFIG':'Configuracion.luau','DONUT':'Donuts.luau','ARM':'Brazo.luau','SERVER':'Servidor.luau','CAMERA':'Camara.luau'}
for key,name in files.items():
    source=(p/name).read_text()
    assert ']====]' not in source
    text=text.replace('__'+key+'_SOURCE__','[====[\n'+source+']====]')
    text=text.replace('__'+key+'_CODE__',source)
text=text.replace('__PREVIEW_CODE__',(p/'PrepararReparto.luau').read_text())
assert not re.search(r'__[A-Z_]+__',text)
(p/'03_INSTALAR_HISTORIA_DONUTS.txt').write_text(text)
print('Built installer:',len(text.encode()),'bytes')
