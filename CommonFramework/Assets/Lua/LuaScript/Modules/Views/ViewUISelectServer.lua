local ViewUISelectServer = class(View)

function ViewUISelectServer:OnAwake()
	self.ButtonConfirm = self:FindTransform('ButtonConfirm'):GetComponent('ButtonCustom')
	self.ButtonConfirm:SetClickAction(self,ViewUISelectServer.OnClickConfirm)
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

return ViewUISelectServer
