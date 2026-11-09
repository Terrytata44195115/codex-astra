# Boda con objeción y falso despertar

Escena preparada a partir de `videoplayback (22).mp4`: ceremonia, novio nervioso, llegada de una invitada, «¡Me opongo!», despertar y sorpresa final. El archivo entregado tiene vídeo 720×1280 a 60 fps y dura 9,77 s, **sin pista de audio**. El diálogo se reconstruye de sus subtítulos visibles, con «Puede besar a la novia» como redacción natural. La secuencia preparada dura **14 s y tiene 10 planos**, dejando más tiempo para esas frases. No incluye voces ni sincronización labial.

## Actualizar los planos de una boda ya instalada

Con **Stop**, ejecuta [03_CORREGIR_PLANOS.txt](03_CORREGIR_PLANOS.txt) en **Script → Comando**. Guarda y pulsa **F5**. También puedes ejecutar el paso 2 actualizado: detecta la instalación existente y aplica la misma corrección. Conserva el reparto, el decorado, los controladores de caras y servidor, los tiempos del diálogo y cualquier frase personalizada en `C.Escenas`.

Los planos pasan de la novia al novio y al general lejano, con cortes directos entre cámaras. La oficiante abre hablando fuera de campo. El general está situado detrás y por encima de la invitada y permanece fijo durante toda su carrera: muestra a la chica avanzando y a la pareja frente al arco al fondo. Después corta al frente de la invitada para «¡Me opongo!» y a la reacción de la novia. El encuadre incluye el arco floral completo y ambos extremos de la trayectoria dentro del centro 9:16. El despertar y la revelación final conservan sus tiempos. La actualización respalda la configuración y la cámara en `ServerStorage.HR_BodaAntesCortes`.

## Insertar en Studio

1. Abre el proyecto que tiene madre, hija y novio y las caras que ya funcionan. Pulsa **Stop** si está ejecutándose.
2. **Archivo → Guardar en archivo como…** y guarda una copia llamada `Boda_Historia.rbxl`.
3. Abre [01_PREPARAR_BODA.txt](01_PREPARAR_BODA.txt), copia todo y pégalo en **Script → Comando**, dentro de la barra de comandos. Pulsa **Ejecutar**. No lo pegues en Salida ni en un Script normal.
4. Lleva el ratón a la vista 3D y pulsa **F**, conservando la selección. Verás el altar y la pareja; el suelo enorme queda fuera de la selección para que no aleje el encuadre. Revisa vestido, caras, arco y luz y guarda.
5. Abre [02_ACTIVAR_HISTORIA_BODA.txt](02_ACTIVAR_HISTORIA_BODA.txt) y ejecútalo del mismo modo, todavía con **Stop**.
6. Guarda con **Ctrl+S**, cierra las pestañas de código y pulsa **F5**. Espera los tres segundos de cuenta atrás. **R** repite, **G** muestra u oculta el texto de guía, **P** vuelve al jugador. Termina con **Stop**.

La franja central de 9:16 sirve para preparar la grabación vertical. Roblox Studio no exporta un MP4 1080×1920 mediante estos comandos; se recorta/exporta después la grabación. Las voces y el acabado de edición se añaden después. Los SRT contienen tiempos previstos, todavía no alineados con voces grabadas.

## Qué se instala

- `Workspace.HR_Boda`: césped, tarima, arco de dos perfiles curvos con rosas y hojas, pasillo, doce sillas, jardineras y dormitorio separado para el despertar.
- Cuatro clones de los rigs R15 con Motor6D ya disponibles. Novia de marfil con falda de pliegues, diadema y velo; novio con traje oscuro y pajarita; oficiante con traje ciruela y libro; invitada de amarillo con falda corta y diadema. El vestuario está modelado con geometría nativa sobre los cuerpos existentes; conserva sus cabellos, **no reproduce los avatares de conejo/pollo del ejemplo**.
- `ReplicatedStorage.HR_Boda`: configuración, brazos y canal de reproducción. Se reutiliza el módulo `Interpretacion` existente.
- Controladores `HR_BodaServidor`, `HR_BodaCamara`, `HR_BodaCaras`, `HR_BodaDetalles`. El cliente facial se copia de la versión instalada: solo se adaptan nombres de carpeta, vínculos y lista de cuatro actores. El original conserva su fuente. Las lágrimas se superponen sin sustituir la cara.
- Animación mediante los Motor6D existentes: ceremonia, ilusión, mano junto a la cabeza, carrera, brazo levantado, susto, despertar sentado, abrazo de la nueva pareja y llanto. No requiere descargar animaciones ni accesorios.

## Volver

Con **Stop**, ejecuta [VOLVER_ESCENA_ANTERIOR.txt](VOLVER_ESCENA_ANTERIOR.txt). Restaura los estados de los controladores anteriores y la iluminación guardada y retira los objetos de boda creados por estos instaladores. Las plantillas de personajes y los decorados anteriores permanecen en el proyecto.

## Comprobación pendiente

Se comprueban sintaxis Luau, continuidad del guion, orientación y trayectorias, encuadre 9:16, preparación de cuatro rigs, respaldo/restauración y errores de escritura simulados. **No se ha ejecutado ni renderizado en Roblox Studio desde este entorno.** En la primera toma hay que revisar especialmente la falda, el asiento en la cama, las manos en el abrazo, que el velo no tape la cara y el encuadre de la revelación. Si el cliente facial no coincide con la estructura conocida, el instalador se detiene antes de desactivar la historia anterior.
