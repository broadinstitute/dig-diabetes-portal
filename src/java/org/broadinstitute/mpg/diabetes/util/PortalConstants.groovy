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


    // constants for getData calls
    public final static String OPERATOR_LESS_THAN_EQUALS                 = "LTE";
    public final static String OPERATOR_LESS_THAN_NOT_EQUALS             = "LT";
    public final static String OPERATOR_MORE_THAN_EQUALS                 = "GTE";
    public final static String OPERATOR_MORE_THAN_NOT_EQUALS             = "GT";
    public final static String OPERATOR_EQUALS                           = "EQ";

    // constants of property id keys (these are automatically generated, but caching often used ones here)
    public final static String PROPERTY_KEY_COMMON_VAR_ID                 = "metadata_rootVAR_ID";
    public final static String PROPERTY_KEY_COMMON_CLOSEST_GENE           = "metadata_rootCLOSEST_GENE";
    public final static String PROPERTY_KEY_COMMON_CHROMOSOME             = "metadata_rootCHROM";
    public final static String PROPERTY_KEY_COMMON_CONSEQUENCE            = "metadata_rootConsequence";
    public final static String PROPERTY_KEY_COMMON_POSITION               = "metadata_rootPOS";
    public final static String PROPERTY_KEY_COMMON_DBSNP_ID               = "metadata_rootDBSNP_ID";

    public final static String PROPERTY_KEY_SG_MAF_82K                    = "metadata_root_ExChip_82k_mdv2_82kMAF";
    public final static String PROPERTY_KEY_SG_MAF_SIGMA1                 = "metadata_root_ExChip_SIGMA1_mdv1_SIGMA1MAF";

    public final static String PROPERTY_KEY_PH_MINA_SIGMA1_T2D            = "metadata_root_ExChip_SIGMA1_mdv2_SIGMA1T2DMINA";
    public final static String PROPERTY_KEY_PH_MINU_SIGMA1_T2D            = "metadata_root_ExChip_SIGMA1_mdv2_SIGMA1T2DMINU";
    public final static String PROPERTY_KEY_PH_OR_FIRTH_SIGNA1_T2D        = "metadata_root_ExChip_SIGMA1_mdv2_SIGMA1T2DOR_FIRTH";
    public final static String PROPERTY_KEY_PH_P_VALUE_GWAS_DIAGRAM       = "metadata_root_GWAS_DIAGRAM_mdv2_DIAGRAMT2DP_VALUE";
    public final static String PROPERTY_KEY_PH_P_VALUE_82K_T2D            = "metadata_root_ExChip_82k_mdv1_82kT2DP_VALUE";



}
