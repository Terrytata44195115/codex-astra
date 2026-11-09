-- Vestuario unido al rig: no descarga accesorios ni ejecuta modelos de la tienda.
local V={}
local ivory=Color3.fromRGB(234,229,218)
local dark=Color3.fromRGB(34,37,44)
local gold=Color3.fromRGB(191,151,80)
local function piece(folder,body,name,size,offset,color,shape)
 local p=Instance.new("Part");p.Name=name;p.Size=size;p.Color=color;p.Material=Enum.Material.SmoothPlastic
 p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.Massless=true;p.CastShadow=false;p.Anchored=false
 p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth
 if shape then p.Shape=shape end
 p.CFrame=body.CFrame*offset;p.Parent=folder
 local w=Instance.new("Weld");w.Part0=body;w.Part1=p;w.C0=offset;w.C1=CFrame.identity;w.Parent=p
 return p
end
local function panel(folder,body,name,color)
 local p=piece(folder,body,name,Vector3.new(body.Size.X*.82,body.Size.Y*.90,.025),CFrame.new(0,0,-body.Size.Z/2-.025),color)
 local gui=Instance.new("SurfaceGui");gui.Name="DetallesCostura";gui.Face=Enum.NormalId.Front
 gui.CanvasSize=Vector2.new(400,400);gui.LightInfluence=1;gui.AlwaysOnTop=false;gui.Parent=p
 return gui
end
local function rectangle(gui,name,x,y,w,h,color,rotation,round)
 local p=Instance.new("Frame");p.Name=name;p.AnchorPoint=Vector2.new(.5,.5);p.Position=UDim2.fromScale(x,y)
 p.Size=UDim2.fromScale(w,h);p.BackgroundColor3=color;p.BorderSizePixel=0;p.Rotation=rotation or 0;p.Parent=gui
 if round then local c=Instance.new("UICorner");c.CornerRadius=UDim.new(1,0);c.Parent=p end
 return p
end
local function skirt(folder,body,color,floorDistance,short)
 local height=math.max(.8,floorDistance-(short and .55 or .12))
 local top=body.Size.X*.47;local bottom=short and top*1.35 or top*1.75
 local run=bottom-top;local slant=math.sqrt(height*height+run*run)
 for i=0,23 do
  local t=i*math.pi/12
  local radius=(top+bottom)/2
  local offset=CFrame.new(math.sin(t)*radius,-height/2,math.cos(t)*radius)*CFrame.Angles(0,t,0)*CFrame.Angles(-math.atan2(run,height),0,0)
  local p=piece(folder,body,"PliegueFalda",Vector3.new(2*math.pi*bottom/24*1.13,slant,.09),offset,color:Lerp(Color3.new(1,1,1),i%2*.035))
  p:SetAttribute("HR_Falda",true)
 end
 local belt=piece(folder,body,"Cinturon",Vector3.new(body.Size.X*1.03,.13,body.Size.Z*1.06),CFrame.new(0,body.Size.Y*.3,0),gold)
 belt:SetAttribute("HR_Falda",true)
end
function V.Aplicar(model,role)
 local folder=Instance.new("Folder");folder.Name="VestuarioBoda";folder.Parent=model
 local h=model:FindFirstChildOfClass("Humanoid");local torso=model.UpperTorso;local lower=model.LowerTorso
 local skin=model.Head.Color
 for _,d in ipairs(model:GetChildren()) do
  if d:IsA("Shirt") or d:IsA("Pants") or d:IsA("ShirtGraphic") then d:Destroy() end
  if d:IsA("Accessory") then
   local handle=d:FindFirstChild("Handle")
   -- Se conservan los cabellos ya incrustados; se retiran gafas/collares ajenos a la boda.
   local hair=d.Name:lower():find("hair") or d.Name:lower():find("braid") or d.AccessoryType==Enum.AccessoryType.Hair
   if not hair and handle then d:Destroy() end
  end
  if d:IsA("BasePart") and d.Name~="HumanoidRootPart" and d.Name~="Head" and d.Name~="LeftHand" and d.Name~="RightHand" then
   if d:IsA("MeshPart") then d.TextureID="" end
   for _,effect in ipairs(d:GetChildren()) do if effect:IsA("SurfaceAppearance") then effect:Destroy() end end
   if role=="Hija" then d.Color=ivory
   elseif role=="Invitada" then d.Color=Color3.fromRGB(218,171,63)
   elseif role=="Madre" then d.Color=Color3.fromRGB(54,39,64)
   else d.Color=dark end
  end
 end
 model.Head:SetAttribute("HR_MascaraTextura",false)
 for _,d in ipairs(model:GetDescendants()) do
  if d:IsA("BasePart") and (d:GetAttribute("HR_Complemento") or d.Name=="Gorra" or d.Name=="Visera") then d:Destroy() end
 end
 if role=="Hija" or role=="Invitada" then
  for _,name in ipairs({"LeftUpperArm","LeftLowerArm","RightUpperArm","RightLowerArm"}) do model[name].Color=skin end
  local foot=model.LeftFoot
  local distance=lower.Position.Y-(foot.Position.Y-foot.Size.Y/2)
  skirt(folder,lower,role=="Hija" and ivory or Color3.fromRGB(215,166,58),distance,role=="Invitada")
  local gui=panel(folder,torso,"Corpiño",role=="Hija" and ivory or Color3.fromRGB(215,166,58))
  rectangle(gui,"Escote",.5,.1,.36,.20,skin,45)
  for i=1,4 do rectangle(gui,"Perla",.5,.28+i*.12,.025,.025,gold,0,true) end
  for _,name in ipairs({"LeftFoot","RightFoot"}) do model[name].Color=role=="Hija" and ivory or gold end
  local head=model.Head;local hat=head:FindFirstChild("HatAttachment")
  local top=hat and hat.Position.Y or .6
  for i=-4,4 do
   local t=i*.19
   local p=piece(folder,head,"PerlaDiadema",Vector3.new(.09,.09,.09),CFrame.new(math.sin(t)*.53,top+.14,math.cos(t)*-.44),role=="Hija" and ivory or gold,Enum.PartType.Ball)
   p:SetAttribute("HR_Velo",true)
  end
  if role=="Hija" then
   for i=-2,2 do
    local veil=piece(folder,head,"Velo",Vector3.new(.36,2.55,.025),CFrame.new(i*.32,top-1.12,.66+math.abs(i)*.04)*CFrame.Angles(0,math.rad(i*5),0),ivory)
    veil.Transparency=.62;veil:SetAttribute("HR_Velo",true)
   end
   for i=-2,2 do
    local lace=piece(folder,head,"EncajeVelo",Vector3.new(.37,.035,.035),CFrame.new(i*.32,top-2.39,.66+math.abs(i)*.04),ivory)
    lace.Transparency=.2;lace:SetAttribute("HR_Velo",true)
   end
  end
 else
  local suit=role=="Madre" and Color3.fromRGB(54,39,64) or dark
  local gui=panel(folder,torso,"PecheraTraje",suit)
  rectangle(gui,"Camisa",.5,.38,.36,.77,ivory)
  rectangle(gui,"SolapaIzquierda",.29,.45,.17,.8,suit,-20)
  rectangle(gui,"SolapaDerecha",.71,.45,.17,.8,suit,20)
  rectangle(gui,"Nudo",.5,.18,.10,.10,role=="Madre" and gold or dark,45)
  if role=="Novio" then
   rectangle(gui,"PajaritaI",.42,.17,.17,.10,dark,-15)
   rectangle(gui,"PajaritaD",.58,.17,.17,.10,dark,15)
   rectangle(gui,"Pañuelo",.80,.40,.14,.07,ivory,-7)
  else rectangle(gui,"Corbata",.5,.44,.08,.43,gold) end
  for i=1,3 do rectangle(gui,"Boton",.5,.59+i*.1,.028,.028,gold,0,true) end
  for _,side in ipairs({"Left","Right"}) do
   local arm=model[side.."LowerArm"]
   piece(folder,arm,"PuñoCamisa",Vector3.new(arm.Size.X*1.02,.13,arm.Size.Z*1.02),CFrame.new(0,-arm.Size.Y*.40,0),ivory)
   model[side.."Foot"].Color=Color3.fromRGB(23,24,29)
  end
  if role=="Madre" then
   local hand=model.LeftHand
   piece(folder,hand,"Libro",Vector3.new(.55,.77,.11),CFrame.new(0,-.05,-.38)*CFrame.Angles(math.rad(-15),0,0),Color3.fromRGB(50,30,53))
   piece(folder,hand,"Paginas",Vector3.new(.49,.70,.08),CFrame.new(0,-.05,-.45)*CFrame.Angles(math.rad(-15),0,0),ivory)
  end
 end
 h.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None
end
return V
