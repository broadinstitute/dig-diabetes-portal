package org.broadinstitute.mpg

import grails.transaction.Transactional
import org.codehaus.groovy.grails.web.json.JSONArray
import org.codehaus.groovy.grails.web.json.JSONObject

@Transactional
class EpigenomeService {
    RestServerService restServerService


    public JSONObject tranlsateVector(JSONObject returnJsonVector){
        // returnJsonVector.regions.val
        JSONObject resultLZJson = new JSONObject();
        List<String> pvalueList = [];
        List<String> chrList = [];
        List<String> positionList = [];
        List<String> scoreTestStatList = [];
        List<String> refAlleleFreqList = []
        List<String> refAlleleList = [];
        List<String> analysisList = [];
        List<String>  idList = [];
        for (Map map in returnJsonVector.tissue_id){
            pvalueList <<  """${map.val}""".toString();
            chrList  <<  """${map.chr}""".toString()
            positionList << """${(map.start + map.stop)/2}"""
            scoreTestStatList << """null""".toString()
            refAlleleFreqList << """null""".toString()
            refAlleleList << """null""".toString()
            analysisList << """null""".toString();
            idList << """${pvalueList.size()}""".toString();
        }
        resultLZJson['pvalue'] = pvalueList as JSONArray;
        resultLZJson['chr'] = chrList as JSONArray;
        resultLZJson['position'] = positionList as JSONArray;
        resultLZJson['scoreTestStat'] = scoreTestStatList as JSONArray;
        resultLZJson['refAlleleFreq'] = refAlleleFreqList as JSONArray;
        resultLZJson['refAllele'] = refAlleleList as JSONArray;
        resultLZJson['analysis'] = analysisList as JSONArray;
        resultLZJson['id'] = idList;


        return resultLZJson;
    }


    /**
     * call the vector data rest service with the given json payload string
     *
     * @param burdenCallJsonPayloadString
     * @return
     */
    public JSONObject getVectorDataRestCallResults(String vectorDataJsonPayloadString) {
        JSONObject VectorDataJson = this.restServerService.postVectorDataRestCall(vectorDataJsonPayloadString);
        return VectorDataJson;
    }
    public JSONObject getBigWigDataRestCall(String vectorDataJsonPayloadString) {
        JSONObject VectorDataJson = this.restServerService.postBigWigDataRestCall(vectorDataJsonPayloadString);
        return VectorDataJson;
    }

}
