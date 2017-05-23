ViewManager = class()
local dicViewClassCache = {}
local UIRoot = nil
local UINormal = nil
local UIPopup = nil
local UITop = nil
local normalViewCache = {}
local popupViewCache = {}
local topViewCache = {}

local LayerOrderName = {
	UINormal = 'UINormal',
	UIPopup = 'UIPopup',
	UITop = 'UITop',
}

function ViewManager.RegisterViews(views)
	for viewName,viewClass in pairs(views) do
		Debugger.LogError("viewName " .. viewName)
		Debugger.LogError(viewClass)
		dicViewClassCache[viewName] = viewClass
	end
end

function ViewManager.Init()
	local Main = UnityEngine.GameObject.Find('Main')
	UIRoot = UnityEngine.GameObject.Find('UIRoot')
	UINormal = UIRoot.transform:Find('Canvas/Normal').gameObject
	UIPopup = UIRoot.transform:Find('Canvas/Popup').gameObject
	UITop = UIRoot.transform:Find('Canvas/Top').gameObject
	CSharpTransfer.Instance:DontDestroyObj(Main)
	CSharpTransfer.Instance:DontDestroyObj(UIRoot)
end

function ViewManager.GetView(viewName)
	Debugger.LogError('ViewManager.GetView ' .. viewName)
	local view = dicViewClassCache[viewName].new()
	local function showFunc()

		local uidata = CSVParser.LoadCsv(CSVPaths.UIConfig,viewName)

		if view.gameObject ~= nil then

		else
			local uiGameObj = AssetsManager.Instance:GetAsset(uidata.path,typeof(UnityEngine.GameObject))
			uiGameObj.name = viewName
			view.gameObject = uiGameObj

			local sortLayerName = ''

			if uidata.layer == '1' then
				uiGameObj.transform.parent = UINormal.transform
				sortLayerName = LayerOrderName.UINormal
			elseif uidata.layer == '2' then
				uiGameObj.transform.parent = UIPopup.transform
				sortLayerName = LayerOrderName.UIPopup
			elseif uidata.layer == '3' then
				uiGameObj.transform.parent = UITop.transform
				sortLayerName = LayerOrderName.UITop
			end
			uiGameObj.transform.localPosition = Vector3.zero
			uiGameObj.transform.localScale = Vector3.one
			uiGameObj.transform.localRotation = Quaternion.identity
			local recttransform = uiGameObj:GetComponent('RectTransform')
			recttransform:SetAsLastSibling()

			local uidepth = LuaComponent.Add(uiGameObj,UIDepthLua)
			uidepth:SetLayerData(true,sortLayerName,1)

		end

		if uidata.layer == '1' then
			viewShow = normalViewCache[viewName]
		elseif uidata.layer == '2' then
			viewShow = popupViewCache[viewName]
		elseif uidata.layer == '3' then
			viewShow = topViewCache[viewName]
		end


	
	end
	view.showCallback = showFunc

	local function hideFunc()
		
	end
	view.Hide = hideFunc

	return view
end

function ViewManager.DestroyAllView(except)
	
end



