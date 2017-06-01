---
--- Created by luzhuqiu.
--- DateTime: 2017/6/1 下午4:40
---
SceneMgr = class()
local m_progressAction
local m_finishCallback

local function SceneMgrUpdate(operation)
    if m_progressAction ~= nil then
        m_progressAction(operation)
    end
    if operation.isDone then
        UpdateBeat:Remove(SceneMgrUpdate,operation)

        ViewManager.DestroyAllView('ViewUILoading')

        m_progressAction = nil
        if m_finishCallback ~= nil then
            m_finishCallback()
        end
    end
end

function SceneMgr.LoadSyny(name)
    UnityEngine.SceneManagement.SceneManager.LoadScene(name)
end

function SceneMgr.LoadASyny(name,progressAction,finishCallback,isShowLoadingUI)
    m_finishCallback = finishCallback
    local operation = UnityEngine.SceneManagement.SceneManager.LoadSceneAsync(name)
    if progressAction ~= nil then
        m_progressAction = progressAction
        UpdateBeat:Add(SceneMgrUpdate, operation)
    end
end