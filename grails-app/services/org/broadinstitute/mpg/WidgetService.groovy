package org.broadinstitute.mpg
import grails.transaction.Transactional
import org.broadinstitute.mpg.diabetes.json.builder.LocusZoomJsonBuilder
import org.broadinstitute.mpg.diabetes.metadata.parser.JsonParser
import org.broadinstitute.mpg.diabetes.metadata.query.QueryJsonBuilder
import org.broadinstitute.mpg.diabetes.metadata.result.KnowledgeBaseFlatSearchTranslator
import org.broadinstitute.mpg.diabetes.metadata.result.KnowledgeBaseResultParser
import org.broadinstitute.mpg.diabetes.util.PortalException
import org.codehaus.groovy.grails.web.json.JSONObject

@Transactional
class WidgetService {
    // instance variables
    JsonParser jsonParser = JsonParser.getService();
    QueryJsonBuilder queryJsonBuilder = QueryJsonBuilder.getQueryJsonBuilder();
    RestServerService restServerService;

    // setting variables
    private final String LOCUSZOOM_17K_ENDPOINT = "17k data";
    private final String LOCUSZOOM_HAIL_ENDPOINT = "Hail Dev";
    private String locusZoomEndpointSelection = LOCUSZOOM_17K_ENDPOINT;
    private final List<String> locusZoomEndpointList = [this.LOCUSZOOM_17K_ENDPOINT, this.LOCUSZOOM_HAIL_ENDPOINT];

    // constants for now
    private final String dataSetKey = "ExSeq_17k_mdv2";
    private final String phenotypeKey = "T2D";
    private final String propertyKey = "P_FIRTH_FE_IV";
    private final String errorResponse = "{\"data\": {}, \"error\": true}";

    /**
     * returns a variant list for the LZ query
     *
     * @param chromosome
     * @param startPosition
     * @param endPosition
     * @return
     * @throws PortalException
     */
    public List<org.broadinstitute.mpg.diabetes.knowledgebase.result.Variant> getVariantListForLocusZoom(String chromosome, int startPosition, int endPosition) throws PortalException {
        // local variables
        List<org.broadinstitute.mpg.diabetes.knowledgebase.result.Variant> variantList;
        String jsonResultString, jsonGetDataString;
        LocusZoomJsonBuilder locusZoomJsonBuilder = null;
        KnowledgeBaseResultParser knowledgeBaseResultParser;

        // build the LZ json builder
        locusZoomJsonBuilder = new LocusZoomJsonBuilder(this.dataSetKey, this.phenotypeKey);

        // get json getData query string
        jsonGetDataString = locusZoomJsonBuilder.getLocusZoomQueryString(chromosome, startPosition, endPosition);

        // submit the post request
        if (this.getLocusZoomEndpointSelection() == this.LOCUSZOOM_17K_ENDPOINT) {
            jsonResultString = this.restServerService.postGetDataCall(jsonGetDataString);

        } else if (this.getLocusZoomEndpointSelection() == this.LOCUSZOOM_HAIL_ENDPOINT) {
            jsonResultString = this.restServerService.postGetHailDataCall(jsonGetDataString);

        } else {
            throw new PortalException("Got incorrect LZ endpoint selection: " + this.getLocusZoomEndpointSelection())
        }


        // translate the returning json into variant list
        knowledgeBaseResultParser = new KnowledgeBaseResultParser(jsonResultString);
        variantList = knowledgeBaseResultParser.parseResult();

        // return
        return variantList;
    }

    /**
     * returns a json string for the LZ query
     *
     * @param chromosome
     * @param startPosition
     * @param endPosition
     * @return
     */
    public String getVariantJsonForLocusZoomString(String chromosome, int startPosition, int endPosition) {
        // local variables
        List<org.broadinstitute.mpg.diabetes.knowledgebase.result.Variant> variantList = null;
        JSONObject jsonResultObject = null;
        KnowledgeBaseFlatSearchTranslator knowledgeBaseFlatSearchTranslator;
        String jsonResultString = null;

        // get the query result and translate to a json string
        try {
            // get the variant list
            variantList = this.getVariantListForLocusZoom(chromosome, startPosition, endPosition);

            // translate to json string
            knowledgeBaseFlatSearchTranslator = new KnowledgeBaseFlatSearchTranslator(this.dataSetKey, this.phenotypeKey, this.propertyKey);
            jsonResultObject = knowledgeBaseFlatSearchTranslator.translate(variantList);

            // translate to json string
            if (jsonResultObject != null) {
                jsonResultString = jsonResultObject.toString();
            } else {
                throw PortalException("got null json object for LZ search");
            }

        } catch (PortalException exception) {
            log.error("Got LZ getData query error: " + exception.getMessage());
            jsonResultString = this.errorResponse;
        }

        // return
        return jsonResultString;
    }

    public String getLocusZoomEndpointSelection() {
        return locusZoomEndpointSelection
    }

    /**
     * sets the LZ endpoint setting
     *
     * @param locusZoomEndpointSelection
     */
    void setLocusZoomEndpointSelection(String locusZoomEndpointSelection) {
        // log
        if (locusZoomEndpointSelection == this.LOCUSZOOM_HAIL_ENDPOINT) {
            log.info("now setting LZ endpoint to 17K dataset")
        } else if (locusZoomEndpointSelection == this.LOCUSZOOM_HAIL_ENDPOINT) {
            log.info("now setting LZ endpoint to Hail goT2D dataset")
        } else {
            log.error("now setting LZ endpoint to unknown: " + locusZoomEndpointSelection)
        }

        // set the endpoint setting
        this.locusZoomEndpointSelection = locusZoomEndpointSelection
    }

    public List<String> getLocusZoomEndpointList() {
        return locusZoomEndpointList
    }
}
