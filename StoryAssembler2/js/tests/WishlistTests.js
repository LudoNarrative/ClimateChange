/* global test, QUnit */
"use strict";
define(["../Wishlist", "../ChunkLibrary", "../Request", "../State"], function(Wishlist, ChunkLibrary, Request, State) {
	
	var run = function() {
		QUnit.module( "Wishlist Module tests" );
		test("wishlist", function( assert ) {
			var wl = Wishlist.create([
				{
					request: "introduceFriend eq true",
					order: "first",
					mandatory: true
				},{
					chunkId: "epilogue",
					order: 2
				}
			]);
			assert.deepEqual(wl.wantsRemaining(), 2, "should have correct number of wants");
			var next = wl.selectNext();
			assert.deepEqual(typeof next.request, "object", "should return a want with a request field.");
			wl.remove(next.id);
			assert.deepEqual(wl.wantsRemaining(), 1, "should have correct number of wants after a remove");
			next = wl.selectNext();
			wl.remove(next.id);
			assert.deepEqual(wl.wantsRemaining(), 0, "should have no wants after removing everything");
			assert.deepEqual(wl.selectNext(), undefined, "should return undefined if no wants left");

			var badListOfWishes = [
				{
					request: "introduceFriend eq true",
				},{
					foo: "bar"
				}
			];
			assert.throws(function(){Wishlist.create(badListOfWishes)}, "should throw error if list has bad want.");

			var wl3 = Wishlist.create([
				{
					request: "introduceFriend eq true",
				}
			]);
			assert.deepEqual(wl.wantsRemaining(), 0, "making new wishlist shouldn't affect old one");
			assert.deepEqual(wl3.wantsRemaining(), 1, "new wishlist should have proper values");
		});

	}

	return {
		run: run
	}
});