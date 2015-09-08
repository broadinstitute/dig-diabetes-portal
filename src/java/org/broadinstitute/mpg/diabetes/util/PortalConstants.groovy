package org.broadinstitute.mpg.diabetes.util

/**
 * Class to contain the portal constants as static strings
 *
 */
class PortalConstants {
    // json mapping keys
    public final static String JSON_EXPERIMENT_KEY      = "experiments";
    public final static String JSON_VERSION_KEY         = "version";
    public final static String JSON_NAME_KEY            = "name";
    public final static String JSON_TYPE_KEY            = "type";
    public final static String JSON_GROUP_KEY            = "group";
    public final static String JSON_TECHNOLOGY_KEY      = "technology";
    public final static String JSON_ANCESTRY_KEY        = "ancestry";
    public final static String JSON_ID_KEY              = "id";
    public final static String JSON_SEARCHABLE_KEY      = "searchable";
    public final static String JSON_SORT_ORDER_KEY      = "sort_order";
    public final static String JSON_VARIANTS_KEY        = "variants";
    public final static String JSON_VARIANT_ID_KEY      = "VAR_ID";
    public final static String JSON_VARIANT_MOST_DEL_SCORE_KEY      = "MOST_DEL_SCORE";
    public final static String JSON_VARIANT_CHROMOSOME_KEY      = "CHROM";
    public final static String JSON_VARIANT_POLYPHEN_PRED_KEY      = "PolyPhen_PRED";
    public final static String JSON_VARIANT_SIFT_PRED_KEY      = "SIFT_PRED";
    public final static String JSON_NUMBER_RECORDS_KEY  = "numRecords";
    public final static String JSON_ERROR_KEY           = "is_error";
    public final static String JSON_PASSBACK_KEY        = "passback";

    // json mapping array key values
    public final static String JSON_DATASETS_KEY        = "sample_groups";
    public final static String JSON_PROPERTIES_KEY      = "properties";
    public final static String JSON_PHENOTYPES_KEY      = "phenotypes";

    // constant types for metadata object tree
    public final static String TYPE_METADATA_ROOT_KEY                   = "metadata_root";
    public final static String TYPE_EXPERIMENT_KEY                      = "experiment";
    public final static String TYPE_SAMPLE_GROUP_KEY                    = "sample_group";
    public final static String TYPE_PHENOTYPE_KEY                       = "phenotype";
    public final static String TYPE_PROPERTY_KEY                        = "property";
    public final static String TYPE_COMMON_PROPERTY_KEY                 = "cproperty";
    public final static String TYPE_PHENOTYPE_PROPERTY_KEY              = "pproperty";
    public final static String TYPE_SAMPLE_GROUP_PROPERTY_KEY           = "dproperty";

    // constant string for the experiment technology type
    public final static String TECHNOLOGY_GWAS_KEY                      = "GWAS";

    // burden test json keys
    public final static String JSON_BURDEN_VARIANTS_KEY                 = "variants";
    public final static String JSON_BURDEN_COVARIATES_KEY               = "covariates";
    public final static String JSON_BURDEN_FILTERS_KEY                  = "filters";
    public final static String JSON_BURDEN_DATASET_KEY                  = "study";

    // burden sample group options
    public final static String BURDEN_DATASET_OPTION_13K                  = "13k";
    public final static String BURDEN_DATASET_OPTION_26K                  = "26k";
    public final static int BURDEN_DATASET_OPTION_ID_13K                  = 1;
    public final static int BURDEN_DATASET_OPTION_ID_26K                  = 2;


    // constants for getData calls
    public final static String OPERATOR_LESS_THAN_EQUALS                 = "LTE";
    public final static String OPERATOR_LESS_THAN_NOT_EQUALS             = "LT";
    public final static String OPERATOR_MORE_THAN_EQUALS                 = "GTE";
    public final static String OPERATOR_MORE_THAN_NOT_EQUALS             = "GT";
    public final static String OPERATOR_EQUALS                           = "EQ";

    // constants for operator type
    public final static String OPERATOR_TYPE_FLOAT                        = "FLOAT";
    public final static String OPERATOR_TYPE_INTEGER                      = "INTEGER";
    public final static String OPERATOR_TYPE_STRING                       = "STRING";


    // constants of property id keys (these are automatically generated, but caching often used ones here)
    public final static String PROPERTY_KEY_COMMON_VAR_ID                 = "metadata_rootVAR_ID";
    public final static String PROPERTY_KEY_COMMON_GENE                   = "metadata_rootGENE";
    public final static String PROPERTY_KEY_COMMON_CLOSEST_GENE           = "metadata_rootCLOSEST_GENE";
    public final static String PROPERTY_KEY_COMMON_CHROMOSOME             = "metadata_rootCHROM";
    public final static String PROPERTY_KEY_COMMON_CONSEQUENCE            = "metadata_rootConsequence";
    public final static String PROPERTY_KEY_COMMON_POSITION               = "metadata_rootPOS";
    public final static String PROPERTY_KEY_COMMON_DBSNP_ID               = "metadata_rootDBSNP_ID";
    public final static String PROPERTY_KEY_COMMON_POLYPHEN_PRED          = "metadata_rootPolyPhen_PRED";
    public final static String PROPERTY_KEY_COMMON_SIFT_PRED              = "metadata_rootSIFT_PRED";
    public final static String PROPERTY_KEY_COMMON_MOST_DEL_SCORE         = "metadata_rootMOST_DEL_SCORE";

    public final static String PROPERTY_KEY_SG_MAF_82K                    = "metadata_root_ExChip_82k_mdv2_82kMAF";
    public final static String PROPERTY_KEY_SG_MAF_SIGMA1                 = "metadata_root_ExChip_SIGMA1_mdv2_SIGMA1MAF";
    public final static String PROPERTY_KEY_SG_EAF_GWAS_GIANT             = "metadata_root_GWAS_GIANT_mdv2_GIANTEAF";
    public final static String PROPERTY_KEY_SG_EAF_GWAS_PGC               = "metadata_root_GWAS_PGC_mdv2_PGCEAF";

    public final static String PROPERTY_KEY_PH_MINA_SIGMA1_T2D            = "metadata_root_ExChip_SIGMA1_mdv2_SIGMA1T2DMINA";
    public final static String PROPERTY_KEY_PH_MINU_SIGMA1_T2D            = "metadata_root_ExChip_SIGMA1_mdv2_SIGMA1T2DMINU";
    public final static String PROPERTY_KEY_PH_OR_FIRTH_SIGNA1_T2D        = "metadata_root_ExChip_SIGMA1_mdv2_SIGMA1T2DOR_FIRTH";
    public final static String PROPERTY_KEY_PH_P_VALUE_GWAS_DIAGRAM_T2D   = "metadata_root_GWAS_DIAGRAM_mdv2_DIAGRAMT2DP_VALUE";
    public final static String PROPERTY_KEY_PH_P_VALUE_82K_T2D            = "metadata_root_ExChip_82k_mdv2_82kT2DP_VALUE";
    public final static String PROPERTY_KEY_PH_BETA_13K_FG                = "metadata_root_ExSeq_13k_mdv2_13kFGBETA";
    public final static String PROPERTY_KEY_PH_BETA_13K_HBA1C             = "metadata_root_ExSeq_13k_mdv2_13kHBA1CBETA";
    public final static String PROPERTY_KEY_PH_BETA_GWAS_MAGIC_2HRG       = "metadata_root_GWAS_MAGIC_mdv2_MAGIC2hrGBETA";

    // burden test variant selection options
    public static final int BURDEN_VARIANT_OPTION_ALL_CODING                     = 1;
    public static final int BURDEN_VARIANT_OPTION_ALL_MISSENSE                   = 2;
    public static final int BURDEN_VARIANT_OPTION_ALL_MISSENSE_POSS_DELETERIOUS  = 3;
    public static final int BURDEN_VARIANT_OPTION_ALL_MISSENSE_PROB_DELETERIOUS  = 4;
    public static final int BURDEN_VARIANT_OPTION_ALL_PROTEIN_TRUNCATING         = 5;
    public static final int BURDEN_VARIANT_OPTION_ALL                            = 0;

    // burden test constants
    public static final String POLYPHEN_PRED_POSSIBLY_DAMAGING              = "possibly_damaging";
    public static final String POLYPHEN_PRED_PROBABLY_DAMAGING              = "probably_damaging";
    public static final String SIFT_PRED_DELETERIOUS                        = "deleterious";


}
