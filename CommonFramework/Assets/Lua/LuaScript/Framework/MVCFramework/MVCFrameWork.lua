require 'Framework/MVCFramework/Controller'
require 'Framework/MVCFramework/Model'
require 'Framework/MVCFramework/View'
require 'Framework/MVCFramework/ControllerManager'
require 'Framework/MVCFramework/ModelManager'
require 'Framework/MVCFramework/ViewManager'
require 'Framework/MVCFramework/MessageCenter'
require 'Framework/MVCFramework/BaseComponent/UIDepthLua'
require 'Modules/MVCRegister'

MVCFrameWork = class()

local function RegisterControllers()
	-- Debugger.LogError('RegisterControllers')
	ControllerManager.RegisterControllers(MVCRegister.Controllers)
end

local function RegisterModels()
	-- Debugger.LogError('RegisterModels')
	ModelManager.RegisterModels(MVCRegister.Models)
end

local function RegisterViews()
	-- Debugger.LogError('RegisterViews')
	ViewManager.Init()
	ViewManager.RegisterViews(MVCRegister.Views)
end

function MVCFrameWork.Init()
	RegisterControllers()
	RegisterModels()
	RegisterViews()
end