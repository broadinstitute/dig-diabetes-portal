package org.broadinstitute.mpg.diabetes.metadata.result;

import org.broadinstitute.mpg.diabetes.knowledgebase.result.Variant;
import org.broadinstitute.mpg.diabetes.util.PortalException;
import org.codehaus.groovy.grails.web.json.JSONObject;

import java.util.List;

/**
 * Interface to be implemented by classes meant to translate a variant list into the desired json format
 *
 */
public interface KnowledgeBaseResultTranslator {

    /**
     * generic translator method to be implemented by the implementing class
     *
     * @param resultList
     * @return
     */
    public JSONObject translate(List<Variant> resultList) throws PortalException;

}
