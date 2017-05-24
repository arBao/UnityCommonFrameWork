local ViewUITop1 = class(View)

function ViewUITop1:OnAwake()
	self.ButtonConfirm = self:FindTransform('ButtonConfirm'):GetComponent('ButtonCustom')
	self.ButtonBack = self:FindTransform('ButtonBack'):GetComponent('ButtonCustom')

	self.ButtonConfirm:SetClickAction(self,ViewUITop1.OnClickButtonConfirm)
	self.ButtonBack:SetClickAction(self,ViewUITop1.OnClickBack)
end

function ViewUITop1:OnShowView()
	
end

function ViewUITop1:OnHideView()
	
end

function ViewUITop1:OnActive()
	
end

function ViewUITop1:OnDeactive()
	
end

function ViewUITop1:OnDestroy()
	
end

--onclick
function ViewUITop1.OnClickButtonConfirm(self,sender)
	if self.onClickButtonConfirmCallback ~= nil then
		self.onClickButtonConfirmCallback()
	end
end

function ViewUITop1.OnClickBack(self,sender)
	self:Hide()
end

return ViewUITop1
