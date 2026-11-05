local preservedSource
local function snapshot(svc,sps)
 return {
  {svc.ReplicatedStorage.HR_PruebaReparto.Configuracion,svc.ReplicatedStorage.HR_PruebaReparto.Configuracion.Source},
  {svc.ServerScriptService.HR_PruebaRepartoServidor,svc.ServerScriptService.HR_PruebaRepartoServidor.Source},
  {sps.HR_PruebaRepartoCamara,sps.HR_PruebaRepartoCamara.Source},
 }
end
local function same(before)
 for _,entry in ipairs(before) do assert(entry[1].Source==entry[2],"Protected camera/timeline source changed") end
end
do
 local svc,sps=setup()
 install()
 local protected=snapshot(svc,sps)
 local module=svc.ReplicatedStorage.HR_PruebaReparto.Interpretacion
 module.Source=module.Source:gsub("p.LeftElbow=a%(48%)","p.LeftElbow=a(49)")
 sps.HR_CarasMarcos:Destroy()
 faceFix()
 assert(sps.HR_CarasMarcos.Enabled)
 same(protected)
 local after=module.Source
 assert(after:find("p.LeftElbow=a(49)",1,true),"Existing gesture adjustment was overwritten")
 preservedSource=after
 faceFix()
 assert(module.Source==after)
 same(protected)
end
for _,existing in ipairs({false,true}) do
 for failAt=1,2 do
  local svc,sps=setup(5+failAt)
  install()
  local protected=snapshot(svc,sps)
  local module=svc.ReplicatedStorage.HR_PruebaReparto.Interpretacion
  module.Source=module.Source.."\n-- prior interpretation\n"
  local priorModule=module.Source
  if existing then sps.HR_CarasMarcos.Source="prior client";sps.HR_CarasMarcos.Enabled=false
  else sps.HR_CarasMarcos:Destroy() end
  assert(not pcall(faceFix))
  assert(module.Source==priorModule)
  if existing then assert(sps.HR_CarasMarcos.Source=="prior client" and not sps.HR_CarasMarcos.Enabled)
  else assert(not sps.HR_CarasMarcos) end
  same(protected)
 end
end
do
 local svc,sps=setup()
 install()
 local protected=snapshot(svc,sps)
 local module=svc.ReplicatedStorage.HR_PruebaReparto.Interpretacion
 local original=module.Source
 sps.HR_CarasMarcos:SetAttribute("HR_Owner","someone else")
 assert(not pcall(faceFix))
 assert(module.Source==original)
 same(protected)
end
do
 local svc,sps=setup()
 install()
 local module=svc.ReplicatedStorage.HR_PruebaReparto.Interpretacion
 local original=module.Source
 svc.ReplicatedStorage.HR_PruebaReparto.Configuracion:Destroy()
 assert(not pcall(faceFix))
 assert(module.Source==original)
end
return "PASS: face-only install and repeat; rollback at both writes; protected camera/timeline and existing gesture adjustment preserved; foreign target rejected.",preservedSource
