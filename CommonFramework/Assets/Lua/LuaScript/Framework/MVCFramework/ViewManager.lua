ViewManager = class()
local dicViews = {}
function ViewManager.RegisterViews(views)
	for viewName,viewClass in pairs(views) do
		Debugger.LogError("viewName " .. viewName)
		Debugger.LogError(viewClass)
		dicViews[viewName] = viewClass
	end
end

function ViewManager.GetView(viewName)
	local view = dicViews[viewName].new()
	local function showFunc()
		
	end
	view.showCallback = showFunc

	local function hideFunc()
		
	end
	view.Hide = hideFunc

	return view
end