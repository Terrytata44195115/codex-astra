-- Installation transactions are tested without running the Roblox runtime code.
local methods={}
local function remove(parent,child)
 if not parent then return end
 for i,x in ipairs(parent.children) do if x==child then table.remove(parent.children,i);return end end
end
local mt={
 __index=function(self,key)
  if methods[key] then return methods[key] end
  local value=self.data[key]
  if value~=nil then return value end
  for _,x in ipairs(self.children) do if x.Name==key then return x end end
 end,
 __newindex=function(self,key,value)
  if key=="Parent" then
   remove(self.data.Parent,self)
   self.data.Parent=value
   if value then table.insert(value.children,self) end
  else self.data[key]=value end
 end,
}
Instance={new=function(class)
 return setmetatable({data={ClassName=class,Name=class,Enabled=class=="Script" or class=="LocalScript",Source=""},children={},attrs={}},mt)
end}
function methods:IsA(class) return self.ClassName==class or class=="BaseScript" and (self.ClassName=="Script" or self.ClassName=="LocalScript") end
function methods:FindFirstChild(name) for _,child in ipairs(self.children) do if child.Name==name then return child end end end
function methods:SetAttribute(key,value) self.attrs[key]=value end
function methods:GetAttribute(key) return self.attrs[key] end
function methods:IsDescendantOf(parent)
 local p=self.Parent
 while p do if p==parent then return true end;p=p.Parent end
 return false
end
function methods:Destroy()
 while #self.children>0 do self.children[1]:Destroy() end
 self.Parent=nil
end
local function make(class,name,parent,owner)
 local x=Instance.new(class);x.Name=name;x.Parent=parent
 if owner then x:SetAttribute("HR_Owner",owner) end
 return x
end
local function setup(failAt)
 workspace=make("Workspace","Workspace")
 local services={RunService={IsRunning=function() return false end}}
 for _,name in ipairs({"ReplicatedStorage","ServerStorage","ServerScriptService","StarterPlayer"}) do services[name]=make("Folder",name) end
 local sps=make("Folder","StarterPlayerScripts",services.StarterPlayer)
 local oldServer=make("Script","HR_CineServidor",services.ServerScriptService,"HR_Cine_V2")
 local oldCamera=make("LocalScript","HR_CineCamara",sps,"HR_Cine_V2")
 oldServer.Source="original server";oldCamera.Source="original camera";oldCamera.Enabled=false
 local cast=make("Folder","HR_EstudioReparto",services.ServerStorage,"HR_ESTUDIO_REPARTO_1")
 local characters=make("Folder","Personajes",cast)
 local roles=make("Folder","Reparto",cast)
 for _,role in ipairs({"Madre","Hija","Novio"}) do
  local actor=make("Model",role,characters)
  local link=make("ObjectValue",role,roles);link.Value=actor
 end
 local preview=make("Model","HR_RevisionReparto",workspace,"HR_ESTUDIO_REPARTO_1")
 local calls=0
 services.ScriptEditorService={
  GetEditorSource=function(_,obj) return obj.Source end,
  UpdateSourceAsync=function(_,obj,callback)
   calls+=1
   if calls==failAt then error("injected editor write failure") end
   obj.Source=callback(obj.Source)
  end,
 }
 game={GetService=function(_,name) assert(services[name],name);return services[name] end}
 return services,sps,oldServer,oldCamera,cast,preview
end
local function install()
__RUN_INSTALLER__
end
local function restore()
__RUN_RESTORE__
end
do
 local svc,sps,server,camera,cast,preview=setup()
 install()
 assert(not server.Enabled and not camera.Enabled)
 assert(svc.ServerScriptService.HR_PruebaRepartoServidor.Enabled)
 assert(sps.HR_PruebaRepartoCamara.Enabled)
 assert(server.Source=="original server" and camera.Source=="original camera")
 assert(preview.Parent==workspace and cast.Parent==svc.ServerStorage)
 local root=svc.ReplicatedStorage.HR_PruebaReparto
 local count=#svc.ReplicatedStorage.children
 install()
 assert(#svc.ReplicatedStorage.children==count and svc.ReplicatedStorage.HR_PruebaReparto==root)
 restore()
 assert(server.Enabled and not camera.Enabled)
 assert(not svc.ServerScriptService.HR_PruebaRepartoServidor.Enabled and not sps.HR_PruebaRepartoCamara.Enabled)
 assert(preview.Parent==svc.ServerStorage)
 install()
 assert(preview.Parent==workspace and not server.Enabled)
 restore()
 assert(server.Enabled and not camera.Enabled)
end
for failAt=1,3 do
 local svc,sps,server,camera,cast,preview=setup(failAt)
 assert(not pcall(install))
 assert(server.Enabled and not camera.Enabled)
 assert(server.Source=="original server" and camera.Source=="original camera")
 assert(not svc.ReplicatedStorage.HR_PruebaReparto)
 assert(not svc.ServerScriptService.HR_PruebaRepartoServidor and not sps.HR_PruebaRepartoCamara)
 assert(preview.Parent==workspace and cast.Parent==svc.ServerStorage)
end
do
 local svc,sps,server,camera=setup()
 local foreign=make("Script","HR_PruebaRepartoServidor",svc.ServerScriptService,"SOMEONE_ELSE")
 foreign.Source="do not touch"
 assert(not pcall(install))
 assert(server.Enabled and not camera.Enabled and foreign.Source=="do not touch")
 assert(not svc.ReplicatedStorage.HR_PruebaReparto)
end
return "PASS: install, repeat, restore, reactivate; all three write-failure rollbacks; foreign destination rejected. Runtime in Studio still pending."
