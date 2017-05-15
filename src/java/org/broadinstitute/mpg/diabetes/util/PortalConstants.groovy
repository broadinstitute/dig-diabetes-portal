package org.broadinstitute.mpg.diabetes.util

/**
 * Class to contain the portal constants as static strings
 *
 */
class PortalConstants {
    // json mapping keys

    public final static String JSON_EXPERIMENT_KEY                      = "experiments";
    public final static String JSON_VERSION_KEY                         = "version";
    public final static String JSON_NAME_KEY                            = "name";
    public final static String JSON_TYPE_KEY                            = "type";
    public final static String JSON_GROUP_KEY                           = "group";
    public final static String JSON_TECHNOLOGY_KEY                      = "technology";
    public final static String JSON_INSTITUTION_KEY                      = "institution";
    public final static String JSON_ANCESTRY_KEY                        = "ancestry";
    public final static String JSON_SUBJECTS_KEY                        = "subjects";
    public final static String JSON_CASES_KEY                           = "cases";
    public final static String JSON_CONTROLS_KEY                        = "controls";
    public final static String JSON_ID_KEY                              = "id";
    public final static String JSON_SEARCHABLE_KEY                      = "searchable";
    public final static String JSON_SORT_ORDER_KEY                      = "sort_order";
    public final static String JSON_MEANING_KEY                         = "meaning";
    public final static String JSON_VARIANTS_KEY                        = "variants";
    public final static String JSON_VARIANT_ID_KEY                      = "VAR_ID";
    public final static String JSON_VARIANT_MOST_DEL_SCORE_KEY          = "MOST_DEL_SCORE";
    public final static String JSON_VARIANT_CHROMOSOME_KEY              = "CHROM";
    public final static String JSON_VARIANT_POLYPHEN_PRED_KEY           = "PolyPhen_PRED";
    public final static String JSON_VARIANT_SIFT_PRED_KEY               = "SIFT_PRED";
    public final static String JSON_VARIANT_CONDEL_PRED_KEY             = "Condel_PRED";
    public final static String JSON_VARIANT_POLYPHEN2_HDIV_PRED_KEY     = "Polyphen2_HDIV_pred";
    public final static String JSON_VARIANT_POLYPHEN2_HVAR_PRED_KEY     = "Polyphen2_HVAR_pred";
    public final static String JSON_VARIANT_LRT_PRED_KEY                = "LRT_pred";
    public final static String JSON_VARIANT_MUTATION_TASTER_PRED_KEY    = "MutationTaster_pred";
    public final static String JSON_NUMBER_RECORDS_KEY                  = "numRecords";
    public final static String JSON_ERROR_KEY                           = "is_error";
    public final static String JSON_PASSBACK_KEY                        = "passback";


    // json mapping array key values
    public final static String JSON_DATASETS_KEY        = "sample_groups";
    public final static String JSON_PROPERTIES_KEY      = "properties";
    public final static String JSON_PHENOTYPES_KEY      = "phenotypes";
    public final static String JSON_COVARIATES_KEY      = "covariates";

    // constant types for metadata object tree
    public final static String TYPE_METADATA_ROOT_KEY                   = "metadata_root";
    public final static String TYPE_EXPERIMENT_KEY                      = "experiment";
    public final static String TYPE_SAMPLE_GROUP_KEY                    = "sample_group";
    public final static String TYPE_PHENOTYPE_KEY                       = "phenotype";
    public final static String TYPE_PROPERTY_KEY                        = "property";
    public final static String TYPE_COMMON_PROPERTY_KEY                 = "cproperty";
    public final static String TYPE_PHENOTYPE_PROPERTY_KEY              = "pproperty";
    public final static String TYPE_SAMPLE_GROUP_PROPERTY_KEY           = "dproperty";
    public final static String TYPE_ALL_PROPERTY_KEY                    = "all";

    // constant string for the experiment technology type
    public final static String TECHNOLOGY_GWAS_KEY                      = "GWAS";

    // constant strings for the commonly used properties
    public final static String NAME_COMMON_PROPERTY_POSITION            = "POS";
    public final static String NAME_COMMON_PROPERTY_CHROMOSOME          = "CHROM";
    public final static String NAME_PHENOTYPE_PROPERTY_P_VALUE          = "P_VALUE";
    public final static String NAME_PHENOTYPE_PROPERTY_TRANSCRIPT_ANNOT = "TRANSCRIPT_ANNOT";

    // constant strings for the commonly used properties
    public final static String NAME_COMMON_METAFILTER_OR                 = "ORBLOCK";
    public final static String NAME_COMMON_METAFILTER_AND                = "ANDBLOCK";

    // trait-search emulation keys
    public final static String KEY_PHENOTYPE_FOR_TRAIT_SEARCH            = "TRAIT";

    // burden test json keys
    public final static String JSON_BURDEN_VARIANTS_KEY                 = "variants";
    public final static String JSON_BURDEN_COVARIATES_KEY               = "covariates";
    public final static String JSON_BURDEN_SAMPLES_KEY                  = "samples";
    public final static String JSON_BURDEN_FILTERS_KEY                  = "filters";
    public final static String JSON_BURDEN_DATASET_KEY                  = "study";
    public final static String JSON_BURDEN_DATA_VERSION_KEY             = "mdv";
    public final static String JSON_BURDEN_PHENOTYPE_KEY                = "phenotype";
    public final static String JSON_BURDEN_CI_CALC_KEY                  = "calc_ci";
    public final static String JSON_BURDEN_CI_LEVEL_KEY                 = "ci_level";
    public final static String JSON_BURDEN_DATASET_ID_KEY               = "dataset_id";

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
    public final static String OPERATOR_TYPE_META                         = "META";


    // constants of property id keys (these are automatically generated, but caching often used ones here)
    // USAGE: these keys mostly used to search through the getMetatadata results; these keys will correspond to unique keys in parsed map of getMetadata json
    public final static String PROPERTY_KEY_COMMON_VAR_ID                 = "metadata_rootVAR_ID";
    public final static String PROPERTY_KEY_COMMON_GENE                   = "metadata_rootGENE";
    public final static String PROPERTY_KEY_COMMON_CLOSEST_GENE           = "metadata_rootCLOSEST_GENE";
    public final static String PROPERTY_KEY_COMMON_CHROMOSOME             = "metadata_rootCHROM";
    public final static String PROPERTY_KEY_COMMON_CONSEQUENCE            = "metadata_rootConsequence";
    public final static String PROPERTY_KEY_COMMON_POSITION               = "metadata_rootPOS";
    public final static String PROPERTY_KEY_COMMON_PROTEIN_CHANGE         = "metadata_rootProtein_change";
    public final static String PROPERTY_KEY_COMMON_DBSNP_ID               = "metadata_rootDBSNP_ID";
    public final static String PROPERTY_KEY_COMMON_POLYPHEN_PRED          = "metadata_rootPolyPhen_PRED";
    public final static String PROPERTY_KEY_COMMON_SIFT_PRED              = "metadata_rootSIFT_PRED";
    public final static String PROPERTY_KEY_COMMON_MOST_DEL_SCORE         = "metadata_rootMOST_DEL_SCORE";
    public final static String PROPERTY_KEY_COMMON_EFFECT_ALLELE          = "metadata_rootEffect_Allele";
    public final static String PROPERTY_KEY_COMMON_REFERENCE_ALLELE       = "metadata_rootReference_Allele";
    public final static String PROPERTY_KEY_COMMON_MUTATION_TASTER_PRED   = "metadata_rootMutationTaster_pred";
    public final static String PROPERTY_KEY_COMMON_LRT_PRED               = "metadata_rootLRT_pred";
    public final static String PROPERTY_KEY_COMMON_POLYPHEN2_HVAR_PRED    = "metadata_rootPolyphen2_HVAR_pred";
    public final static String PROPERTY_KEY_COMMON_POLYPHEN2_HDIV_PRED    = "metadata_rootPolyphen2_HDIV_pred";

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

    // constants of property id keys (these are automatically generated, but caching often used ones here)
    public final static String SAMPLE_GROUP_KEY_SG_SIGMA1                 = "metadata_root_GWAS_SIGMA1_mdv2_SIGMA1";
    public final static String SAMPLE_GROUP_KEY_SG_GWAS_PGC               = "metadata_root_GWAS_PGC_mdv2_PGC";

    public final static int PROTEIN_PREDICTION_TYPE_PROTEINEFFECT                   = 1;
    public final static int PROTEIN_PREDICTION_TYPE_POLYPHEN                        = 2;
    public final static int PROTEIN_PREDICTION_TYPE_SIFT                            = 3;
    public final static int PROTEIN_PREDICTION_TYPE_CONDEL                          = 4;


    public final static String PROTEIN_PREDICTION_POLYPHEN_NONE_NAME                = "---";
    public final static String PROTEIN_PREDICTION_POLYPHEN_NONE_STRING_CODE                = "---";
    public final static int PROTEIN_PREDICTION_POLYPHEN_NONE_CODE                   = 0;
    public final static String PROTEIN_PREDICTION_POLYPHEN_PROBABLYDAMAGING_NAME    = "probably damaging";
    public final static String PROTEIN_PREDICTION_POLYPHEN_PROBABLYDAMAGING_STRING_CODE    = "probably_damaging";
    public final static int PROTEIN_PREDICTION_POLYPHEN_PROBABLYDAMAGING_CODE       = 1;
    public final static String PROTEIN_PREDICTION_POLYPHEN_POSSIBLYDAMAGING_NAME    = "possibly damaging";
    public final static String PROTEIN_PREDICTION_POLYPHEN_POSSIBLYDAMAGING_STRING_CODE    = "possibly_damaging";
    public final static int PROTEIN_PREDICTION_POLYPHEN_POSSIBLYDAMAGING_CODE       = 2;
    public final static String PROTEIN_PREDICTION_POLYPHEN_BENIGN_NAME              = "benign";
    public final static String PROTEIN_PREDICTION_POLYPHEN_BENIGN_STRING_CODE              = "benign";
    public final static int PROTEIN_PREDICTION_POLYPHEN_BENIGN_CODE                 = 3;

    public final static String PROTEIN_PREDICTION_SIFT_NONE_NAME                    = "---";
    public final static String PROTEIN_PREDICTION_SIFT_NONE_STRING_CODE                    = "---";
    public final static int PROTEIN_PREDICTION_SIFT_NONE_CODE                       = 0;
    public final static String PROTEIN_PREDICTION_SIFT_DELETERIOUS_NAME             = "deleterious";
    public final static String PROTEIN_PREDICTION_SIFT_DELETERIOUS_STRING_CODE             = "deleterious";
    public final static int PROTEIN_PREDICTION_SIFT_DELETERIOUS_CODE                = 1;
    public final static String PROTEIN_PREDICTION_SIFT_TOLERATED_NAME               = "tolerated";
    public final static String PROTEIN_PREDICTION_SIFT_TOLERATED_STRING_CODE               = "tolerated";
    public final static int PROTEIN_PREDICTION_SIFT_TOLERATED_CODE                  = 2;

    public final static String PROTEIN_PREDICTION_CONDEL_NONE_NAME                  = "---";
    public final static String PROTEIN_PREDICTION_CONDEL_NONE_STRING_CODE                  = "---";
    public final static int PROTEIN_PREDICTION_CONDEL_NONE_CODE                     = 0;
    public final static String PROTEIN_PREDICTION_CONDEL_DELETERIOUS_NAME           = "deleterious";
    public final static String PROTEIN_PREDICTION_CONDEL_DELETERIOUS_STRING_CODE           = "deleterious";
    public final static int PROTEIN_PREDICTION_CONDEL_DELETERIOUS_CODE              = 1;
    public final static String PROTEIN_PREDICTION_CONDEL_BENIGN_NAME                = "benign";
    public final static String PROTEIN_PREDICTION_CONDEL_BENIGN_STRING_CODE                = "neutral";
    public final static int PROTEIN_PREDICTION_CONDEL_BENIGN_CODE                   = 2;

    public final static String PROTEIN_PREDICTION_EFFECT_ALL_NAME                   = "all-effects";
    public final static int PROTEIN_PREDICTION_EFFECT_ALL_CODE                      = 0;
    public final static String PROTEIN_PREDICTION_EFFECT_PTV_NAME                   = "protein-truncating";
    public final static int PROTEIN_PREDICTION_EFFECT_PTV_CODE                      = 1;
    public final static String PROTEIN_PREDICTION_EFFECT_MISSENSE_NAME              = "missense";
    public final static int PROTEIN_PREDICTION_EFFECT_MISSENSE_CODE                 = 2;
    public final static String PROTEIN_PREDICTION_EFFECT_SYNONYMOUS_NAME            = "no effect (synonymous coding)";
    public final static int PROTEIN_PREDICTION_EFFECT_SYNONYMOUS_CODE               = 3;
    public final static String PROTEIN_PREDICTION_EFFECT_NONCODING_NAME             = "no effect (non-coding)";
    public final static int PROTEIN_PREDICTION_EFFECT_NONCODING_CODE                = 4;
    public final static String PROTEIN_PREDICTION_EFFECT_CODING_NAME                = "coding variant";
    public final static int PROTEIN_PREDICTION_EFFECT_CODING_CODE                   = 5;


    // START - BURDEN TEST SECTION
    // burden sample group options
    public final static String BURDEN_DATASET_OPTION_13K                  = "13k";
    public final static String BURDEN_DATASET_OPTION_26K                  = "26k";
    public final static int BURDEN_DATASET_OPTION_ID_13K                  = 1;
    public final static int BURDEN_DATASET_OPTION_ID_17K                  = 2;
    public final static int BURDEN_DATASET_OPTION_ID_26K                  = 3;
    public final static int BURDEN_MAF_OPTION_ID_ALL                      = 1;
    public final static int BURDEN_MAF_OPTION_ID_ANCESTRY                 = 2;
    public final static String BURDEN_DEFAULT_PHENOTYPE_KEY               = "t2d";

    // burden root datasets for the 13k/26k MAF filtering = TEMP FOR NOW until further factoring
    public static final String BURDEN_SAMPLE_GROUP_ROOT_26k_ID                   = "metadata_root_ExSeq_26k_mdv3_26k";
    public static final String BURDEN_SAMPLE_GROUP_ROOT_17k_ID                   = "metadata_root_ExSeq_17k_mdv2_17k";
    public static final String BURDEN_SAMPLE_GROUP_ROOT_13k_ID                   = "metadata_root_ExSeq_13k_mdv1_13k";

    // burden test variant selection options
    public static final int BURDEN_VARIANT_OPTION_ALL_CODING                     = 1;
    public static final int BURDEN_VARIANT_OPTION_ALL_MISSENSE                   = 2;
    public static final int BURDEN_VARIANT_OPTION_ALL_MISSENSE_POSS_DELETERIOUS  = 3;
    public static final int BURDEN_VARIANT_OPTION_ALL_MISSENSE_PROB_DELETERIOUS  = 4;
    public static final int BURDEN_VARIANT_OPTION_ALL_PROTEIN_TRUNCATING         = 5;
    public static final int BURDEN_VARIANT_OPTION_NS_STRICT                      = 6;
    public static final int BURDEN_VARIANT_OPTION_NS_BROAD                       = 7;
    public static final int BURDEN_VARIANT_OPTION_NS                             = 8;
    public static final int BURDEN_VARIANT_OPTION_ALL                            = 0;

    // burden test constants
    public static final String POLYPHEN_PRED_POSSIBLY_DAMAGING              = "possibly_damaging";
    public static final String POLYPHEN_PRED_PROBABLY_DAMAGING              = "probably_damaging";
    public static final String SIFT_PRED_DELETERIOUS                        = "deleterious";
    // START - BURDEN TEST SECTION


    // property common names, regardless of where in tree they are
    // USAGE: these mostly used for searching through getData results json by property name
    public static final String PROPERTY_NAME_VAR_ID                         = "VAR_ID";
    public static final String PROPERTY_NAME_CHROMOSOME                     = "CHROM";
    public static final String PROPERTY_NAME_POSITION                       = "POS";
    public static final String PROPERTY_NAME_MINOR_ALLELE_COUNT             = "MAC";
    public static final String PROPERTY_NAME_P_FIRTH                        = "P_FIRTH_FE_IV";

    // property meaning types
    public static final String PROPERTY_MEANING_P_VALUE_KEY                 = "P_VALUE";
    public static final String PROPERTY_MEANING_ODDS_RATIO_KEY              = "ODDS_RATIO";
    public static final String PROPERTY_MEANING_BETA_KEY                    = "BETA";

    //  types of metadata
    public static final String METADATA_VARIANT                             = "VARIANT";
    public static final String METADATA_SAMPLE                              = "SAMPLE";

    public class BurdenTest {
        public static final String VARIANT                                  = "VARIANT";
        public static final String GENE                                     = "GENE";
    }



}
