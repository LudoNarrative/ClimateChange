/*
 *
 */

function Action (operation="", args=[]) {

	this.operation = operation;
	this.args = args;


	var applyAction = function (operation, args) {

		// switch on operation
		// sometimes returning a value where appropriate

		switch (operation) {

			case 'set_value' : 
				console.log("apply set value action");
				

		}
		
	}

	var evaluateValue = function () {

	}

	
}