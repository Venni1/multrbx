
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LuaApp = CoreGui.RobloxGui.Modules.LuaApp
local StringsLocale = require(LuaApp.StringsLocale)

local Modules = script.Parent.Parent
local Components = Modules.Components
local Constants = require(Modules.Constants)
local Create = require(Modules.Create)

local Signal = require(Modules.Signal)

local User = require(Modules.Models.User)

local ListEntry = require(Components.ListEntry)
local UserThumbnail = require(Components.UserThumbnail)

local ICON_CELL_WIDTH = 60
local HEIGHT = 54

local function userPresenceToText(localization, presence, lastLocation)
	if presence == User.PresenceType.OFFLINE then
		return localization:Format(StringsLocale.Keys.OFFLINE)
	elseif presence == User.PresenceType.ONLINE then
		return localization:Format(StringsLocale.Keys.ONLINE)
	elseif presence == User.PresenceType.IN_GAME then
		if lastLocation ~= nil then
			return lastLocation
		else
			return localization:Format(StringsLocale.Keys.ONLINE)
		end
	elseif presence == User.PresenceType.IN_STUDIO then
		if lastLocation ~= nil then
			return lastLocation
		else
			return localization:Format(StringsLocale.Keys.ONLINE)
		end
	end
end

local UserEntry = {}
UserEntry.__index = UserEntry

function UserEntry.new(appState, user, icon, selected)
	local self = {
		user = user,
		appState = appState,
	}
	setmetatable(self, UserEntry)

	self.icon = icon or "rbxasset://textures/ui/LuaChat/graphic/ic-checkbox.png"

	local listEntry = ListEntry.new(appState, HEIGHT)
	self.rbx = listEntry.rbx

	local userThumbnail = UserThumbnail.new(appState, user.id, true)
	userThumbnail.rbx.Size = UDim2.new(0, 36, 0, 36)
	userThumbnail.rbx.Position = UDim2.new(0.5, 0, 0.5, 0)
	userThumbnail.rbx.AnchorPoint = Vector2.new(0.5, 0.5)
	self.userThumbnail = userThumbnail

	local userThumbnailFrame = Create.new"Frame" {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(0, ICON_CELL_WIDTH, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		userThumbnail.rbx,
	}
	userThumbnailFrame.Parent = self.rbx

	local label = Create.new"TextLabel" {
		Name = "Label",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -ICON_CELL_WIDTH, 0.75, 0),
		Position = UDim2.new(0, ICON_CELL_WIDTH, 0, 0),
		TextSize = 18,
		TextColor3 = Constants.Color.GRAY1,
		Font = Enum.Font.SourceSans,
		Text = user.name,
		TextXAlignment = Enum.TextXAlignment.Left,
	}
	label.Parent = self.rbx

	local sublabel = Create.new"TextLabel" {
		Name = "SubLabel",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -ICON_CELL_WIDTH, 0.35, 0),
		Position = UDim2.new(0, ICON_CELL_WIDTH, 0.55, 0),
		TextSize = 14,
		TextColor3 = Constants.Color.GRAY2,
		Font = Enum.Font.SourceSans,
		Text = userPresenceToText(appState.localization, user.presence, user.lastLocation),
		TextXAlignment = Enum.TextXAlignment.Left,
	}
	sublabel.Parent = self.rbx

	local value = Create.new"ImageLabel" {
		Name = "Icon",
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 20, 0, 20),
		Position = UDim2.new(1, -32, .5, 0),
		Image = self.icon,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Visible = user.id ~= tostring(Players.LocalPlayer.UserId),
	}
	value.Parent = self.rbx

	local divider = Create.new"Frame" {
		Name = "Divider",
		BackgroundColor3 = Constants.Color.GRAY4,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -ICON_CELL_WIDTH, 0, 1),
		Position = UDim2.new(0, ICON_CELL_WIDTH, 1, -1),
	}
	divider.Parent = self.rbx

	self:SetIsSelected(selected)

	self.tapped = Signal.new()

	listEntry.tapped:Connect(function()
		self.tapped:Fire()
	end)

	return self
end

function UserEntry:SetIsSelected(selected)
	if selected then
		self.rbx.Icon.Image = "rbxasset://textures/ui/LuaChat/graphic/ic-checkbox-on.png"
	else
		self.rbx.Icon.Image = self.icon
	end
end

function UserEntry:Update(user, selected)
	self.user = user
	self.rbx.Label.Text = user.name
	self.rbx.SubLabel.Text = userPresenceToText(self.appState.localization, user.presence, user.lastLocation)

	self:SetIsSelected(selected)

	if user.id == tostring(Players.LocalPlayer.UserId) then
		self.rbx.Icon.Visible = false
	else
		self.rbx.Icon.Visible = true
	end

	self.userThumbnail:Update(user)
end

return UserEntry