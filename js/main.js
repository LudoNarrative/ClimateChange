/**
 * Copyright (c) 2015 Sarah Harmon
 *
 * This source code is free to use under the GNU General Public License (GPL) with author attribution.
 *
 * The following code will read in data from the demo.json file, and
 * construct Passage objects.  It will then display the Passage with
 * the title "Start".
 *
 **/

// A dictionary to store Passages.
passages = {};
filename = "../demo.json";

// Read in passage data from demo.json
$.getJSON( filename, function( data ) {

	// For each set of passage data,
	for (var i=0; i<data.length; i++){

		// Construct the list of choices.
		var choiceList = new Choices([]);
		for (var j=0; j<data[i].choices.length;j++){
			choiceList.addChoice(data[i].choices[j][0],data[i].choices[j][1]);
		}

		// Define the data as a Passage object.
		var p = new Passage(data[i].title, data[i].scene, choiceList);

		// Add the Passage object to a searchable dictionary, with passage titles as keys.
		passages[p.title] = p;
	}

	// Display the first passage.
	passages["Start"].render();
});
