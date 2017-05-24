local ViewUILogin = class(View)

function ViewUILogin:OnAwake()
	self.testNum = 666
	self.InputName = self:FindTransform('InputName')
	self.ButtonLogin = self:FindTransform('ButtonLogin'):GetComponent('ButtonCustom')

	self.ButtonLogin:SetClickAction(self,ViewUILogin.OnClickLogin)
end

function ViewUILogin:OnShowView()
	
end

function ViewUILogin:OnHideView()
	
end

function ViewUILogin:OnActive()
	
end

function ViewUILogin:OnDeactive()
	
end

function ViewUILogin:OnDestroy()
	
end

--OnClicks

function ViewUILogin.OnClickLogin(self,sender)
	if self.OnClickButtonLoginCallback ~= nil then
		self.OnClickButtonLoginCallback()
	end
end

return ViewUILogin