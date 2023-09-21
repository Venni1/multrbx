local ServerStorage = game:GetService('ServerStorage')
local StarterGui = game:GetService('StarterGui')

local RobloxGui = game:GetService("CoreGui").RobloxGui
local Create = require(RobloxGui.Modules.Mobile.Create)

return function(position, size)
	local AppGui = {}

	AppGui.ScreenGui = ServerStorage:WaitForChild('ScreenGuiV2'):Clone()
	AppGui.ScreenGui.Name = 'ScreenGui'
	AppGui.EdgeShadingGui = StarterGui:WaitForChild('EdgeShading'):Clone()
	AppGui.EdgeShadingGui.Name = 'EdgeShadingGui'

	AppGui.EdgeShadingGui.DisplayOrder = 0
	AppGui.ScreenGui.DisplayOrder = 2

	AppGui.RootGui = Create"Frame"
	{
		Position = position;
		Size = size;
		BackgroundTransparency = 1;
		Name = "RootGui";
	}

	for _,child in pairs(AppGui.ScreenGui:GetChildren()) do
		child.Parent = AppGui.RootGui
	end
	AppGui.RootGui.Parent = AppGui.ScreenGui

	return AppGui;
end

