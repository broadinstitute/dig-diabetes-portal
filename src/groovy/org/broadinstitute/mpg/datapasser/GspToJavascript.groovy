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


    public String printValuesAsJavascriptMaps(){
        StringBuilder returnValue = new StringBuilder("[")
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
        returnValue << "]"
        return returnValue.toString()
    }



    public List <String> codeValuesForPassBack(){
        List <String> allValuesToReturn = []
        for ( int  i = 0 ; i < storedValues?.size() ; i++ ){
            if ((storedValues[i].value)&&((storedValues[i].name))){
                allValuesToReturn << "${storedValues[i].name}^${storedValues[i].value}^${storedValues[i].count}"
            }
        }
        return allValuesToReturn
    }







}
