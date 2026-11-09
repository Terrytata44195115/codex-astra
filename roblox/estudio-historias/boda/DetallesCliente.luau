-- Lagrimas y dos corazones locales; no sustituye ni oculta el renderer facial.
local Run=game:GetService("RunService")
local stage=workspace:WaitForChild("HR_BodaActores",25)
if not stage then return end
local bride=stage:WaitForChild("Hija",15)
if not bride then return end
local groom=stage:WaitForChild("Novio",15)
local guest=stage:WaitForChild("Invitada",15)
local heart=Instance.new("BillboardGui");heart.Name="HR_CorazonesBoda";heart.Adornee=groom.Head
heart.Size=UDim2.fromOffset(100,70);heart.StudsOffset=Vector3.new(0,1.45,0);heart.AlwaysOnTop=false;heart.Enabled=false;heart.Parent=groom.Head
local label=Instance.new("TextLabel");label.Size=UDim2.fromScale(1,1);label.BackgroundTransparency=1;label.Text="♥  ♥";label.TextColor3=Color3.fromRGB(235,65,100);label.TextSize=36;label.Font=Enum.Font.GothamBold;label.Parent=heart
local folder=game:GetService("ReplicatedStorage"):WaitForChild("HR_Boda",15)
local C=require(folder:WaitForChild("Configuracion",10))
local binding="HR_BodaDetalles"
Run:BindToRenderStep(binding,Enum.RenderPriority.Camera.Value+12,function()
 local support=workspace:FindFirstChild("HR_CarasBodaLocales")
 local face=support and support:FindFirstChild("HR_Cara_Hija")
 local gui=face and face:FindFirstChild("HR_ExpresionVisible")
 if gui then
  local tears=gui:FindFirstChild("HR_LagrimasBoda")
  if not tears then
   tears=Instance.new("Frame");tears.Name="HR_LagrimasBoda";tears.Size=UDim2.fromScale(1,1);tears.BackgroundTransparency=1;tears.Parent=gui
   for _,x in ipairs({.33,.67}) do
    local f=Instance.new("Frame");f.Position=UDim2.fromScale(x-.028,.51);f.Size=UDim2.fromScale(.056,.24)
    f.BackgroundColor3=Color3.fromRGB(85,188,236);f.BackgroundTransparency=.12;f.BorderSizePixel=0;f.Parent=tears
    local round=Instance.new("UICorner");round.CornerRadius=UDim.new(1,0);round.Parent=f
   end
  end
  tears.Visible=bride.Head:GetAttribute("HR_Lagrimas")==true
 end
 local start=folder:GetAttribute("Inicio");local t=start and workspace:GetServerTimeNow()-start or -1
 heart.Enabled=t>=10.6 and t<=C.Duracion+.5 and groom.Head.LocalTransparencyModifier<.99
 heart.StudsOffset=Vector3.new(0,1.45+math.sin(t*5)*.10,0)
end)
script.Destroying:Connect(function() Run:UnbindFromRenderStep(binding);heart:Destroy() end)
