package org.broadinstitute.mpg.diabetes.burden.parser;

import org.broadinstitute.mpg.diabetes.util.PortalConstants;
import org.broadinstitute.mpg.diabetes.util.PortalException;
import org.codehaus.groovy.grails.web.json.JSONException;
import org.codehaus.groovy.grails.web.json.JSONObject;

import java.util.List;

/**
 * Created by mduby on 8/21/15.
 */
public class BurdenJsonBuilder {
    // singleton instance
    private static BurdenJsonBuilder burdenJsonBuilder;


    /**
     * singleton getter
     *
     * @return
     */
    public static BurdenJsonBuilder getBurdenJsonBuilder() {
        if (burdenJsonBuilder == null) {
            burdenJsonBuilder = new BurdenJsonBuilder();
        }

        return burdenJsonBuilder;
    }

    /**
     * returns a json object to use for a json burden port request object
     *
     * @param variantList               the variants to include; if null or empty, exception is thrown
     * @param covariatesList            the list of covariates; if null or empty, include first 10
     * @return
     * @throws PortalException
     */
    public JSONObject getBurdenPostJson(List<String> variantList, List<String> covariatesList) throws PortalException {
        // local variables
        JSONObject finalObject;

        // create the json object
        try {
            finalObject = new JSONObject(this.getBurdenPostJsonString(variantList, covariatesList));
        } catch (JSONException exception) {
            throw new PortalException(("got json creation exception for burden test payload geneeration: " + exception.getMessage()));
        }

        // return
        return finalObject;
    }

    /**
     * returns a string from which to build a json burden port request object
     *
     * @param variantList               the variants to include; if null or empty, exception is thrown
     * @param covariatesList            the list of covariates; if null or empty, include first 10
     * @return
     * @throws PortalException
     */
    public String getBurdenPostJsonString(List<String> variantList, List<String> covariatesList) throws PortalException {
        // local variables
        String finalString;
        StringBuilder stringBuilder = new StringBuilder();

        // create the variant list json object string
        stringBuilder.append("{\"");
        stringBuilder.append(PortalConstants.JSON_BURDEN_VARIANTS_KEY);
        stringBuilder.append("\" : [");
        if (variantList == null) {
            throw new PortalException("Got null variant list for the burden test");
        } else if (variantList.size() == 0) {
                throw new PortalException("Got empty variant list for the burden test");
        } else {
            for (int i = 0; i < variantList.size(); i++) {
                stringBuilder.append("\"" + variantList.get(i) + "\"");
                if (i < variantList.size() - 1) {
                    stringBuilder.append(",");
                }
            }
        }
        stringBuilder.append("],");

        // create the covariates list json object string
        stringBuilder.append("\"");
        stringBuilder.append(PortalConstants.JSON_BURDEN_COVARIATES_KEY);
        stringBuilder.append("\" : [");
        if ((covariatesList == null) || (covariatesList.size() == 0)) {
            for (int i = 1; i < 11; i++) {
                stringBuilder.append("\"C" + i + "\"");
                if (i < 10) {
                    stringBuilder.append(",");
                }
            }
        }
        stringBuilder.append("]}");

        // create the filters list object string
        // TODO - no filters for DIGP-42 09/13/15 deadline

        // return
        return stringBuilder.toString();
    }
}
