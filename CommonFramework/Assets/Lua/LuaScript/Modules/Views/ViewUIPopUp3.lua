local ViewUIPopUp3 = class(View)

function ViewUIPopUp3:OnAwake()
	self.ButtonConfirm = self:FindTransform('ButtonConfirm'):GetComponent('ButtonCustom')
	self.ButtonBack = self:FindTransform('ButtonBack'):GetComponent('ButtonCustom')

	self.ButtonConfirm:SetClickAction(self,ViewUIPopUp3.OnClickButtonConfirm)
	self.ButtonBack:SetClickAction(self,ViewUIPopUp3.OnClickButtonBack)
end

function ViewUIPopUp3:OnShowView()
	
end

function ViewUIPopUp3:OnHideView()
	
end

function ViewUIPopUp3:OnActive()
	
end

function ViewUIPopUp3:OnDeactive()
	
end

function ViewUIPopUp3:OnDestroy()
	
end

--onclick
function ViewUIPopUp3.OnClickButtonConfirm(self,sender)
	if self.onClickButtonConfirmCallback ~= nil then
		self.onClickButtonConfirmCallback()
	end
end

function ViewUIPopUp3.OnClickButtonBack(self,sender)
	self:Hide()
end

return ViewUIPopUp3
