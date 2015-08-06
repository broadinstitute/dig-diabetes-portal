package dport.meta
/**
 * Created by balexand on 8/6/2015.
 */
class UserQueryContext {
    private String exomeSequence  = "ExSeq_17k_mdv2"
    private String gwasData  = "GWAS_DIAGRAM_mdv2"
    private String exomeChip  = "ExChip_82k_mdv2"
    private String sigmaData  = "unknown"

    String technology = ""
    String sampleGroup = ""
    String version = ""
    String ancestry = ""
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
            default: break;
        }
        return returnValue
    }

    public String getPhenotype (){
        return "T2D"
    }
    public String getOperand (){
        String returnValue
        switch (this.sampleGroup) {
            case "gwas": returnValue = "P_VALUE"; break;
            case "sigma": returnValue = "P_VALUE"; break;
            case "exomeseq": returnValue = "P_FIRTH_FE_IV"; break;
            case "exomechip": returnValue = "P_VALUE"; break;
            default: break;
        }
        return returnValue

    }
    public String getOperator (){
        return "LTE"
    }
    public String getValue (){
        return "1"
    }
    public String getOperandType (){
        return "FLOAT"
    }

}
