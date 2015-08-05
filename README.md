## What is HypedJS? 
HypedJS is a lightweight, open-source JavaScript tool that lets you quickly create and embed hypertext stories and experiences.

## How do I use HypedJS?
1. Fork and clone a local copy of the repo.

2. Skip to Step 3 if you want to view the demo.  Otherwise, continue to Step 2.

3. To make change the text, edit the demo.json file. This file contains data about each passage in your hypertext experience.

  * Each passage should have an identifying **title**, static text that describes the **scene**, and an array of **choices**.
  
  * A scene is an array of Strings, with each element being a separate paragraph in the scene. Each choice contains the text for that choice, and a reference (title) for the passage to which this choice should link.

  * The first passage displayed should have a title of **Start**.

  * You can set hidden variables with String or number values.  Somewhere inside your scene description, simply write **@@set PARAM-NAME to PARAM-VALUE@@**.

  * To retrieve and state the value for a parameter, use the command **@@get PARAM-NAME@@**. You can state a parameter value during a scene, or inside the text of a choice.

4. Open the terminal / command line.

  * Change directory (cd) into the HypedJS folder.

  * Type **python -m SimpleHTTPServer** to get a simple server running. This will avoid cross-origin issues when reading the JSON file locally.

5. Open localhost:8000 in your web browser to view the result.


5) That's it! You can play around with the JS, CSS, and HTML to make it your own.