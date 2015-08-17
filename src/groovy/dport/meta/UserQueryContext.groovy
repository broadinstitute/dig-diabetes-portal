package dport.meta

import org.apache.juli.logging.LogFactory

/**
 * Created by balexand on 8/6/2015.
 *
 * This class is intended to serve two purposes:
 * short-term: let's pull out all of the static Definition/dependencies
 *       that are necessary to construct filters into one place
 * longer-term: will require some metadata changes, but this is the place to
 *       derive specifics such as sample group IDs based on the information in the metadata
 */
class UserQueryContext {
    private static final log = LogFactory.getLog(this)

    private String exomeSequence  = "ExSeq_17k_mdv2"
    private String gwasData  = "GWAS_DIAGRAM_mdv2"
    private String exomeChip  = "ExChip_82k_mdv2"
    private String sigmaData  = "unknown"

    String technology = ""
    String sampleGroup = ""
    String customSampleGroup = ""
    String version = ""
    String ancestry = ""
    String value = "1"
    String propertyCategory = "PVALUE"
    String phenotype = "blah"
    String operator = "LTE"
    public UserQueryContext(){
    }
    public static generateUserQueryContext(){

    }
    public String getDataSetId (){
        String returnValue
        switch (this.sampleGroup) {
            case "gwas": returnValue = gwasData; break;
            case "sigma": returnValue = sigmaData; break;
            case "exomeseq": returnValue = exomeSequence; break;
            case "exomechip": returnValue = exomeChip; break;
            case "custom": returnValue = customSampleGroup; break;
            default:
                returnValue = "blah";
                break;
        }
        return returnValue
    }

    public String getPhenotype (){
        return phenotype
    }
    public String getOperand (){
        String returnValue
        switch (propertyCategory){
            case "PVALUE":
            case "PVALUE_LTE":
            case "PVALUE_GTE":
                switch (this.sampleGroup) {
                    case "gwas": returnValue = "P_VALUE"; break;
                    case "sigma": returnValue = "P_VALUE"; break;
                    case "exomeseq": returnValue = "P_FIRTH_FE_IV"; break;
                    case "exomechip": returnValue = "P_VALUE"; break;
                    case "custom": returnValue = "P_VALUE"; break;
                    default:
                        log.error("unknown getOperand sampleGroup ${this.sampleGroup}")
                        break;
                }
                break;
            case "GENE":
                returnValue = "GENE";
                break;
            case "CHROM":
                returnValue = "CHROM";
                break;
            case "POS_GTE":
            case "POS_LTE":
                returnValue = "POS";
                break;
            default:
                log.error("unknown getOperand  ${this.propertyCategory}")
                break;
        }
         return returnValue
    }
    public String getOperator (){
        String returnValue
        switch (propertyCategory){
            case "PVALUE":
            case "PVALUE_LTE":
            case "POS_LTE":
                returnValue = "LTE";
                break;
            case "GENE":
            case "CHROM":
                returnValue = "EQ";
                break;
            case "POS_GTE":
            case "PVALUE_GTE":
                returnValue = "GTE";
                break;
            default:
                log.error("unknown getOperand  ${this.propertyCategory}")
                break;
        }
        return returnValue
    }
    public String getValue (){
        return value
    }
    public String getOperandType (){
        String returnValue
        switch (propertyCategory){
            case "POS_LTE":
            case "POS_GTE":
                returnValue = "INTEGER";
                break;
            case "PVALUE":
            case "PVALUE_LTE":
            case "PVALUE_GTE":
                returnValue = "FLOAT";
                break;
            case "GENE":
            case "CHROM":
                returnValue = "STRING";
                break;
            default:
                log.error("unknown getOperandType  ${this.propertyCategory}")
                break;
        }
        return returnValue

    }

}
