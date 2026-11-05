-- Solo representa caras; no controla movimientos, camara, dialogos ni tiempos.
local RS=game:GetService("ReplicatedStorage")
local Run=game:GetService("RunService")
local Asset=game:GetService("AssetService")
local root=RS:WaitForChild("HR_PruebaReparto",15)
if not root or root:GetAttribute("HR_Owner")~="HR_PRUEBA_REPARTO_1" then return end
local stage=workspace:WaitForChild("HR_PruebaActores",25)
if not stage or stage:GetAttribute("HR_Owner")~="HR_PRUEBA_REPARTO_1" then return end
local B=require(root:WaitForChild("Interpretacion",10))
if type(B.PixelesCara)~="function" then warn("[HR CARAS] Falta el modulo corregido.");return end
local pool={}
local images={}
local function imageKey(state,masked) return state..(masked and "_MASCARA" or "") end
local available,message=pcall(function()
 for _,state in ipairs(B.EstadosCara) do
  for _,masked in ipairs({false,true}) do
   local image=Asset:CreateEditableImage({Size=Vector2.new(B.ResolucionCara,B.ResolucionCara)})
   assert(image,"No hay memoria disponible para EditableImage.")
   table.insert(images,image)
   image:WritePixelsBuffer(Vector2.zero,Vector2.new(B.ResolucionCara,B.ResolucionCara),B.PixelesCara(state,masked))
   pool[imageKey(state,masked)]=image
  end
 end
end)
if not available then
 for _,image in ipairs(images) do image:Destroy() end
 warn("[HR CARAS] No se pudieron generar texturas. Se conservan las caras originales: "..tostring(message))
end
local bindings={}
for _,role in ipairs({"Madre","Hija","Novio"}) do
 local model=stage:WaitForChild(role,15)
 local head=model and model:WaitForChild("Head",10)
 if head then
  local original={}
  for _,item in ipairs(head:GetChildren()) do
   if item:IsA("Decal") and item.Face==Enum.NormalId.Front then table.insert(original,{item=item,opacity=item.Transparency}) end
  end
  local decal
  local failed=false
  local function update()
   if not available or failed then return end
   local state=head:GetAttribute("HR_Expresion") or "NEUTRA"
   local masked=head:GetAttribute("HR_MascaraTextura")==true
   local image=pool[imageKey(state,masked)] or pool[imageKey("NEUTRA",masked)]
   local ok,err=pcall(function()
    if not decal then
     decal=Instance.new("Decal");decal.Name="HR_ExpresionLocal";decal.Face=Enum.NormalId.Front
     decal.Color3=Color3.new(1,1,1);decal.Transparency=0;decal.Parent=head
    end
    local content=Content.fromObject(image)
    local assigned=pcall(function() decal.ColorMapContent=content end)
    if not assigned then decal.TextureContent=content end
    for _,entry in ipairs(original) do entry.item.Transparency=1 end
   end)
   if not ok then
    failed=true
    if decal then decal:Destroy();decal=nil end
    for _,entry in ipairs(original) do entry.item.Transparency=entry.opacity end
    warn("[HR CARAS] "..role..": se conserva la cara original. "..tostring(err))
   end
  end
  update()
  head:GetAttributeChangedSignal("HR_Expresion"):Connect(update)
  head:GetAttributeChangedSignal("HR_MascaraTextura"):Connect(update)
  table.insert(bindings,{head=head,original=original,decal=function() return decal end})
 end
end
Run.RenderStepped:Connect(function()
 -- Sigue la ocultacion local que ya hace la camara en cada plano.
 for _,binding in ipairs(bindings) do
  if binding.head.Parent then
   local value=binding.head.LocalTransparencyModifier
   local decal=binding.decal()
   if decal then decal.LocalTransparencyModifier=value end
   for _,entry in ipairs(binding.original) do if entry.item.Parent then entry.item.LocalTransparencyModifier=value end end
  end
 end
end)
if available then print("[HR CARAS] Texturas listas sobre la cabeza; camara y secuencia conservadas.") end
