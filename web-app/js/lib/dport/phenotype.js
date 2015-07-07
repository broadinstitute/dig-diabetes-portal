var mpgSoftware = mpgSoftware || {};


(function () {
    "use strict";


    mpgSoftware.phenotype = (function () {

        /***
         * format a single line for the phenotypic trait table
         * @param variant
         * @param effectsField
         * @param show_gene
         * @param show_exseq
         * @param show_exchp
         * @returns {Array}
         */
        var convertLineForPhenotypicTraitTable = function ( variant, effectsField ) {
            var retVal = [];
            var pValueGreyedOut = (variant.P_VALUE > .05)? "greyedout" :"normal";
            retVal.push("<a class='boldlink' href='../variantInfo/variantInfo/"+ variant.DBSNP_ID+"'>"+ variant.DBSNP_ID+"</a>");
            retVal.push("<a class='boldItlink' href='../gene/geneInfo/"+ variant.CLOSEST_GENE+"'>"+ variant.CLOSEST_GENE+"</a>");
            retVal.push(""+ variant.P_VALUE.toPrecision(3));
            var betaVal;
            if ($.isNumeric(variant[effectsField])){
                betaVal = parseFloat(variant[effectsField]);
                retVal.push("<span class='" +pValueGreyedOut+ "'>"+betaVal.toPrecision(3)+"</span>");
            } else {
                retVal.push("<span class='" +pValueGreyedOut+ "'>--</span>");
            }
            retVal.push((variant.MAF)?(""+variant.MAF.toPrecision(3)):"");
            retVal.push("<a class='boldlink' href='./traitInfo/"+ variant.DBSNP_ID+"'>click here</a>");
            return retVal;
        };





        var iterativeTableFiller = function  (variant, show_gene, show_exseq, show_exchp)  {
            var effectTypeTitle =  UTILS.determineEffectsTypeHeader(variant);
            var effectTypeString =  UTILS.determineEffectsTypeString(effectTypeTitle);
            $('#effectTypeHeader').append(effectTypeTitle);
            $('#phenotypeTraits').dataTable({
                iDisplayLength: 25,
                bFilter: false,
                aaSorting: [[ 2, "asc" ]],
                aoColumnDefs: [{ sType: "allnumeric", aTargets: [ 2, 3, 4 ] } ]
            });
            var dataLength = variant.length;
            var effectsField = UTILS.determineEffectsTypeString (effectTypeTitle);
            for ( var i = 0 ; i < dataLength ; i++ ){
                var array = convertLineForPhenotypicTraitTable(variant[i],effectsField,show_gene, show_exseq, show_exchp);
                $('#phenotypeTraits').dataTable().fnAddData( array, (i==25) || (i==(dataLength-1)));
            }
        };


        return {
            // public routines
            iterativeTableFiller: iterativeTableFiller
        }


    }());

})();