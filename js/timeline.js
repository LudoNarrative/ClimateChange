$.chain = function() {
    var promise = $.Deferred().resolve().promise();
    jQuery.each( arguments, function() {
        promise = promise.pipe( this );
    });
    return promise;
};

var content = {
	"0_low" : {
		"text" : "<h3>Dinner With Friends</h3><p>You are Emma Richards, a PhD student who studies <span class='mutable'>shrimp</span>.</p><p>Tomorrow, you'll be defending your thesis. Your friends decided to throw a dinner party for you.</p><p><span class='mutable'>Were you able to field their questions, while still passing food around the table?</span></p>",
		"artAccentSrc" : "",
		"climateFacts" : [
			{
				"title" : "2020 Climate Fact",
				"text" : "Most of the native bird population in Europe has collapsed, due to falling insect populations brought on by inclement weather. The ripples in the food chain have affected most of the agricultural output for those countries."
			}
		]
	},
	"1_low" : {
		"text" : "<h3>First Lecture-Low</h3><p>You wonder how your first lecture will go. Will you be in front of hundreds of students? Or maybe a smaller class? What will you talk about? It's hard to say, since you're still wrapping up work on your dissertation. Hopefully once you have your PhD, things will solidify.</p>",
		"artAccentSrc" : "",
		"climateFacts" : [
		{
				"title" : "2025 Climate Fact",
				"text" : "Most of the native bird population in Europe has collapsed, due to falling insect populations brought on by inclement weather. The ripples in the food chain have affected most of the agricultural output for those countries."
			}
		]
	},
	"1_medium" : {
		
		"text" : "<h3>First Lecture-Medium</h3><p>You wonder how your first lecture will go. Will you be in front of hundreds of students? Or maybe a smaller class? What will you talk about? It's hard to say, since you're still wrapping up work on your dissertation. Hopefully once you have your PhD, things will solidify.</p>",
		"artAccentSrc" : "",
		"climateFacts" : [{
				"title" : "2025 Climate Fact",
				"text" : "Most of the native bird population in Europe has collapsed, due to falling insect populations brought on by inclement weather. The ripples in the food chain have affected most of the agricultural output for those countries."
			}]
	},
	"1_high" : {
		
		"text" : "<h3>First Lecture-Hot</h3><p>You wonder how your first lecture will go. Will you be in front of hundreds of students? Or maybe a smaller class? What will you talk about? It's hard to say, since you're still wrapping up work on your dissertation. Hopefully once you have your PhD, things will solidify.</p>",
		"artAccentSrc" : "",
		"climateFacts" : [{
				"title" : "2025 Climate Fact",
				"text" : "Most of the native bird population in Europe has collapsed, due to falling insect populations brought on by inclement weather. The ripples in the food chain have affected most of the agricultural output for those countries."
			}]
	},
	"2_low" : {
		
		"text" : "<h3>Beach Scene-Low</h3>",
		"artAccentSrc" : "",
		"climateFacts" : [{
				"title" : "2035 Climate Fact",
				"text" : "Most of the native bird population in Europe has collapsed, due to falling insect populations brought on by inclement weather. The ripples in the food chain have affected most of the agricultural output for those countries."
			}]
	},
	"2_medium" : {
		
		"text" : "<h3>Beach Scene-Medium</h3>",
		"artAccentSrc" : "",
		"climateFacts" : [{
				"title" : "2035 Climate Fact",
				"text" : "Most of the native bird population in Europe has collapsed, due to falling insect populations brought on by inclement weather. The ripples in the food chain have affected most of the agricultural output for those countries."
			}]
	},
	"2_high": {
		
		"text" : "<h3>Beach Scene-High</h3>",
		"artAccentSrc" : "",
		"climateFacts" : [{
				"title" : "2035 Climate Fact",
				"text" : "Most of the native bird population in Europe has collapsed, due to falling insect populations brought on by inclement weather. The ripples in the food chain have affected most of the agricultural output for those countries."
			}]
	},
	"3_low" : {
		
		"text" : "<h3>Epilogue-Low</h3>",
		"artAccentSrc" : "",
		"climateFacts" : [{
				"title" : "2045 Climate Fact",
				"text" : "Most of the native bird population in Europe has collapsed, due to falling insect populations brought on by inclement weather. The ripples in the food chain have affected most of the agricultural output for those countries."
			}]
	},
	"3_medium" : {
		
		"text" : "<h3>Epilogue-Medium</h3>",
		"artAccentSrc" : "",
		"climateFacts" : [{
				"title" : "2045 Climate Fact",
				"text" : "Most of the native bird population in Europe has collapsed, due to falling insect populations brought on by inclement weather. The ripples in the food chain have affected most of the agricultural output for those countries."
			}]
	},
	"3_high": {
		
		"text" : "<h3>Epilogue-High</h3>",
		"artAccentSrc" : "",
		"climateFacts" : [{
				"title" : "2045 Climate Fact",
				"text" : "Most of the native bird population in Europe has collapsed, due to falling insect populations brought on by inclement weather. The ripples in the food chain have affected most of the agricultural output for those countries."
			}]
	}
};

//Timeline animations
function drawUpToPresent(){
		document.getElementById('upToPresent').classList.add('draw-in');
		setTimeout(function(){
			document.querySelector('.point.upToPresent').style.opacity = 1;
		}, 5000*1);
	}

	function fadeFutureGradient(){
		document.getElementById('futureGradient').classList.add('fade-in');
	}

	function drawFutureBottom(){
		document.getElementById('futureBottom').classList.add('draw-in');
		document.querySelectorAll('.point.futureBottom').forEach(function(point){
			point.style.opacity = 1;
		});
	}

	function drawFutureMiddle(){
		document.getElementById('futureMiddle').classList.add('draw-in');
		document.querySelectorAll('.point.futureMiddle').forEach(function(point){
			point.style.opacity = 1;
		});
	}

	function drawFutureTop(){
		document.getElementById('futureTop').classList.add('draw-in');
		document.querySelectorAll('.point.futureTop').forEach(function(point){
			point.style.opacity = 1;
		});
	}

	function showFirstScene(){
		document.getElementById('mainText').classList.add('fade-in-fast');
		document.getElementById('climateFacts').classList.add('fade-in-fast');
		document.getElementById('artAccent').classList.add('fade-in-fast');
	}
//end timeline animations

function circleClicked(timestep, level, theElement) {

	if ($("#mainText").css("display") == "none") { $("#mainText").fadeIn(1000);	}

	var animations = $.chain(function() {
		$("#climateFacts").fadeOut(1000);
	    return $("#mainTextContent").fadeOut(1000);				//"Our world is changing, something something..."
	}, function() {
		$("#mainTextContent").html(content[timestep + "_" + level].text);
		$("#climateFacts .title").html(content[timestep + "_" + level].climateFacts[0].title);
		$("#climateFacts .text").html(content[timestep + "_" + level].climateFacts[0].text);
		$("#climateFacts .title").fadeIn(1000);
		$("#climateFacts .text").fadeIn(1000);
		$("#climateFacts").fadeIn(1000);
		return $("#mainTextContent").fadeIn(1000);				//"Our world is changing, something something..."
	});

	$.when( animations ).done(function() {
	    // ALL ANIMATIONS HAVE BEEN DONE IN SEQUENCE
	});
	
	if ($("#artAccent").css("display") == "none") { $("#artAccent").fadeIn(1000);	}		//artAccent
	
	if ($("#climateFacts").css("display") == "none") { $("#climateFacts").fadeIn(1000);	}		//climateFacts

}

function startIntro() {

	var introTexts = [
		"Our world is changing...warming in an ever-accelerating<br/>reaction to humanity's continued development.",
		"We all have a part to play, together, in this...but each journey is also our own",
		"...steering into one of many possible futures.",
		"Maybe we can turn the tide to stem the worst of the changes.",
		"Maybe our action comes just too little, too late.",
		"Or maybe we let the chance to save our world slip through our fingers.",
		"What will you choose?"
	];

	var animations = $.chain(function() {
		$('#centerText').html(introTexts[0]);
	    return $('#centerText').fadeIn(1000);				//"Our world is changing, something something..."
	}, function() {
		return $('body').delay(3000);							//wait
	}, function() {
		return $('#blackout').fadeTo(1000, 0.5);					//fade in graph
	}, function() {
		drawUpToPresent();										//starts drawing to current day
	}, function() {
		return $('body').delay(2000);							//wait
	}, function() {
	    return $('#centerText').fadeOut(1000);			//fade out text
	}, function() {

	}, function() {
		$('#centerText').html(introTexts[1]);
		return $('#centerText').fadeIn(1000);			//"We all have a part to play, together, in this...but each journey is also our own"
	}, function() {
		return $('body').delay(3000);					//wait
	}, function() {
	    return $('#centerText').fadeOut(1000);			//fade out text
	}, function() {
		fadeFutureGradient();							//start animating gradient cone thingie
		$('#centerText').html(introTexts[2]);			//"...steering into one of many possible futures"
		return $('#centerText').fadeIn(1000);
	}, function() {
		return $('body').delay(3000);					//wait
	}, function() {
	    return $('#centerText').fadeOut(1000);			//fade out text
	}, function() {
		drawFutureBottom();								//draw in bottom line
		$('#centerText').html(introTexts[3]);			//"Maybe we do cool things"
		return $('#centerText').fadeIn(1000);
	}, function() {
		return $('body').delay(3000);					//wait
	}, function() {
	    return $('#centerText').fadeOut(1000);			//fade out text
	}, function() {
		drawFutureMiddle();								//draw in middle line
		$('#centerText').html(introTexts[4]);			//"Maybe things aren't so great"
		return $('#centerText').fadeIn(1000);
	}, function() {
		return $('body').delay(3000);					//wait
	}, function() {
	    return $('#centerText').fadeOut(1000);			//fade out text
	}, function() {
		drawFutureTop();								//draw in top line
		$('#centerText').html(introTexts[5]);			//"Or maybe we let the chance to save our world slip through our fingers."
		return $('#centerText').fadeIn(1000);
	}, function() {
		return $('body').delay(3000);					//wait
	}, function() {
	    return $('#centerText').fadeOut(1000);			//fade out text
	}, function() {
		$('#centerText').html(introTexts[6]);			//"What will you choose?"
		return $('#centerText').fadeIn(1000);
	}, function() {
		return $('body').delay(3000);					//wait
	}, function() {
		$('#blackout').fadeOut(1000);					//fade in graph all the way
	    return $('#centerText').fadeOut(1000);			//fade out text
	}, function() {
		circleClicked(0, "low");						//trigger click action on first timeline dot
	}
	);

	$.when( animations ).done(function() {
	    // ALL ANIMATIONS HAVE BEEN DONE IN SEQUENCE
	});
}