MVCRegister = {
	
	Controllers = 
	{
		['ControllerTest'] = require 'Modules/Controllers/ControllerTest',
		['ControllerLogin'] = require 'Modules/Controllers/ControllerLogin',
		['ControllerSelectServer'] = require 'Modules/Controllers/ControllerSelectServer',
		['ControllerPopUp1'] = require 'Modules/Controllers/ControllerPopUp1',
		['ControllerTop1'] = require 'Modules/Controllers/ControllerTop1',
	},

	Models = 
	{
		['ModelTest'] = require 'Modules/Models/ModelTest',
		['ModelLogin'] = require 'Modules/Models/ModelLogin',
		['ModelSelectServer'] = require 'Modules/Models/ModelSelectServer',
		['ModelPopUp1'] = require 'Modules/Models/ModelPopUp1',
		['ModelTop1'] = require 'Modules/Models/ModelTop1',
	},

	Views = 
	{
		['ViewTest'] = require 'Modules/Views/ViewTest',
		['ViewUILogin'] = require 'Modules/Views/ViewUILogin',
		['ViewUISelectServer'] = require 'Modules/Views/ViewUISelectServer',
		['ViewUIPopUp1'] = require 'Modules/Views/ViewUIPopUp1',
		['ViewUITop1'] = require 'Modules/Views/ViewUITop1',
	},
}