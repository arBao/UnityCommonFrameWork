require 'LuaComponent/Battle/JoyStick'

local ViewUIBattle = class(View)

function ViewUIBattle:OnAwake()
    self.ButtonSpeed = self:FindTransform('BtnSpeed'):GetComponent('ButtonCustom')
    self.JoyStick = LuaComponent.Add(self:FindTransform('JoyStick').gameObject,JoyStick)

    self.ButtonSpeed:SetClickAction(self,ViewUIBattle.OnClickButtonSpeed)
end

function ViewUIBattle:OnShowView()
	
end

function ViewUIBattle:OnHideView()
	
end

function ViewUIBattle:OnActive()
	
end

function ViewUIBattle:OnDeactive()
	
end

function ViewUIBattle:OnDestroy()
	
end

function ViewUIBattle:OnClickButtonSpeed(self,sender)
    if self.onClickButtonSpeedCallback ~= nil then
        self.onClickButtonSpeedCallback()
    end
end

return ViewUIBattle
