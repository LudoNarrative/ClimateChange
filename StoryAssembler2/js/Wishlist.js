/* Implements a Wishlist for StoryAssembler.

A wishlist is an unordered set of Wants.
*/

define(["Want", "Request", "util"], function(Want, Request, util) {

	var create = function(items) {
		items = items || [];
		var _wants = {};
		// Add the wants passed in to the constructor.
		var want;
		items.forEach(function(item) {
			want = Want.create(item); // will throw error if any wants in list are invalid
			_wants[want.id] = want;
		});

		// Interface functions for the Wishlist.
		var remove = function(id) {
			delete _wants[id];
		}

		var selectNext = function() {
			if (wantsRemaining() > 0) {
				return _wants[util.oneOf(Object.keys(_wants))];
			}
			return undefined;
		}

		var findBestPath = function(chunkLibrary) {
			var paths = [];
			var want = this.selectNext().request;
			console.log("want", want);

			var keys = chunkLibrary.getKeys();
			for (var i = 0; i < keys.length; i++) {
				var chunk = chunkLibrary.get(keys[i]);
				console.log("considering " + chunk.id);
				var result = findAllSatisfyingPathsFrom(chunk, want, chunkLibrary);
				if (result.length > 0) {
					paths = paths.concat(result);
				}
			}

			console.log("paths", paths);
			if (paths.length > 0) {
				return chooseFromPotentialPaths(paths);
			} else {
				return undefined;
			}
		}

		var findAllSatisfyingPathsFrom = function(chunk, want, chunkLibrary) {
			var paths = [];
			var path;
			if (chunk.id && want.type === "id" && chunk.id === want.val) {
				console.log("id " + chunk.id + " matches want " + want.val + "; adding to path");
				path = {
					route: [chunk.id],
					satisfies: [want]
				}
			}
			if (chunk.request && chunk.request.type === "id") {
				console.log("request of type id: iterating down");
				var requestedChunk = chunkLibrary.get(chunk.request.val);
				var reqPath = findAllSatisfyingPathsFrom(requestedChunk, Request.byId(chunk.request.val));
				if (reqPath.length > 0) {
					var firstPath = reqPath[0];
					path.route = path.route.concat(firstPath.route);
					// path.satisfies = path.satisfies.concat(firstPath.satisfies); // TODO: we don't want to record the want we satisfied as a result of being in this node: we only care about the original want. Maybe we can prune when we get back to the top?
				}
			}
			if (path) {
				paths.push(path);
			}
			return paths;
		}

		var chooseFromPotentialPaths = function(paths) {
			// Stub: just return the first.
			console.log("paths[0]", paths[0]);
			return paths[0];
		}

		var wantsRemaining = function() {
			return Object.keys(_wants).length;
		}

		// Return the wishlist interface.
		return {
			remove: remove,
			selectNext: selectNext,
			findBestPath: findBestPath,
			wantsRemaining: wantsRemaining
		}
	}

	return {
		create: create
	}
});	