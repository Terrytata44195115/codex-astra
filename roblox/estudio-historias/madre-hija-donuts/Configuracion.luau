local C={
 Version="DONUTS_23S_1",Duracion=23,Preparacion=3,FrenteSeguro=9/16,
 SubtitulosGuia=true,Nombres={Madre="Madre",Hija="Hija"},
 Posiciones={Madre=Vector3.new(-2.4,0,-4.1),Hija=Vector3.new(1.8,0,-4.1)},
 Interacciones={
  {Rol="Hija",Donut="Donut_04",Inicio=4.6,Agarre=5.4,Alzar=5.7,Boca=6.35,Morder=6.5,Retirar=7.2,Fin=7.8},
  {Rol="Madre",Donut="Donut_02",Inicio=10.4,Agarre=11.25,Alzar=11.8,Boca=14.7,Morder=15,Retirar=15.35,Fin=15.65},
 },
}
local function scene(a,b,voz,text,ma,hi,mf,hf,ml,hl)
 return {Inicio=a,Fin=b,Voz=voz,Texto=text,Acciones={Madre=ma or "ESCUCHAR",Hija=hi or "ESCUCHAR"},
  Caras={Madre=mf or "NEUTRA",Hija=hf or "NEUTRA"},Miradas={Madre=ml or "Hija",Hija=hl or "Madre"}}
end
C.Escenas={
 scene(0,3,"Madre","Uno de estos dónuts tiene una sorpresa.","SENALAR","ILUSION","ALEGRE","ALEGRE","Donut_02","Madre"),
 scene(3,4.6,"Hija","¡Empiezo yo!","ESCUCHAR","ILUSION","ALEGRE","ALEGRE"),
 scene(4.6,6.35,nil,"","ESCUCHAR","COGER","INQUIETA","ALEGRE","Hija","Donut_04"),
 scene(6.35,8.1,"Hija","Mmm… ¡buenísimo!","ESCUCHAR","COMER","ALEGRE","ALEGRE","Hija","Madre"),
 scene(8.1,10.4,"Madre","Ahora me toca a mí.","SENALAR","ESCUCHAR","ALEGRE","INQUIETA","Donut_02","Madre"),
 scene(10.4,13.5,"Madre","A ver… este.","COGER","INCOMODA","INQUIETA","INQUIETA","Donut_02","Madre"),
 scene(13.5,15,"Hija","Ese no…","COMER","INCOMODA","INQUIETA","INQUIETA","Donut_02","Madre"),
 scene(15,17,"Madre","¡¿Pero qué es esto?!","SUSTO","ILUSION","ALARMA","ALEGRE"),
 scene(17,20,"Hija","¡Ese era el de la sorpresa!","INCOMODA","ILUSION","ENFADADA","ALEGRE"),
 scene(20,22,"Madre","Ahora eliges tú dos.","SENALAR","ESCUCHAR","ENFADADA","INQUIETA"),
 scene(22,23,"Hija","¿¡Dos!?","ESCUCHAR","SUSTO","ALEGRE","ALARMA"),
}
local function shot(a,b,roles,kind,angle,extra)
 local s={Inicio=a,Fin=b,Roles=roles,Tipo=kind,Angulo=angle or 0,Acercar=0.035}
 for k,v in pairs(extra or {}) do s[k]=v end
 return s
end
C.Planos={
 shot(0,1,{"Madre","Hija"},"MESA",0),
 shot(1,2.1,{"Madre"},"MEDIO",-7),
 shot(2.1,3,{"Madre","Hija"},"MEDIO",0),
 shot(3,4.6,{"Hija"},"MEDIO",7),
 shot(4.6,5.4,{"Hija"},"DETALLE",-12,{Donut="Donut_04"}),
 shot(5.4,6.35,{"Hija"},"MEDIO",8),
 shot(6.35,7.4,{"Hija"},"CARA",-5),
 shot(7.4,8.1,{"Madre"},"MEDIO",-6),
 shot(8.1,9.2,{"Madre"},"MEDIO",6),
 shot(9.2,10.4,{},"DONUT",-5,{Donut="Donut_02"}),
 shot(10.4,11.5,{"Madre"},"DETALLE",10,{Donut="Donut_02"}),
 shot(11.5,12.7,{"Madre"},"MEDIO",-7),
 shot(12.7,13.5,{"Hija"},"CARA",6),
 shot(13.5,14.4,{"Hija"},"CARA",-5,{Acercar=0.06}),
 shot(14.4,15.1,{"Madre"},"MEDIO",8),
 shot(15.1,16.2,{"Madre"},"MEDIO",-6,{Margen=1.34}),
 shot(16.2,17,{"Madre"},"CARA",5),
 shot(17,18.5,{"Hija"},"MEDIO",-8),
 shot(18.5,20,{"Hija"},"CARA",7),
 shot(20,21.2,{"Madre"},"MEDIO",-7),
 shot(21.2,22,{"Madre"},"CARA",6),
 shot(22,23,{"Hija"},"CARA",-5),
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
