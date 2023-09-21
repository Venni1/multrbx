local Modules = script.Parent.Parent
local Create = require(Modules.Create)
local Constants = require(Modules.Constants)
local Signal = require(Modules.Signal)
local Text = require(Modules.Text)

local FONT = Enum.Font.SourceSans
local TEXT_SIZE = 18
local X_PADDING = 8

local TextButton = {}

TextButton.__index = TextButton

function TextButton.new(appState, name, textKey)
	local self = {}

	self.enabled = true


	local text = appState.localization:Format(textKey)

	local textWidth = Text.GetTextWidth(text, FONT, TEXT_SIZE)

	self.rbx = Create.new "TextButton" {
		Name = name,
		BackgroundTransparency = 1,
		Text = "",
		Size = UDim2.new(0, textWidth + X_PADDING, 1, 0),

		Create.new "TextLabel" {
			Name = "Label",
			Size = UDim2.new(0, textWidth, 0, TEXT_SIZE),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			BackgroundTransparency = 1,
			Text = text,
			Font = FONT,
			TextSize = TEXT_SIZE,
			TextColor3 = Constants.Color.BLUE_PRIMARY,
		},
	}

	self.Pressed = Signal.new()

	self.rbx.MouseButton1Click:Connect(function()
		if not self.enabled then
			return
		end

		self.Pressed:Fire()
	end)

	setmetatable(self, TextButton)

	return self
end

function TextButton:SetEnabled(value)
	if value then
		self.rbx.Label.TextColor3 = Constants.Color.BLUE_PRIMARY
		self.rbx.Label.TextTransparency = 0
	else
		self.rbx.Label.TextColor3 = Constants.Color.GRAY3
	end

	self.enabled = value
end

return TextButton