local C={
 Version="DONUTS_PICANTES_25S_3",Duracion=25,Preparacion=3,FrenteSeguro=9/16,
 CantidadDonuts=6,RetoPicante=true,Sorpresa={Rol="Hija",Inicio=14.7,Salto=15.0},
 SubtitulosGuia=true,Nombres={Madre="Madre",Hija="Hija"},
 Posiciones={Madre=Vector3.new(-2.4,0,-4.1),Hija=Vector3.new(1.8,0,-4.1)},
 Interacciones={},
}
-- Cinco jump cuts comprimen el tiempo; solo el ultimo necesita mostrar el alcance.
for i=1,5 do
 local t=4.5+(i-1)*.8
 table.insert(C.Interacciones,{Rol="Hija",Donut=string.format("Donut_%02d",i),Montaje=true,
  Inicio=t,Agarre=t+.03,Alzar=t+.10,Boca=t+.18,Morder=t+.25,Retirar=t+.57,Fin=t+.72})
end
table.insert(C.Interacciones,{Rol="Hija",Donut="Donut_06",Inicio=12.5,Agarre=13.2,Alzar=13.55,Boca=14.5,Morder=14.7,Retirar=15.05,Fin=15.30})
local function scene(a,b,voz,text,ma,hi,mf,hf,ml,hl)
 return {Inicio=a,Fin=b,Voz=voz,Texto=text,Acciones={Madre=ma or "ESCUCHAR",Hija=hi or "ESCUCHAR"},
  Caras={Madre=mf or "NEUTRA",Hija=hf or "NEUTRA"},Miradas={Madre=ml or "Hija",Hija=hl or "Madre"}}
end
C.Escenas={
 scene(0,2.5,"Hija","¡A que me como los seis!","ESCUCHAR","ILUSION","INQUIETA","ALEGRE"),
 scene(2.5,4.5,"Madre","El último no lo toques.","SENALAR","ESCUCHAR","NEUTRA","ALEGRE","Donut_06","Madre"),
 scene(4.5,8.5,nil,"","INCOMODA","COMER","INQUIETA","ALEGRE","Hija","Madre"),
 scene(8.5,10.5,"Hija","¡Solo queda uno!","ESCUCHAR","ILUSION","NEUTRA","ALEGRE"),
 scene(10.5,12.5,"Madre","Te he dicho que ese no.","SENALAR","INCOMODA","ENFADADA","INQUIETA","Donut_06","Madre"),
 scene(12.5,14.7,"Hija","¡Pues también me lo como!","ESCUCHAR","COGER","INQUIETA","ALEGRE","Hija","Donut_06"),
 scene(14.7,17,"Hija","¡Mamá, esto pica!","ESCUCHAR","SUSTO","ALEGRE","ALARMA"),
 scene(17,20,"Madre","Ese era el mío. ¡Extra picante!","ILUSION","INCOMODA","ALEGRE","ALARMA"),
 scene(20,22.5,"Hija","¡Agua, agua!","ESCUCHAR","SUSTO","ALEGRE","ALARMA"),
 scene(22.5,25,"Madre","¿Te guardo otro?","ILUSION","NEGAR","ALEGRE","INQUIETA"),
}
local function shot(a,b,kind,fov)
 return {Inicio=a,Fin=b,Roles={"Madre","Hija"},Tipo=kind,Angulo=0,Acercar=0,Fov=fov}
end
C.Planos={
 shot(0,2.5,"GENERAL",70),
 shot(2.5,4.5,"ZOOM",58),
 shot(4.5,5.3,"MONTAJE",58),
 shot(5.3,6.1,"MONTAJE",65),
 shot(6.1,6.9,"MONTAJE",58),
 shot(6.9,7.7,"MONTAJE",65),
 shot(7.7,8.5,"MONTAJE",58),
 shot(8.5,10.5,"ZOOM",58),
 shot(10.5,12.5,"GENERAL",70),
 shot(12.5,14.7,"ZOOM",60),
 shot(14.7,17,"REACCION",70),
 shot(17,20,"ZOOM",58),
 shot(20,22.5,"GENERAL",70),
 shot(22.5,25,"ZOOM",58),
}
function C.EncuadreFrontal(points,front,aspect)
 assert(#points>0,"No hay puntos para el encuadre frontal.")
 local low=Vector3.new(math.huge,math.huge,math.huge);local high=-low
 for _,p in ipairs(points) do low=low:Min(p);high=high:Max(p) end
 local focus=(low+high)/2
 local direction=(front+Vector3.yAxis*.25).Unit
 local axes=CFrame.lookAt(focus,focus-direction)
 local tanV=math.tan(math.rad(58/2))
 local tanH=tanV*math.max(.05,math.min(C.FrenteSeguro,aspect))
 local distance=1
 for _,p in ipairs(points) do
  local q=axes:PointToObjectSpace(p)
  distance=math.max(distance,q.Z+math.abs(q.X)*1.12/tanH,q.Z+math.abs(q.Y)*1.12/tanV,q.Z+.8)
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
