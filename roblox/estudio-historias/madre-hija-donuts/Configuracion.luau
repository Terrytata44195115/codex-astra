local C={
 Version="DONUTS_SUSURRO_20S_4",Duracion=20,Preparacion=3,FrenteSeguro=9/16,
 CantidadDonuts=6,RetoPicante=true,MarcoVertical=true,
 Sorpresa={Rol="Hija",Inicio=12.5,Salto=12.65},
 Apertura={Fin=2.4,GiroInicio=.55,GiroFin=1.4,Senalar=1.5},
 Saltos={{Inicio=12.65,Fin=13.2,Altura=.50},{Inicio=13.25,Fin=13.75,Altura=.35}},
 MontajeInicio=7.6,
 SubtitulosGuia=true,Nombres={Madre="Madre",Hija="Hija"},
 Posiciones={Madre=Vector3.new(-2.4,0,-4.1),Hija=Vector3.new(1.8,0,-4.1)},
 Interacciones={},
}
for i=1,4 do
 local t=7.6+(i-1)*.7
 table.insert(C.Interacciones,{Rol="Hija",Donut=string.format("Donut_%02d",i),Montaje=true,
  Inicio=t,Agarre=t+.03,Alzar=t+.09,Boca=t+.16,Morder=t+.23,Retirar=t+.52,Fin=t+.64})
end
table.insert(C.Interacciones,{Rol="Hija",Donut="Donut_05",Inicio=10.4,Agarre=11.1,Alzar=11.45,Boca=12.3,Morder=12.5,Retirar=12.85,Fin=13.05})
local function scene(a,b,voz,text,ma,hi,mf,hf,ml,hl)
 return {Inicio=a,Fin=b,Voz=voz,Texto=text,Acciones={Madre=ma or "ESCUCHAR",Hija=hi or "ESCUCHAR"},
  Caras={Madre=mf or "NEUTRA",Hija=hf or "NEUTRA"},Miradas={Madre=ml or "Hija",Hija=hl or "Madre"}}
end
C.Escenas={
 scene(0,2.4,"Hija","¡Mamá, mira esos dónuts!","ILUSION","ILUSION","ALEGRE","ALEGRE","CAMARA","CAMARA"),
 scene(2.4,6.1,"Madre","Hay uno que pica, pero mi hija no lo sabe.","SUSURRAR","ESCUCHAR","ALEGRE","ALEGRE","CAMARA","Donut_05"),
 scene(6.1,7.6,"Hija","¡Me los voy a comer!","ESCUCHAR","ILUSION","ALEGRE","ALEGRE"),
 scene(7.6,10.4,nil,"","INCOMODA","COMER","ALEGRE","ALEGRE","Hija","CAMARA"),
 scene(10.4,12.5,"Hija","¡Qué ricos!","ESCUCHAR","COGER","ALEGRE","ALEGRE","Hija","Donut_05"),
 scene(12.5,13.85,"Hija","¡Mamá, esto pica!","ILUSION","SUSTO","ALEGRE","ENFADADA","Hija","CAMARA"),
 scene(13.85,15.3,nil,"","ESCUCHAR","ENFADO","ALEGRE","ENFADADA","Hija","CAMARA"),
 scene(15.3,17.6,"Madre","¿Te guardo el último?","ILUSION","ENFADO","ALEGRE","ENFADADA","CAMARA","Madre"),
 scene(17.6,20,"Hija","¡Ni loca! ¡Agua!","ILUSION","NEGAR","ALEGRE","ENFADADA","Hija","CAMARA"),
}
local function shot(a,b,kind,fov,roles)
 return {Inicio=a,Fin=b,Roles=roles or {"Madre","Hija"},Tipo=kind,Angulo=0,Acercar=0,Fov=fov}
end
C.Planos={
 shot(0,1.5,"GENERAL",56),
 shot(1.5,2.4,"ZOOM",50),
 shot(2.4,6.1,"SUSURRO",42,{"Madre"}),
 shot(6.1,7.6,"ZOOM",50),
 shot(7.6,8.3,"MONTAJE",50),
 shot(8.3,9,"MONTAJE",54),
 shot(9,9.7,"MONTAJE",50),
 shot(9.7,10.4,"MONTAJE",54),
 shot(10.4,12.5,"ZOOM",50),
 shot(12.5,13.85,"REACCION",46,{"Hija"}),
 shot(13.85,15.3,"CARA",42,{"Hija"}),
 shot(15.3,17.6,"CARA",42,{"Madre"}),
 shot(17.6,19,"CARA",42,{"Hija"}),
 shot(19,20,"ZOOM",50),
}
function C.EncuadreFrontal(points,front,aspect,fov,margin,slope)
 assert(#points>0,"No hay puntos para el encuadre frontal.")
 local low=Vector3.new(math.huge,math.huge,math.huge);local high=-low
 for _,p in ipairs(points) do low=low:Min(p);high=high:Max(p) end
 local focus=(low+high)/2
 local direction=(front+Vector3.yAxis*(slope or .20)).Unit
 local axes=CFrame.lookAt(focus,focus-direction)
 local tanV=math.tan(math.rad((fov or 50)/2))
 local tanH=tanV*math.max(.05,math.min(C.FrenteSeguro,aspect))
 local distance=1;margin=margin or 1.03
 for _,p in ipairs(points) do
  local q=axes:PointToObjectSpace(p)
  distance=math.max(distance,q.Z+math.abs(q.X)*margin/tanH,q.Z+math.abs(q.Y)*margin/tanV,q.Z+.8)
 end
 return axes*CFrame.new(0,0,distance),focus
end
function C.EscenaEn(t)
 for i,s in ipairs(C.Escenas) do if t<s.Fin then return s,i end end
 return C.Escenas[#C.Escenas],#C.Escenas
end
function C.PlanoEn(t)
 for i,s in ipairs(C.Planos) do if t<s.Fin then return s,i end end
 return C.Planos[#C.Planos],#C.Planos
end
return C
