-- PASO 2. Ejecutar completo con Stop, tras revisar el decorado del paso 1.
assert(not game:GetService("RunService"):IsRunning(),"Primero pulsa Stop.")
local Storage=game:GetService("ServerStorage")
local RS=game:GetService("ReplicatedStorage")
local SSS=game:GetService("ServerScriptService")
local SPS=game:GetService("StarterPlayer").StarterPlayerScripts
local editor=game:GetService("ScriptEditorService")
local OWNER="HR_BODA_1"
local decor=workspace:FindFirstChild("HR_Boda")
assert(decor and decor:GetAttribute("HR_Owner")==OWNER and decor:FindFirstChild("Reparto"),"Ejecuta primero 01_PREPARAR_BODA.")
local oldRoot=RS:FindFirstChild("HR_PruebaReparto")
assert(oldRoot and oldRoot:GetAttribute("HR_Owner")=="HR_PRUEBA_REPARTO_1" and oldRoot:FindFirstChild("Interpretacion"),"Falta la biblioteca de poses que ya funcionaba.")
local face=SPS:FindFirstChild("HR_CarasMarcos")
assert(face and face:IsA("LocalScript") and face:GetAttribute("HR_Owner")=="HR_PRUEBA_REPARTO_1","No se reconoce el cliente facial de la historia anterior.")
local oldFace=editor:GetEditorSource(face)
assert(oldFace:find('HR_ExpresionVisible',1,true) and oldFace:find('HR_SoportesCaraLocales',1,true),"La version facial es distinta. Se conserva: comparte su codigo antes de activar la boda.")
local newFace,n=oldFace:gsub('ipairs%(%s*{%s*"Madre"%s*,%s*"Hija"%s*,%s*"Novio"%s*}%s*%)','ipairs({"Madre","Hija","Novio","Invitada"})')
if n==0 then newFace,n=oldFace:gsub('ipairs%(%s*{%s*"Madre"%s*,%s*"Hija"%s*}%s*%)','ipairs({"Madre","Hija","Novio","Invitada"})') end
assert(n==1,"No se ha encontrado una unica lista de actores en las caras. Se conserva el sistema anterior.")
for before,after in pairs({HR_PruebaReparto="HR_Boda",HR_PruebaActores="HR_BodaActores",HR_SoportesCaraLocales="HR_CarasBodaLocales",HR_CarasMarcos_Visual="HR_CarasBoda_Visual",HR_PRUEBA_REPARTO_1=OWNER}) do newFace=newFace:gsub(before,after) end
local check=(function()
__PREVIEW_CODE__
end)()
for _,role in ipairs({"Madre","Hija","Novio","Invitada"}) do check.Verificar(decor.Reparto:FindFirstChild(role)) end
local existing=RS:FindFirstChild("HR_Boda")
if existing then
 assert(existing:GetAttribute("HR_Owner")==OWNER,"Existe otra configuracion con este nombre.")
 for _,where in ipairs({{SSS,"HR_BodaServidor"},{SPS,"HR_BodaCamara"},{SPS,"HR_BodaCaras"},{SPS,"HR_BodaDetalles"}}) do
  local script=where[1]:FindFirstChild(where[2])
  assert(script and script:GetAttribute("HR_Owner")==OWNER and script.Enabled,"La instalacion existente esta incompleta; conserva el estado y comparte Salida.")
 end
 print("[HR BODA] Historia ya instalada. No se han creado copias. Guarda y pulsa F5.")
 return
end
assert(not Storage:FindFirstChild("HR_BodaAntesHistoria"),"Existe un respaldo anterior de boda. Usa VOLVER_ESCENA_ANTERIOR antes de reinstalar.")
local previous={}
for _,candidate in ipairs({{SSS,"HR_PruebaRepartoServidor"},{SPS,"HR_PruebaRepartoCamara"},{SPS,"HR_CarasMarcos"},{SSS,"HR_CineServidor"},{SPS,"HR_CineCamara"}}) do
 local script=candidate[1]:FindFirstChild(candidate[2])
 if script then
  assert(script:IsA("BaseScript") and (script:GetAttribute("HR_Owner")=="HR_PRUEBA_REPARTO_1" or script:GetAttribute("HR_Owner")=="HR_Cine_V2"),"Controlador no reconocido: "..script.Name)
  table.insert(previous,{object=script,enabled=script.Enabled})
 end
end
local staging=Instance.new("Folder");local created={};local backup
local ok,err=pcall(function()
 local root=Instance.new("Folder");root.Name="HR_Boda";root:SetAttribute("HR_Owner",OWNER);root:SetAttribute("Version","BODA_1");root.Parent=staging
 local remote=Instance.new("RemoteEvent");remote.Name="Canal";remote.Parent=root
 local definitions={
  {parent=root,name="Configuracion",class="ModuleScript",source=__CONFIG_SOURCE__},
  {parent=root,name="Brazos",class="ModuleScript",source=__ARM_SOURCE__},
  {parent=SSS,name="HR_BodaServidor",class="Script",source=__SERVER_SOURCE__},
  {parent=SPS,name="HR_BodaCamara",class="LocalScript",source=__CAMERA_SOURCE__},
  {parent=SPS,name="HR_BodaCaras",class="LocalScript",source=newFace},
  {parent=SPS,name="HR_BodaDetalles",class="LocalScript",source=__DETAILS_SOURCE__},
 }
 for _,e in ipairs(definitions) do
  assert(not e.parent:FindFirstChild(e.name),"Ya existe "..e.name..". Se conserva.")
  local script=Instance.new(e.class);script.Name=e.name;script:SetAttribute("HR_Owner",OWNER)
  if script:IsA("BaseScript") then script.Enabled=false end
  script.Parent=staging;table.insert(created,script);e.object=script
  editor:UpdateSourceAsync(script,function() return e.source end)
  assert(editor:GetEditorSource(script)==e.source,"No se sincronizo "..e.name)
 end
 backup=Instance.new("Folder");backup.Name="HR_BodaAntesHistoria";backup:SetAttribute("HR_Owner",OWNER)
 for _,e in ipairs(previous) do
  local ref=Instance.new("ObjectValue");ref.Name=e.object.Name;ref.Value=e.object;ref:SetAttribute("EstabaActivo",e.enabled);ref.Parent=backup
 end
 backup.Parent=Storage
 for _,e in ipairs(previous) do e.object.Enabled=false end
 root.Parent=RS;table.insert(created,root)
 for _,e in ipairs(definitions) do e.object.Parent=e.parent end
 for _,e in ipairs(definitions) do if e.object:IsA("BaseScript") then e.object.Enabled=true end end
end)
if not ok then
 for _,e in ipairs(previous) do e.object.Enabled=e.enabled end
 for i=#created,1,-1 do pcall(function() created[i]:Destroy() end) end
 if backup then backup:Destroy() end
 staging:Destroy();error("[HR BODA] Activacion detenida y cambios revertidos: "..tostring(err))
end
staging:Destroy();game:GetService("Selection"):Set({decor.Ceremonia.ArcoFloral,decor.Reparto.Madre,decor.Reparto.Hija,decor.Reparto.Novio})
print("[HR BODA] INSTALADA: 14 segundos, 11 planos, cuatro actores y dos decorados.")
print("[HR BODA] Guarda, cierra las pestanas de codigo y pulsa F5. Cuenta atras de tres segundos.")
print("[HR BODA] R repite; G muestra/oculta el dialogo de guia; P devuelve la camara.")
print("[HR BODA] El archivo de referencia no tiene audio: texto reconstruido de sus subtitulos; las voces se anaden despues.")
print("[HR BODA] Pendiente revision visual: vestido en la cama, manos en el abrazo y encuadre vertical de cada corte.")
