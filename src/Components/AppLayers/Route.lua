local Components = script.Parent.Parent
local Packages = Components.Parent.Packages

local Roact: Roact = require(Packages.Roact)
local RoactRouter = require(Packages.RoactRouter)
local Llama = require(Packages.Llama)

return function(path: string, render)
    local routingPath = RoactRouter.Path.new(path)

    return Roact.createElement(RoactRouter.Route, {
        path = path,
        always = true,

        render = function(routing)
            local stackResult = Llama.List.findWhere(routing.history._entries, function(entry)
                return entry.path == path
            end)

            local looseStackResult = Llama.List.findWhere(routing.history._entries, function(entry)
                return routingPath:match(entry.path) ~= nil
            end)

            routing.inRange = stackResult and stackResult <= routing.history._index
            routing.inRangeLoose = looseStackResult and looseStackResult <= routing.history._index
            routing.matchLoose = routingPath:match(routing.history._entries[routing.history._index].path)

            return Roact.createElement("Frame", {
                BackgroundTransparency = 1,
                ZIndex = routing.matchLoose and 100 or 10,
                Size = UDim2.fromScale(1, 1),
            }, render(routing))
        end,
    })
end
