local ViewUIPopUp4 = class(View)

function ViewUIPopUp4:OnAwake()
	self.ButtonConfirm = self:FindTransform('ButtonConfirm'):GetComponent('ButtonCustom')
	self.ButtonBack = self:FindTransform('ButtonBack'):GetComponent('ButtonCustom')

	self.ButtonConfirm:SetClickAction(self,ViewUIPopUp4.OnClickButtonConfirm)
	self.ButtonBack:SetClickAction(self,ViewUIPopUp4.OnClickButtonBack)
end

function ViewUIPopUp4:OnShowView()
	
end

function ViewUIPopUp4:OnHideView()
	
end

function ViewUIPopUp4:OnActive()
	
end

function ViewUIPopUp4:OnDeactive()
	
end

function ViewUIPopUp4:OnDestroy()
	
end

--onclick
function ViewUIPopUp4.OnClickButtonConfirm(self,sender)
	if self.onClickButtonConfirmCallback ~= nil then
		self.onClickButtonConfirmCallback()
	end
end

function ViewUIPopUp4.OnClickButtonBack(self,sender)
	self:Hide()
end

return ViewUIPopUp4
