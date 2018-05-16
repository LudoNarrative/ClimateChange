/*
 * Resource class
 */

function Resource (label="", privacy="private", initialValue=0) {

	this.label = label;
	this.privacy = privacy;
	this.initialValue = initialValue;
	this.value = initialValue;

	var minValue = 0;
	var maxValue = 10;

	var getValue = function () 		{ return this.value; }
	var setValue = function (newValue) { this.value = newValue; }

	return {
		getValue : getValue,
		setValue : setValue
	}
}
