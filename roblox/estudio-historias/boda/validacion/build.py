from pathlib import Path
import json,re
p=Path(__file__).resolve().parent.parent
sources={
 'CONFIG':p/'Configuracion.luau','PREVIEW':p.parent/'madre-hija-donuts/PrepararReparto.luau',
 'CLOTHES':p/'Vestuario.luau','SCENE':p/'Escena.luau',
 'ARM':p.parent/'madre-hija-donuts/Brazo.luau','SERVER':p/'Servidor.luau',
 'CAMERA':p/'Camara.luau','DETAILS':p/'DetallesCliente.luau',
}
def render(text):
 config=(p/'Configuracion.luau').read_text()
 plans=config[config.index('C.Planos={'):config.index('\nfunction C.EscenaEn')]
 entry=config[config.index('-- HR_BODA_ENTRADA_INICIO'):config.index('-- HR_BODA_ENTRADA_FIN')+len('-- HR_BODA_ENTRADA_FIN')]
 for key,source in [('PLANS',plans),('ENTRY',entry)]:
  text=text.replace('__'+key+'_SOURCE__','[====[\n'+source+']====]')
 for key,path in sources.items():
  source=path.read_text();assert ']====]' not in source
  text=text.replace('__'+key+'_CODE__',source).replace('__'+key+'_SOURCE__','[====[\n'+source+']====]')
 assert not re.search(r'__[A-Z_]+__',text)
 return text
cuts=render((p/'Cortes.plantilla.luau').read_text())
(p/'03_CORREGIR_PLANOS.txt').write_text(cuts)
for template,out in [('Preparar.plantilla.luau','01_PREPARAR_BODA.txt'),('Activar.plantilla.luau','02_ACTIVAR_HISTORIA_BODA.txt')]:
 text=render((p/template).read_text().replace('__CUTS_CODE__',cuts))
 (p/out).write_text(text)
 print(out,len(text.encode()),'bytes')
source=(p/'Configuracion.luau').read_text()
scenes=[]
for m in re.finditer(r'scene\(([\d.]+),([\d.]+),(nil|"[^"]*"),"([^"]*)"',source):
 scenes.append(dict(inicio=float(m[1]),fin=float(m[2]),voz=None if m[3]=='nil' else m[3][1:-1],texto=m[4]))
assert len(scenes)==9 and scenes[-1]['fin']==14
shots=[dict(inicio=float(m[1]),fin=float(m[2]),tipo=m[3],roles=re.findall(r'"([^"]+)"',m[4])) for m in re.finditer(r'shot\(([\d.]+),([\d.]+),"([^"]+)",\{([^}]+)\}',source)]
(p/'GUION.json').write_text(json.dumps({'duracion':14,'planos':len(shots),'version':'BODA_CORTES_2','fuente':'Subtitulos visibles del MP4 sin audio; no es una transcripcion de voz.','escenas':scenes,'camaras':shots},ensure_ascii=False,indent=2)+'\n')
def stamp(t):
 n=round(t*1000);return f'{n//3600000:02}:{n//60000%60:02}:{n//1000%60:02},{n%1000:03}'
spoken=[s for s in scenes if s['voz']]
(p/'DIALOGOS_GUIA.srt').write_text('\n'.join(f"{i}\n{stamp(s['inicio'])} --> {stamp(s['fin'])}\n{s['texto']}\n" for i,s in enumerate(spoken,1)))
for role,label in [('Madre','OFICIANTE'),('Hija','NOVIA'),('Novio','NOVIO'),('Invitada','INVITADA')]:
 (p/f'VOZ_{label}.txt').write_text('\n\n'.join(s['texto'] for s in spoken if s['voz']==role)+'\n')
