assert(not game:GetService("RunService"):IsRunning(),"Primero pulsa Stop.")
local RS=game:GetService("ReplicatedStorage")
local SSS=game:GetService("ServerScriptService")
local SPS=game:GetService("StarterPlayer").StarterPlayerScripts
local editor=game:GetService("ScriptEditorService")
local OWNER="HR_PRUEBA_REPARTO_1"
local root=RS:FindFirstChild("HR_PruebaReparto")
assert(root and root:GetAttribute("HR_Owner")==OWNER,"Falta la historia de Marcos instalada.")
local unchanged={root:FindFirstChild("Configuracion"),SSS:FindFirstChild("HR_PruebaRepartoServidor"),SPS:FindFirstChild("HR_PruebaRepartoCamara")}
local protected={}
for index=1,3 do
 local item=unchanged[index]
 assert(item and item:IsA("LuaSourceContainer") and item:GetAttribute("HR_Owner")==OWNER,"Falta un componente reconocido de la historia: "..index)
 protected[item]=editor:GetEditorSource(item)
end
local module=root:FindFirstChild("Interpretacion")
assert(module and module:IsA("ModuleScript") and module:GetAttribute("HR_Owner")==OWNER,"Modulo de interpretacion no reconocido.")
local localScript=SPS:FindFirstChild("HR_CarasMarcos")
assert(not localScript or (localScript:IsA("LocalScript") and localScript:GetAttribute("HR_Owner")==OWNER),"Existe otro HR_CarasMarcos no reconocido.")
local previousModule=editor:GetEditorSource(module)
local previousClient=localScript and editor:GetEditorSource(localScript)
local previousEnabled=localScript and localScript.Enabled
local moduleText=__ACTING_SOURCE__
local clientText=__FACE_CLIENT_SOURCE__
-- Conserva literalmente los gestos y la palidez de la version instalada.
local poseStart=previousModule:find("local function a(",1,true)
local poseEnd=poseStart and (previousModule:find("local function oval(",poseStart,true) or previousModule:find("function B.Preparar(",poseStart,true))
local paleStart=previousModule:find("function B.Palidez(",1,true)
local paleEnd=paleStart and (previousModule:find("-- Complementos",paleStart,true) or previousModule:find("function B.Complementos(",paleStart,true))
assert(poseStart and poseEnd and paleStart and paleEnd,"No se reconoce la biblioteca de gestos. No se ha modificado nada.")
local newPoseStart=assert(moduleText:find("local function a(",1,true))
local newPoseEnd=assert(moduleText:find("function B.Preparar(",newPoseStart,true))
moduleText=moduleText:sub(1,newPoseStart-1)..previousModule:sub(poseStart,poseEnd-1)..moduleText:sub(newPoseEnd)
local newPaleStart=assert(moduleText:find("function B.Palidez(",1,true))
local newPaleEnd=assert(moduleText:find("function B.Complementos(",newPaleStart,true))
moduleText=moduleText:sub(1,newPaleStart-1)..previousModule:sub(paleStart,paleEnd-1)..moduleText:sub(newPaleEnd)
local created=false
local ok,err=pcall(function()
 if not localScript then
  localScript=Instance.new("LocalScript");created=true
  localScript.Name="HR_CarasMarcos";localScript.Enabled=false;localScript:SetAttribute("HR_Owner",OWNER);localScript.Parent=SPS
 end
 localScript.Enabled=false
 editor:UpdateSourceAsync(module,function() return moduleText end)
 editor:UpdateSourceAsync(localScript,function() return clientText end)
 assert(editor:GetEditorSource(module)==moduleText,"No se sincronizo Interpretacion.")
 assert(editor:GetEditorSource(localScript)==clientText,"No se sincronizaron las caras.")
 for item,text in pairs(protected) do assert(editor:GetEditorSource(item)==text,"Se ha cambiado un componente protegido: "..item.Name) end
 localScript.Enabled=true
end)
if not ok then
 pcall(function() editor:UpdateSourceAsync(module,function() return previousModule end) end)
 if created and localScript then localScript:Destroy()
 elseif localScript then
  pcall(function() editor:UpdateSourceAsync(localScript,function() return previousClient end) end)
  localScript.Enabled=previousEnabled
 end
 error("[HR CARAS] Correccion detenida: "..tostring(err))
end
print("[HR CARAS] CORRECCION INSTALADA. Biblioteca facial y cliente preparados; revisar rostro en Studio.")
print("[HR CARAS] Se conservan los controladores de camara, secuencia y configuracion.")
print("[HR CARAS] Guarda, cierra pestanas de codigo y pulsa F5. R repite la toma.")
