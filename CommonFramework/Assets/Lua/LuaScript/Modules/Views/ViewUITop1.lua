local ViewUITop1 = class(View)

function ViewUITop1:OnAwake()
	self.ButtonConfirm = self:FindTransform('ButtonConfirm'):GetComponent('ButtonCustom')

	self.ButtonConfirm:SetClickAction(self,ViewUITop1.OnClickButtonConfirm)
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

return ViewUITop1
