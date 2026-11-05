-- Expresiones de cara como Decal: las imagenes se crean en el cliente de Studio.
-- No cambia las poses, la palidez, los Motor6D ni los tiempos de la historia.
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
function B.Preparar(actor)
 local head=actor.model.Head
 actor.skin={}
 for _,name in ipairs({"Head","LeftHand","RightHand"}) do
  local part=actor.model:FindFirstChild(name)
  if part then table.insert(actor.skin,{part=part,color=part.Color}) end
 end
 -- Ya no se oculta la cara original antes de disponer de una textura nueva.
 local legacy=head:FindFirstChild("HR_CaraDibujada")
 if legacy and legacy:IsA("SurfaceGui") then legacy:Destroy() end
end
function B.Cara(actor,key)
 if actor.faceKey==key then return end
 actor.faceKey=key
 actor.model.Head:SetAttribute("HR_Expresion",key)
end
function B.Palidez(actor,amount)
 for _,entry in ipairs(actor.skin) do entry.part.Color=entry.color:Lerp(Color3.fromRGB(253,249,240),math.clamp(amount,0,1)*0.8) end
end
function B.Complementos(actor)
 local head=actor.model.Head
 local old=actor.model:FindFirstChild("Ultra-Fabulous Hair")
 if old then old:Destroy() end
 local folder=Instance.new("Folder");folder.Name="HR_GorraMascaraProvisional";folder.Parent=actor.model
 -- HatAttachment y FaceFrontAttachment son referencias de la superficie visual.
 -- Head.Size es la caja fisica y no describe el ancho real de MeshType.Head.
 local hat=head:FindFirstChild("HatAttachment")
 local face=head:FindFirstChild("FaceFrontAttachment")
 local top=hat and hat.Position.Y or head.Size.Y*0.6
 local radius=face and math.abs(face.Position.Z) or head.Size.Z*0.6
 local diameter=math.max(radius*2,top*2,0.5)
 local function dome(name,size,offset)
  local part=Instance.new("Part")
  part.Name=name;part.Size=size;part.Transparency=0;part.Color=Color3.fromRGB(22,24,31)
  part.Material=Enum.Material.SmoothPlastic;part.CanCollide=false;part.CanTouch=false;part.CanQuery=false
  part.Massless=true;part.CastShadow=false;part.Anchored=false;part.CFrame=head.CFrame*offset
  part:SetAttribute("HR_Complemento",true);part.Parent=folder
  local mesh=Instance.new("SpecialMesh");mesh.MeshType=Enum.MeshType.Sphere;mesh.Scale=Vector3.new(1,1,1);mesh.Parent=part
  local weld=Instance.new("Weld");weld.Part0=head;weld.Part1=part;weld.C0=offset;weld.C1=CFrame.identity;weld.Parent=part
 end
 dome("Gorra",Vector3.new(diameter*1.06,diameter*0.28,diameter*1.03),CFrame.new(0,top+diameter*0.015,0))
 dome("Visera",Vector3.new(diameter*0.90,diameter*0.055,diameter*0.70),CFrame.new(0,top-diameter*0.10,-radius*0.90))
 -- La mascara se pinta sobre la textura de cara; no hay bloques delante de ojos y nariz.
 head:SetAttribute("HR_MascaraTextura",true)
end

B.EstadosCara={"NEUTRA","ALEGRE","INQUIETA","VERGUENZA","ENFADADA","ALARMA"}
B.ResolucionCara=256
function B.PixelesCara(key,masked)
 local n=B.ResolucionCara
 local pixels=buffer.create(n*n*4)
 local function blend(x,y,color,alpha)
  if x<0 or y<0 or x>=n or y>=n or alpha<=0 then return end
  local i=(y*n+x)*4
  local old=buffer.readu8(pixels,i+3)/255
  local out=alpha+old*(1-alpha)
  if out<=0 then return end
  for c=0,2 do
   local v=(color[c+1]*alpha+buffer.readu8(pixels,i+c)*old*(1-alpha))/out
   buffer.writeu8(pixels,i+c,math.floor(math.clamp(v,0,255)+0.5))
  end
  buffer.writeu8(pixels,i+3,math.floor(math.clamp(out,0,1)*255+0.5))
 end
 local function ellipse(cx,cy,rx,ry,color,opacity)
  cx*=n;cy*=n;rx*=n;ry*=n
  for y=math.max(0,math.floor(cy-ry-1)),math.min(n-1,math.ceil(cy+ry+1)) do
   for x=math.max(0,math.floor(cx-rx-1)),math.min(n-1,math.ceil(cx+rx+1)) do
    local distance=math.sqrt(((x+0.5-cx)/rx)^2+((y+0.5-cy)/ry)^2)
    local coverage=math.clamp((1-distance)*math.min(rx,ry)+0.5,0,1)
    blend(x,y,color,coverage*(opacity or 1))
   end
  end
 end
 local function stroke(x1,y1,x2,y2,width,color)
  x1*=n;y1*=n;x2*=n;y2*=n;width*=n
  local dx,dy=x2-x1,y2-y1
  local length=dx*dx+dy*dy
  for y=math.max(0,math.floor(math.min(y1,y2)-width-1)),math.min(n-1,math.ceil(math.max(y1,y2)+width+1)) do
   for x=math.max(0,math.floor(math.min(x1,x2)-width-1)),math.min(n-1,math.ceil(math.max(x1,x2)+width+1)) do
    local t=length>0 and math.clamp(((x+0.5-x1)*dx+(y+0.5-y1)*dy)/length,0,1) or 0
    local distance=math.sqrt((x+0.5-x1-t*dx)^2+(y+0.5-y1-t*dy)^2)
    blend(x,y,color,math.clamp(width/2+0.5-distance,0,1))
   end
  end
 end
 local ink={26,22,28};local white={255,254,250}
 local alarm=key=="ALARMA"
 local happy=key=="ALEGRE"
 local shy=key=="VERGUENZA"
 local worried=key=="INQUIETA" or shy
 local angry=key=="ENFADADA"
 if masked then
  ellipse(0.5,0.82,0.43,0.26,{23,26,34})
  stroke(0.22,0.66,0.78,0.66,0.012,{62,65,75})
 end
 for _,x in ipairs({0.34,0.66}) do
  if happy or shy then
   local sign=happy and -1 or 1
   stroke(x-0.065,0.425,x,0.425+sign*0.04,0.021,ink)
   stroke(x,0.425+sign*0.04,x+0.065,0.425,0.021,ink)
  elseif alarm then
   ellipse(x,0.42,0.076,0.103,ink)
   ellipse(x,0.42,0.062,0.088,white)
   ellipse(x,0.43,0.024,0.037,ink)
  else
   ellipse(x,0.42,0.034,0.055,ink)
   ellipse(x-0.009,0.40,0.010,0.013,white)
  end
 end
 local tilt=angry and 0.04 or worried and -0.035 or 0
 local eyebrowY=alarm and 0.245 or 0.285
 stroke(0.25,eyebrowY-tilt,0.41,eyebrowY+tilt,0.018,ink)
 stroke(0.59,eyebrowY+tilt,0.75,eyebrowY-tilt,0.018,ink)
 if not masked then
  if alarm then
   ellipse(0.5,0.71,0.072,0.104,ink)
   ellipse(0.5,0.775,0.040,0.021,{223,111,133})
  elseif happy then
   stroke(0.39,0.665,0.45,0.715,0.019,ink)
   stroke(0.45,0.715,0.55,0.715,0.019,ink)
   stroke(0.55,0.715,0.61,0.665,0.019,ink)
  elseif worried or angry then
   stroke(0.42,0.725,0.50,0.69,0.019,ink)
   stroke(0.50,0.69,0.58,0.725,0.019,ink)
  else
   stroke(0.43,0.69,0.50,0.71,0.018,ink)
   stroke(0.50,0.71,0.57,0.69,0.018,ink)
  end
 end
 if (happy or shy) and not masked then
  ellipse(0.235,0.59,0.053,0.027,{246,137,153},0.45)
  ellipse(0.765,0.59,0.053,0.027,{246,137,153},0.45)
 end
 if alarm or key=="INQUIETA" then ellipse(0.82,0.34,0.019,0.043,{112,198,237},0.95) end
 return pixels
end
return B
