-- Perfil mate de interior. Cambios respaldados, sin luces extra ni filtros nuevos.
local P={Owner="HR_DONUTS_ASPECTO_4"}
function P.Preparar(decor,lighting,storage)
 local existing=storage:FindFirstChild("HR_DonutsAspectoOriginal")
 if existing then assert(existing:GetAttribute("HR_Owner")==P.Owner,"Existe otro respaldo de aspecto.") end
 local edits={}
 local function edit(object,values)
  local before={}
  for key in pairs(values) do before[key]=object[key] end
  table.insert(edits,{object=object,before=before,after=values})
 end
 edit(lighting,{
  Brightness=1.0,ExposureCompensation=-.30,ClockTime=13.5,
  Ambient=Color3.fromRGB(92,98,104),OutdoorAmbient=Color3.fromRGB(92,98,104),
  EnvironmentDiffuseScale=.25,EnvironmentSpecularScale=.10,GlobalShadows=false,
  ColorShift_Top=Color3.fromRGB(0,0,0),ColorShift_Bottom=Color3.fromRGB(0,0,0),
  FogStart=0,FogEnd=100000,
 })
 for _,effect in ipairs(lighting:GetChildren()) do
  if effect:IsA("PostEffect") then edit(effect,{Enabled=false})
  elseif effect:IsA("Atmosphere") then edit(effect,{Density=0,Haze=0,Glare=0}) end
 end
 local room=decor:FindFirstChild("Sala")
 local mesa=decor:FindFirstChild("Mesa")
 assert(room and mesa,"Falta la sala o la mesa.")
 for _,part in ipairs(room:GetDescendants()) do
  if part:IsA("Light") then edit(part,{Enabled=false,Brightness=0})
  elseif part:IsA("BasePart") then
   local name=part.Name;local color
   if name=="Suelo" then color=Color3.fromRGB(166,142,90)
   elseif name=="Techo" then color=Color3.fromRGB(192,202,212)
   elseif name:find("Pared") or name:find("Fondo") or name:find("Ventana") and (name=="BajoVentana" or name=="SobreVentana") or name=="SobrePuerta" then color=Color3.fromRGB(106,143,162)
   elseif name:find("Rodapie") then color=Color3.fromRGB(185,194,197)
   elseif name:find("Marco") then color=Color3.fromRGB(49,60,69)
   elseif name=="VistaCielo" then color=Color3.fromRGB(42,171,203)
   elseif name=="VistaCesped" then color=Color3.fromRGB(99,141,68) end
   if color then edit(part,{Color=color,Reflectance=0}) end
  end
 end
 for _,part in ipairs(mesa:GetDescendants()) do
  if part:IsA("BasePart") then
   local color=part.Name=="Tablero" and Color3.fromRGB(166,145,103) or part.Name:find("UnionTablas") and Color3.fromRGB(109,90,62) or Color3.fromRGB(139,116,75)
   edit(part,{Color=color,Reflectance=0})
  end
 end
 local backup=existing;local created=false
 local plan={}
 function plan:Aplicar()
  if not backup then
   backup=Instance.new("Folder");backup.Name="HR_DonutsAspectoOriginal";backup:SetAttribute("HR_Owner",P.Owner);created=true
   for i,e in ipairs(edits) do
    local ref=Instance.new("ObjectValue");ref.Name=string.format("Ajuste_%03d",i);ref.Value=e.object
    for key,value in pairs(e.before) do ref:SetAttribute(key,value) end
    ref.Parent=backup
   end
   backup.Parent=storage
  end
  for _,e in ipairs(edits) do for key,value in pairs(e.after) do e.object[key]=value end end
 end
 function plan:Revertir()
  for _,e in ipairs(edits) do for key,value in pairs(e.before) do e.object[key]=value end end
  if created and backup then backup:Destroy() end
 end
 return plan
end
return P
