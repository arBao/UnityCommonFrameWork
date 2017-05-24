MVCRegister = {
	
	Controllers = 
	{
		['ControllerTest'] = require 'Modules/Controllers/ControllerTest',
		['ControllerLogin'] = require 'Modules/Controllers/ControllerLogin',
		['ControllerSelectServer'] = require 'Modules/Controllers/ControllerSelectServer',
	},

	Models = 
	{
		['ModelTest'] = require 'Modules/Models/ModelTest',
		['ModelLogin'] = require 'Modules/Models/ModelLogin',
		['ModelSelectServer'] = require 'Modules/Models/ModelSelectServer',
	},

	Views = 
	{
		['ViewTest'] = require 'Modules/Views/ViewTest',
		['ViewUILogin'] = require 'Modules/Views/ViewUILogin',
		['ViewUISelectServer'] = require 'Modules/Views/ViewUISelectServer',
	},
}