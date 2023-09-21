local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LuaApp = CoreGui.RobloxGui.Modules.LuaApp
local StringsLocale = require(LuaApp.StringsLocale)

local Modules = script.Parent.Parent
local Components = Modules.Components

local Signal = require(Modules.Signal)
local Create = require(Modules.Create)
local Constants = require(Modules.Constants)
local ConversationActions = require(Modules.Actions.ConversationActions)
local Immutable = require(Modules.Immutable)
local ActionType = require(Modules.ActionType)
local DialogInfo = require(Modules.DialogInfo)

local ConversationModel = require(Modules.Models.Conversation)

local HeaderLoader = require(Components.HeaderLoader)
local TextInputEntry = require(Components.TextInputEntry)
local SectionComponent = require(Components.ListSection)
local FriendSearchBoxComponent = require(Components.FriendSearchBox)
local ResponseIndicator = require(Components.ResponseIndicator)

local Intent = DialogInfo.Intent

local NewChatGroup = {}
NewChatGroup.__index = NewChatGroup

local function getAsset(name)
	return "rbxasset://textures/ui/LuaChat/"..name..".png"
end

function NewChatGroup.new(appState)
	local self = {
		appState = appState,
	}
	setmetatable(self, NewChatGroup)

	self.conversation = ConversationModel.empty()

	self.responseIndicator = ResponseIndicator.new(appState)
	self.responseIndicator:SetVisible(false)

	-- Header:
	self.header = HeaderLoader.GetHeader(appState, Intent.NewChatGroup)
	self.header:SetDefaultSubtitle()
	self.header:SetTitle("New Chat Group")
	self.header:SetBackButtonEnabled(true)
	self.header:SetConnectionState(Enum.ConnectionState.Disconnected)

	-- Name the group:
	local placeholderText = appState.localization:Format(StringsLocale.Keys.NAME_THIS_CHAT_GROUP)
	self.groupName = TextInputEntry.new(appState, getAsset("icons/ic-nametag"), placeholderText)
	self.groupName.rbx.LayoutOrder = 1
	self.groupName.textBoxChanged:Connect(function(groupName)
		self.conversation.title = groupName
	end)

	-- Search for friends:
	self.searchComponent = FriendSearchBoxComponent.new(
		appState,
		self.conversation.participants,
		Constants.MAX_PARTICIPANT_COUNT,
		function(user)
			return user.isFriend and user.id ~= tostring(Players.LocalPlayer.UserId)
		end
	)
	self.searchComponent.rbx.LayoutOrder = 3
	self.searchComponent.addParticipant:Connect(function(id)
		self:ChangeParticipants(Immutable.Set(self.conversation.participants, #self.conversation.participants+1, id))
	end)
	self.searchComponent.removeParticipant:Connect(function(id)
		self:ChangeParticipants(Immutable.RemoveValueFromList(self.conversation.participants, id))
	end)


	-- Assemble the dialog from components we just made:
	self.sectionComponent = SectionComponent.new(appState, nil, 2)
	self.rbx = Create.new"ImageLabel" {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,

		ScaleType = "Slice",
		SliceCenter = Rect.new(5,5,6,6),
		Image = "rbxasset://textures/ui/LuaChat/9-slice/modal.png",

		Create.new("UIListLayout") {
			Name = "ListLayout",
			SortOrder = "LayoutOrder",
		},
		self.header.rbx,
		Create.new"Frame" {
			Name = "Content",
			Size = UDim2.new(1, 0, 1, -(self.header.heightOfHeader)),
			BackgroundColor3 = Constants.Color.GRAY5,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			ClipsDescendants = true,

			Create.new"UIListLayout" {
				Name = "ListLayout",
				SortOrder = "LayoutOrder",
			},
			self.groupName.rbx,
			self.sectionComponent.rbx,
			self.searchComponent.rbx,
		},
		self.responseIndicator.rbx,
	}

	-- Wire up the save button to actually create our new chat group:
	self.saveGroup = self.header:CreateHeaderButton("SaveGroup", StringsLocale.Keys.SAVE_NEW_GROUP)
	self.saveGroup:SetEnabled(false)
	self.saveGroup.Pressed:Connect(function()
		if #self.conversation.participants >= Constants.MIN_PARTICIPANT_COUNT then
			self.responseIndicator:SetVisible(true)
			self.appState.store:Dispatch(
				ConversationActions.CreateConversation(self.conversation, function(id)
					self.responseIndicator:SetVisible(false)
					if id ~= nil then
						self.ConversationSaved:Fire(id)
					end
					self.appState.store:Dispatch({
						type = ActionType.RemoveRoute,
						intent = Intent.NewChatGroup
					})
				end)
			)
		end
	end)

	self.BackButtonPressed = self.header.BackButtonPressed
	self.ConversationSaved = Signal.new()

	if not self.appState.store:GetState().FetchedAllFriends then
		self.appState.store:Dispatch(ConversationActions.GetAllFriends())
	end

	self.tooManyFriendsAlertId = nil

	-- Monitor for several size changes to properly scale dialog elements:
	self.groupName.rbx:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		self:Resize()
	end)
	self.header.rbx:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		self:Resize()
	end)

	return self
end

function NewChatGroup:Resize()
	-- Content frame must resize if the header changes size (which happens when it shows the "Connecting" message):
	local sizeContent = UDim2.new(1, 0, 1, -(self.header.rbx.AbsoluteSize.Y +
		Constants.ModalDialog.CLEARANCE_CORNER_ROUNDING))
	self.rbx.Content.Size = sizeContent

	-- Friends Search frame must resize to fit properly with their peers:
	local sizeSearch = UDim2.new(1, 0, 1, -(self.groupName.rbx.AbsoluteSize.Y + self.sectionComponent.rbx.AbsoluteSize.Y))
	self.searchComponent.rbx.Size = sizeSearch
end

function NewChatGroup:ChangeParticipants(participants)
	self.conversation = Immutable.Set(self.conversation, "participants", participants)
	self.searchComponent:Update(participants)
	self.saveGroup:SetEnabled(#participants >= Constants.MIN_PARTICIPANT_COUNT)
end

function NewChatGroup:Update(current, previous)
	self.header:SetConnectionState(current.ConnectionState)
	self.searchComponent:Update(self.conversation.participants)
end

return NewChatGroup