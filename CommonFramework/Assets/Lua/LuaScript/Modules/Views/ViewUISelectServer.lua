local ViewUISelectServer = class(View)

function ViewUISelectServer:OnAwake()
	self.ButtonConfirm = self:FindTransform('ButtonConfirm'):GetComponent('ButtonCustom')
	self.ButtonBack = self:FindTransform('ButtonBack'):GetComponent('ButtonCustom')

	self.ButtonConfirm:SetClickAction(self,ViewUISelectServer.OnClickConfirm)
	self.ButtonBack:SetClickAction(self,ViewUISelectServer.OnClickBack)
end

function ViewUISelectServer:OnShowView()
	
end

function ViewUISelectServer:OnHideView()
	
end

function ViewUISelectServer:OnActive()
	
end

function ViewUISelectServer:OnDeactive()
	
end

function ViewUISelectServer:OnDestroy()
	
end

--OnClicks

function ViewUISelectServer.OnClickConfirm(self,sender)
	if self.onclickBtnConfirmCallback ~= nil then
		self.onclickBtnConfirmCallback()
	end
end

function ViewUISelectServer.OnClickBack(self,sender)
	Debugger.LogError('ViewUISelectServer.OnClickBack')
	self:Hide()
end

return ViewUISelectServer



