from pathlib import Path
base=Path(__file__).resolve().parent.parent
folder=base/'correccion-caras'
text=(folder/'Visibilidad.plantilla.luau').read_text()
source=(base/'CarasCliente.luau').read_text()
assert ']====]' not in source
assert text.count('__FACE_CLIENT_SOURCE__')==1
text=text.replace('__FACE_CLIENT_SOURCE__','[====[\n'+source+']====]')
(folder/'PEGAR_CORREGIR_VISIBILIDAD.txt').write_text(text)
print('Generated facial visibility patch:',len(text.encode()),'bytes')
