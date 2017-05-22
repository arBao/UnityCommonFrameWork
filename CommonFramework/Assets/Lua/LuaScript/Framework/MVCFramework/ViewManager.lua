ViewManager = class()
local dicViews = {}
local uiobjsCache = {}
local UIRoot = nil
local UINormal = nil
local UIPopup = nil
local UITop = nil

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
	UINormal = UIRoot.transform:Find('Canvas/Normal').gameObject
	UIPopup = UIRoot.transform:Find('Canvas/Popup').gameObject
	UITop = UIRoot.transform:Find('Canvas/Top').gameObject
	CSharpTransfer.Instance:DontDestroyObj(Main)
	CSharpTransfer.Instance:DontDestroyObj(UIRoot)
end

function ViewManager.GetView(viewName)
	Debugger.LogError('ViewManager.GetView ' .. viewName)
	
	
	local view = dicViews[viewName].new()
	
	local function showFunc()
		local uidata = CSVParser.LoadCsv(CSVPaths.UIConfig,viewName)
		local uiGameObj = AssetsManager.Instance:GetAsset(uidata.path,typeof(UnityEngine.GameObject))
		uiGameObj.name = viewName
		view.uiobj = uiGameObj
		table.insert(uiobjsCache,uiGameObj)
		if uidata.layer == '1' then
			uiGameObj.transform.parent = UINormal.transform
		elseif uidata.layer == '2' then
			uiGameObj.transform.parent = UIPopup.transform
		elseif uidata.layer == '3' then
			uiGameObj.transform.parent = UITop.transform
		end
		uiGameObj.transform.localPosition = Vector3.zero
		uiGameObj.transform.localScale = Vector3.one
		uiGameObj.transform.localRotation = Quaternion.identity
		local recttransform = uiGameObj:GetComponent('RectTransform')
		recttransform:SetAsLastSibling()


		
	end
	view.showCallback = showFunc

	local function hideFunc()
		
	end
	view.Hide = hideFunc

	return view
end



