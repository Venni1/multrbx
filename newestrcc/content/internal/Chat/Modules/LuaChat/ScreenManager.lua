local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local Modules = script.Parent

local ScreenRouter = require(Modules.ScreenRouter)
local Device = require(Modules.Device)
local DialogFrame = require(Modules.Views.DialogFrame)

local ScreenManager = {}

--[[
	Create a new ScreenManager that uses the given 'root'
]]
function ScreenManager.new(root, appState)
	local self = {
		_stack = {},
		_framesToViews = {},
		rbx = root,
		appState = appState,
		route = nil,
		routeMap = nil,
		paused = false,
	}

	local dialogFrame = DialogFrame.new(appState, nil)
	dialogFrame.rbx.Parent = self.rbx
	self.dialogFrame = dialogFrame

	setmetatable(self, {
		__index = ScreenManager
	})

	if self.appState then
		self.appState.store.Changed:Connect(function(current, previous)
			self:Update(current, previous)
		end)
	end

	local bottomBarSignal = UserInputService:GetPropertyChangedSignal("BottomBarSize")
	bottomBarSignal:Connect(function()
		GuiService:SetGlobalGuiInset(0, 0, 0, UserInputService.BottomBarSize.Y)
	end)

	return self
end

function ScreenManager:Update(current, previous)
	if current == previous then
		return
	end

	if self.paused ~= self.appState.store:GetState().ToggleChatPaused then
		self.paused = self.appState.store:GetState().ToggleChatPaused
		if self.paused then
			self:DisableAllViews()
		else
			self:EnableAllViews()
			self:SetTabBarVisible(current.TabBarVisible)
		end

		return
	end

	if current.TabBarVisible ~= previous.TabBarVisible then
		self:SetTabBarVisible(current.TabBarVisible)
	end

	if current.Location.current == self.route then

		return
	end

	if current.FormFactor == Device.FormFactor.UNKNOWN then
		return
	end

	local routeMap = ScreenRouter.RouteMaps[current.FormFactor]

	if routeMap[current.Location.current.intent] == nil then
		return
	end

	--If a view representing this route already exists on the stack, we'll just pop down to it
	local viewInStack = false
	for _, view in ipairs(self._stack) do
		if ScreenRouter:Compare(view.route, current.Location.current) then
			viewInStack = true
			break
		end
	end

	if viewInStack then
		while not ScreenRouter:Compare(self:GetCurrentView().route, current.Location.current) do
			self:PopView(self:GetCurrentView())
		end
	else
		if current.Location.current.popToIntent ~= nil then
			while #self._stack > 1 and current.Location.current.popToIntent ~= self:GetCurrentView().route.intent do
				self:PopView(self:GetCurrentView())
			end
		end
		local newView = ScreenRouter:GetView(self.appState, current.Location.current, routeMap)
		self:PushView(newView, current.Location.current.intent)
	end

	self.route = current.Location.current

	self.tabBarVisible = true
	UserInputService:GetPropertyChangedSignal("BottomBarSize"):Connect(function()
		self:SetTabBarVisible(self.tabBarVisible)
	end)
end

function ScreenManager:GetViewOrderMap()
	local indexMap = {}

	for i = #self._stack, 1, -1 do
		local view = self._stack[i]
		if not indexMap[view] then
			indexMap[view] = i
		end
	end

	return indexMap
end

function ScreenManager:SortViews()
	local indexMap = self:GetViewOrderMap()

	for frame, view in pairs(self._framesToViews) do
		local order = indexMap[view] or 0
		-- TODO: CLIPLAYEREX-1051: We shoud set the frame sort order here. This is something that the player experience
		-- team is working on. It should be fine for us not to do this for now.
		frame.Name = ("LuaChat-layer%d"):format(order)
	end
end

function ScreenManager:GetCurrentView()
	return self._stack[#self._stack]
end

function ScreenManager:GetViewStack()
	return self._stack
end

function ScreenManager:PushView(view, intent)

	local current = self:GetCurrentView()

	-- There are no reasons to push a view on top of itself!
	if current == view then
		error("Tried to push a view on top of itself!", 2)
	end

	if current then
		current:Pause(view)
	end

	table.insert(self._stack, view)

	if view and view.rbx then
		local frame = self.dialogFrame:AddDialogFrame(intent)
		self._framesToViews[frame] = view

		frame.ChildRemoved:Connect(function()
			self._framesToViews[frame] = nil
			frame:Destroy()
		end)

		view.rbx.Parent = frame

		self:SortViews()
	end

	view:Start(current)
end

--[[
	Pop the view that's currently being shown.

	Optionally, pass in a view to make the ScreenManager only pop if that view
	is the one on top of the stack. This makes the pop operation idempotent.
]]
function ScreenManager:PopView(expectView)
	if expectView and expectView ~= self:GetCurrentView() then
		return
	end

	local last = self._stack[#self._stack]
	local current = self._stack[#self._stack - 1]

	if last then
		self:SortViews()

		last:Stop(current)
	end

	table.remove(self._stack, #self._stack)

	if current then
		current:Resume(last)
	end

	self.dialogFrame:ConfigureModalFrame()

	return last
end

function ScreenManager:EnableAllViews()
	self.dialogFrame.rbx.Enabled = true
end

function ScreenManager:DisableAllViews()
	self.dialogFrame.rbx.Enabled = false
end

function ScreenManager:SetTabBarVisible(visible)
	if self.appState.store:GetState().FormFactor == Device.FormFactor.PHONE then
		if visible then
			GuiService:BroadcastNotification("", GuiService:GetNotificationTypeList().SHOW_TAB_BAR)
		else
			GuiService:BroadcastNotification("", GuiService:GetNotificationTypeList().HIDE_TAB_BAR)
		end
	end
	self.tabBarVisible = visible
end

return ScreenManager