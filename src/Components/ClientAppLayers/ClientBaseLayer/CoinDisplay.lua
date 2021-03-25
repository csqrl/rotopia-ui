local Components = script.Parent.Parent.Parent
local Packages = Components.Parent.Packages

local Roact: Roact = require(Packages.Roact)

local e = Roact.createElement

local Component = Roact.Component:extend("CoinDisplay")

Component.defaultProps = {
	transparency = 0,
	onClick = nil,
}

function Component:init()
	self:setState({
		coinsValue = 0,
	})
end

function Component:render()
	local state = self.state
	local props = self.props

	local coinsText = tostring(state.coinsValue)

	-- local xsOffset = math.clamp((props.Viewport.Y - 320) / (375 - 320), 0, 1)
	local xsOffset = 1
	local baseSize = UDim2.fromOffset(110, 88):Lerp(UDim2.fromOffset(142, 112), xsOffset)

	return e("ImageButton", {
		AnchorPoint = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -16, 0, 8),
		Size = baseSize,
		ClipsDescendants = true,
		Image = "rbxassetid://6551803737",
		ImageColor3 = nil,
		ImageTransparency = props.transparency,

		[Roact.Event.MouseButton1Click] = props.onClick,
		[Roact.Event.MouseButton2Click] = props.onRightClick,
		[Roact.Event.TouchLongPress] = props.onRightClick,
	}, {
		Icon = e("ImageLabel", {
			AnchorPoint = Vector2.new(0, 1),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(.056, .92),
			Size = UDim2.fromScale(.887, .857),
			ZIndex = 20,
			Image = "rbxassetid://6551820072",
			ImageColor3 = nil,
			ImageTransparency = props.transparency,
		}),

		IconBorder = e("ImageLabel", {
			AnchorPoint = Vector2.new(0, 1),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(.056, .92),
			Size = UDim2.fromScale(.887, .857),
			ZIndex = 10,
			Image = "rbxassetid://6551817243",
			ImageColor3 = nil,
			ImageTransparency = props.transparency,
		}),

		ValueBackground = e("ImageLabel", {
			AnchorPoint = Vector2.new(0, 1),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(.056, .92),
			Size = UDim2.fromScale(.887, .857),
			ZIndex = 1,
			Image = "rbxassetid://6551810103",
			ImageColor3 = Color3.fromRGB(255, 0, 106),
			ImageTransparency = props.transparency,
		}),

		Value = e("TextLabel", {
			AnchorPoint = Vector2.new(.5, 1),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(.479, .777),
			Rotation = 5,
			Size = UDim2.fromScale(.65, .196),
			ZIndex = 30,
			Font = Enum.Font.GothamSemibold,
			Text = coinsText,
			TextColor3 = Color3.new(1, 1, 1),
			TextScaled = true,
			TextSize = 22,
			TextTransparency = props.transparency,
		}),
	})
end

return Component
