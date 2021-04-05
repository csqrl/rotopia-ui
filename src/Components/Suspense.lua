local Root = script.Parent.Parent

local Roact: Roact = require(Root.Packages.Roact)

local Component = Roact.Component:extend("Suspense")

Component.defaultProps = {
    fallback = nil, -- Element
    render = nil, -- Callback
    fail = nil, -- Callback

    load = nil, -- (onComplete: (data: any) -> nil) -> nil
}

function Component:init(props)
    self:setState({
        loading = true,
    })

    self.onComplete = function(data)
        self:setState({
            loading = false,
            success = true,
            data = data,
        })
    end

    self.onFail = function(message)
        self:setState({
            loading = false,
            success = false,
            data = message,
        })
    end

    if type(props.load) == "function" then
        coroutine.wrap(function()
            local success, errorText = pcall(function()
                props.load(self.onComplete, self.onFail)
            end)

            if not success then
                self.onFail(errorText)
            end
        end)()
    else
        self.onComplete(props.load)
    end
end

function Component:render()
    local props, state = self.props, self.state

    if state.loading then
        return props.fallback
    else
        if state.success then
            if type(props.render) == "function" then
                return props.render(state.data)
            end
        else
            if type(props.fail) == "function" then
                return props.fail(state.data)
            end
        end
    end
end

return Component
