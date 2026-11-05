from pathlib import Path

base = Path(__file__).resolve().parent.parent
text = (base / 'Instalador.plantilla.luau').read_text()
for token, filename in [
    ('__CONFIG_SOURCE__', 'Configuracion.luau'),
    ('__SERVER_SOURCE__', 'Servidor.luau'),
    ('__CAMERA_SOURCE__', 'Camara.luau'),
]:
    source = (base / filename).read_text()
    assert ']====]' not in source
    assert text.count(token) == 1
    text = text.replace(token, '[====[\n' + source + ']====]')
assert '__CONFIG_SOURCE__' not in text
(base / 'PEGAR_PRUEBA_TRES_ACTORES.txt').write_text(text)
print('Generated direct installer:', len(text.encode()), 'bytes')
