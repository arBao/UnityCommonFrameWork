local ViewUITop2 = class(View)

function ViewUITop2:OnAwake()
	self.ButtonBack = self:FindTransform('ButtonBack'):GetComponent('ButtonCustom')

	self.ButtonBack:SetClickAction(self,ViewUITop2.OnClickBack)
end

function ViewUITop2:OnShowView()
	
end

function ViewUITop2:OnHideView()
	
end

function ViewUITop2:OnActive()
	
end

function ViewUITop2:OnDeactive()
	
end

function ViewUITop2:OnDestroy()
	
end

function ViewUITop2.OnClickBack(self,sender)
	self:Hide()
end

return ViewUITop2
