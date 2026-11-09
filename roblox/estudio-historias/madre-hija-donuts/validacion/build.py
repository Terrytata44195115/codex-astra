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
patch=(p/'CorreccionFrontal.plantilla.luau').read_text()
for key,name in files.items():
    patch=patch.replace('__'+key+'_SOURCE__','[====[\n'+(p/name).read_text()+']====]')
    patch=patch.replace('__'+key+'_CODE__',(p/name).read_text())
patch=patch.replace('__TABLE_CODE__',(p/'AjustarMesa.luau').read_text())
patch=patch.replace('__ASPECT_CODE__',(p/'Aspecto.luau').read_text())
patch=patch.replace('__PREVIEW_CODE__',(p/'PrepararReparto.luau').read_text())
assert not re.search(r'__[A-Z_]+__',patch)
(p/'04_RETO_6_DONUTS.txt').write_text(patch)
(p/'05_SUSURRO_PICANTE_Y_LUZ.txt').write_text(patch)
print('Built frontal correction:',len(patch.encode()),'bytes')
source=(p/'Configuracion.luau').read_text()
section=source[source.index('C.Escenas={'):source.index('\nlocal function shot')]
scenes=[]
for match in re.finditer(r'scene\(([\d.]+),([\d.]+),(nil|"[^"]*"),"([^"]*)"',section):
    scenes.append({'inicio':float(match[1]),'fin':float(match[2]),'voz':None if match[3]=='nil' else match[3][1:-1],'texto':match[4]})
assert len(scenes)==9 and scenes[-1]['fin']==20
(p/'GUION_DONUTS.json').write_text(json.dumps({'duracion':20,'donuts':6,'picante':5,'escenas':scenes},ensure_ascii=False,indent=2))
spoken=[s for s in scenes if s['voz']]
def stamp(t):
    n=round(t*1000);return f'{n//3600000:02}:{n//60000%60:02}:{n//1000%60:02},{n%1000:03}'
(p/'DIALOGOS_REFERENCIA.srt').write_text('\n'.join(f"{i}\n{stamp(s['inicio'])} --> {stamp(s['fin'])}\n{s['texto']}\n" for i,s in enumerate(spoken,1)))
for role in ['Madre','Hija']:
    (p/('VOZ_'+role.upper()+'.txt')).write_text('\n\n'.join(s['texto'] for s in spoken if s['voz']==role)+'\n')
