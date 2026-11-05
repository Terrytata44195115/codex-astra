assert(C.Duracion==24)
local allowed={Madre=true,Hija=true,Novio=true}
for _,list in ipairs({C.Escenas,C.Planos}) do
 local time=0
 for _,entry in ipairs(list) do
  assert(entry.Inicio==time and entry.Fin>entry.Inicio,"Gap or overlap in timeline")
  time=entry.Fin
 end
 assert(time==24,"Story must end at 24 seconds")
end
assert(#C.Planos==19)
for i,scene in ipairs(C.Escenas) do
 assert(C.EscenaEn(scene.Inicio)==scene)
 assert(C.EscenaEn(scene.Fin-0.001)==scene)
 for role in pairs(allowed) do
  assert(type(scene.Acciones[role])=="string" and type(scene.Caras[role])=="string")
  assert(allowed[scene.Miradas[role]])
 end
 if scene.Voz then assert(allowed[scene.Voz] and #scene.Texto>0) end
end
for _,shot in ipairs(C.Planos) do
 assert(C.PlanoEn(shot.Inicio)==shot)
 assert(C.PlanoEn(shot.Fin-0.001)==shot)
 for _,role in ipairs(shot.Roles) do assert(allowed[role]) end
 assert(shot.Acercar>=0 and shot.Acercar<0.1)
end
assert(C.EscenaEn(0).Voz=="Hija")
assert(C.EscenaEn(3.5).Acciones.Novio=="CORRER")
assert(C.EscenaEn(5.5).Voz=="Hija")
assert(C.EscenaEn(10).Caras.Madre=="ALARMA")
assert(C.PlanoEn(10).Roles[1]=="Madre")
assert(C.PlanoEn(11.8).Tipo=="CARA")
assert(C.PlanoEn(23.2).Roles[1]=="Novio")
assert(C.Nombres.Novio=="Marcos")
local groupDuration=0
for _,shot in ipairs(C.Planos) do if #shot.Roles==3 then groupDuration+=shot.Fin-shot.Inicio end end
assert(groupDuration<1,"Group shot must be brief")
return "PASS: 24 seconds, contiguous dialogue and 19 shots; Marcos entrance, mother reaction and final cap reaction match requested timing."
