-- Ejecutar completo en Comando, con Stop, en Madre_Hija_Novio.rbxl.
assert(not game:GetService("RunService"):IsRunning(),"Primero pulsa Stop.")
local RS=game:GetService("ReplicatedStorage")
local Storage=game:GetService("ServerStorage")
local SSS=game:GetService("ServerScriptService")
local SPS=game:GetService("StarterPlayer").StarterPlayerScripts
local editor=game:GetService("ScriptEditorService")
local OWNER="HR_PRUEBA_REPARTO_1"
local cast=Storage:FindFirstChild("HR_EstudioReparto")
local preview=workspace:FindFirstChild("HR_RevisionReparto") or Storage:FindFirstChild("HR_RevisionReparto")
assert(cast and cast:GetAttribute("HR_Owner")=="HR_ESTUDIO_REPARTO_1" and cast:FindFirstChild("Reparto"),"Falta preparar el reparto de la fase 1.")
assert(preview and preview:GetAttribute("HR_Owner")=="HR_ESTUDIO_REPARTO_1","No se reconoce la galeria de revision.")
local previewParent=preview.Parent
for _,role in ipairs({"Madre","Hija","Novio"}) do
 local link=cast.Reparto:FindFirstChild(role)
 assert(link and link:IsA("ObjectValue") and link.Value and link.Value:IsDescendantOf(cast),"Referencia de reparto no valida: "..role)
end
local previous={
 {name="ServidorAnterior",object=SSS:FindFirstChild("HR_CineServidor"),class="Script"},
 {name="CamaraAnterior",object=SPS:FindFirstChild("HR_CineCamara"),class="LocalScript"},
}
for _,entry in ipairs(previous) do
 assert(entry.object and entry.object:IsA(entry.class) and entry.object:GetAttribute("HR_Owner")=="HR_Cine_V2","No se reconoce el controlador anterior: "..entry.name)
 entry.enabled=entry.object.Enabled
end
local root=RS:FindFirstChild("HR_PruebaReparto")
assert(not root or (root:IsA("Folder") and root:GetAttribute("HR_Owner")==OWNER),"Existe otro HR_PruebaReparto no reconocido.")
local texts={
 Configuracion=__CONFIG_SOURCE__,
 Interpretacion=__ACTING_SOURCE__,
 Servidor=__SERVER_SOURCE__,
 Camara=__CAMERA_SOURCE__,
}
local definitions={
 {parent=root,name="Configuracion",class="ModuleScript",text=texts.Configuracion},
 {parent=root,name="Interpretacion",class="ModuleScript",text=texts.Interpretacion},
 {parent=SSS,name="HR_PruebaRepartoServidor",class="Script",text=texts.Servidor},
 {parent=SPS,name="HR_PruebaRepartoCamara",class="LocalScript",text=texts.Camara},
}
for _,entry in ipairs(definitions) do
 entry.object=entry.parent and entry.parent:FindFirstChild(entry.name)
 if entry.object then
  assert(entry.object:IsA(entry.class) and entry.object:GetAttribute("HR_Owner")==OWNER,"Destino no reconocido: "..entry.name)
  entry.before=editor:GetEditorSource(entry.object)
  if entry.object:IsA("BaseScript") then entry.enabled=entry.object.Enabled end
 end
end
if root then
 local galleryLink=root:FindFirstChild("Galeria")
 assert(not galleryLink or (galleryLink:IsA("ObjectValue") and galleryLink.Value==preview),"Galeria de prueba no reconocida.")
 local canal=root:FindFirstChild("Canal")
 assert(not canal or (canal:IsA("RemoteEvent") and canal:GetAttribute("HR_Owner")==OWNER),"Canal no reconocido.")
 for _,entry in ipairs(previous) do
  local link=root:FindFirstChild(entry.name)
  assert(not link or (link:IsA("ObjectValue") and link.Value==entry.object and type(link:GetAttribute("EstabaActivo"))=="boolean"),"Respaldo no reconocido: "..entry.name)
 end
end
local created={}
local function create(class,name,parent)
 local item=Instance.new(class);item.Name=name;item:SetAttribute("HR_Owner",OWNER)
 if item:IsA("BaseScript") then item.Enabled=false end
 table.insert(created,item);item.Parent=parent;return item
end
local ok,err=pcall(function()
 if not root then root=create("Folder","HR_PruebaReparto",RS) end
 definitions[1].parent=root
 definitions[2].parent=root
 if not root:FindFirstChild("Galeria") then
  local link=create("ObjectValue","Galeria",root);link.Value=preview
 end
 for _,entry in ipairs(previous) do
  if not root:FindFirstChild(entry.name) then
   local link=create("ObjectValue",entry.name,root)
   link.Value=entry.object;link:SetAttribute("EstabaActivo",entry.enabled)
  end
 end
 if not root:FindFirstChild("Canal") then create("RemoteEvent","Canal",root) end
 for _,entry in ipairs(definitions) do
  if not entry.object then entry.object=create(entry.class,entry.name,entry.parent) end
  if entry.object:IsA("BaseScript") then entry.object.Enabled=false end
  local text=entry.text
  editor:UpdateSourceAsync(entry.object,function() return text end)
  assert(editor:GetEditorSource(entry.object)==text,"No se sincronizo "..entry.name)
 end
 for _,entry in ipairs(previous) do entry.object.Enabled=false end
 preview.Parent=workspace
 for _,entry in ipairs(definitions) do if entry.object:IsA("BaseScript") then entry.object.Enabled=true end end
end)
if not ok then
 for _,entry in ipairs(definitions) do
  if entry.before and entry.object then
   pcall(function() editor:UpdateSourceAsync(entry.object,function() return entry.before end) end)
   if entry.object:IsA("BaseScript") then entry.object.Enabled=entry.enabled end
  end
 end
 for i=#created,1,-1 do created[i]:Destroy() end
 for _,entry in ipairs(previous) do entry.object.Enabled=entry.enabled end
 preview.Parent=previewParent
 error("[HR PRUEBA] Instalacion detenida: "..tostring(err))
end
print("[HR HISTORIA] INSTALADA: madre, hija y Marcos; 24 segundos y 19 planos.")
print("[HR HISTORIA] Actualiza la prueba anterior; no activa controladores adicionales.")
print("[HR HISTORIA] Guarda con Ctrl+S, cierra pestanas de codigo y pulsa F5. R repite; P vuelve al jugador.")
print("[HR HISTORIA] Caras dibujadas y complementos provisionales. Conserva la ropa actual; el tiro bajo sigue pendiente.")
print("[HR HISTORIA] Voces y musica se montan en el editor. Guion y subtitulos de referencia incluidos en la entrega.")
