package dig.diabetes.portal

import org.ccil.cowan.tagsoup.Parser
import grails.transaction.Transactional
import groovy.json.JsonSlurper
import org.codehaus.groovy.grails.web.json.JSONObject

@Transactional
class NewsFeedService {

    // TODO: move this to an env variable
    private String googleApiKey = 'AIzaSyDX3a4IafytydybkbeF1O61YjenfA2i9gU';

    private JSONObject currentPosts = [
            stroke: [],
            mi: [],
            ibd   : [],
            t2d   : []
    ]

    private JSONObject blogIds = [
            t2d   : '5010306206573083521',
            mi: '7857348124942584918',
            ibd: '7857348124942584918',
            stroke: '7857348124942584918'
    ]
    // the last time the posts were successfully retrieved
    private JSONObject postsLastUpdatedAt = [
        stroke: new Date(0),
        mi: new Date(0),
        ibd: new Date(0),
        t2d: new Date(0)
    ]
    // how often to refresh the cache, in milliseconds
    private Integer cacheTimeout = 15 * 60 * 1000

    /**
     * Check if the cached posts have expired--if so, update the
     * cache, and return the posts, otherwise just return the posts
     */
    public JSONObject getCurrentPosts(String portalType) {
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