View = class()

function View:cotr()
	self.showCallback = nil
	self.hideCallback = nil
	self.gameObject = null
	self.isShow = false
	self.findTransformCallback = nil
	self.transformCache = nil
end

function View:SetViewData(viewDataParm)
	self.viewData = viewDataParm

end

function View:GetViewData()
	return self.viewData
end

function View:Show()
	self.showCallback()
end

function View:Hide()
	self.hideCallback()
end

function View:FindTransform(name)
	return self.findTransformCallback(name)
end

function View:OnAwake()
	
end

function View:OnShowView()
	
end

function View:OnHideView()
	
end

function View:OnActive()
	
end

function View:OnDeactive()
	
end

function View:OnDestroy()
	
end

