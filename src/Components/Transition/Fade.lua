local Root = script.Parent.Parent.Parent

local Roact: Roact = require(Root.Packages.Roact)
local Flipper = require(Root.Packages.Flipper)
local Llama = require(Root.Packages.Llama)

local e = Roact.createElement

local Component = Roact.Component:extend("TransitionFade")

Component.defaultProps = {
	show = false,
	unmount = true,

	whenShown = 0,
	whenHidden = 1,

	springFrequency = 5,
	springDamping = 1,
}

function Component:init(props)
	self.motor = Flipper.SingleMotor.new(props.show and props.whenShown or props.whenHidden)

	self:setState({
		hidden = not props.show,
		transparency = self.motor:getValue(),
	})

	self.motor:onStep(function(value)
		self:setState({
			hidden = value == props.whenHidden,
			transparency = value,
		})
	end)
end

function Component:didUpdate(prevProps, prevState)
	if prevProps.show ~= self.props.show then
		local motorGoal = self.props.show and self.props.whenShown or self.props.whenHidden

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

function Component:render()
	local mounted = not (self.props.unmount and self.state.hidden)
	local transparency = self.state.transparency

	if not mounted then
		return nil
	end

	local children = Llama.Dictionary.map(self.props[Roact.Children] or {}, function(child)
		local newProps = Llama.Dictionary.merge(child.props, {
			transparency = transparency
		})

		return e(child.component, newProps)
	end)

	return Roact.createFragment(children)
end

return Component
