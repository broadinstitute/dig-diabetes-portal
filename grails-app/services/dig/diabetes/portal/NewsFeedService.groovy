package dig.diabetes.portal

import org.broadinstitute.mpg.RestServerService
import org.broadinstitute.mpg.diabetes.bean.PortalVersionBean
import org.ccil.cowan.tagsoup.Parser
import grails.transaction.Transactional
import groovy.json.JsonSlurper
import org.codehaus.groovy.grails.web.json.JSONObject

import javax.annotation.PostConstruct

@Transactional
class NewsFeedService {
    RestServerService restServerService

    // TODO: move this to an env variable
    private String googleApiKey = 'AIzaSyDX3a4IafytydybkbeF1O61YjenfA2i9gU';

    private boolean initializationExecuted = false

    private JSONObject currentPosts = new JSONObject()
//            [
//            stroke: [],
//            mi: [],
//            ibd   : [],
//            t2d   : []
//            sleep   : []
//    ]

    private JSONObject blogIds = new JSONObject()
//            [
//            t2d   : '5010306206573083521',
//            mi: '3944203828206499294',
//            ibd: '7857348124942584918',
//            stroke: '7961982646849648720'
//            sleep: '3616035242050290841'
//    ]
    // the last time the posts were successfully retrieved
    private JSONObject postsLastUpdatedAt = new JSONObject()

//            [
//        stroke: new Date(0),
//        mi: new Date(0),
//        ibd: new Date(0),
//        t2d: new Date(0)
//    ]
    // how often to refresh the cache, in milliseconds
    private Integer cacheTimeout = 15 * 60 * 1000


    private initialize() {
        if (!initializationExecuted){
            List<PortalVersionBean> portalVersionBeanList = restServerService.retrieveBeanForAllPortals()
            for (PortalVersionBean portalVersionBean in portalVersionBeanList){
                blogIds[portalVersionBean.portalType] = portalVersionBean.blogId
                postsLastUpdatedAt[portalVersionBean.portalType] = new Date(0)
                currentPosts[portalVersionBean.portalType] = []
            }
            initializationExecuted = true
        }
    }



    /**
     * Check if the cached posts have expired--if so, update the
     * cache, and return the posts, otherwise just return the posts
     */
    public JSONObject getCurrentPosts(String portalType) {
        initialize()
        if(portalType == '') {
            return ([posts: []] as JSONObject)
        }
        Date currentDate = new Date()
        Date dateToUpdateAt = new Date(postsLastUpdatedAt[portalType].getTime() + cacheTimeout)
        if (currentDate.after(dateToUpdateAt)) {
            // update the cache
            fetchCurrentPosts(portalType)
        }

        // return what's in the cache
        return ([posts: currentPosts[portalType]] as JSONObject)
    }

    // call out to the blog and get the most recent posts
    def fetchCurrentPosts(String portalType) {
        initialize()
        try {
            // this url requests the 4 most recent posts, getting back the
            // published-at date, url, title, and content for each post
            String url = "https://www.googleapis.com/blogger/v3/blogs/${blogIds[portalType]}/posts?maxResults=4&orderBy=published&fields=items(content%2Cpublished%2Ctitle%2Curl)&key=${googleApiKey}".toURL().text
            JSONObject posts = (new JsonSlurper().parseText(url)) as JSONObject;

            ArrayList<String> processedPosts = new ArrayList<String>()

            posts.items.each {
                // process each item.content into text content
                String content = it.content
                def slurper = new XmlSlurper(new Parser())
                def document = slurper.parseText(content)

                // create new JSON object with processed content, date, title, and link
                JSONObject thisPost = [
                    content: document.toString(),
                    date   : it.published,
                    title  : it.title,
                    url    : it.url
                ]

                processedPosts << thisPost
            }

            currentPosts[portalType] = processedPosts
            postsLastUpdatedAt[portalType] = new Date()
        } catch (Exception e) {
            log.error("Error updating the news feed for ${portalType}: ${e}")
        }
    }
}