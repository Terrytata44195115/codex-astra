local function signal()
 local callbacks={}
 return {
  Connect=function(_,callback)
   local c={active=true};callbacks[c]=callback
   c.Disconnect=function() c.active=false end
   return c
  end,
  Fire=function() for c,fn in pairs(callbacks) do if c.active then fn() end end end,
 }
end
function methods:WaitForChild(name) return self:FindFirstChild(name) end
function methods:FindFirstChildOfClass(name) for _,c in ipairs(self.children) do if c.ClassName==name then return c end end end
function methods:GetChildren() local t={} for _,c in ipairs(self.children) do table.insert(t,c) end return t end
function methods:ClearAllChildren() while #self.children>0 do self.children[1]:Destroy() end end
function methods:GetAttributeChangedSignal(name)
 if not self.signals then self.signals={} end
 if not self.signals[name] then self.signals[name]=signal() end
 return self.signals[name]
end
local originalSet=methods.SetAttribute
function methods:SetAttribute(name,value)
 local old=self:GetAttribute(name)
 originalSet(self,name,value)
 if old~=value and self.signals and self.signals[name] then self.signals[name]:Fire() end
end
Vector2={new=function(x,y) return {X=x,Y=y} end}
Vector3={new=function(x,y,z) return {X=x,Y=y,Z=z} end}
UDim={new=function(a,b) return {a,b} end}
UDim2={fromScale=function(a,b) return {a,b} end}
Color3={fromRGB=function(r,g,b)return {R=r/255,G=g/255,B=b/255}end}
local cfMeta={}
local function cf(x,y,z,yaw) return setmetatable({X=x,Y=y,Z=z,yaw=yaw or 0},cfMeta) end
cfMeta.__mul=function(a,b)
 local c,s=math.cos(a.yaw),math.sin(a.yaw)
 return cf(a.X+c*b.X+s*b.Z,a.Y+b.Y,a.Z-s*b.X+c*b.Z,a.yaw+b.yaw)
end
CFrame={new=function(x,y,z)return cf(x,y,z)end,Angles=function(_,y,_)return cf(0,0,0,y)end}
Enum={NormalId={Front=5},SurfaceGuiSizingMode={FixedSize=1},RenderPriority={Camera={Value=200}}}
do
 local svc,sps=setup()
 install()
 local protected={}
 for _,item in ipairs({svc.ReplicatedStorage.HR_PruebaReparto.Configuracion,svc.ReplicatedStorage.HR_PruebaReparto.Interpretacion,svc.ServerScriptService.HR_PruebaRepartoServidor,sps.HR_PruebaRepartoCamara}) do protected[item]=item.Source end
 patchFaces()
 for item,source in pairs(protected) do assert(item.Source==source) end
 local headByRole={}
 local stage=make("Folder","HR_PruebaActores",workspace,"HR_PRUEBA_REPARTO_1")
 for i,role in ipairs({"Madre","Hija","Novio"}) do
  local model=make("Model",role,stage)
  local head=make("Part","Head",model)
  head.CFrame=CFrame.new(i*3,5,12);head.Size=Vector3.new(1.9,0.95,0.95);head.LocalTransparencyModifier=0
  local front=make("Attachment","FaceFrontAttachment",head);front.Position=Vector3.new(0,0,-0.57)
  local hat=make("Attachment","HatAttachment",head);hat.Position=Vector3.new(0,0.57,0)
  local mesh=make("SpecialMesh","Mesh",head);mesh.Scale=Vector3.new(1.25,1.25,1.25)
  local decal=make("Decal","face",head);decal.Face=5;decal.Transparency=0;decal.LocalTransparencyModifier=0
  head:SetAttribute("HR_Expresion","ALEGRE");head:SetAttribute("HR_MascaraTextura",role=="Novio")
  headByRole[role]=head
 end
 local callbacks={}
 function svc.RunService:BindToRenderStep(name,priority,callback) assert(priority==211);callbacks[name]=callback end
 function svc.RunService:UnbindFromRenderStep(name) callbacks[name]=nil end
 local function tick() local c={} for _,fn in pairs(callbacks) do table.insert(c,fn) end for _,fn in ipairs(c) do fn() end end
 script=sps.HR_CarasMarcos;script.Destroying=signal()
 launchFaces()
 tick()
 local folder=workspace.HR_SoportesCaraLocales
 assert(folder and #folder.children==3)
 for role,head in pairs(headByRole) do
  local support=folder:FindFirstChild("HR_Cara_"..role)
  local gui=support.HR_ExpresionVisible
  assert(support.Parent==folder and support.Anchored and support.Transparency==1)
  assert(not support.CanCollide and not support.CanQuery and not support.CanTouch)
  assert(math.abs(support.Size.X-1.14)<0.001)
  assert(support.CFrame.Z-head.CFrame.Z<-(head.Size.Z*1.25/2))
  assert(gui.Adornee==support and not gui.AlwaysOnTop and gui.Enabled)
  assert(#gui.children==1 and #gui.children[1].children>=8)
  assert(head.face.Transparency==1)
 end
 local mother=headByRole.Madre
 local support=folder.HR_Cara_Madre
 local oldCanvas=support.HR_ExpresionVisible.children[1]
 mother:SetAttribute("HR_Expresion","ALARMA")
 assert(oldCanvas.Parent==nil and support.HR_ExpresionVisible.children[1]~=oldCanvas)
 local offsetZ=support.CFrame.Z-mother.CFrame.Z
 mother.CFrame=CFrame.new(30,8,-12)*CFrame.Angles(0,math.pi/2,0)
 tick()
 assert(math.abs(support.CFrame.X-(30+offsetZ))<0.001 and math.abs(support.CFrame.Z+12)<0.001)
 headByRole.Novio.LocalTransparencyModifier=1
 tick();assert(not folder.HR_Cara_Novio.HR_ExpresionVisible.Enabled)
 headByRole.Novio.LocalTransparencyModifier=0
 tick();assert(folder.HR_Cara_Novio.HR_ExpresionVisible.Enabled)
 stage.Parent=nil
 tick();assert(folder.Parent==nil and next(callbacks)==nil)
 for _,head in pairs(headByRole) do assert(head.face.Transparency==0 and head.face.LocalTransparencyModifier==0) end
 for item,source in pairs(protected) do assert(item.Source==source) end
end
do
 local svc,sps=setup(6)
 install()
 local previous=sps.HR_CarasMarcos.Source
 sps.HR_CarasMarcos.Enabled=false
 assert(not pcall(patchFaces))
 assert(sps.HR_CarasMarcos.Source==previous and not sps.HR_CarasMarcos.Enabled)
end
return "PASS: only facial client updated; 3 independent supports, outward offset, expression redraw, head translation/rotation, cut visibility and cleanup; write failure restores prior client. Studio visuals pending."
