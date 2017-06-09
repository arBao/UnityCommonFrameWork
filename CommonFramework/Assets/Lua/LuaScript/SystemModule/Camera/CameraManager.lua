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
---获取摄像机视野
function CameraManager:GetBattleCameraField()
    if self.BattleCamera == nil then
        self.BattleCamera = UnityEngine.GameObject.Find('BattleCamera'):GetComponent('Camera')
        self.BattleCameraTransform = self.BattleCamera.transform
        self.scale = UnityEngine.Screen.width / UnityEngine.Screen.height
        self.orthographicSize = self.BattleCamera.orthographicSize
    end

    local cameraPos = self.BattleCameraTransform.position
    local delta = 1.1
    local width = self.orthographicSize * self.scale * delta
    local height = self.orthographicSize * delta
    local t = {['xLeft'] = cameraPos.x - width,['xRight'] = cameraPos.x + width,
        ['yBottom'] = cameraPos.y - height,['yTop'] = cameraPos.y + height}
    UnityEngine.Debug.DrawLine(Vector3.New(t.xLeft,t.yTop,-10),Vector3.New(t.xRight,t.yTop,-10),Color.red)
    UnityEngine.Debug.DrawLine(Vector3.New(t.xLeft,t.yTop,-10),Vector3.New(t.xLeft,t.yBottom,-10),Color.red)
    UnityEngine.Debug.DrawLine(Vector3.New(t.xRight,t.yTop,-10),Vector3.New(t.xRight,t.yBottom,-10),Color.red)
    UnityEngine.Debug.DrawLine(Vector3.New(t.xLeft,t.yBottom,-10),Vector3.New(t.xRight,t.yBottom,-10),Color.red)
    return t
end