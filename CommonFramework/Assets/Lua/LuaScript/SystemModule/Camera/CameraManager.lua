---
--- Created by luzhuqiu.
--- DateTime: 2017/6/7 下午12:10
---
CameraManager = class()
function CameraManager:GetInstance()
    if self.m_instance == nil then
        self.m_instance = CameraManager.new()
    end
    return self.m_instance
end

function CameraManager:GetUICamera()
    if self.uiCamera == nil then
        self.uiCamera = UnityEngine.GameObject.Find('UICamera'):GetComponent('Camera')
    end
    return self.uiCamera
end