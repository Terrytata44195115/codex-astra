-- Actualizacion de los planos: ejecutar con Stop sobre la boda ya instalada.
assert(not game:GetService("RunService"):IsRunning(),"Primero pulsa Stop.")
local RS=game:GetService("ReplicatedStorage")
local Storage=game:GetService("ServerStorage")
local SPS=game:GetService("StarterPlayer").StarterPlayerScripts
local editor=game:GetService("ScriptEditorService")
local OWNER="HR_BODA_1"
local root=RS:FindFirstChild("HR_Boda")
assert(root and root:GetAttribute("HR_Owner")==OWNER,"Primero ejecuta 02_ACTIVAR_HISTORIA_BODA.")
local config=root:FindFirstChild("Configuracion")
local camera=SPS:FindFirstChild("HR_BodaCamara")
assert(config and config:IsA("ModuleScript") and config:GetAttribute("HR_Owner")==OWNER,"Falta la configuracion de boda reconocida.")
assert(camera and camera:IsA("LocalScript") and camera:GetAttribute("HR_Owner")==OWNER,"Falta la camara de boda reconocida.")
local previousConfig=editor:GetEditorSource(config)
local first=previousConfig:find("C.Planos={",1,true)
local last=first and previousConfig:find("\nfunction C.EscenaEn",first,true)
assert(first and last and previousConfig:find("local function shot(",1,true),"La configuracion tiene otra estructura. Se conserva; comparte su codigo para adaptar los planos.")
local newConfig=previousConfig:sub(1,first-1)..__PLANS_SOURCE__..previousConfig:sub(last)
local startHelper=newConfig:find("-- HR_BODA_ENTRADA_INICIO",1,true)
local endHelper=newConfig:find("-- HR_BODA_ENTRADA_FIN",1,true)
if startHelper and endHelper then
 newConfig=newConfig:sub(1,startHelper-1)..__ENTRY_SOURCE__..newConfig:sub(endHelper+#"-- HR_BODA_ENTRADA_FIN")
else
 assert(not newConfig:find("function C.EncuadreEntrada",1,true),"La funcion de entrada tiene otra estructura. Se conserva.")
 local finish=newConfig:find("\nreturn C%s*$")
 assert(finish,"No se reconoce el final de la configuracion.")
 newConfig=newConfig:sub(1,finish)..__ENTRY_SOURCE__..newConfig:sub(finish)
end
newConfig=newConfig:gsub('Version="BODA_1"','Version="BODA_CORTES_2"',1)
local definitions={{object=config,source=newConfig,label="Configuracion"},{object=camera,source=__CAMERA_SOURCE__,label="Camara"}}
local enabled=camera.Enabled;local version=root:GetAttribute("Version")
local backup=Storage:FindFirstChild("HR_BodaAntesCortes")
if backup then assert(backup:GetAttribute("HR_Owner")==OWNER,"Existe otro respaldo con este nombre.") end
local unchanged=true
for _,e in ipairs(definitions) do e.before=editor:GetEditorSource(e.object);if e.before~=e.source then unchanged=false end end
if unchanged then print("[HR BODA] Cortes ya actualizados. Guarda y pulsa F5.");return end
local fresh=false
local ok,err=pcall(function()
 if not backup then
  backup=Instance.new("Folder");backup.Name="HR_BodaAntesCortes";backup:SetAttribute("HR_Owner",OWNER);fresh=true
  backup:SetAttribute("VersionAnterior",version or "BODA_1")
  for _,e in ipairs(definitions) do local value=Instance.new("StringValue");value.Name=e.label;value.Value=e.before;value.Parent=backup end
  backup.Parent=Storage
 end
 camera.Enabled=false
 for _,e in ipairs(definitions) do
  editor:UpdateSourceAsync(e.object,function() return e.source end)
  assert(editor:GetEditorSource(e.object)==e.source,"No se sincronizo "..e.label)
 end
 root:SetAttribute("Version","BODA_CORTES_2");camera.Enabled=enabled
end)
if not ok then
 for _,e in ipairs(definitions) do pcall(function() editor:UpdateSourceAsync(e.object,function() return e.before end) end) end
 root:SetAttribute("Version",version);camera.Enabled=enabled
 if fresh and backup then backup:Destroy() end
 error("[HR BODA] Actualizacion detenida y planos anteriores restaurados: "..tostring(err))
end
print("[HR BODA] PLANOS ACTUALIZADOS: novia, novio, general lejano de la llegada y corte al frente de la invitada.")
print("[HR BODA] Cortes directos; la camara de entrada permanece fija mientras ella se acerca al altar.")
print("[HR BODA] Guarda con Ctrl+S, cierra codigo y pulsa F5. R repite. Reparto, caras y dialogos conservados.")
