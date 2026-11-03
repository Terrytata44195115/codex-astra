-- Este modulo se ejecuta desde Comando al activar el paquete, en modo Edicion.
-- Crea avatares nuevos en ServerStorage. No cambia las chicas existentes.
return function()
 local Players=game:GetService("Players")
 local storage=game:GetService("ServerStorage")
 local name="HR_AvataresRopa"
 local old=storage:FindFirstChild(name)
 if old then
  assert(old:GetAttribute("HR_Avatares")=="ROPA_CHICOS_1","Existe un contenedor ajeno llamado "..name)
  assert(old:FindFirstChild("chicoX") and old:FindFirstChild("chicoB"),"El contenedor de avatares esta incompleto.")
  return old
 end
 local container=Instance.new("Folder")
 container.Name=name
 container:SetAttribute("HR_Avatares","ROPA_CHICOS_1")
 local function accessory(model,name,base,elements)
  local acc=Instance.new("Accessory")
  acc.Name=name
  local handle=Instance.new("Part")
  handle.Name="Handle"
  handle.Size=Vector3.new(0.1,0.1,0.1)
  handle.Transparency=1
  handle.Massless=true
  handle.CanCollide=false
  handle.CanTouch=false
  handle.CFrame=base.CFrame
  handle.Parent=acc
  local weld=Instance.new("Weld")
  weld.Name="AccessoryWeld"
  weld.Part0=base
  weld.Part1=handle
  weld.Parent=handle
  for _,e in ipairs(elements) do
   local part=Instance.new(e.class or "Part")
   part.Name=e.name or "Detalle"
   part.Size=e.size
   part.Color=e.color
   part.Material=Enum.Material.SmoothPlastic
   part.CanCollide=false
   part.CanTouch=false
   part.Massless=true
   part.CFrame=base.CFrame*e.cf
   part.Parent=acc
   local joint=Instance.new("Weld")
   joint.Part0=handle
   joint.Part1=part
   joint.C0=e.cf
   joint.Parent=part
  end
  acc.Parent=model
 end
 local function build(name,accent,glasses)
  local desc=Instance.new("HumanoidDescription")
  desc.HeightScale=1
  desc.WidthScale=1
  desc.DepthScale=1
  desc.HeadScale=1
  desc.BodyTypeScale=0
  desc.ProportionScale=0
  local skin=Color3.fromRGB(234,184,146)
  for _,property in ipairs({"HeadColor","TorsoColor","LeftArmColor","RightArmColor","LeftLegColor","RightLegColor"}) do desc[property]=skin end
  local ok,model=pcall(function()
   return Players:CreateHumanoidModelFromDescriptionAsync(desc,Enum.HumanoidRigType.R15)
  end)
  desc:Destroy()
  assert(ok and typeof(model)=="Instance","Roblox no pudo crear el R15. "..tostring(model))
  model.Name=name
  model:SetAttribute("HR_AvatarProcedural",true)
  model.Parent=container
  local head=model:FindFirstChild("Head")
  local torso=model:FindFirstChild("UpperTorso")
  assert(head and torso and model:FindFirstChild("HumanoidRootPart"),"Roblox devolvio un rig incompleto.")
  local dark=Color3.fromRGB(24,28,38)
  for _,part in ipairs(model:GetChildren()) do
   if part:IsA("BasePart") and part.Name~="Head" and part.Name~="HumanoidRootPart"
    and part.Name~="LeftHand" and part.Name~="RightHand" then
    part.Color=dark
   end
  end
  local hair=Color3.fromRGB(18,19,24)
  local size=head.Size
  local elements={
   {size=Vector3.new(size.X*1.08,size.Y*0.32,size.Z*1.06),cf=CFrame.new(0,size.Y*0.5,0),color=hair},
   {size=Vector3.new(size.X*1.04,size.Y*0.65,size.Z*0.22),cf=CFrame.new(0,size.Y*0.08,size.Z*0.48),color=hair},
  }
  for i=1,5 do
   local x=(i-3)*size.X*0.19
   table.insert(elements,{class="WedgePart",size=Vector3.new(size.X*0.25,size.Y*0.46,size.Z*0.35),
    cf=CFrame.new(x,size.Y*0.31,-size.Z*0.43)*CFrame.Angles(0,0,math.rad((i-3)*-8)),color=i==2 and accent or hair})
  end
  for i=1,4 do
   table.insert(elements,{class="WedgePart",size=Vector3.new(size.X*0.28,size.Y*0.38,size.Z*0.65),
    cf=CFrame.new((i-2.5)*size.X*0.2,size.Y*0.72,0)*CFrame.Angles(0,math.rad(i*25),math.rad((i-2.5)*12)),color=hair})
  end
  accessory(model,"HR_PeloAnime",head,elements)
  local z=-torso.Size.Z/2-0.045
  accessory(model,"HR_Uniforme",torso,{
   {size=Vector3.new(torso.Size.X*0.35,torso.Size.Y*0.9,0.06),cf=CFrame.new(0,0,z),color=Color3.fromRGB(235,235,240)},
   {size=Vector3.new(0.15,torso.Size.Y*0.55,0.08),cf=CFrame.new(0,-torso.Size.Y*0.06,z-0.05),color=Color3.fromRGB(72,119,210)},
   {class="WedgePart",size=Vector3.new(torso.Size.X*0.19,torso.Size.Y*0.45,0.1),cf=CFrame.new(-torso.Size.X*0.21,torso.Size.Y*0.25,z-0.03)*CFrame.Angles(0,0,math.rad(-18)),color=dark},
   {class="WedgePart",size=Vector3.new(torso.Size.X*0.19,torso.Size.Y*0.45,0.1),cf=CFrame.new(torso.Size.X*0.21,torso.Size.Y*0.25,z-0.03)*CFrame.Angles(0,0,math.rad(18)),color=dark},
  })
  if glasses then
   local e={}
   local front=-size.Z/2-0.08
   local color=Color3.fromRGB(15,15,18)
   for _,side in ipairs({-1,1}) do
    local x=side*size.X*0.23
    for _,y in ipairs({-0.08,0.14}) do
     table.insert(e,{size=Vector3.new(size.X*0.37,0.035,0.04),cf=CFrame.new(x,y*size.Y,front),color=color})
    end
    for _,dx in ipairs({-0.18,0.18}) do
     table.insert(e,{size=Vector3.new(0.035,size.Y*0.22,0.04),cf=CFrame.new(x+dx*size.X,size.Y*0.03,front),color=color})
    end
   end
   table.insert(e,{size=Vector3.new(size.X*0.12,0.035,0.04),cf=CFrame.new(0,size.Y*0.05,front),color=color})
   accessory(model,"HR_Gafas",head,e)
  end
 end
 local ok,err=pcall(function()
  build("chicoX",Color3.fromRGB(72,119,210),false)
  build("chicoB",Color3.fromRGB(178,65,78),true)
 end)
 if not ok then container:Destroy(); error(err) end
 container.Parent=storage
 print("[HR ROPA] Dos bases R15 creadas. Pelo y uniforme geometricos, sin IDs de catalogo.")
 return container
end
