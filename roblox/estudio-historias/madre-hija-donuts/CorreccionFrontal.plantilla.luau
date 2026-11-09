-- Ejecutar completo con Stop. Corrige la toma ya instalada; no crea otro director.
assert(not game:GetService("RunService"):IsRunning(),"Primero pulsa Stop.")
local Storage=game:GetService("ServerStorage")
local RS=game:GetService("ReplicatedStorage")
local SSS=game:GetService("ServerScriptService")
local SPS=game:GetService("StarterPlayer").StarterPlayerScripts
local editor=game:GetService("ScriptEditorService")
local root=RS:FindFirstChild("HR_PruebaReparto")
local decor=workspace:FindFirstChild("HR_RetoDonuts")
assert(root and root:GetAttribute("HR_Owner")=="HR_PRUEBA_REPARTO_1" and decor and decor:GetAttribute("HR_Owner")=="HR_DONUTS_DECORADO_1","No se reconoce la historia de donuts.")
local definitions={
 {object=root:FindFirstChild("Configuracion"),class="ModuleScript",text=__CONFIG_SOURCE__,key="Configuracion"},
 {object=root:FindFirstChild("Donuts"),class="ModuleScript",text=__DONUT_SOURCE__,key="Donuts"},
 {object=root:FindFirstChild("BrazoDonut"),class="ModuleScript",text=__ARM_SOURCE__,key="BrazoDonut"},
 {object=SSS:FindFirstChild("HR_PruebaRepartoServidor"),class="Script",text=__SERVER_SOURCE__,key="Servidor"},
 {object=SPS:FindFirstChild("HR_PruebaRepartoCamara"),class="LocalScript",text=__CAMERA_SOURCE__,key="Camara"},
}
for _,e in ipairs(definitions) do
 assert(e.object and e.object:IsA(e.class) and e.object:GetAttribute("HR_Owner")=="HR_PRUEBA_REPARTO_1","Falta un controlador reconocido: "..e.key)
 e.before=editor:GetEditorSource(e.object)
 if e.object:IsA("BaseScript") then e.enabled=e.object.Enabled end
end
assert(definitions[1].before:find("DONUTS_",1,true),"La configuracion activa no es de donuts.")
local M=(function()
__TABLE_CODE__
end)()
local layout=M.Preparar(decor)
local backup=Storage:FindFirstChild("HR_DonutsAntesRetoPicante")
if backup then assert(backup:GetAttribute("HR_Owner")=="HR_DONUTS_PICANTE_3","Existe otro respaldo de correccion.") end
local createdBackup=false
local staging=Instance.new("Folder")
local oldFood=decor.Donuts
local oldName=oldFood.Name
local freshFood
local ok,err=pcall(function()
 local D=(function()
__DONUT_CODE__
 end)()
 local board=decor.Mesa.Tablero
 freshFood=D.Mesa(staging,{CFrame=board.CFrame+Vector3.new(0,layout.Delta,0),Size=board.Size})
 if not backup then
  backup=Instance.new("Folder");backup.Name="HR_DonutsAntesRetoPicante";backup:SetAttribute("HR_Owner","HR_DONUTS_PICANTE_3");createdBackup=true
  for _,e in ipairs(definitions) do
   local value=Instance.new("StringValue");value.Name=e.key;value.Value=e.before
   if e.enabled~=nil then value:SetAttribute("EstabaActivo",e.enabled) end
   value.Parent=backup
  end
  backup.Parent=Storage
 end
 for _,e in ipairs(definitions) do
  if e.object:IsA("BaseScript") then e.object.Enabled=false end
  local text=e.text
  editor:UpdateSourceAsync(e.object,function() return text end)
  assert(editor:GetEditorSource(e.object)==text,"No se sincronizo "..e.key)
 end
 layout:Aplicar()
 if not backup:FindFirstChild("DonutsAnteriores") then
  oldFood.Name="DonutsAnteriores";oldFood.Parent=backup
 else oldFood.Parent=staging end
 freshFood.Parent=decor
 for _,e in ipairs(definitions) do if e.object:IsA("BaseScript") then e.object.Enabled=true end end
end)
if not ok then
 for _,e in ipairs(definitions) do
  pcall(function() editor:UpdateSourceAsync(e.object,function() return e.before end) end)
  if e.object:IsA("BaseScript") then e.object.Enabled=e.enabled end
 end
 if freshFood then freshFood:Destroy() end
 oldFood.Name=oldName;oldFood.Parent=decor
 pcall(function() layout:Revertir() end)
 staging:Destroy()
 if createdBackup and backup then backup:Destroy() end
 error("[HR DONUTS] Correccion detenida y revertida: "..tostring(err))
end
staging:Destroy()
game:GetService("Selection"):Set({decor.RepartoDonuts})
print("[HR DONUTS] RETO PICANTE INSTALADO: 6 donuts, madre e hija, 25 segundos y 14 planos frontales.")
print("[HR DONUTS] Cinco bocados en montaje rapido; sexto picante. Mordisco alineado a la boca y mesa ajustada a la cintura.")
print("[HR DONUTS] Guarda con Ctrl+S y pulsa F5. R repite; G muestra/oculta el texto. Las caras conservan su codigo.")
