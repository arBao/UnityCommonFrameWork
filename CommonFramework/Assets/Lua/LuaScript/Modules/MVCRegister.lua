MVCRegister = {
	
	Controllers = 
	{
		['ControllerTest'] = require 'Modules/Controllers/ControllerTest',
		['ControllerLogin'] = require 'Modules/Controllers/ControllerLogin',
		['ControllerSelectServer'] = require 'Modules/Controllers/ControllerSelectServer',
		['ControllerPopUp1'] = require 'Modules/Controllers/ControllerPopUp1',
		['ControllerPopUp2'] = require 'Modules/Controllers/ControllerPopUp2',
		['ControllerTop1'] = require 'Modules/Controllers/ControllerTop1',
		['ControllerTop2'] = require 'Modules/Controllers/ControllerTop2',
	},

	Models = 
	{
		['ModelTest'] = require 'Modules/Models/ModelTest',
		['ModelLogin'] = require 'Modules/Models/ModelLogin',
		['ModelSelectServer'] = require 'Modules/Models/ModelSelectServer',
		['ModelPopUp1'] = require 'Modules/Models/ModelPopUp1',
		['ModelPopUp2'] = require 'Modules/Models/ModelPopUp2',
		['ModelTop1'] = require 'Modules/Models/ModelTop1',
		['ModelTop2'] = require 'Modules/Models/ModelTop2',
	},

	Views = 
	{
		['ViewTest'] = require 'Modules/Views/ViewTest',
		['ViewUILogin'] = require 'Modules/Views/ViewUILogin',
		['ViewUISelectServer'] = require 'Modules/Views/ViewUISelectServer',
		['ViewUIPopUp1'] = require 'Modules/Views/ViewUIPopUp1',
		['ViewUIPopUp2'] = require 'Modules/Views/ViewUIPopUp2',
		['ViewUITop1'] = require 'Modules/Views/ViewUITop1',
		['ViewUITop2'] = require 'Modules/Views/ViewUITop2',
	},
}