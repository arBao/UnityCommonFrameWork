ViewManager = class()
local viewClassCacheDic = {}--view类
local viewInstanceCache = {}--实例化后的view
local viewNormalPopupStackArray = {}--view Normal和Popup管理栈
local viewTopStackArray = {}--view Top层管理栈
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

local function SetTransformDic(transform,dicTransforms)
    dicTransforms[transform.name] = transform
    for i = 0,transform.childCount - 1,1 do
     	SetTransformDic(transform:GetChild(i),dicTransforms)
    end
end 

local function SetHideView(view)
	view.gameObject:SetActive(false)
	view.isShow = false
	view:OnDeactive()
	view:OnHideView()
end

local function SetShowView(view)
	view.gameObject:SetActive(true)
	view.isShow = true
	view:OnShowView()
	view:OnActive()
end

local function SortNormalPopupLayerNums()
	local normalOrderCnt = 1
	local popupOrderCnt = 1
	for i = 1,#viewNormalPopupStackArray do
		local viewInStack = viewNormalPopupStackArray[i]
		if viewInStack.layer == LayerOrderNum.UINormal then
			if viewInStack.isShow == true then
				local uidepth = LuaComponent.Get(viewInStack.gameObject,UIDepthLua)
				uidepth:SetLayerOrderNum(normalOrderCnt)
				normalOrderCnt = normalOrderCnt + 1
			end
		else 
			if viewInStack.isShow == true then
				local uidepth = LuaComponent.Get(viewInStack.gameObject,UIDepthLua)
				uidepth:SetLayerOrderNum(popupOrderCnt)
				popupOrderCnt = popupOrderCnt + 1
			end
		end
	end
end

local function SortTopLayerNums()
	local topOrderCnt = 1
	for i = 1,#viewTopStackArray do
		local viewInStack = viewTopStackArray[i]
		local uidepth = LuaComponent.Get(viewInStack.gameObject,UIDepthLua)
		uidepth:SetLayerOrderNum(topOrderCnt)
		topOrderCnt = topOrderCnt + 1
	end
end

function ViewManager.GetView(viewName)
	Debugger.LogError('ViewManager.GetView ' .. viewName)
	local view = viewClassCacheDic[viewName].new()
	view.name = viewName

	local function showFunc()
		if view.isShow then
			return
		end
		if view.gameObject ~= nil then

		else
			local uidata = CSVParser.LoadCsv(CSVPaths.UIConfig,viewName)
			local uiGameObj = AssetsManager.Instance:GetAsset(uidata.path,typeof(UnityEngine.GameObject))
			uiGameObj.name = viewName
			view.gameObject = uiGameObj
			view.transformCache = {}
			SetTransformDic(view.gameObject.transform,view.transformCache)

			view.layer = uidata.layer
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

			uiGameObj:AddComponent(typeof(UnityEngine.UI.GraphicRaycaster))
			view:OnAwake()
			
		end

		SetShowView(view)
		--如果是normal层的界面，就要隐藏栈里面的已界面显示
		if view.layer == LayerOrderNum.UINormal then
			Debugger.LogError('if view.layer == LayerOrderName.UINormal then')
			for i = #viewNormalPopupStackArray, 1, -1 do
				local viewInStack = viewNormalPopupStackArray[i]
				if viewInStack.isShow == true then
					SetHideView(viewInStack)
				end
			end
		end

		--入栈并设置sortlayernum
		if view.layer == LayerOrderNum.UINormal or view.layer == LayerOrderNum.UIPopup then
			table.insert(viewNormalPopupStackArray,view)
			SortNormalPopupLayerNums()
		else
			table.insert(viewTopStackArray,view)
			SortTopLayerNums()
		end

	end
	view.showCallback = showFunc

	local function hideFunc()
		if view.layer == LayerOrderNum.UINormal then
			SetHideView(view)
			table.remove(viewNormalPopupStackArray)
			for i = #viewNormalPopupStackArray, 1, -1 do
				local viewInStack = viewNormalPopupStackArray[i]
				SetShowView(viewInStack)
				if viewInStack.layer == LayerOrderNum.UINormal then
					break
				end
			end
			SortNormalPopupLayerNums()

		elseif view.layer == LayerOrderNum.UIPopup then
			SetHideView(view)
			table.remove(viewNormalPopupStackArray)
			SortNormalPopupLayerNums()
		else
			SetHideView(view)
			table.remove(viewTopStackArray)
			SortTopLayerNums()
		end
		
	end
	view.hideCallback = hideFunc

	local function findTransform(name)
		local transform = view.transformCache[name]
     	if transform == nil then
     		Debugger.LogError('name transform not found ' .. name .. '  view  ' .. viewName)
     	end
     	return transform
	end
	view.findTransformCallback = findTransform

	return view
end

function ViewManager.DestroyAllView(except)
	
end



