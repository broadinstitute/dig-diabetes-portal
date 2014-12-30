//beforeEach(function () {
//  jasmine.addMatchers({
//    toBePlaying: function () {
//      return {
//        compare: function (actual, expected) {
//          var player = actual;
//
//          return {
//            pass: player.currentlyPlayingSong === expected && player.isPlaying
//          }
//        }
//      };
//    }
//  });
//});


describe("expandRegionBegin", function() {
    it("expands region > 500000 by 500000", function() {
        expect(expandRegionBegin(500000 * 2)).toEqual(500000);
    });
    it("region < 500000 defaults to 0", function() {
        expect(expandRegionBegin(499999)).toEqual(0);
    });

});
