local CoreGui = game:GetService("CoreGui")

local LuaApp = CoreGui.RobloxGui.Modules.LuaApp
local StringsLocale = require(LuaApp.StringsLocale)

local Modules = script.Parent.Parent

local Functional = require(Modules.Functional)
local Create = require(Modules.Create)
local Constants = require(Modules.Constants)
local Signal = require(Modules.Signal)
local ActionType = require(Modules.ActionType)

local ToastModel = require(Modules.Models.ToastModel)

local UserThumbnailBar = require(Modules.Components.UserThumbnailBar)
local ListSection = require(Modules.Components.ListSection)
local UserList = require(Modules.Components.UserList)

local ICON_CELL_WIDTH = 60
local SEARCH_BOX_HEIGHT = 48
local CLEAR_TEXT_WIDTH = 44

local FriendSearchBox = {}
FriendSearchBox.__index = FriendSearchBox

function FriendSearchBox.new(appState, participants, maxParticipantCount, filter)
	local self = {
		appState = appState,
		participants = participants,
		users = appState.store:GetState().Users,
		maxParticipantCount = maxParticipantCount,
	}
	setmetatable(self, FriendSearchBox)

	self.friendThumbnails = UserThumbnailBar.new(appState, maxParticipantCount, 1)
	self.friendThumbnails.removed:Connect(function(id)
		self:RemoveParticipant(id)
	end)

	self.userList = UserList.new(appState, nil, filter)
	self.userList.userSelected:Connect(function(user)
		local selected = Functional.Find(self.participants, user.id)
		if selected then
			self:RemoveParticipant(user.id)
		else
			self:AddParticipant(user.id)
		end
		self:ClearText()
	end)

	self.rbx = Create.new"Frame" {
		Name = "FriendSearchBox",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),

		Create.new"UIListLayout" {
			Name = "ListLayout",
			SortOrder = "LayoutOrder",
		},
		self.friendThumbnails.rbx,
		Create.new"Frame" {
			Name = "Divider1",
			BackgroundColor3 = Constants.Color.GRAY4,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 1),
			LayoutOrder = 2,
		},
		ListSection.new(appState, nil, 3).rbx,
		Create.new"Frame" {
			Name = "SearchContainer",
			BackgroundTransparency = 0,
			BackgroundColor3 = Constants.Color.WHITE,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, SEARCH_BOX_HEIGHT),
			LayoutOrder = 4,

			Create.new"ImageLabel" {
				Name = "SearchIcon",
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 24, 0, 24),
				Position = UDim2.new(0, ICON_CELL_WIDTH/2, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = "rbxasset://textures/ui/LuaChat/icons/ic-search-gray.png",
			},
			Create.new"TextBox" {
				Name = "Search",
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -CLEAR_TEXT_WIDTH-ICON_CELL_WIDTH, 1, 0),
				Position = UDim2.new(0, ICON_CELL_WIDTH, 0, 0),
				TextSize = 18,
				TextColor3 = Constants.Color.GRAY1,
				Font = Enum.Font.SourceSans,
				Text = "",
				PlaceholderText = appState.localization:Format(StringsLocale.Keys.SEARCH_FOR_FRIENDS),
				PlaceholderColor3 = Constants.Color.GRAY3,
				TextXAlignment = Enum.TextXAlignment.Left,
				OverlayNativeInput = true,
				ClearTextOnFocus = false,
				ClipsDescendants = true,
			},
			Create.new"ImageButton" {
				Name = "Clear",
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 16, 0, 16),
				Position = UDim2.new(1, -(CLEAR_TEXT_WIDTH/2), 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				AutoButtonColor = false,
				Image = "rbxasset://textures/ui/LuaChat/icons/ic-clear-solid.png",
				ImageTransparency = 1,
			},
		},
		Create.new"Frame" {
			Name = "Divider2",
			BackgroundColor3 = Constants.Color.GRAY4,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 1),
			LayoutOrder = 5,
		},
		Create.new"ScrollingFrame" {
			Name = "ScrollingFrame",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 5,
			BottomImage = "rbxasset://textures/ui/LuaChat/9-slice/scroll-bar.png",
			MidImage = "rbxasset://textures/ui/LuaChat/9-slice/scroll-bar.png",
			TopImage = "rbxasset://textures/ui/LuaChat/9-slice/scroll-bar.png",
			LayoutOrder = 6,

			self.userList.rbx,
		},
	}

	self.searchContainer = self.rbx.SearchContainer
	local clearButton = self.searchContainer.Clear
	local search = self.searchContainer.Search

	clearButton.MouseButton1Click:Connect(function()
		self:ClearText()
	end)

	self:Resize()

	local function updateClearButtonVisibility()
		-- If we were to set the visible property of the clear button on the textbox focus lost event
		-- it would disable the clear button, which in turn would stop the click event
		-- from being able to notify the button
		local visible = search:IsFocused() and (search.Text  ~= "")
		clearButton.ImageTransparency = visible and 0 or 1
	end

	self.searchChanged = Signal.new()
	self.addParticipant = Signal.new()
	self.removeParticipant = Signal.new()

	search:GetPropertyChangedSignal("Text"):Connect(function()
		updateClearButtonVisibility()
		self.userList:ApplySearch(search.Text)
		self:Resize()
		self:ResizeCanvas()
	end)
	search.Focused:Connect(updateClearButtonVisibility)
	search.FocusLost:Connect(updateClearButtonVisibility)

	self.participantComponents = {}
	self.participantMap = {}

	self:UpdateFriends(appState.store:GetState().Users, self.participants)

	self.userList.rbx.ChildAdded:Connect(function(child)
		self:ResizeCanvas();
	end)

	self.userList.rbx.ChildRemoved:Connect(function(child)
		self:ResizeCanvas();
	end)

	self.userList.rbx:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		self:ResizeCanvas()
	end)

	return self
end

function FriendSearchBox:Resize()

	local height = 0
	for _, element in pairs(self.rbx:GetChildren()) do
		if element:IsA("GuiObject") and element.Visible and element.Name ~= "ScrollingFrame" then
			height = height + element.AbsoluteSize.Y
		end
	end

	self.rbx.ScrollingFrame.Size = UDim2.new(1, 0, 1, -height)
end

function FriendSearchBox:ResizeCanvas()

	local height = 0
	for _, element in pairs(self.userList.rbx:GetChildren()) do
		if element:IsA("GuiObject") and element.Visible then
			height = height + element.AbsoluteSize.Y
		end
	end
	self.rbx.ScrollingFrame.CanvasSize = UDim2.new(1, 0, 0, height)
end

function FriendSearchBox:AddParticipant(userId)
	if #self.participants >= self.maxParticipantCount then

		if self.tooManyFriendsToastModel == nil then
			local messageKey = StringsLocale.Keys.TOO_MANY_PEOPLE
			local messageArguments = {
				MAX_GROUP_SIZE = tostring(Constants.MAX_PARTICIPANT_COUNT+1),
			}
			local toastModel = ToastModel.new(Constants.ToastIDs.TOO_MANY_PEOPLE, messageKey, messageArguments)
			self.tooManyFriendsToastModel = toastModel
		end

		self.appState.store:Dispatch({
			type = ActionType.ShowToast,
			toast = self.tooManyFriendsToastModel,
		})
	else
		self.addParticipant:Fire(userId)
	end
end

function FriendSearchBox:RemoveParticipant(userId)
	self.removeParticipant:Fire(userId)
end

function FriendSearchBox:UpdateFriends(users, selectedList)
	local friends = {}
	for _, user in pairs(users) do
		table.insert(friends, user)
	end
	self.userList:Update(friends, selectedList)
	self:Resize()
end

function FriendSearchBox:ClearText()
	self.searchContainer.Search.Text = ""
	self:Resize()
end

function FriendSearchBox:Update(participants)
	local state = self.appState.store:GetState()
	local users = state.Users

	if participants ~= self.participants then
		self.friendThumbnails:Update(participants)
	end

	if participants ~= self.participants or users ~= self.users then
		self:UpdateFriends(users, participants)
	end

	self.participants = participants
	self.users = users

	self:Resize()
end

return FriendSearchBox