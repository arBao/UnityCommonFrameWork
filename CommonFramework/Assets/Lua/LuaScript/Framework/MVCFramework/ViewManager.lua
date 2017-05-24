ViewManager = class()
local viewClassCacheDic = {}--view类
local viewInstanceCache = {}--实例化后的view
local viewStackArray = {}--view栈
local UIRoot = nil
local UINormal = nil
local UIPopup = nil
local UITop = nil
--UI节点上的gameobject名称
local LayerOrderName = {
	UINormal = 'UINormal',
	UIPopup = 'UIPopup',
	UITop = 'UITop',
}

--表数据里面的layer字段值
local LayerOrderNum = {
	UINormal = '1',
	UIPopup = '2',
	UITop = '3',
}

function ViewManager.RegisterViews(views)
	for viewName,viewClass in pairs(views) do
		Debugger.LogError("viewName " .. viewName)
		Debugger.LogError(viewClass)
		viewClassCacheDic[viewName] = viewClass
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
	local view = viewClassCacheDic[viewName].new()

	local function showFunc()

		local uidata = CSVParser.LoadCsv(CSVPaths.UIConfig,viewName)

		if view.gameObject ~= nil then

		else
			local uiGameObj = AssetsManager.Instance:GetAsset(uidata.path,typeof(UnityEngine.GameObject))
			uiGameObj.name = viewName
			view.gameObject = uiGameObj

			local sortLayerName = ''

			if uidata.layer == LayerOrderNum.UINormal then
				uiGameObj.transform.parent = UINormal.transform
				sortLayerName = LayerOrderName.UINormal
			elseif uidata.layer == LayerOrderNum.UIPopup then
				uiGameObj.transform.parent = UIPopup.transform
				sortLayerName = LayerOrderName.UIPopup
			elseif uidata.layer == LayerOrderNum.UITop then
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

			view:OnAwake()

		end
		--隐藏栈里面的已界面显示
		if uidata.layer == LayerOrderNum.UINormal then

		elseif uidata.layer == LayerOrderNum.UIPopup then

		elseif uidata.layer == LayerOrderNum.UITop then

		end
		
		table.insert(viewStackArray,view)
	
	end
	view.showCallback = showFunc

	local function hideFunc()
		
	end
	view.Hide = hideFunc

	return view
end

function ViewManager.DestroyAllView(except)
	
end



