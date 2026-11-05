from pathlib import Path
base=Path(__file__).resolve().parent.parent
folder=base/'correccion-caras'
text=(folder/'Instalador.plantilla.luau').read_text()
for key,name in [('__ACTING_SOURCE__','Interpretacion.luau'),('__FACE_CLIENT_SOURCE__','CarasCliente.luau')]:
    source=(base/name).read_text()
    assert ']====]' not in source
    assert text.count(key)==1
    text=text.replace(key,'[====[\n'+source+']====]')
(folder/'PEGAR_CORREGIR_CARAS.txt').write_text(text)
print('Generated face-only fix:',len(text.encode()),'bytes')
