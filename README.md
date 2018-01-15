# Climate Change

A game with concurrent story and game generation. 

## To Run the Game

To run the Climate Change game, download zip, cd to the directory, and then run

	twistd -no web --path=. --port=8000

Open localhost:8000 to see the demo. Enjoy.

If you don't have Twisted, you can also use:

	python -m SimpleHTTPServer
	or
	python -m http.server (for Python3 users)

---

## The Cygnus Game Compiler

ClimateChange contains a git submodule; a repository embedded inside another repository. asp-phaser-generator-2 is the compiler which converts a Cygnus game (the ASP game spec outputted by Gemini) into Javascript/Phaser. There are some special considerations for developing with a git submodule. 

### First time developer setup

Initialize project and submodule: 

	git clone --recurse-submodules https://github.com/LudoNarrative/ClimateChange.git

Set config to automatically give more helpful log and diff messages:

	cd ClimateChange
	git config --global status.submoduleSummary true
	git config --global diff.submodule log

Currently the submodule's head is detached (checked out to some commit that isn't master). So pushing won't work (from neither submodule nor superproject). We need asp-phaser-generator-2 to have a local branch that tracks remote changes.

	cd asp-phaser-generator-2
	git checkout master

(Master, by default, tracks origin/master.) If you ever see `HEAD detached at ...` in status, you should checkout master again.

### Making changes to the compiler (asp-generator-2)

Since asp-phaser-generator-2 is a repository embedded inside another repository, when you make changes to asp-phaser-generator-2, you'll need to commit them in both that repo _and_ the superproject it's embedded in, ClimateChange: 

1. First commit the submodule's changes
(You can make changes to the compiler directly in ClimateChange/asp-phaser-generator-2/. No need to make a separate clone.)
Navigate to ClimateChange/asp-phaser-generator-2/
`git commit`

2. Then tell the main project, ClimateChange, to track the updated version and commit 
Navigate to ClimateChange/

	git add asp-phaser-generator-2
	git commit

3. Then push both commits to their respective remote repositories

	git push --recurse-submodules=on-demand

### To update your local version of the submodule from remote
from ClimateChange: 

	git submodule update --remote

