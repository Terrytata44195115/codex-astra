from pathlib import Path
import json
import re

base = Path(__file__).resolve().parent.parent
text = (base / 'Configuracion.luau').read_text()
names = {'Madre': 'Madre', 'Hija': 'Hija', 'Novio': 'Marcos'}
scenes = []
for match in re.finditer(r' scene\(([0-9.]+),([0-9.]+),(nil|"[^"]*"),"([^"]*)",', text):
    start, end = map(float, match.group(1, 2))
    role = None if match[3] == 'nil' else match[3].strip('"')
    scenes.append({'inicio': start, 'fin': end, 'rol': role,
                   'voz': names.get(role), 'texto': match[4],
                   'voz_interior': start == 10})
shots = []
for match in re.finditer(r' shot\(([0-9.]+),([0-9.]+),\{([^}]*)\},"([^"]*)"', text):
    shots.append({'inicio': float(match[1]), 'fin': float(match[2]),
                  'personajes': [names[x] for x in re.findall(r'"(\w+)"', match[3])],
                  'plano': match[4]})
assert len(scenes) == 11 and len(shots) == 19
for entries in (scenes, shots):
    time = 0
    for entry in entries:
        assert entry['inicio'] == time and entry['fin'] > time
        time = entry['fin']
    assert time == 24
data = {'titulo': 'Mamá conoce a Marcos', 'duracion': 24,
        'audio': 'Guia de montaje; no se incluyen voces ni musica sintetizadas.',
        'escenas': scenes, 'planos': shots}
(base / 'GUION_Y_PLANOS.json').write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n')

def stamp(seconds):
    ms = round(seconds * 1000)
    return f'{ms // 3600000:02}:{ms // 60000 % 60:02}:{ms // 1000 % 60:02},{ms % 1000:03}'

subs = []
for scene in scenes:
    if scene['voz']:
        subs.append(f"{len(subs)+1}\n{stamp(scene['inicio'])} --> {stamp(scene['fin'])}\n{scene['texto']}\n")
(base / 'DIALOGOS_MARCOS.srt').write_text('\n'.join(subs))
guide = [
    'MAMA CONOCE A MARCOS — GUIA PARA EL EDITOR',
    'Duracion: 24 segundos desde que termina la cuenta atras.',
    'Formato de entrega final: 1080x1920. El video de Studio puede grabarse horizontal: recortar el centro a 9:16.',
    'No incluir la cuenta atras. Las voces y la musica se montan despues; estos archivos no contienen audio.',
    '',
    'VOCES',
    'Hija: ilusionada al principio, luego avergonzada. Madre: alegre al principio, asustada en el pensamiento y tajante al final. Marcos: educado, algo nervioso.',
    '10-14 s: la frase de la madre es pensamiento en voz en off; puede llevar un eco muy sutil.',
    '',
    'DIALOGOS',
]
for scene in scenes:
    who = scene['voz'] or 'Sin dialogo'
    if scene['voz_interior']:
        who += ' (pensamiento)'
    guide.append(f"{scene['inicio']:g}-{scene['fin']:g} s | {who}: {scene['texto'] or 'Marcos entra corriendo.'}")
guide += ['', 'MONTAJE',
          'Los cortes de camara ya estan en la captura: conservar su orden. Priorizar cortes directos y los pequenos acercamientos existentes.',
          'Musica alegre y suave durante la presentacion. Interrumpirla al aparecer Marcos (3,5 s); puede entrar un golpe comico breve.',
          '10 s: silencio corto o bajada de la base para destacar la palidez y el pensamiento de la madre.',
          '23,2 s: acento comico discreto cuando Marcos se lleva la mano a la gorra. Terminar en 24 s.',
          'Subtitulos: DIALOGOS_MARCOS.srt es una referencia temporal. Si se usan palabras destacadas, dejarlas bajo las caras y sin tapar las manos.',
          'Ajustar las voces a sus intervalos con pausas naturales. No dar por sincronizado el audio hasta revisar el montaje.',
          '', 'PLANOS INCLUIDOS']
for shot in shots:
    guide.append(f"{shot['inicio']:g}-{shot['fin']:g} s | {shot['plano']} | {', '.join(shot['personajes'])}")
(base / 'GUION_EDITOR.txt').write_text('\n'.join(guide) + '\n')
print('Exported 11 scenes, 19 shots and 10 dialogue cues from Configuracion.luau.')
