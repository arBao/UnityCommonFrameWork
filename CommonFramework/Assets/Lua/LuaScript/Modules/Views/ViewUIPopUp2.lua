local ViewUIPopUp2 = class(View)

function ViewUIPopUp2:OnAwake()
	self.ButtonConfirm = self:FindTransform('ButtonConfirm'):GetComponent('ButtonCustom')

	self.ButtonConfirm:SetClickAction(self,ViewUIPopUp2.OnClickButtonConfirm)
end

function ViewUIPopUp2:OnShowView()
	
end

function ViewUIPopUp2:OnHideView()
	
end

function ViewUIPopUp2:OnActive()
	
end

function ViewUIPopUp2:OnDeactive()
	
end

function ViewUIPopUp2:OnDestroy()
	
end

--onclick
function ViewUIPopUp2.OnClickButtonConfirm(self,sender)
	if self.onClickButtonConfirmCallback ~= nil then
		self.onClickButtonConfirmCallback()
	end
end

return ViewUIPopUp2
