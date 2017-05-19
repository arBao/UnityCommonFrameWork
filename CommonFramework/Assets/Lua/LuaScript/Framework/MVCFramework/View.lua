View = class()

function View:cotr()
	self.showCallback = nil
	self.hideCallback = nil
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