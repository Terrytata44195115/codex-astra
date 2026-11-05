local C={
 Version="HISTORIA_MARCOS_24S_1",
 Duracion=24,Preparacion=3,
 SubtitulosGuia=false,
 FrenteSeguro=9/16,
 AccesoriosProvisionales=true,
 Animaciones={Correr="rbxassetid://616140816",Saludar="rbxassetid://507770239"},
 Entrada={Inicio=3.5,Fin=5.5},
 Nombres={Madre="Madre",Hija="Hija",Novio="Marcos"},
}
local function scene(a,b,role,text,actions,faces,looks)
 local s={Inicio=a,Fin=b,Voz=role,Texto=text,Acciones={Madre="ESCUCHAR",Hija="ESCUCHAR",Novio="ESCUCHAR"},Caras={Madre="NEUTRA",Hija="NEUTRA",Novio="NEUTRA"},Miradas={Madre="Novio",Hija="Novio",Novio="Madre"}}
 for k,v in pairs(actions or {}) do s.Acciones[k]=v end
 for k,v in pairs(faces or {}) do s.Caras[k]=v end
 for k,v in pairs(looks or {}) do s.Miradas[k]=v end
 return s
end
C.Escenas={
 scene(0,2,"Hija","¡Mamá, hoy conoces a Marcos!",{Hija="ILUSION",Madre="ILUSION"},{Hija="ALEGRE",Madre="ALEGRE"},{Hija="Madre",Madre="Hija"}),
 scene(2,3.5,"Madre","¡Por fin! ¿Dónde está?",{Madre="ILUSION"},{Hija="ALEGRE",Madre="ALEGRE"},{Hija="Madre",Madre="Hija"}),
 scene(3.5,5.5,nil,"",{Novio="CORRER"},{Hija="ALEGRE",Madre="NEUTRA"}),
 scene(5.5,7.5,"Hija","Mamá, este es Marcos.",{Hija="PRESENTAR"},{Hija="ALEGRE",Madre="INQUIETA"}),
 scene(7.5,10,"Novio","Buenas tardes, señora.",{Novio="SALUDAR"},{Novio="ALEGRE",Madre="INQUIETA",Hija="ALEGRE"}),
 scene(10,14,"Madre","¿Dónde me he metido? ¿Qué me ha traído mi hija?",{Madre="SUSTO",Hija="INCOMODA"},{Madre="ALARMA",Hija="INQUIETA"}),
 scene(14,16,"Hija","Mamá… no empieces.",{Hija="NEGAR",Madre="INCOMODA"},{Madre="INQUIETA",Hija="VERGUENZA"},{Hija="Madre"}),
 scene(16,19,"Madre","Quítate eso… ¡y súbete los pantalones!",{Madre="SENALAR",Hija="TAPAR_CARA"},{Madre="ENFADADA",Hija="VERGUENZA",Novio="INQUIETA"}),
 scene(19,21.5,"Novio","¡Sí, señora! Mi madre dice lo mismo.",{Novio="RESIGNADO",Hija="INCOMODA"},{Madre="ENFADADA",Hija="VERGUENZA",Novio="INQUIETA"}),
 scene(21.5,22.5,"Hija","¡Tierra, trágame!",{Hija="TAPAR_CARA"},{Madre="ENFADADA",Hija="VERGUENZA",Novio="INQUIETA"},{Hija="Madre"}),
 scene(22.5,24,"Madre","¡Y la gorra!",{Madre="SENALAR_GORRA",Novio="MANO_GORRA",Hija="INCOMODA"},{Madre="ENFADADA",Hija="VERGUENZA",Novio="INQUIETA"}),
}
C.Escenas[6].VozInterior=true
local function shot(a,b,roles,kind,angle,push,extra)
 local s={Inicio=a,Fin=b,Roles=roles,Tipo=kind,Angulo=angle or 0,Acercar=push or 0}
 for k,v in pairs(extra or {}) do s[k]=v end
 return s
end
C.Planos={
 shot(0,1.1,{"Madre","Hija"},"MEDIO",0,0.02),
 shot(1.1,2,{"Hija"},"MEDIO",-8,0.03),
 shot(2,3.5,{"Madre"},"MEDIO",8,0.03),
 shot(3.5,4.7,{"Novio"},"ENTERO",-12,0,{Altura=-0.08}),
 shot(4.7,5.5,{"Novio"},"HOMBRO",0,0,{Sobre="Madre",Visibles={"Madre","Novio"}}),
 shot(5.5,6.4,{"Madre","Hija","Novio"},"ENTERO",-10,0),
 shot(6.4,7.5,{"Hija"},"MEDIO",-10,0.02),
 shot(7.5,9.2,{"Novio"},"MEDIO",10,0.03),
 shot(9.2,10,{"Madre"},"CARA",-8,0.02),
 shot(10,11.8,{"Madre"},"MEDIO",5,0.03,{Margen=1.32}),
 shot(11.8,14,{"Madre"},"CARA",-8,0.05),
 shot(14,16,{"Hija"},"CARA",8,0.035),
 shot(16,17.4,{"Madre"},"MEDIO",-5,0.02),
 shot(17.4,18.2,{"Novio"},"PANTALON",0,0),
 shot(18.2,19,{"Hija"},"CARA",-8,0.02),
 shot(19,21.5,{"Novio"},"MEDIO",-10,0.035,{Margen=1.40}),
 shot(21.5,22.5,{"Hija"},"CARA",8,0.04),
 shot(22.5,23.2,{"Madre"},"CARA",-5,0.02),
 shot(23.2,24,{"Novio"},"MEDIO",8,0.02),
}
function C.EscenaEn(t)
 for i,s in ipairs(C.Escenas) do if t<s.Fin then return s,i end end
 return C.Escenas[#C.Escenas],#C.Escenas
end
function C.PlanoEn(t)
 for i,s in ipairs(C.Planos) do if t<s.Fin then return s,i end end
 return C.Planos[#C.Planos],#C.Planos
end
return C
