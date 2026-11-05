-- Caras dibujadas sobre SurfaceGui: no dependen de IDs de texturas externas.
-- Las poses reutilizan los Motor6D presentes; no se reconstruye el rig.
local B={}
local function a(x,y,z) return CFrame.Angles(math.rad(x or 0),math.rad(y or 0),math.rad(z or 0)) end
function B.Pose(key,t)
 local p={}
 local pulse=math.sin(t*5)
 if key=="ILUSION" then
  p.RightShoulder=a(25+pulse*4,0,-30);p.LeftShoulder=a(25-pulse*4,0,30)
  p.RightElbow=a(48);p.LeftElbow=a(48);p.Neck=a(-4,0,pulse*2)
 elseif key=="PRESENTAR" then
  p.RightShoulder=a(55,0,-40);p.RightElbow=a(35);p.RightWrist=a(0,25)
  p.LeftElbow=a(15);p.Waist=a(2,5)
 elseif key=="SUSTO" then
  p.RightShoulder=a(90,0,-20);p.LeftShoulder=a(90,0,20)
  p.RightElbow=a(118+pulse*2);p.LeftElbow=a(118-pulse*2)
  p.Neck=a(-9,0,5);p.Waist=a(-10,0,pulse)
 elseif key=="INCOMODA" then
  p.LeftShoulder=a(12,0,8);p.LeftElbow=a(35);p.Neck=a(8,0,-5)
 elseif key=="NEGAR" then
  p.Neck=a(5,math.sin(t*7)*12,-4)
  p.RightShoulder=a(30,0,-30);p.RightElbow=a(65);p.LeftElbow=a(20)
 elseif key=="SENALAR" or key=="SENALAR_GORRA" then
  local up=key=="SENALAR_GORRA" and 95 or t<1.4 and 75 or 35
  p.RightShoulder=a(up,0,-12);p.RightElbow=a(12);p.Waist=a(5,0,-2)
 elseif key=="TAPAR_CARA" then
  p.RightShoulder=a(60,0,-8);p.LeftShoulder=a(60,0,8)
  p.RightElbow=a(126);p.LeftElbow=a(126);p.Neck=a(14);p.Waist=a(4)
 elseif key=="RESIGNADO" then
  p.RightShoulder=a(25,0,-55);p.LeftShoulder=a(25,0,55)
  p.RightElbow=a(85);p.LeftElbow=a(85);p.Neck=a(4,0,pulse*2)
 elseif key=="MANO_GORRA" then
  p.RightShoulder=a(95,0,-10);p.RightElbow=a(112);p.Neck=a(6)
 end
 return p
end
local function oval(parent,x,y,w,h,color)
 local f=Instance.new("Frame")
 f.AnchorPoint=Vector2.new(0.5,0.5);f.Position=UDim2.fromScale(x,y);f.Size=UDim2.fromScale(w,h)
 f.BackgroundColor3=color;f.BorderSizePixel=0;f.Parent=parent
 local r=Instance.new("UICorner");r.CornerRadius=UDim.new(1,0);r.Parent=f
 return f
end
local function line(parent,x1,y1,x2,y2,width,color)
 local f=Instance.new("Frame")
 f.AnchorPoint=Vector2.new(0.5,0.5);f.Position=UDim2.fromScale((x1+x2)/2,(y1+y2)/2)
 f.Size=UDim2.fromScale(math.sqrt((x2-x1)^2+(y2-y1)^2),width)
 f.Rotation=math.deg(math.atan2(y2-y1,x2-x1));f.BorderSizePixel=0;f.BackgroundColor3=color;f.Parent=parent
 return f
end
function B.Preparar(actor)
 local head=actor.model.Head
 actor.skin={}
 for _,name in ipairs({"Head","LeftHand","RightHand"}) do
  local part=actor.model:FindFirstChild(name)
  if part then table.insert(actor.skin,{part=part,color=part.Color}) end
 end
 for _,item in ipairs(head:GetChildren()) do
  if item:IsA("Decal") and item.Face==Enum.NormalId.Front then item.Transparency=1 end
 end
 local gui=Instance.new("SurfaceGui")
 gui.Name="HR_CaraDibujada";gui.Adornee=head;gui.Face=Enum.NormalId.Front
 gui.SizingMode=Enum.SurfaceGuiSizingMode.FixedSize;gui.CanvasSize=Vector2.new(512,512)
 gui.AlwaysOnTop=false;gui.LightInfluence=0;gui.Parent=head
 actor.faceGui=gui
end
function B.Cara(actor,key)
 if actor.faceKey==key then return end
 actor.faceKey=key
 actor.faceGui:ClearAllChildren()
 local container=Instance.new("Frame")
 container.Size=UDim2.fromScale(1,1);container.BackgroundTransparency=1;container.Parent=actor.faceGui
 local ink=Color3.fromRGB(27,21,26)
 local white=Color3.fromRGB(255,255,250)
 local alarm=key=="ALARMA"
 local happy=key=="ALEGRE"
 local worried=key=="INQUIETA" or key=="VERGUENZA"
 for _,x in ipairs({0.33,0.67}) do
  if happy then
   line(container,x-0.07,0.43,x,0.39,0.022,ink)
   line(container,x,0.39,x+0.07,0.43,0.022,ink)
  else
   local eye=oval(container,x,0.42,alarm and 0.19 or 0.14,alarm and 0.25 or 0.17,ink)
   oval(eye,0.5,0.5,0.78,0.82,white)
   local pupil=oval(eye,0.5,0.53,alarm and 0.27 or 0.43,alarm and 0.40 or 0.60,ink)
   oval(pupil,0.28,0.23,0.3,0.2,white)
  end
 end
 local leftTilt=key=="ENFADADA" and 0.05 or worried and -0.045 or 0
 line(container,0.23,0.27-leftTilt,0.41,0.27+leftTilt,0.026,ink)
 line(container,0.59,0.27+leftTilt,0.77,0.27-leftTilt,0.026,ink)
 if alarm then
  local mouth=oval(container,0.5,0.72,0.19,0.22,ink)
  oval(mouth,0.5,0.80,0.60,0.20,Color3.fromRGB(237,133,150))
 elseif happy then
  line(container,0.38,0.66,0.45,0.72,0.025,ink)
  line(container,0.45,0.72,0.55,0.72,0.025,ink)
  line(container,0.55,0.72,0.62,0.66,0.025,ink)
 else
  line(container,0.40,0.70,0.5,0.68,0.025,ink)
  line(container,0.5,0.68,0.60,0.70,0.025,ink)
 end
 if worried or happy then
  local l=oval(container,0.22,0.61,0.12,0.07,Color3.fromRGB(245,129,147));l.BackgroundTransparency=0.35
  local r=oval(container,0.78,0.61,0.12,0.07,Color3.fromRGB(245,129,147));r.BackgroundTransparency=0.35
 end
 if alarm or key=="INQUIETA" then
  local sweat=oval(container,0.84,0.34,0.055,0.12,Color3.fromRGB(112,204,255));sweat.Rotation=-20
 end
end
function B.Palidez(actor,amount)
 for _,entry in ipairs(actor.skin) do entry.part.Color=entry.color:Lerp(Color3.fromRGB(253,249,240),math.clamp(amount,0,1)*0.8) end
end
-- Complementos estilizados de previsualizacion; no necesitan cargar recursos ajenos.
-- Conservan el cuerpo, la ropa y el esqueleto del avatar elegido.
function B.Complementos(actor)
 local head=actor.model.Head
 local old=actor.model:FindFirstChild("Ultra-Fabulous Hair")
 if old then old:Destroy() end
 local folder=Instance.new("Folder");folder.Name="HR_GorraMascaraProvisional";folder.Parent=actor.model
 local size=head.Size
 local function part(name,dimensions,offset,shape)
  local p=Instance.new("Part");p.Name=name;p.Size=dimensions;p.Color=Color3.fromRGB(24,25,32)
  p.Material=Enum.Material.Fabric;p.Anchored=false;p.CanCollide=false;p.Massless=true;p.CastShadow=false
  p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth
  p.Shape=shape or Enum.PartType.Block;p.CFrame=head.CFrame*offset
  p:SetAttribute("HR_Complemento",true);p.Parent=folder
  local w=Instance.new("Weld");w.Part0=head;w.Part1=p;w.C0=offset;w.C1=CFrame.identity;w.Parent=p
  return p
 end
 part("Gorra",Vector3.new(size.X*1.10,size.Y*0.48,size.Z*1.12),CFrame.new(0,size.Y*0.48,0),Enum.PartType.Ball)
 part("Visera",Vector3.new(size.Y*0.07,size.X*0.95,size.Z*0.95),CFrame.new(0,size.Y*0.30,-size.Z*0.65)*a(0,0,90),Enum.PartType.Cylinder)
 part("MascaraBaja",Vector3.new(size.X*1.035,size.Y*0.47,size.Z*1.035),CFrame.new(0,-size.Y*0.27,0))
 for _,sign in ipairs({-1,1}) do
  part("LateralMascara",Vector3.new(size.X*0.07,size.Y*0.75,size.Z*1.03),CFrame.new(sign*size.X*0.49,-size.Y*0.07,0))
 end
 part("ParteTraseraMascara",Vector3.new(size.X*1.03,size.Y*0.8,size.Z*0.08),CFrame.new(0,0,size.Z*0.48))
end
return B
