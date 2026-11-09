-- Ejecutar completo en Script > Comando con Stop, en Madre_Hija_Donuts.
assert(not game:GetService("RunService"):IsRunning(),"Primero pulsa Stop.")
local Storage=game:GetService("ServerStorage")
local RS=game:GetService("ReplicatedStorage")
local SSS=game:GetService("ServerScriptService")
local SPS=game:GetService("StarterPlayer").StarterPlayerScripts
local editor=game:GetService("ScriptEditorService")
local OWNER="HR_DONUTS_HISTORIA_1"
local decor=workspace:FindFirstChild("HR_RetoDonuts")
assert(decor and decor:GetAttribute("HR_Owner")=="HR_DONUTS_DECORADO_1","Primero crea la sala y la mesa.")
assert(decor:GetAttribute("HR_SueloLuzAjustados"),"Primero aplica el ajuste de suelo y luz.")
assert(decor:FindFirstChild("Sala") and decor.Sala:FindFirstChild("Suelo") and decor:FindFirstChild("Mesa") and decor.Mesa:FindFirstChild("Tablero") and decor:FindFirstChild("Marcas"),"El decorado esta incompleto.")
local root=RS:FindFirstChild("HR_PruebaReparto")
assert(root and root:GetAttribute("HR_Owner")=="HR_PRUEBA_REPARTO_1" and root:FindFirstChild("Interpretacion") and root:FindFirstChild("Canal"),"Falta el sistema de la historia anterior.")
local cast=Storage:FindFirstChild("HR_EstudioReparto")
assert(cast and cast:GetAttribute("HR_Owner")=="HR_ESTUDIO_REPARTO_1" and cast:FindFirstChild("Reparto"),"Faltan las plantillas del reparto.")
local roles=cast.Reparto
local P=(function()
__PREVIEW_CODE__
end)()
for _,role in ipairs({"Madre","Hija"}) do
 local link=roles:FindFirstChild(role)
 assert(link and link:IsA("ObjectValue") and link.Value and link.Value:IsDescendantOf(cast),"Referencia no valida: "..role)
 P.Verificar(link.Value)
end
local faces=SPS:FindFirstChild("HR_CarasMarcos")
assert(faces and faces:IsA("LocalScript") and faces:GetAttribute("HR_Owner")=="HR_PRUEBA_REPARTO_1","No se reconoce el cliente de caras que funcionaba.")
local oldFace=editor:GetEditorSource(faces)
-- Se conserva el cliente facial instalado, cambiando exclusivamente sus dos papeles.
local newFace,replacements=oldFace:gsub('ipairs%(%s*{%s*"Madre"%s*,%s*"Hija"%s*,%s*"Novio"%s*}%s*%)','ipairs({"Madre","Hija"})')
local _,twoRoles=newFace:gsub('ipairs%(%s*{%s*"Madre"%s*,%s*"Hija"%s*}%s*%)','')
assert(replacements==1 or (replacements==0 and twoRoles==1),"El cliente de caras tiene otra estructura. Instalacion detenida para conservarlo; comparte su codigo.")
local texts={Configuracion=__CONFIG_SOURCE__,Donuts=__DONUT_SOURCE__,BrazoDonut=__ARM_SOURCE__,Servidor=__SERVER_SOURCE__,Camara=__CAMERA_SOURCE__}
local definitions={
 {parent=root,name="Configuracion",class="ModuleScript",text=texts.Configuracion,backup="Configuracion",required=true},
 {parent=root,name="Donuts",class="ModuleScript",text=texts.Donuts},
 {parent=root,name="BrazoDonut",class="ModuleScript",text=texts.BrazoDonut},
 {parent=SSS,name="HR_PruebaRepartoServidor",class="Script",text=texts.Servidor,backup="Servidor",required=true},
 {parent=SPS,name="HR_PruebaRepartoCamara",class="LocalScript",text=texts.Camara,backup="Camara",required=true},
 {parent=SPS,name="HR_CarasMarcos",class="LocalScript",text=newFace,backup="Caras",required=true},
}
for _,entry in ipairs(definitions) do
 entry.object=entry.parent:FindFirstChild(entry.name)
 assert(entry.object or not entry.required,"Falta el controlador anterior: "..entry.name)
 if entry.object then
  assert(entry.object:IsA(entry.class) and entry.object:GetAttribute("HR_Owner")=="HR_PRUEBA_REPARTO_1","Destino no reconocido: "..entry.name)
  entry.before=editor:GetEditorSource(entry.object)
  if entry.object:IsA("BaseScript") then entry.enabled=entry.object.Enabled end
 end
end
local previous={}
for _,candidate in ipairs({{SSS,"HR_CineServidor"},{SPS,"HR_CineCamara"}}) do
 local obj=candidate[1]:FindFirstChild(candidate[2])
 if obj then
  assert(obj:IsA("BaseScript") and obj:GetAttribute("HR_Owner")=="HR_Cine_V2","Controlador anterior no reconocido: "..obj.Name)
  table.insert(previous,{object=obj,enabled=obj.Enabled})
 end
end
local backup=Storage:FindFirstChild("HR_DonutsAntesHistoria")
if backup then
 assert(backup:GetAttribute("HR_Owner")==OWNER,"Existe un respaldo de otro origen.")
 for _,entry in ipairs(definitions) do if entry.backup then assert(backup:FindFirstChild(entry.backup),"Respaldo incompleto: "..entry.backup) end end
end
local existingFood=decor:FindFirstChild("Donuts")
if existingFood then
 assert(existingFood:GetAttribute("HR_Owner")==OWNER,"Ya hay otros donuts en la sala: se conservan y se detiene la instalacion.")
 for i=1,6 do assert(existingFood:FindFirstChild(string.format("Donut_%02d",i)),"Falta el donut "..i) end
end
local existingCast=decor:FindFirstChild("RepartoDonuts")
if existingCast then
 assert(existingCast:GetAttribute("HR_Owner")==OWNER,"Hay un reparto de otro origen.")
 for _,role in ipairs({"Madre","Hija"}) do P.Verificar(existingCast:FindFirstChild(role)) end
end
local staging=Instance.new("Folder")
local created={};local newBackup=false;local newFood,newCast
local ok,err=pcall(function()
 local D=(function()
__DONUT_CODE__
 end)()
 local C=(function()
__CONFIG_CODE__
 end)()
 if not existingFood then newFood=D.Mesa(staging,decor.Mesa.Tablero) end
 if not existingCast then newCast=P.Crear(staging,roles,decor,C) end
 if not backup then
  backup=Instance.new("Folder");backup.Name="HR_DonutsAntesHistoria";backup:SetAttribute("HR_Owner",OWNER);newBackup=true
  for _,entry in ipairs(definitions) do
   if entry.backup then
    local value=Instance.new("StringValue");value.Name=entry.backup;value.Value=entry.before
    if entry.enabled~=nil then value:SetAttribute("EstabaActivo",entry.enabled) end
    value.Parent=backup
   end
  end
  for _,entry in ipairs(previous) do
   local link=Instance.new("ObjectValue");link.Name=entry.object.Name;link.Value=entry.object;link:SetAttribute("EstabaActivo",entry.enabled);link.Parent=backup
  end
  backup.Parent=Storage
 end
 for _,entry in ipairs(definitions) do
  if not entry.object then
   local item=Instance.new(entry.class);item.Name=entry.name;item:SetAttribute("HR_Owner","HR_PRUEBA_REPARTO_1")
   entry.object=item;table.insert(created,item);item.Parent=entry.parent
  end
  if entry.object:IsA("BaseScript") then entry.object.Enabled=false end
  local source=entry.text
  editor:UpdateSourceAsync(entry.object,function() return source end)
  assert(editor:GetEditorSource(entry.object)==source,"No se sincronizo "..entry.name)
 end
 for _,entry in ipairs(previous) do entry.object.Enabled=false end
 if newFood then newFood.Parent=decor end
 if newCast then newCast.Parent=decor end
 for _,entry in ipairs(definitions) do if entry.object:IsA("BaseScript") then entry.object.Enabled=true end end
end)
if not ok then
 for _,entry in ipairs(definitions) do
  if entry.before and entry.object then
   pcall(function() editor:UpdateSourceAsync(entry.object,function() return entry.before end) end)
   if entry.object:IsA("BaseScript") then entry.object.Enabled=entry.enabled end
  end
 end
 for _,entry in ipairs(previous) do entry.object.Enabled=entry.enabled end
 for i=#created,1,-1 do created[i]:Destroy() end
 if newFood then newFood:Destroy() end
 if newCast then newCast:Destroy() end
 staging:Destroy()
 if newBackup and backup then backup:Destroy() end
 error("[HR DONUTS] Instalacion detenida y cambios revertidos: "..tostring(err))
end
staging:Destroy()
decor.ModelStreamingMode=Enum.ModelStreamingMode.Persistent
game:GetService("Selection"):Set({decor.RepartoDonuts})
print("[HR DONUTS] HISTORIA INSTALADA: madre, hija, 6 donuts, 25 segundos y 14 planos frontales.")
print("[HR DONUTS] Caras conservadas; historia anterior respaldada. Guarda con Ctrl+S, cierra las pestanas de codigo y pulsa F5.")
print("[HR DONUTS] Espera la cuenta atras. R repite; G oculta/muestra el dialogo; P devuelve la camara.")
print("[HR DONUTS] Dialogo en pantalla como guia. Las voces se montan despues. Revisar el contacto de manos y los planos en la primera toma.")
