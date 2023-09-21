local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")

local LuaChat = script.Parent.Parent

local Create = require(LuaChat.Create)
local Constants = require(LuaChat.Constants)
local Text = require(LuaChat.Text)
local WebApi = require(LuaChat.WebApi)

local AssetInfoActions = require(LuaChat.Actions.AssetInfoActions)

local BUBBLE_PADDING = 10
local EXTERIOR_PADDING = 3
local INTERIOR_PADDING = 12
local ICON_SIZE = 64

local function isOutgoingMessage(message)
	local localUserId = tostring(Players.LocalPlayer.UserId)
	return message.senderTargetId == localUserId
end


local AssetCard = {}

AssetCard.__index = AssetCard

function AssetCard.new(appState, message, assetId)
	local self = {}
	setmetatable(self, AssetCard)

	local state = appState.store:GetState()
	local user = state.Users[message.senderTargetId]
	local username = user and user.name or "unknown user"

	self.appState = appState
	self.paddingObject = nil
	self.message = message
	self.bubbleType = "AssetCard"
	self.connections = {}
	self.viewDetailsClick = nil
	self.assetId = tonumber(assetId)

	self.tail = Create.new "ImageLabel" {
		Name = "Tail",
		Size = UDim2.new(0, 6, 0, 6),
		BackgroundTransparency = 1,
	}

	self.actionLabel = Create.new "TextLabel" {
		Name = "ActionLabel",
		BackgroundTransparency = 1,

		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(0.8, 0, 0.8, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		TextSize = 20,
		TextColor3 = Constants.Color.GRAY1,
		Font = Enum.Font.SourceSans,
		Text = "View Details",
	}

	self.actionButton = Create.new "ImageButton" {
		Name = "Action",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0.5, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, 32),
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(3,3,4,4),
		Image = "rbxasset://textures/ui/LuaChat/9-slice/input-default.png",
		self.actionLabel,
	}

	self.Title = Create.new "TextLabel" {
		Name = "Title",
		BackgroundTransparency = 1,

		AnchorPoint = Vector2.new(0.5, 0),
		TextSize = 20,
		Size = UDim2.new(1, 0, 0, 20),
		Position = UDim2.new(0.5, 0, 0, 0),

		TextColor3 = Constants.Color.GRAY1,
		Font = Enum.Font.SourceSans,
		TextXAlignment = Enum.TextXAlignment.Left
	}

	self.Icon = Create.new "ImageLabel" {
		Name = "Icon",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, self.Title.TextSize + INTERIOR_PADDING),
		Size = UDim2.new(0, ICON_SIZE, 0, ICON_SIZE),
	}

	self.Details = Create.new "TextLabel" {
		Name = "Details",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, - INTERIOR_PADDING -ICON_SIZE, 0, ICON_SIZE),
		Position = self.Icon.Position + UDim2.new(0 , INTERIOR_PADDING + ICON_SIZE, 0, 0),

		TextColor3 = Constants.Color.GRAY2,
		Font = Enum.Font.SourceSans,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true,
	}

	self.Content = Create.new "Frame" {
		Name = "Content",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -BUBBLE_PADDING * 2, 1, -BUBBLE_PADDING * 2),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Visible = false,

		self.actionButton,
		self.Title,
		self.Icon,
		self.Details,
	}

	self.bubble = Create.new "ImageLabel" {
		Name = "Bubble",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(0, 267, 1, 0),
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(10, 10, 11, 11),
		LayoutOrder = 2,

		self.Content,
		self.tail,
	}

	self.usernameLabel = Create.new "TextLabel" {
		Name = "UsernameLabel",
		Font = Enum.Font.SourceSans,
		TextSize = 12,
		Visible = false,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -56, 0, 16),
		Position = UDim2.new(0, 56, 0, 0),
		TextColor3 = Constants.Color.GRAY2,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		Text = username,
	}

	self.bubbleContainer = Create.new "Frame" {
		Name = "BubbleContainer",
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, 0),

		self.bubble,
		self.usernameLabel,
	}

	self.rbx = Create.new "Frame" {
		Name = "AssetCard",
		BackgroundTransparency = 1,

		Create.new "UIListLayout" {
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		},

		self.bubbleContainer,
	}

	-- 'isOutgoing' means "is sent by the local user". This function separates the tail position & color
	if isOutgoingMessage(message) then
		self.tail.AnchorPoint = Vector2.new(0, 0)
		self.tail.Position = UDim2.new(1, 0, 0, 0)
		self.tail.ImageColor3 = Color3.new(1, 1, 1)

		self.bubble.ImageColor3 = Color3.new(1, 1, 1)
		self.bubble.AnchorPoint = Vector2.new(1, 0)
		self.bubble.Position = UDim2.new(1, -10, 0, 0)

		self.rbx.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	else
		self.tail.AnchorPoint = Vector2.new(1, 0)
		self.tail.Position = UDim2.new(0, 0, 0, 0)
		self.tail.ImageColor3 = Color3.new(1, 1, 1)

		self.bubble.ImageColor3 = Color3.new(1, 1, 1)
		self.bubble.AnchorPoint = Vector2.new(0, 0)
		self.bubble.Position = UDim2.new(0, 54, 0, 0)

		self.rbx.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	end

	local action = AssetInfoActions.GetAssetInformation(assetId, function(store)
		self.Content.Visible = true
		self:Update(appState.store:GetState())
	end)

	appState.store:Dispatch(action)

	local connection = self.rbx:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		self:Resize()
	end)
	table.insert(self.connections, connection)

	return self
end


function AssetCard:Resize()
	self.bubble.Size = UDim2.new(0, 267, 0, 92 + ICON_SIZE)

	local containerHeight = self.bubble.AbsoluteSize.Y

	if self.usernameLabel.Visible then
		containerHeight = containerHeight + self.usernameLabel.AbsoluteSize.Y
	end

	self.bubbleContainer.Size = UDim2.new(1, 0, 0, containerHeight)

	local height = 0
	for _, child in ipairs(self.rbx:GetChildren()) do
		if child:IsA("GuiObject") then
			height = height + child.AbsoluteSize.Y
		end
	end

	Text.TruncateTextLabel(self.Title, "...")

	self.rbx.Size = UDim2.new(1, 0, 0, height + EXTERIOR_PADDING*2)
end

function AssetCard:Update(state)
	if state.AssetInfo[self.assetId] ~= self.itemInfo then
		self.itemInfo = state.AssetInfo[self.assetId]
		self.assetId = self.itemInfo.AssetId

		self.Title.Text = self.itemInfo.Name
		self.Details.Text = self.itemInfo.Description:gsub("%s", " ")

		self.Icon.Image = self.itemInfo.Icon

		if self.viewDetailsClick then self.viewDetailsClick:Disconnect() end

		self.viewDetailsClick = self.actionButton.MouseButton1Click:Connect(function()
			GuiService:BroadcastNotification(WebApi.MakeItemUrl(self.itemInfo.assetId),
				GuiService:GetNotificationTypeList().VIEW_GAME_DETAILS)
		end)

	end
	self:Resize()
end

function AssetCard:Destruct()
	for _, connection in ipairs(self.connections) do
		connection:Disconnect()
	end
	self.connections = {}
	self.rbx:Destroy()
end



return AssetCard
