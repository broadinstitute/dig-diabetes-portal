var UTILS = {
    invertMap: function (map){
        var inv={};
        var keys=Object.keys(map);
        for(var i=0;i<keys.length;i++){
            if (map[keys[i]]) {
                inv[map[keys[i]]]=keys[i];
            }
        }
        return inv;
    },
    get_variant_repr: function(v) {
        return v.CHROM + ':' + v.POS;
    },

    get_variant_title: function(v) {
        if (v.DBSNP_ID) {
            return v.DBSNP_ID;
        } else {
            return v.CHROM + ':' + v.POS;
        }
    },
    variantInfoHeaderSentence: function (variant) {
        var returnValue = "";
        if (variant.IN_GENE) {
            returnValue += "lies in the gene <em>" +variant.IN_GENE+ "</em>";
        } else {
            returnValue += "is nearest to the gene <em>" +variant.CLOSEST_GENE+ "</em>";
        }
        return  returnValue;
    },
     get_highest_frequency: function(v) {
        var max = 0;
        var max_pop = '';
        _.each(['AA', 'EA', 'SA', 'EU', 'HS'], function(k) {
            var af = v['_13k_T2D_' + k + '_MAF'];
            if (af > max) {
                max = af;
                max_pop = k;
            }
        });
        return [max, max_pop];
    },

    get_simple_variant_effect: function(v) {
        if (v.MOST_DEL_SCORE == 1) {
            return 'protein-truncating'
        }
        else if (v.MOST_DEL_SCORE == 2) {
            return 'missense'
        }
        else if (v.MOST_DEL_SCORE == 3) {
            return 'synonymous-coding'
        }
        // if MOST_DEL_SCORE is null, treat it as 4
        else {
            return 'non-coding';
        }
    },

    getSimpleVariantsEffect: function(vMOST_DEL_SCORE) {
        if (vMOST_DEL_SCORE == 1) {
            return 'protein-truncating'
        }
        else if (vMOST_DEL_SCORE == 2) {
            return 'missense'
        }
        else if (vMOST_DEL_SCORE == 3) {
            return 'synonymous-coding'
        }
        // if MOST_DEL_SCORE is null, treat it as 4
        else {
            return 'non-coding';
        }
    },

    get_significance_text: function(significance) {
        if (significance < 5e-8) {
            return 'genome-wide';
        } else if (significance < 5e-2) {
            return 'nominal';
        } else {
            return
        }
    },

    get_lowest_p_value: function(variant) {
        var pval = 1;
        var datatype = '';
        if (variant.IN_EXCHP && variant.EXCHP_T2D_P_value < pval) {
            pval = variant.EXCHP_T2D_P_value;
            datatype = 'exome chip';
        }
        if (variant.IN_EXSEQ && variant._13k_T2D_P_EMMAX_FE_IV < pval) {
            pval = variant._13k_T2D_P_EMMAX_FE_IV;
            datatype = 'exome sequencing';
        }
        if (variant.IN_GWAS && variant.GWAS_T2D_PVALUE < pval) {
            pval = variant.GWAS_T2D_PVALUE;
            datatype = 'GWAS';
        }
        return [pval, datatype];
    },

    get_consequence_names: function(variant) {
        if (!variant.Consequence) return [];
        var keys = variant.Consequence.split(';');
        var names = [];
        _.each(keys, function(k) {
            if (!k) return;
            var consequence = _.find(CONSTANTS.so_consequences, function(c) { return c.key == k });
            if (consequence) {
                names.push(consequence.name);
            } else {
                names.push(k);
            }
        });
        return names;
    },

    fillAssociationsStatistics: function(variant,
                                         vMap,
                                         availableData,
                                         pValue,
                                         strongCutOff,
                                         weakCutOff,
                                         variantTitle,
                                         textStrongLine1,
                                         textStrongLine2,
                                         textMediumLine,
                                         textWeakLine,
                                         noDataLine ) {
        var retVal = "";
        var iMap = UTILS.invertMap(vMap);
        if (variant[iMap[availableData]]){
            retVal +="<p>";
            if (variant[iMap[pValue]] <= strongCutOff ) {
                retVal += "<strong>" + textStrongLine1 +" "+ variantTitle  +" "+ textStrongLine2;
            }
            if  (variant[iMap[pValue]]  >  strongCutOff  && variant[iMap[pValue]] <=   weakCutOff) {
                retVal += textMediumLine;
            }
            if  (variant[iMap[pValue]]  >  weakCutOff) {
                retVal  += textMediumLine;
            }
            if (variant[iMap[pValue]] <= strongCutOff ) {
                retVal += "</strong>" ;
            }
            retVal +="</p>"+
                   "<ul>"+
                    "<li>p-value from this analysis:"+variant[iMap[pValue]] + "</li>"+
                    "</ul>";
        } else {
            retVal += noDataLine;
        }
        return retVal;
    }

};