local C={}
C.Version="ROPA_CHICOS_1"
C.Personajes={X="chicoX",B="chicoB"}
C.CrearAvatares=true
C.UsarPerros=false
C.OcultarOriginales=true
C.OcultarDurantePlay={"perroX","perroB"} -- Objetos del primer decorado, sin asignar duenos.
C.Modo="COMPLETA"
C.Escena=1
C.DesdeEscena=1
C.HastaEscena=6
C.Preparacion=3
C.Pausa=2
C.DistanciaEntrada=6
C.VelocidadCarrera=4.8
C.DuracionPaso=0.42
C.AlturaPaso=0.5
C.DistanciaCarrera=8
-- Todos los planos son abiertos para hacer el zoom despues en CapCut.
-- AspectoObjetivo protege el recorte central vertical, incluso en ventana horizontal.
C.Camara={ParaEditar=true,AspectoObjetivo=9/16,Entero=1.08,Medio=1.1,Cara=1.1,Detalle=1.1}
C.Expresiones={
 ENFADADA={Confirmada=true,Textura="rbxassetid://2065228834"},
 FELIZ={Confirmada=false,Textura="rbxassetid://4691186503"},
 SORPRENDIDA={Confirmada=false,Referencia="1149190774"},
 PENSATIVA={Confirmada=false,Referencia="1111927273"},
 SERIA={Confirmada=false,Referencia="8855105242"},
 PREOCUPADA={Confirmada=false,Referencia="12087064682"},
 LLORANDO={Confirmada=false},
}
C.Escenas={
 {
  Duracion=6.5,Entrada=2,Accion="ACUSAR",X="ENFADADA",B="SORPRENDIDA",
  Dialogo="X llega. Desde segundo 2: ¡ME HAS COPIADO LA ROPA!",
  Cortes={{0,"ENTRADA",45},{2,"AMBAS",46},{2.9,"X_MEDIO",44},{4.5,"B_MEDIO",44}},
 },
 {
  Duracion=4.8,Accion="DEFENDER",X="ENFADADA",B="PENSATIVA",
  Dialogo="B piensa. Desde segundo 0,85: ¡NOOO! ¡YO NO TE HE COPIADO!",
  Cortes={{0,"B_MEDIO",44},{1.4,"AMBAS",46},{2.6,"X_MEDIO",44},{3.5,"B_MEDIO",44}},
 },
 {
  Duracion=5,Accion="LLORAR",X="ENFADADA",B="PENSATIVA",
  Dialogo="X: ¡PERO SI LO HABLAMOS AYER! Luego B se queda pensando.",
  Cortes={{0,"X_MEDIO",44},{1.8,"B_MEDIO",44},{3.5,"X_MEDIO",44}},
 },
 {
  Duracion=4.6,Accion="RECORDAR",X="LLORANDO",B="PENSATIVA",
  Dialogo="B piensa en silencio. Desde segundo 1,6: ESPERA... ¿AYER?",
  Cortes={{0,"B_MEDIO",44},{2.5,"AMBAS",46},{3.4,"B_MEDIO",44}},
 },
 {
  Duracion=6,Accion="TRAICION",X="LLORANDO",B="PREOCUPADA",
  Dialogo="X: YO PENSE QUE ERAMOS AMIGOS... UN AMIGO NO ME HACE ESTO.",
  Cortes={{0,"X_MEDIO",44},{2.2,"AMBAS",46},{3.5,"B_MEDIO",44},{4.5,"X_MEDIO",44}},
 },
 {
  Duracion=5,Accion="FINAL_ROPA",X="ENFADADA",B="SORPRENDIDA",
  Dialogo="X: ¡ES LA MISMA ROPA! ¡TE LO CONTE AYER! Reaccion de B y X decepcionado.",
  Cortes={{0,"X_MEDIO",44},{1.2,"B_MEDIO",44},{2.9,"AMBAS",46},{3.7,"X_MEDIO",44}},
 },
}
return C
