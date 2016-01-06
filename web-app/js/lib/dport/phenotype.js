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
            retVal.push(((variant.MAF)&&(variant.MAF!=='0'))?(""+variant.MAF.toPrecision(3)):"");
            retVal.push("<a class='boldlink' href='./traitInfo/"+ variant.DBSNP_ID+"'>click here</a>");
            return retVal;
         },

         iterativeTableFiller = function  (variant, show_gene, show_exseq, show_exchp)  {
            var effectTypeTitle =  UTILS.determineEffectsTypeHeader(variant);
            var effectTypeString =  UTILS.determineEffectsTypeString(effectTypeTitle);
            $('#effectTypeHeader').append(effectTypeTitle);
            var table = $('#phenotypeTraits').dataTable({
                iDisplayLength: 25,
                bFilter: false,
                aaSorting: [[ 2, "asc" ]],
                aoColumnDefs: [{ sType: "allnumeric", aTargets: [ 2, 3, 4 ] } ]
            });
            var tableTools = new $.fn.dataTable.TableTools( table, {
                "buttons": [
                    "copy",
                    "csv",
                    "xls",
                    "pdf",
                    { "type": "print", "buttonText": "Print me!" }
                ],
                "sSwfPath": "../js/DataTables-1.10.7/extensions/TableTools/swf/copy_csv_xls_pdf.swf"
            } );
            $( tableTools.fnContainer() ).insertAfter('#phenotypeTraits');
            var dataLength = variant.length;
            var effectsField = UTILS.determineEffectsTypeString ('#phenotypeTraits');
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