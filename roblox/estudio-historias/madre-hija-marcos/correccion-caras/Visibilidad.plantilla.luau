assert(not game:GetService("RunService"):IsRunning(),"Primero pulsa Stop.")
local editor=game:GetService("ScriptEditorService")
local root=game:GetService("ReplicatedStorage"):FindFirstChild("HR_PruebaReparto")
local SSS=game:GetService("ServerScriptService")
local SPS=game:GetService("StarterPlayer").StarterPlayerScripts
local OWNER="HR_PRUEBA_REPARTO_1"
assert(root and root:GetAttribute("HR_Owner")==OWNER,"No se reconoce la historia de Marcos.")
local script=SPS:FindFirstChild("HR_CarasMarcos")
assert(script and script:IsA("LocalScript") and script:GetAttribute("HR_Owner")==OWNER,"Falta el cliente facial de la historia.")
local protected={}
local entries={root:FindFirstChild("Configuracion"),root:FindFirstChild("Interpretacion"),SSS:FindFirstChild("HR_PruebaRepartoServidor"),SPS:FindFirstChild("HR_PruebaRepartoCamara")}
for i=1,4 do
 local item=entries[i]
 assert(item and item:IsA("LuaSourceContainer") and item:GetAttribute("HR_Owner")==OWNER,"Falta un componente reconocido: "..i)
 protected[item]=editor:GetEditorSource(item)
end
assert(protected[entries[2]]:find('SetAttribute("HR_Expresion"',1,true),"Primero debe estar instalada la biblioteca de expresiones por atributos.")
local previous=editor:GetEditorSource(script)
local enabled=script.Enabled
local text=__FACE_CLIENT_SOURCE__
local ok,err=pcall(function()
 script.Enabled=false
 editor:UpdateSourceAsync(script,function() return text end)
 assert(editor:GetEditorSource(script)==text,"No se sincronizo el cliente facial.")
 for item,source in pairs(protected) do assert(editor:GetEditorSource(item)==source,"Se modifico un componente protegido: "..item.Name) end
 script.Enabled=true
end)
if not ok then
 pcall(function() editor:UpdateSourceAsync(script,function() return previous end) end)
 script.Enabled=enabled
 error("[HR CARAS V2] Instalacion detenida: "..tostring(err))
end
print("[HR CARAS V2] INSTALADO. Se actualizo solamente el cliente facial.")
print("[HR CARAS V2] Camara, secuencia, gestos y palidez conservados.")
print("[HR CARAS V2] Guarda, cierra pestanas de codigo y pulsa F5. Revisa un primer plano; R repite.")
