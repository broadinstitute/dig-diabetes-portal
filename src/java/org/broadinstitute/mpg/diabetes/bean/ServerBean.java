package org.broadinstitute.mpg.diabetes.bean;

/**
 * Created by mduby on 8/25/15.
 */
public class ServerBean {
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
}
