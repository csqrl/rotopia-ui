local UserInputService = game:GetService("UserInputService")

local Root = script.Parent.Parent

local Roact: Roact = require(Root.Packages.Roact)
local Llama = require(Root.Packages.Llama)

local Context = require(script.Parent.Context)

local Component = Roact.Component:extend("DeviceProvider")

Component.defaultProps = {
    class = "Frame",
    props = {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
    }
}

local function determineInputTypeFromEnum(userInput)
    local inputType = "mouse"

    if userInput == Enum.UserInputType.Touch then
        inputType = "touch"
    elseif userInput.Name:match("Gamepad") then
        inputType = "gamepad"
    end

    return inputType
end

function Component:init()
    self:setState({
        width = 0,
        height = 0,
        input = "touch",
    })

    self.connection = UserInputService.LastInputTypeChanged:Connect(function(userInput)
        self:setState({
            input = determineInputTypeFromEnum(userInput),
        })
    end)
end

function Component:willUnmount()
    self.connection:Disconnect()
end

function Component:render()
    local props = Llama.Dictionary.merge(self.props.props, {
        [Roact.Change.AbsoluteSize] = function(rbx)
            self:setState({
                width = rbx.AbsoluteSize.X,
                height = rbx.AbsoluteSize.Y,
            })
        end,
    })

    return Roact.createElement(self.props.class, props, {
        Roact.createElement(Context.Provider, {
            value = self.state,
        }, self.props[Roact.Children])
    })
end

return Component
