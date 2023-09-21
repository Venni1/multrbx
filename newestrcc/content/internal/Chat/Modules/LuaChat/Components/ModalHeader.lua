local PlayerService = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LuaApp = CoreGui.RobloxGui.Modules.LuaApp
local StringsLocale = require(LuaApp.StringsLocale)

local Modules = script.Parent.Parent
local Components = Modules.Components

local Create = require(Modules.Create)
local Signal = require(Modules.Signal)
local Constants = require(Modules.Constants)

local ModalTextButton = require(Components.ModalTextButton)
local BaseHeader = require(Components.BaseHeader)
local PaddedImageButton = require(Components.PaddedImageButton)

local ICON_CELL_WIDTH = 60
local HEIGHT_OF_HEADER = 44
local HEIGHT_OF_DISCONNECTED = 32
local HEIGHT_OF_BORDER = 1

local TOTAL_HEIGHT_OF_HEADER = HEIGHT_OF_HEADER + HEIGHT_OF_BORDER

local ModalHeader = BaseHeader:Template()
ModalHeader.__index = ModalHeader

function ModalHeader.new(appState, dialogType)
	local self = {}

	self.heightOfHeader = TOTAL_HEIGHT_OF_HEADER
	self.heightOfDisconnected = HEIGHT_OF_DISCONNECTED

	self.buttons = {}
	self.connections = {}
	self.appState = appState
	self.dialogType = dialogType
	self.backButton = PaddedImageButton.new(self.appState, "Close",
		"rbxasset://textures/ui/LuaChat/icons/ic-close-gray2.png")
	self.backButton.rbx.Visible = false
	self.backButton.rbx.Size = UDim2.new(0, 24, 0, 24)
	self.backButton.rbx.Position = UDim2.new(0.5, -2, 0.5, 0)
	self.backButton.rbx.AnchorPoint = Vector2.new(0.5, 0.5)
	self.title = ""
	self.subtitle = nil
	self.connectionState = Enum.ConnectionState.Connected

	self.BackButtonPressed = Signal.new()
	self.backButton.Pressed:Connect(function()
		self.BackButtonPressed:Fire()
	end)

	self.rbx = Create.new "Frame" {
		Name = "HeaderFrame",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, TOTAL_HEIGHT_OF_HEADER),

		Create.new("UIListLayout") {
			Name = "ModalHeaderListLayout",
			SortOrder = "LayoutOrder",
			FillDirection = Enum.FillDirection.Vertical,
		},

		Create.new "Frame" {
			Name = "BottomBorder",
			BackgroundColor3 = Constants.Color.GRAY3,
			Size = UDim2.new(1, 0, 0, HEIGHT_OF_BORDER),
			BorderSizePixel = 0,
			LayoutOrder = 1,
		},

		Create.new "Frame" {
			Name = "Disconnected",
			BackgroundColor3 = Constants.Color.GRAY3,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0, 1),
			Size = UDim2.new(1, 0, 0, 0), -- Note: Deliberately has zero vertical height, will be scaled.
			ClipsDescendants = true,
			LayoutOrder = 2,

			Create.new "TextLabel" {
				Name = "Title",
				BackgroundTransparency = 1,
				TextSize = 14,
				TextColor3 = Constants.Color.WHITE,
				Size = UDim2.new(1, 0, 0, HEIGHT_OF_DISCONNECTED),
				Position = UDim2.new(0.5, 0, 1, 0),
				AnchorPoint = Vector2.new(0.5, 1),
				Text = appState.localization:Format(StringsLocale.Keys.NO_NETWORK_CONNECTION),
				Font = "SourceSansBold",
				LayoutOrder = 0,
			},
		},

		Create.new "Frame" {
			Name = "Header",
			BackgroundTransparency = 1, -- Set transparent so the rounded corners will show.
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, HEIGHT_OF_HEADER),
			LayoutOrder = 0,

			Create.new "Frame" {
				Name = "Content",
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, -4),
				Position = UDim2.new(0, 0, 0, 4),

				Create.new"Frame" {
					Name = "Icon",
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(0, ICON_CELL_WIDTH, 1, 0),
					Position = UDim2.new(0, 0, 0, 0),

					self.backButton.rbx,
				},

				Create.new "Frame" {
					Name = "Titles",
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 200, 1, 0),
					Position = UDim2.new(0.5, 0, 0, 0),
					AnchorPoint = Vector2.new(0.5, 0),

					Create.new "UIListLayout" {
						SortOrder = "LayoutOrder",
						VerticalAlignment = Enum.VerticalAlignment.Center
					},

					Create.new "TextLabel" {
						Name = "Title",
						BackgroundTransparency = 1,
						TextSize = 20,
						TextColor3 = Constants.Color.GRAY1,
						Size = UDim2.new(0, 200, 0, 18),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Text = "Title",
						Font = "SourceSans",
						LayoutOrder = 0,
					},

					Create.new "TextLabel" {
						Name = "Subtitle",
						BackgroundTransparency = 1,
						TextSize = 12,
						TextColor3 = Constants.Color.GRAY1,
						Size = UDim2.new(0, 200, 0, 18),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Text = "",
						Font = "SourceSans",
						LayoutOrder = 1,
					},
				},

				Create.new "Frame" {
					Name = "Buttons",
					BackgroundTransparency = 1,
					Position = UDim2.new(1, -12, 0, 0),
					Size = UDim2.new(0, 100, 1, 0),
					AnchorPoint = Vector2.new(1, 0),

					Create.new "UIListLayout" {
						SortOrder = "LayoutOrder",
						HorizontalAlignment = "Right",
						FillDirection = "Horizontal",
					},
				},
			},
		},
	}

	self.rbx:GetPropertyChangedSignal("Parent"):Connect(function()
		if self.rbx and self.rbx.Parent then
			game:GetService("RunService").Stepped:wait() -- TextBounds isn't recalculated when this fires so we wait
			self:SetTitle(self.title) -- Again, this can be much cleaner once we have proper truncation support
		end
	end)

	do
		local userId = PlayerService.localPlayer.userId
		local connection = appState.store.Changed:Connect(function(state, oldState)
			if state.Users == oldState.Users then
				return
			end

			if state.Users[userId] == oldState.Users[userId] then
				return
			end

			self:SetConnectionState()
		end)
		table.insert(self.connections, connection)
	end

	setmetatable(self, ModalHeader)
	return self
end

function ModalHeader:CreateHeaderButton(name, textKey)
	local saveGroup = ModalTextButton.new(self.appState, name, textKey)
	self:AddButton(saveGroup)
	return saveGroup
end

return ModalHeader