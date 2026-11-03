# Historias Roblox V6

Paquete para actualizar el sistema HR_Cine ya instalado en el proyecto de Roblox Studio.

## Descargar e instalar

1. Abre [HR_EntregaV6.rbxmx](HR_EntregaV6.rbxmx) y pulsa **Download raw file / Descargar archivo sin procesar**. Guarda el archivo con extension `.rbxmx`.
2. Deten el juego con **Stop**.
3. En Studio, importa el archivo mediante **Workspace → Insertar desde archivo…**. Debe aparecer una carpeta `HR_EntregaV6` dentro de Workspace. Los scripts ejecutables del paquete estan desactivados.
4. Abre [ACTIVAR_PAQUETE_V6.txt](ACTIVAR_PAQUETE_V6.txt). Pulsa **Raw** y copia TODO su contenido.
5. Pegalo en el editor **Comando** de Studio y pulsa **Ejecutar**. Este comando guarda los textos anteriores en `ServerStorage > HR_Respaldo_...`, reemplaza los tres controladores propios y conserva las referencias de perros.
6. Espera el mensaje `[HR V6] INSTALADO`. Guarda el proyecto y pulsa **F5**.

El uso de `HttpService:GenerateGUID()` solo crea un identificador local para el respaldo; no realiza solicitudes HTTP. Si Studio pide confirmacion por ese uso, comprueba que has pegado el activador de esta carpeta.

## Primera reproduccion

Escenas 1 a 3 seguidas, durante 15,8 segundos:

- X entra corriendo y llega a hablar con B.
- Plano breve de ambas, gesto acusatorio y primer plano de X.
- B piensa y se defiende; alternan planos de ambas y de cada actriz.
- X cruza brazos y solloza; termina en primer plano.

Deja aproximadamente 6 studs libres detras de X, alejandose de B. El controlador comprueba suelo y obstaculos y detiene la toma si no encuentra recorrido. **P** recupera la camara del jugador durante la revision; **Stop y F5** reinician la prueba.

## Configuracion

En `ReplicatedStorage > HR_Cine > Configuracion`:

- `Modo = "COMPLETA"`: reproduce `DesdeEscena` hasta `HastaEscena`, sin pausas. El rango inicial es 1 a 3.
- `Modo = "ESCENA"`: reproduce solo el numero `Escena`.
- `Modo = "PAUSAS"`: reproduce el rango con cuenta atras de 3 segundos y pausa de 2 segundos por toma.
- `HastaEscena = 8`: incluye toda la historia, de 39,9 segundos. Requiere asignar ambos perros.
- `Camara.Entero`, `Camara.Medio`, `Camara.Cara` y `Camara.Detalle`: distancias independientes. Un valor mayor aleja ese tipo de plano.

Asigna los objetos de perros existentes a `HR_Cine > DobbyX > Value` y `DobbyB > Value`. No se adivinan sus identidades ni se duplican. Salida informa de las articulaciones reconocidas; los modelos sin articulaciones reconocidas solo realizan pequenas inclinaciones del conjunto.

## Limites y validacion

El instalador, los tres scripts y el activador se compilaron con Luau. Se comprobaron duraciones, orden de cortes y tiempo disponible para las carreras. El paquete XML se verifico para conservar completos los tres textos. **No se ejecuto Roblox Studio en el entorno de preparacion.** Hay que revisar las pisadas con IK y el ajuste de las manos en los avatares reales.

Las caras no confirmadas conservan la textura original. FELIZ esta desactivada por el fallo de carga observado. El llanto es corporal; no incluye textura de llanto ni lagrimas confirmadas. Dialogos, ladridos y titulo final se anaden en CapCut. El sistema no modifica scripts ajenos; el error de `Workspace.Part.Script` necesita una revision separada.
