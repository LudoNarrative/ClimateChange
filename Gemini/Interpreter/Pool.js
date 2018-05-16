/* 
 * Pool class, including the subclass, subpool
 */

function Pool () {

	// A pool is made up of 1 or more subpools
	var subpools = [];

	// Subpool constructor
	function Subpool (row, col, locationType, withinType) {
		this.row = row;
		this.col = col;
		this.locationType = locationType;
		this.withinType = withinType;
	}

	var addSubpool = function (row, col, locationType, withinType) {
		subpools.push(new Subpool(row, col, locationType, withinType));
	}

	return {
		addSubpool : addSubpool,
		subpools : subpools
	}
}
