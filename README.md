## To Run

To run, download zip, cd to the directory, and then run

	twistd -no web --path=. --port=8000

Open localhost:8000 to see the demo. Enjoy.

If you don't have Twisted, you can also use:

	python -m SimpleHTTPServer

	or

	python -m http.server (for Python3 users)


## Changing the Submodule

`ClimateChange` contains a git submodule, `asp-phaser-generator-2`, which is a repository embedded inside another repository. 

So when you make changes to `asp-phaser-generator-2`, you'll need to commit them in both that repo _and_ the superproject it's embedded in, `ClimateChange`: 

#### 1. First commit/push the submodule's changes

(Make changes to the compiler in `ClimateChange/asp-phaser-generator-2/`)

Navigate to `ClimateChange/asp-phaser-generator-2/`
```
git commit
git push
```

#### 2. Then tell the main project, `ClimateChange`, to track the updated version 

Navigate to `ClimateChange/`
```
git add asp-phaser-generator-2
git commit
git push
```
