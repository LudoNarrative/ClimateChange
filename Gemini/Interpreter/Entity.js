/*
 * Entity class
 */ 
function Entity (label="", many=true) {

	// Can have either "this." syntax (which makes the variable public),
	// or "var" syntax, and use getters/setters
	this.label = label;
	this.many = many;

}