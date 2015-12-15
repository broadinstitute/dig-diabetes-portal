

    <!-- TODO: migrate to using a task runner (grunt, gulp, etc.) to minify/uglify down to a smaller set of includes -->
    <!--
    <script src="http://portaldev.sph.umich.edu/lzplug/assets/js/vendor/jquery.min.js"></script>
    <script src="http://portaldev.sph.umich.edu/lzplug/assets/js/vendor/d3.min.js"></script>
    -->
    <script src="http://portaldev.sph.umich.edu/lzplug/assets/js/vendor/q.min.js"></script>
    <script src="http://portaldev.sph.umich.edu/lzplug/assets/js/app/locuszoom.js"></script>
    <script src="http://portaldev.sph.umich.edu/lzplug/assets/js/app/locuszoom.data.js" type="text/javascript"></script>
    <script src="http://portaldev.sph.umich.edu/lzplug/assets/js/app/Instance.js"></script>
    <script src="http://portaldev.sph.umich.edu/lzplug/assets/js/app/Panel.js"></script>
    <script src="http://portaldev.sph.umich.edu/lzplug/assets/js/app/DataLayer.js"></script>
    <!-- link rel="stylesheet" type="text/css" href="assets/css/locuszoom.css"/ -->
    <script type="text/javascript">
        //grep Lead /net/snowwhite/home/welchr/scratch/morris_2012_hits_fixed.csv | tr , "\t" | sort -g -k 7 | cut -f3,4,8 | head -15 | awk '{print "[\"" $1 ":" $2 "\",", "\"" $3 "\"],"}'
        var topHits = [
            ["10:114758349", "TCF7L2"],
            ["6:20679709", "CDKAL1"],
            ["10:94462882", "HHEX/IDE"],
            ["9:22134094", "CDKN2A/B"],
            ["8:118185025", "SLC30A8"],
            ["3:185511687", "IGF2BP2"],
            ["16:53819169", "FTO"],
            ["7:28196413", "JAZF1"],
            ["3:12393125", "PPARG"],
            ["7:130437689", "KLF14"],
            ["12:66212318", "HMGA2"],
            ["9:81905590", "TLE4"],
            ["4:6289986", "WFS1"],
            ["10:80942631", "ZMIZ1"],
            ["11:72433098", "ARAP1"] ];


        // Apply form data to a remapping of a LocusZoom object
        function handleFormSubmit(lz_id){
            //var chr   = $("#" + lz_id + "_chr")[0].value;
            //var start = $("#" + lz_id + "_start")[0].value;
            //var end   = $("#" + lz_id + "_end")[0].value;
            var target =  $("#" + lz_id + "_region")[0].value.split(":");
            var chr = target[0];
            var pos = target[1];
            var start = 0;
            var end = 0;
            if ( pos.match(/[-+]/) ) {
                if (pos.match(/[-]/)) {
                    pos = pos.split("-");
                    start = +pos[0];
                    end = +pos[1];
                } else {
                    pos = pos.split("+");
                    start = (+pos[0]) - (+pos[1]);
                    end = (+pos[0]) + (+pos[1]);
                }

            } else {
                start = +pos - 300000
                end = +pos + 300000
            }
            LocusZoom._instances[lz_id].mapTo(chr, start, end);
        }

        function jumpTo(region, lz_id) {
            lz_id = lz_id || "lz-1";
            var target = region.split(":");
            var chr = target[0];
            var pos = target[1];
            var start = 0;
            var end = 0;
            if ( pos.match(/[-+]/) ) {

            } else {
                start = +pos - 300000
                end = +pos + 300000
            }
            LocusZoom._instances[lz_id].state.ldrefvar = "";
            LocusZoom._instances[lz_id].mapTo(chr, start, end);
            populateForms();
            return(false);
        }

        // Fill demo forms with values already loaded into LocusZoom objects
        function populateForms(){
            d3.selectAll("div.lz-instance").each(function(){
                $("#" + this.id + "_region")[0].value = LocusZoom._instances[this.id].state.chr +
                        ":" + LocusZoom._instances[this.id].state.start +
                        "-" + LocusZoom._instances[this.id].state.end;

            });
        }

        /*
        function listHits() {
            $("#tophits").empty().append("<ul>").children(0).append(topHits.map(function(e) {
                return "<li><a href='javascript:jumpTo(\"" + e[0] + "\");'>" + e[1] + " </a></li>";
            }))
        }
        */

        function formatDataRegion(region) {
            return region.substring(2);
        }

        function initPage() {
            // DIGP-209: taking out
            // listHits();
            LocusZoom.populate();
            populateForms();
            // $("#lz-1_hits").html(topHits.map(function(k) {return "<option>" + k + "</option>"}).join(""));
        }
        ;

    </script>
</head>
<body style="background-color: #CCCCCC; margin: 10px;" onload="initPage()">
<table border="0" cellspacing="10">
    <tr>
        <td>
            <div>
                <form>
                    <b>lz-1</b> &middot;
                    <label for="lz-1_region">Region: </label>
                    <input type="text" size=25 id="lz-1_region">
                    <input type="button" id="lz-1_submit" value="Go" onClick="handleFormSubmit('lz-1');" />
                </form>
                <br>
            </div>
<!--
            <div id="lz-1" class="lz-instance" data-region="10:114550452-115067678"></div>
            -->
            <div id="lz-1" class="lz-instance" data-region="${regionSpecification?.substring(3)}"></div>
        </td>
        <td style="vertical-align:top">
            <h3>Top Hits</h3>
            <div id="tophits"></div>
        </td>
    </tr>
</table>
