require 'LuaComponent/Battle/JoyStick'

local ViewUIBattle = class(View)

function ViewUIBattle:OnAwake()
    self.ButtonSpeed = self:FindTransform('BtnSpeed'):GetComponent('ButtonCustom')
    self.BtnTestProcessMode = self:FindTransform('BtnTestProcessMode'):GetComponent('ButtonCustom')
    self.JoyStick = LuaComponent.Add(self:FindTransform('JoyStick').gameObject,JoyStick)

    self.ButtonSpeed:SetClickAction(self,ViewUIBattle.OnClickButtonSpeed)
    self.BtnTestProcessMode:SetClickAction(self,ViewUIBattle.OnClickBtnTestProcessMode)

    self.JoyStick.OnDragCallback = self.JoyStickOnDragCallback
    self.JoyStick.EndDragCallback = self.JoyStickEndDragCallback
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

function ViewUIBattle.OnClickButtonSpeed(self,sender)
    if self.onClickButtonSpeedCallback ~= nil then
        self.onClickButtonSpeedCallback()
    end
end

function ViewUIBattle.OnClickBtnTestProcessMode(self,sender)
    if self.onClickBtnTestProcessModeCallback ~= nil then
        self.onClickBtnTestProcessModeCallback()
    end
end

function ViewUIBattle:SetJoyStickOnDragCallback(func)
    self.JoyStick.OnDragCallback = func
end

function ViewUIBattle:SetJoyStickEndDragCallback(func)
    self.JoyStick.EndDragCallback = func
end

return ViewUIBattle
