local C={Version="BODA_CORTES_2",Duracion=14,Preparacion=3,FrenteSeguro=9/16,MarcoVertical=true,SubtitulosGuia=true}
-- Papeles internos compatibles con los rigs y las caras de la biblioteca existente.
C.Roles={"Madre","Hija","Novio","Invitada"}
C.Nombres={Madre="Oficiante",Hija="Novia",Novio="Monkey",Invitada="Invitada"}
C.Posiciones={Madre=Vector3.new(0,0,-2.3),Hija=Vector3.new(-1.75,0,.25),Novio=Vector3.new(1.75,0,.25),Invitada=Vector3.new(0,0,15)}
C.Giros={Madre=0,Hija=25,Novio=-25,Invitada=180}
C.Dormitorio=Vector3.new(-28,0,0)
local function smooth(t) t=math.clamp(t,0,1);return t*t*(3-2*t) end
function C.RaizEn(role,t,height,baseCF,origin)
 local function at(x,y,z,yaw) return origin*CFrame.new(x,y,z)*CFrame.Angles(0,math.pi+math.rad(yaw or 0),0) end
 if role=="Invitada" and t>=4 and t<5.2 then
  local p=C.Posiciones.Invitada:Lerp(Vector3.new(.4,0,2.7),smooth((t-4)/1.2))
  return at(p.X,height+.22+.07*math.abs(math.sin(t*18)),p.Z,180)
 elseif role=="Invitada" and t>=5.2 and t<10.6 then return at(.4,height+.22,2.7)
 elseif role=="Hija" and t>=7.2 and t<10.6 then return at(C.Dormitorio.X,2.36,-1.8)
 elseif role=="Hija" and t>=10.6 then return at(-1.9,t>=12.2 and height-1.0 or height+.22,4.7,t<12.2 and 180 or 0)
 elseif role=="Novio" and t>=10.6 then return at(1.30,height+.22,.65,-65)
 elseif role=="Invitada" and t>=10.6 then return at(.3,height+.22,.65,65) end
 return baseCF
end
local function scene(a,b,voz,text,acciones,caras)
 local s={Inicio=a,Fin=b,Voz=voz,Texto=text,Acciones={},Caras={}}
 for _,r in ipairs(C.Roles) do s.Acciones[r]="ESCUCHAR";s.Caras[r]="NEUTRA" end
 for k,v in pairs(acciones or {}) do s.Acciones[k]=v end
 for k,v in pairs(caras or {}) do s.Caras[k]=v end
 return s
end
C.Escenas={
 scene(0,1.6,"Madre","Puede besar a la novia.",{Madre="CEREMONIA"},{Madre="ALEGRE",Hija="ALEGRE",Novio="VERGUENZA"}),
 scene(1.6,3,"Hija","¿Estás listo, Monkey?",{Hija="ILUSION"},{Hija="ALEGRE",Novio="VERGUENZA"}),
 scene(3,4,"Novio","Listo…",{Novio="NERVIOSO"},{Novio="VERGUENZA",Hija="ALEGRE"}),
 scene(4,5.2,nil,"",{Invitada="CORRER"},{Hija="ALEGRE",Novio="ALEGRE",Invitada="ENFADADA"}),
 scene(5.2,6.5,"Invitada","¡Ey! ¡Yo me opongo!",{Invitada="OPONER",Hija="SUSTO"},{Invitada="ENFADADA",Hija="ALARMA",Madre="ALARMA",Novio="INQUIETA"}),
 scene(6.5,7.2,"Hija","¡Aaah!",{Hija="TAPAR_CARA"},{Hija="ALARMA"}),
 scene(7.2,10.6,"Hija","¡Qué bueno que era solo un sue…!",{Hija="DESPERTAR"},{Hija="INQUIETA"}),
 scene(10.6,12.2,nil,"",{Novio="ABRAZAR",Invitada="ABRAZAR",Hija="SUSTO"},{Novio="ALEGRE",Invitada="ALEGRE",Hija="ALARMA"}),
 scene(12.2,14,"Hija","¡Noooo!",{Hija="LLORAR"},{Hija="ALARMA",Novio="ALEGRE",Invitada="ALEGRE"}),
}
local function shot(a,b,tipo,roles,fov,angle)
 return {Inicio=a,Fin=b,Tipo=tipo,Roles=roles,Fov=fov or 43,Angulo=angle or 0}
end
C.Planos={
 -- La oficiante abre en voz fuera de campo: primero se ve a la novia.
 shot(0,1.6,"MEDIO",{"Hija"},45,-8),
 shot(1.6,3,"CARA",{"Hija"},42,-8),
 shot(3,4,"MEDIO",{"Novio"},43,8),
 shot(4,5.2,"ENTRADA",{"Madre","Hija","Novio","Invitada"},52),
 shot(5.2,6.5,"MEDIO",{"Invitada"},43),
 shot(6.5,7.2,"CARA",{"Hija"},42),
 shot(7.2,8,"CAMA",{"Hija"},47),
 shot(8,10.6,"DESPERTAR",{"Hija"},43),
 shot(10.6,12.2,"REVELACION",{"Hija","Novio","Invitada"},47,-10),
 shot(12.2,14,"LLANTO",{"Hija"},43),
}
function C.EscenaEn(t)
 for i,s in ipairs(C.Escenas) do if t<s.Fin then return s,i end end
 return C.Escenas[#C.Escenas],#C.Escenas
end
function C.PlanoEn(t)
 for i,s in ipairs(C.Planos) do if t<s.Fin then return s,i end end
 return C.Planos[#C.Planos],#C.Planos
end
-- Puntos del plano ajustados a la zona central 9:16, sin recortar caras.
function C.Encuadrar(points,front,aspect,fov,margin,slope)
 local low=Vector3.new(math.huge,math.huge,math.huge);local high=-low
 for _,p in ipairs(points) do low=low:Min(p);high=high:Max(p) end
 local focus=(low+high)/2;local direction=(front+Vector3.yAxis*(slope or .06)).Unit
 local axes=CFrame.lookAt(focus,focus-direction)
 local tv=math.tan(math.rad(fov/2));local th=tv*math.max(.05,math.min(C.FrenteSeguro,aspect))
 local distance=1
 for _,p in ipairs(points) do
  local q=axes:PointToObjectSpace(p)
  distance=math.max(distance,q.Z+math.abs(q.X)*(margin or 1.08)/th,q.Z+math.abs(q.Y)*(margin or 1.08)/tv,q.Z+.8)
 end
 return axes*CFrame.new(0,0,distance),focus
end
-- HR_BODA_ENTRADA_INICIO
-- Encuadre fijo de la carrera completa, desde detras de la invitada.
-- Ajusta la perspectiva de ambos extremos: el altar lejano y la corredora cercana.
function C.EncuadreEntrada(origin,heights,aspect,fov)
 local points={}
 local function box(position,half)
  for _,x in ipairs({-1,1}) do for _,y in ipairs({-1,1}) do for _,z in ipairs({-1,1}) do
   table.insert(points,position+half*Vector3.new(x,y,z))
  end end end
 end
 for _,role in ipairs({"Madre","Hija","Novio"}) do
  local p=C.Posiciones[role];local h=(heights[role] or 3)+2.35
  box(Vector3.new(p.X,h/2+.22,p.Z),Vector3.new(.95,h/2,.7))
 end
 for _,p in ipairs({C.Posiciones.Invitada,Vector3.new(.4,0,2.7)}) do
  local h=(heights.Invitada or 3)+2.6
  box(Vector3.new(p.X,h/2+.22,p.Z),Vector3.new(1.1,h/2,.75))
 end
 box(Vector3.new(0,4.3,-3.1),Vector3.new(5.15,4.3,.5))
 local axes=CFrame.lookAt(Vector3.zero,Vector3.new(0,-.68,-1))
 local tv=math.tan(math.rad(fov/2));local th=tv*math.max(.05,math.min(C.FrenteSeguro,aspect))
 local localPoints={};local nearest=-math.huge
 for _,p in ipairs(points) do local q=axes:PointToObjectSpace(p);table.insert(localPoints,q);nearest=math.max(nearest,q.Z) end
 local function limits(z)
  local xl,xh,yl,yh=-math.huge,math.huge,-math.huge,math.huge
  for _,p in ipairs(localPoints) do
   local depth=z-p.Z
   xl=math.max(xl,p.X-th*depth/1.04);xh=math.min(xh,p.X+th*depth/1.04)
   yl=math.max(yl,p.Y-tv*depth/1.04);yh=math.min(yh,p.Y+tv*depth/1.04)
  end
  return xl,xh,yl,yh
 end
 local low=nearest+.8;local high=low+128
 while true do
  local xl,xh,yl,yh=limits(high)
  if xl<=xh and yl<=yh then break end
  high=nearest+(high-nearest)*2
 end
 for _=1,40 do
  local middle=(low+high)/2;local xl,xh,yl,yh=limits(middle)
  if xl<=xh and yl<=yh then high=middle else low=middle end
 end
 local xl,xh,yl,yh=limits(high)
 local localCamera=axes*CFrame.new((xl+xh)/2,(yl+yh)/2,high)
 local frame=origin*localCamera
 local focus=frame.Position+frame.LookVector*15
 return frame,focus,points
end
-- HR_BODA_ENTRADA_FIN
return C
