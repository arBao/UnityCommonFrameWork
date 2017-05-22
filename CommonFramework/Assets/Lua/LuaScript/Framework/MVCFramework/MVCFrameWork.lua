require 'Framework/MVCFramework/Controller'
require 'Framework/MVCFramework/Model'
require 'Framework/MVCFramework/View'
require 'Framework/MVCFramework/ControllerManager'
require 'Framework/MVCFramework/ModelManager'
require 'Framework/MVCFramework/ViewManager'
require 'Framework/MVCFramework/MessageCenter'

MVCFrameWork = class()

local controllers = 
{
	['ControllerTest'] = require 'Modules/Controllers/ControllerTest',
	['ControllerLogin'] = require 'Modules/Controllers/ControllerLogin',
}

local models = 
{
	['ModelTest'] = require 'Modules/Models/ModelTest',
	['ModelLogin'] = require 'Modules/Models/ModelLogin',
}

local views = 
{
	['ViewTest'] = require 'Modules/Views/ViewTest',
	['ViewUILogin'] = require 'Modules/Views/ViewUILogin',
}

local function RegisterControllers()
	Debugger.LogError('RegisterControllers')
	ControllerManager.RegisterControllers(controllers)
end

local function RegisterModels()
	Debugger.LogError('RegisterModels')
	ModelManager.RegisterModels(models)
end

local function RegisterViews()
	Debugger.LogError('RegisterViews')
	ViewManager.Init()
	ViewManager.RegisterViews(views)
end

function MVCFrameWork.Init()
	RegisterControllers()
	RegisterModels()
	RegisterViews()
end