local ViewUILogin = class(View)

function ViewUILogin:OnAwake()
	self.testNum = 666
	self.InputName = self:FindTransform('InputName')
	self.ButtonLogin = self:FindTransform('ButtonLogin'):GetComponent('ButtonCustom')
	self.ButtonSend = self:FindTransform('ButtonSend'):GetComponent('ButtonCustom')
	self.ButtonLinkTest = self:FindTransform('ButtonLinkTest'):GetComponent('ButtonCustom')
	self.ButtonBattle = self:FindTransform('ButtonBattle'):GetComponent('ButtonCustom')

	self.ButtonLogin:SetClickAction(self,ViewUILogin.OnClickLogin)
	self.ButtonSend:SetClickAction(self,ViewUILogin.OnClickButtonSend)
	self.ButtonLinkTest:SetClickAction(self,ViewUILogin.OnClickButtonLinkTest)
	self.ButtonBattle:SetClickAction(self,ViewUILogin.OnClickButtonBattle)
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

function ViewUILogin.OnClickButtonSend(self,sender)
    if self.OnClickButtonSendCallback ~= nil then
        self.OnClickButtonSendCallback()
    end
end

function ViewUILogin.OnClickButtonLinkTest(self,sender)
	if self.OnClickButtonLinkTestCallback ~= nil then
		self.OnClickButtonLinkTestCallback()
	end
end

function ViewUILogin.OnClickButtonBattle(self,sender)
	if self.OnClickButtonBattleCallback ~= nil then
		self.OnClickButtonBattleCallback()
	end
end

return ViewUILogin