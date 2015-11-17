package org.broadinstitute.mpg.datapasser

/**
 * Created by balexand on 11/2/2015.
 */
class GspToJavascript {
    public static int TRANSTYPE_NONE = 0
    public static int TRANSTYPE_V_AND_A_ROW = 1
    public static int TRANSTYPE_V_AND_A_COLUMN = 2

    private List<LinkedHashMap> storedValues = []
    private int transType = TRANSTYPE_NONE
    private int count = 0

    public GspToJavascript(List<LinkedHashMap> storedValues, int transType ) {
        this.storedValues = storedValues
        this.transType = transType
    }
    public GspToJavascript(List<LinkedHashMap> storedValues ) {
        this.storedValues = GspToJavascript.TRANSTYPE_V_AND_A_ROW
        this.transType = transType
    }

    public String printValuesAsJavascriptStrings(){
        StringBuilder returnValue = new StringBuilder("[")
        for ( int  i = 0 ; i < storedValues?.size() ; i++ ){
            if (storedValues[i].value){
                returnValue << "'${storedValues[i].value}'"
                if (i+1 < storedValues?.size()){
                    returnValue << ","
                }
            }
        }
        returnValue << "]"
        return returnValue.toString()
    }

    /***
     * convert a Java representation into a JavaScript object
     * @return
     */
    public String printValuesAsJavascriptMaps(){
        StringBuilder returnValue = new StringBuilder("[")
        if (transType == TRANSTYPE_V_AND_A_COLUMN){
            for ( int  i = 0 ; i < storedValues?.size() ; i++ ){
                if ((storedValues[i].value)&&((storedValues[i].name))){
                    returnValue << "{'name':'${storedValues[i].name}',"
                    returnValue << "'value':'${storedValues[i].value}',"
                    returnValue << "'count':'${storedValues[i].count}'}"
                    if (i+1 < storedValues?.size()){
                        returnValue << ","
                    }
                }
            }
        } else if (transType == TRANSTYPE_V_AND_A_ROW) {
            for (int i = 0; i < storedValues?.size(); i++) {
                if ((storedValues[i].value) && ((storedValues[i].name))) {
                    returnValue << "{'name':'${storedValues[i].name}',"
                    returnValue << "'value':'${storedValues[i].value}',"
                    returnValue << "'pvalue':'${storedValues[i].pvalue}',"
                    returnValue << "'count':'${storedValues[i].count}'}"
                    if (i + 1 < storedValues?.size()) {
                        returnValue << ","
                    }
                }
            }
        }
        returnValue << "]"
        return returnValue.toString()
    }



    public List <String> codeValuesForPassBack(){
        List <String> allValuesToReturn = []
        if (transType == TRANSTYPE_V_AND_A_COLUMN) {
            for ( int  i = 0 ; i < storedValues?.size() ; i++ ){
                if ((storedValues[i].value)&&((storedValues[i].name))){
                    allValuesToReturn << "${storedValues[i].name}^${storedValues[i].value}^${storedValues[i].count}"
                }
            }
        } else if (transType == TRANSTYPE_V_AND_A_ROW) {
            for (int i = 0; i < storedValues?.size(); i++) {
                if ((storedValues[i].value) && ((storedValues[i].name))) {
                    allValuesToReturn << "${storedValues[i].name}^${storedValues[i].value}^${storedValues[i].count}^${storedValues[i].pvalue}"
                }
            }
        }
        return allValuesToReturn
    }



    public LinkedHashMap<String,LinkedHashMap<String,String>> namesAndValues(){
        LinkedHashMap<String,String> returnValue = [:]
        if (transType == TRANSTYPE_V_AND_A_COLUMN) {
            for ( int  i = 0 ; i < storedValues?.size() ; i++ ) {
                if ((storedValues[i].value) && ((storedValues[i].name))) {
                    LinkedHashMap<String,String> values = [:]
                    values['value'] = storedValues[i].value
                    values['count'] = storedValues[i].count
                    returnValue["${storedValues[i].name}"] = values
                }
            }
        } else if (transType == TRANSTYPE_V_AND_A_ROW) {
            for ( int  i = 0 ; i < storedValues?.size() ; i++ ) {
                if ((storedValues[i].value) && ((storedValues[i].name))) {
                    LinkedHashMap<String,String> values = [:]
                    values['value'] = storedValues[i].value
                    values['count'] = storedValues[i].count
                    values['pvalue'] = storedValues[i].pvalue
                    returnValue["${storedValues[i].name}"] = values
                }
            }
        }

        return returnValue
    }







}
