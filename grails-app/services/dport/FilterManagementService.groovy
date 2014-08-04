package dport

import grails.transaction.Transactional

@Transactional
class FilterManagementService {

    def STANDARD_VARIANT_FILERS = """
{
    "t2d-genomewide":
        { "filter_type": "FLOAT", "operand": "_13k_T2D_P_EMMAX_FE_IV", "operator": "LTE", "value": 5e-8 }
    },
    "t2d-nominal": {
        "filter_type": "FLOAT", "operand": "_13k_T2D_P_EMMAX_FE_IV", "operator": "LTE", "value": 5e-2
    },
    "exchp-genomewide": {
        "filter_type": "FLOAT", "operand": "EXCHP_T2D_P_value", "operator": "LTE", "value": 5e-8
    },
    "exchp-nominal": {
        "filter_type": "FLOAT", "operand": "EXCHP_T2D_P_value", "operator": "LTE", "value": 5e-2
    },
    "in-exseq": {
        "filter_type": "STRING", "operand": "IN_EXSEQ", "operator": "EQ", "value": 1
    },
    "in-exchp": {
        "filter_type": "STRING", "operand": "IN_EXCHP", "operator": "EQ", "value": 1
    },
    "lof": {
        "filter_type": "FLOAT", "operand": "MOST_DEL_SCORE", "operator": "EQ", "value": 1
    },
    "gwas-genomewide": {
        "filter_type": "FLOAT", "operand": "GWAS_T2D_PVALUE", "operator": "LTE", "value": 5e-8
    },
    "gwas-nominal": {
        "filter_type": "FLOAT", "operand": "GWAS_T2D_PVALUE", "operator": "LTE", "value": 5e-2
    },
    "sigma-genomewide": {
        "filter_type": "FLOAT", "operand": "SIGMA_T2D_P", "operator": "LTE", "value": 5e-8
    },
    "sigma-nominal": {
        "filter_type": "FLOAT", "operand": "SIGMA_T2D_P", "operator": "LTE", "value": 5e-2
    },
    "in-sigma": {
        "filter_type": "STRING", "operand": "IN_SIGMA", "operator": "EQ", "value": "1"
    }
}""".toString();

    def serviceMethod() {
//
//        def get_variant_filters_from_key(key):
//        """
//    The website contains all over the place to particular subsets of variants.
//    These subsets are defined by variant filters, but in the UI it"s easier to refer to them by a simple string key
//    A string could imply one or more filters - so this function gets a list of filters
//    Some are parsed, some are constant - see STANDARD_VARIANT_FILTERS above for a list of constants
//    """
//
//        if key.startswith("total-"):
//        population = key.split("-")[1]
//        if population == "exchp":
//        operand = "EXCHP_T2D_MAF"
//        elif population == "exseq":
//        operand = "_13k_T2D_"+population+"_MAF"
//        else:
//        operand = "GWAS_T2D_PVALUE"
//        return [
//                {
//                    "filter_type": "FLOAT",
//                    "operand": operand,
//                    "operator": "GTE",
//                    "value": 0,
//                },
//        ]
//
//        elif key.startswith("common-"):
//        population = key.split("-")[1]
//        if population == "exchp":
//        operand = "EXCHP_T2D_MAF"
//        else:
//        operand = "_13k_T2D_"+population+"_MAF"
//        return [
//                {
//                    "filter_type": "FLOAT",
//                    "operand": operand,
//                    "operator": "GTE",
//                    "value": 5e-2,
//                },
//        ]
//
//        elif key.startswith("rare-"):
//        population = key.split("-")[1]
//        if population == "exchp":
//        operand = "EXCHP_T2D_MAF"
//        else:
//        operand = "_13k_T2D_"+population+"_MAF"
//        return [
//                {
//                    "filter_type": "FLOAT",
//                    "operand": operand,
//                    "operator": "LT",
//                    "value": 5e-3,
//                },
//                {
//                    "filter_type": "FLOAT",
//                    "operand": operand,
//                    "operator": "GT",
//                    "value": 0,
//                }
//        ]
//
//        elif key.startswith("lowfreq-"):
//        population = key.split("-")[1]
//        if population == "exchp":
//        operand = "EXCHP_T2D_MAF"
//        else:
//        operand = "_13k_T2D_"+population+"_MAF"
//        return [
//                {
//                    "filter_type": "FLOAT",
//                    "operand": operand,
//                    "operator": "LT",
//                    "value": 5e-2,
//                },
//                {
//                    "filter_type": "FLOAT",
//                    "operand": operand,
//                    "operator": "GTE",
//                    "value": 5e-3,
//                },
//        ]
//
//        else:
//        return [STANDARD_VARIANT_FILERS.get(key),]
//    }
    }
    }
