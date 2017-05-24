local ViewUIPopUp1 = class(View)

function ViewUIPopUp1:OnAwake()
	self.ButtonConfirm = self:FindTransform('ButtonConfirm'):GetComponent('ButtonCustom')
	self.ButtonBack = self:FindTransform('ButtonBack'):GetComponent('ButtonCustom')

	self.ButtonConfirm:SetClickAction(self,ViewUIPopUp1.OnClickButtonConfirm)
	self.ButtonBack:SetClickAction(self,ViewUIPopUp1.OnClickButtonBack)
end

function ViewUIPopUp1:OnShowView()
	
end

function ViewUIPopUp1:OnHideView()
	
end

function ViewUIPopUp1:OnActive()
	
end

function ViewUIPopUp1:OnDeactive()
	
end

function ViewUIPopUp1:OnDestroy()
	
end

--onclick
function ViewUIPopUp1.OnClickButtonConfirm(self,sender)
	if self.onClickButtonConfirmCallback ~= nil then
		self.onClickButtonConfirmCallback()
	end
end

function ViewUIPopUp1.OnClickButtonBack(self,sender)
	self:Hide()
end

return ViewUIPopUp1
