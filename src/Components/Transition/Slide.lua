local Root = script.Parent.Parent.Parent

local Roact: Roact = require(Root.Packages.Roact)
local Flipper = require(Root.Packages.Flipper)

local e = Roact.createElement

local Component = Roact.Component:extend("TransitionSlide")

Component.defaultProps = {
	direction = "up",

	show = false,
	transitionOnMount = true,
	unmount = true,

	size = UDim2.fromScale(1, 1),
	zindex = nil,

	springFrequency = 5,
	springDamping = 1,
}

local function GetPositionalConfigFromDirection(direction: string)
	local config = {
		position = UDim2.fromScale(0, 1),
		anchor = Vector2.new(),
	}

	if direction == "down" then
		config.position = UDim2.new()
		config.anchor = Vector2.new(0, 1)
	elseif direction == "left" then
		config.position = UDim2.new()
		config.anchor = Vector2.new(1, 0)
	elseif direction == "right" then
		config.position = UDim2.fromScale(1, 0)
		config.anchor = Vector2.new()
	end

	return config
end

function Component:init(props)
	local motorGoal = (props.show and not props.transitionOnMount) and 0 or 1
	self.motor = Flipper.SingleMotor.new(motorGoal)

	self:setState({ hidden = motorGoal == 1 })

	local binding, setBinding = Roact.createBinding(self.motor:getValue())
	self.binding = binding

	self.motor:onStep(function(value)
		setBinding(value)
		self:setState({ hidden = value == 1 })
	end)
end

function Component:didUpdate(prevProps, prevState)
	if prevProps.show ~= self.props.show then
		local motorGoal = self.props.show and 0 or 1

		self.motor:setGoal(Flipper.Spring.new(motorGoal, {
			frequency = self.props.springFrequency,
			dampingRatio = self.props.springDamping,
		}))
	end

	if prevState.hidden ~= self.state.hidden then
		if self.state.hidden and type(self.props.onExited) == "function" then
			self.props.onExited()
		elseif not self.state.hidden and type(self.props.onEnter) == "function" then
			self.props.onEnter()
		end
	end
end

function Component:willUnmount()
	self.motor:stop()
end

function Component:didMount()
	if self.props.transitionOnMount then
		local motorGoal = self.props.show and 0 or 1

		self.motor:setGoal(Flipper.Spring.new(motorGoal, {
			frequency = self.props.springFrequency,
			dampingRatio = self.props.springDamping,
		}))
	end
end

function Component:render()
	local positional = GetPositionalConfigFromDirection(self.props.direction)
	local mounted = not (self.props.unmount and self.state.hidden)

	local children = self.props[Roact.Children]

	return e("Frame", {
		BackgroundTransparency = 1,
		Size = self.props.size,
		ZIndex = self.props.zindex,

		AnchorPoint = self.binding:map(function(value)
			return Vector2.new():Lerp(positional.anchor, value)
		end),

		Position = self.binding:map(function(value)
			return UDim2.new():Lerp(positional.position, value)
		end),
	}, mounted and children)
end

return Component
