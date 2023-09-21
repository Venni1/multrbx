local PlayerService = game:GetService("Players")

local Modules = script.Parent.Parent
local Text = require(Modules.Text)
local GetUsername = require(Modules.Actions.GetUsername)
local PaddedImageButton = require(Modules.Components.PaddedImageButton)
local Constants = require(Modules.Constants)
local DialogInfo = require(Modules.DialogInfo)

local BaseHeader = {}

--[[
	This type of pseudo-inheritance for components is usually bad, but this is a special exception.
	It is not recommended to do this.
]]
function BaseHeader:Template()
	local class = {}
	for key, value in pairs(self) do
		class[key] = value
	end
	return class
end

function BaseHeader:SetTitle(text)

	local label = self.rbx.Header.Content.Titles.Title
	label.Text = text

	Text.TruncateTextLabel(label, "...")

	self.title = text
end

function BaseHeader:SetDefaultSubtitle()
	if (self.dialogType ~= DialogInfo.DialogType.Centered) and (self.dialogType ~= DialogInfo.DialogType.Left) then
		self:SetSubtitle("")
		return
	end

	local displayText = ""
	local player = PlayerService.localPlayer
	if player then
		local localUser = self.appState.store:GetState().Users[player.userId]
		if localUser then
			if player:GetUnder13() then
				displayText = string.format("%s: <13", localUser.name)
			else
				displayText = string.format("%s: 13+", localUser.name)
			end
		else
			self.appState.store:Dispatch(GetUsername(player.userId))
			return
		end
	end

	self:SetSubtitle(displayText)
end

--[[
	Sets the Header's subtitle

	Pass an empty string to hide the subtitle completely.

	Otherwise pass nil to default to the userAge label.
]]
function BaseHeader:SetSubtitle(displayText)
	assert(type(displayText) == "nil" or type(displayText) == "string",
		"Invalid argument number #1 to SetSubtitle, expected string or nil.")

	self.subtitle = displayText

	if displayText == "" then
		self.rbx.Header.Content.Titles.Subtitle.Visible = false
	else
		self.rbx.Header.Content.Titles.Subtitle.Visible = true
		self.rbx.Header.Content.Titles.Subtitle.Text = displayText
	end
end

function BaseHeader:SetBackButtonEnabled(enabled)
	self.backButton.rbx.Visible = enabled
end


function BaseHeader:AddButton(button)
	table.insert(self.buttons, button)
	button.rbx.Parent = self.rbx.Header.Content.Buttons
	button.rbx.LayoutOrder = #self.buttons
end

function BaseHeader:AddContent(content)
	content.rbx.Parent = self.rbx.Header.Content
end

function BaseHeader:SetConnectionState(connectionState)
	if not self.subtitle then
		self:SetDefaultSubtitle()
	end

	if self.dialogType == DialogInfo.DialogType.Right then
		return
	end

	if connectionState ~= self.connectionState and self.rbx.Parent ~= nil and self.rbx.Parent.Parent ~= nil then
		if connectionState == Enum.ConnectionState.Disconnected then
			-- Tween in the header size to accomodate the disconnect message:
			local size = UDim2.new(1, 0, 0, self.heightOfHeader + self.heightOfDisconnected)
			self.rbx:TweenSize(size, Enum.EasingDirection.Out, Constants.Tween.PHONE_TWEEN_STYLE,
				Constants.Tween.PHONE_TWEEN_TIME, true);

			-- At the same time as we increase the header size, reveal the message itself:
			local sizeDisconnect = UDim2.new(1, 0, 0, self.heightOfDisconnected)
			self.rbx.Disconnected:TweenSize(sizeDisconnect, Enum.EasingDirection.Out, Constants.Tween.PHONE_TWEEN_STYLE,
				Constants.Tween.PHONE_TWEEN_TIME, true)
			self.rbx.Disconnected.Visible = true
		else
			-- Tween the header back to conceal the disconnect message:
			local size = UDim2.new(1, 0, 0, self.heightOfHeader)
			self.rbx:TweenSize(size, Enum.EasingDirection.In, Constants.Tween.PHONE_TWEEN_STYLE,
				Constants.Tween.PHONE_TWEEN_TIME, true);

			-- Immediately scale the disconnect message back down to nothing and hide it:
			local sizeDisconnect = UDim2.new(1, 0, 0, 0)
			self.rbx.Disconnected.Size = sizeDisconnect
			self.rbx.Disconnected.Visible = false
		end
		self.connectionState = connectionState
	end
end

function BaseHeader:GetNewBackButton()
	return PaddedImageButton.new(self.appState, "Back", Constants.PlatformSpecific.BACK_BUTTON_ASSET_ID)
end

function BaseHeader:Destroy()
	for _, conn in pairs(self.connections) do
		conn:Disconnect()
	end
	self.connections = {}
end

return BaseHeader