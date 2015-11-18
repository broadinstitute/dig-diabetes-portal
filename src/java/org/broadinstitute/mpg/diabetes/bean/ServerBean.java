package org.broadinstitute.mpg.diabetes.bean;

/**
 * Created by mduby on 8/25/15.
 */
public class ServerBean {
    // static constants for the method call signatures
    public static final String BURDEN_TEST_CALL_V2                              = "v2";
    public static final String BURDEN_TEST_CALL_GET_PHENOTYPES                  = "getPhenotypes";
    public static final String BURDEN_TEST_CALL_GET_PHENOTYPES_WITH_SLASH       = "/getPhenotypes";

    // instance variables
    private String url;
    private String name;

    public ServerBean(String name, String url) {
        this.name = name;
        this.url = url;
    }

    public String getUrl() {
        return url;
    }

    public String getName() {
        return name;
    }

    public String getRestServiceCallUrl(String methodString) {
        return (this.url + "/" + methodString);
    }
}
