local Replicated = game:GetService("ReplicatedStorage")

local Knit = require(Replicated.Knit)

local Root = script.Parent.Parent.Parent.Parent
local Components = Root.Components

local Roact: Roact = require(Root.Packages.Roact)
local RoactRouter = require(Root.Packages.RoactRouter)

local Suspense = require(Components.Suspense)

local e = Roact.createElement

return function()
    return e(RoactRouter.Context.Consumer, {
        render = function(routing)
            if routing.history.location.path ~= "/shop" then
                return nil
            end

            return e(Suspense, {
                load = function(onComplete, onFail)
                    Knit.OnStart():andThen(function()
                        return Knit.GetService("MarketService")
                    end):andThen(function(MarketService)
                        return MarketService.Currency:GetProductsPromise()
                    end):andThen(function(products)
                        onComplete(products)
                    end):catch(onFail)
                end,

                fallback = e("TextLabel", {
                    Text = "Loading...",
                    Size = UDim2.fromScale(1, 1),
                    BackgroundColor3 = BrickColor.random().Color,
                }),

                fail = function(data)
                    print(data)
                end,

                render = function(data)
                    return e("TextLabel", {
                        Text = tostring(data),
                        Size = UDim2.fromScale(1, 1),
                    })
                end,
            })
        end,
    })
end
