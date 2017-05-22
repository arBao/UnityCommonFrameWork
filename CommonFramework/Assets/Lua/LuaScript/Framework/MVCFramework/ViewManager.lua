ViewManager = class()
local dicViews = {}
local UIRoot = nil

function ViewManager.RegisterViews(views)
	for viewName,viewClass in pairs(views) do
		Debugger.LogError("viewName " .. viewName)
		Debugger.LogError(viewClass)
		dicViews[viewName] = viewClass
	end
end

function ViewManager.Init()
	local Main = UnityEngine.GameObject.Find('Main')
	UIRoot = UnityEngine.GameObject.Find('UIRoot')
	CSharpTransfer.Instance:DontDestroyObj(Main)
	CSharpTransfer.Instance:DontDestroyObj(UIRoot)
end

function ViewManager.GetView(viewName)
	local uidata = CSVParser.LoadCsv(CSVPaths.UIConfig,viewName)
	local uiGameObj = AssetsManager.Instance:GetAsset(uidata.path,typeof(UnityEngine.GameObject))
	local view = dicViews[viewName].new()
	view.uiobj = uiGameObj
	local function showFunc()
		
	end
	view.showCallback = showFunc

	local function hideFunc()
		
	end
	view.Hide = hideFunc

	return view
end