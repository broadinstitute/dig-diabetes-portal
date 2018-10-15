
import grails.util.Environment
import org.broadinstitute.mpg.diabetes.bean.ServerBean
import org.broadinstitute.mpg.diabetes.bean.PortalVersionBean

// locations to search for config files that get merged into the main config;
// config files can be ConfigSlurper scripts, Java properties files, or classes
// in the classpath in ConfigSlurper format

def appName = "${appName}"
def catalinaBase = System.properties.getProperty('catalina.base')
if (!catalinaBase) catalinaBase = '.'   // just in case
def logDirectory = "${catalinaBase}/logs"


site.version = 't2dgenes' // could be 'sigma', 't2dgenes', or 'beacon'
if (site.version == 't2dgenes'){
    site.title = 'Type 2 Diabetes Genetics'  // could be 'SIGMA T2D' or 'Type 2 Diabetes Genetics'
    site.subtext = 'Beta'
    site.operator = 't2d-error@googlegroups.com'

    portal {
        sections {
            show_gene = 1
            show_gwas  = 1
            show_exchp = 1
            show_exseq = 1
            show_sigma = 0
            show_beacon = 0
        }
    }

}else if (site.version == 'sigma'){
    site.title = 'SIGMA T2D'  // could be 'SIGMA T2D' or 'Type 2 Diabetes Genetics'
    site.subtext = 'a resource on the genetics of type 2 diabetes in Mexico'
    site.operator = 't2d-error@googlegroups.com'

    portal {
        sections {
            show_gene = 1
            show_gwas  = 1
            show_exchp = 0
            show_exseq = 0
            show_sigma = 1
            show_beacon = 0
        }
    }



} else if (site.version == 'sigma'){
    site.title = 'BEACON'  // could be 'SIGMA T2D' or 'Type 2 Diabetes Genetics'
    site.subtext = 'index lookup for all variants'
    site.operator = 'kyuksel@broadinstitute.org '

    portal {
        sections {
            show_gene = 0
            show_gwas  = 0
            show_exchp = 0
            show_exseq = 0
            show_sigma = 0
            show_beacon = 1
        }
    }



}



grails.plugin.databasemigration.updateOnStart = true


if  (Environment.current == Environment.DEVELOPMENT)  {
     println('\n\n*** Preparing DEV environment ***\n\n')
} else if  (Environment.current == Environment.TEST)  {
    println('\n\n*** Preparing TEST environment ***\n\n')
}   else if  (Environment.current == Environment.PRODUCTION)  {
    println('\n\n*** Preparing PROD environment ***\n\n')
 }  else {
    println("\n\n*** Preparing ${Environment.current} environment ***\n\n")
}


/**
 * Loads external config files from the .grails subfolder in the user's home directory
 * Home directory in Windows is usually: C:\Users\<username>\.grails
 * In Unix, this is usually ~\.grails
 *
 */
if (appName) {
    grails.config.locations = []

    // If the developer specifies a directory for the external config files at the command line, use it.
    // This will look like 'grails -DprimaryConfigDir=[directory name] [target]'
    // Otherwise, look for these files in the user's home .grails/projectdb directory
    // If there are no external config files in either location, don't override anything in this Config.groovy
    String primaryOverrideDirName = System.properties.get('overrideConfigDir')
    String secondaryOverrideDirName = "${userHome}/.grails/${appName}"

    println (">>>>>>>>>>>Note to developers: config files may be placed in the directory  = ${secondaryOverrideDirName}")
    println (">>>>>>>>>>>Alternatively, specify the directory you are drawing from with the grails option -DoverrideConfigDir=myDirectoryWhichMightBeNamedWhateverIWant")


    List<String> fileNames = ["${appName}-commons-config.groovy", "${appName}-${Environment.current.name}-config.groovy"]
    fileNames.each { fileName ->
        String primaryFullName = "${primaryOverrideDirName}/${fileName}"
        String secondaryFullName = "${secondaryOverrideDirName}/${fileName}"

        if (new File(primaryFullName).exists()) {
            println "Overriding Config.groovy with $primaryFullName"
            grails.config.locations << "file:$primaryFullName"
        } else if (new File(secondaryFullName).exists()) {
            println "Overriding Config.groovy with $secondaryFullName"
            grails.config.locations << "file:$secondaryFullName"
        }
    }
 }

if (grails.config.locations.isEmpty()){
    println "\n** No config override  in effect **"
} else {
    println "\n** !! config override is in effect !! **"
    for (location in grails.config.locations )   {
        println "!!!!! ${location} !! **"
    }
}

digdevlocalServer = new ServerBean("KB-dev-localhost", "http://localhost:8090/dccservices/")
digdevlocalFederatedServer = new ServerBean("KB-dev-localhost-federated", "http://localhost:8090/dccservices/distributed/")
digAWS02KBV2prodServer = new ServerBean("KB-stage-2016-aws", "http://ec2-52-207-40-241.compute-1.amazonaws.com:8090/dccservices/")
federatedAwsStageKBV2Server = new ServerBean("KB-stage-fed-2016-aws", "http://ec2-52-207-40-241.compute-1.amazonaws.com:8085/dccservices/distributed/")
toddTestServer = new ServerBean("KB-ToddTest-Broad","http://dig-prod.broadinstitute.org:8087/todd/gs/")
digdevmarcin = new ServerBean("KB-dev-Broad", "http://dig-api-dev.broadinstitute.org/dev/gs/")
digawsdevnewKB = new ServerBean("KB-dev-2017-aws", "http://ec2-34-229-106-174.compute-1.amazonaws.com:8090/dccservices/")
digawsdevWorkflowKB = new ServerBean("KB-dev-2017-aws-8089", "http://ec2-34-229-106-174.compute-1.amazonaws.com:8089/dccservices/")
digawsdevnewKB_fed = new ServerBean("KB-dev-fed-2017-aws", "http://ec2-34-228-247-254.compute-1.amazonaws.com:8085/dccservices/distributed/")
digawsdevnewKB_fed = new ServerBean("KB-dev-fed-2017-aws", "http://ec2-34-229-106-174.compute-1.amazonaws.com:8085/dccservices/distributed/")
digawsqanewKB = new ServerBean("KB-qa-2017-aws", "http://ec2-34-237-63-26.compute-1.amazonaws.com:8090/dccservices/")
digawsqanewKB_fed = new ServerBean("KB-qa-fed-2017-aws", "http://ec2-34-237-63-26.compute-1.amazonaws.com:8085/dccservices/distributed/")
digawsprodmiKB = new ServerBean("KB-prod-mi-2017-aws", "http://ec2-52-55-251-60.compute-1.amazonaws.com:8090/dccservices/")
digawsprodstrokeKB = new ServerBean("KB-prod-stroke-2017-aws", "http://ec2-34-207-249-213.compute-1.amazonaws.com:8090/dccservices/")
digawsdemoibdKB = new ServerBean("KB-ibd-demo-2017-aws", "http://ec2-54-90-219-234.compute-1.amazonaws.com:8090/dccservices/")


// I'm not sure whether the following seven lines are necessary or not
ebiKB1 = new ServerBean("EBI prod KB1 - no burden", "http://www.ebi.ac.uk/ega/t2d/dig-genome-store/gs/")
ebiKB2 = new ServerBean("EBI dev KB2", "http://www.ebi.ac.uk/ega/ampt2d/dev/dig-genome-services/")
digawsqanewKB = new ServerBean("QA Broad non fed KB", "http://ec2-34-237-63-26.compute-1.amazonaws.com:8090/dccservices/")
digawsqanewKB_fed = new ServerBean("QA fed KB", "http://ec2-34-237-63-26.compute-1.amazonaws.com:8085/dccservices/distributed/")
digawsqanewKB_fed_dedicated = new ServerBean("Dedicated EBI QA fed KB", "http://ec2-34-237-63-26.compute-1.amazonaws.com:8082/dccservices/distributed/")
digAWSKBV2prodServer = new ServerBean("Prod Broad non fed KB", "http://ec2-52-90-97-40.compute-1.amazonaws.com:8090/dccservices/")
federatedAwsProdKBV2Server = new ServerBean("Prod fed KB", "http://ec2-52-90-97-40.compute-1.amazonaws.com:8085/dccservices/distributed/")

// KB for the test federated portal changes
digawsqanewKB_fed_dedicated_EBIv2 = new ServerBean("Dedicated EBI QA fed KB - Using EBI KB2", "http://ec2-34-237-63-26.compute-1.amazonaws.com:8082/dccservices/distributed/")


// this will be your default
//defaultRestServer = digawsqanewKB
defaultRestServer = digawsdevWorkflowKB


getRestServerList = [
        digdevlocalServer,
        digdevlocalFederatedServer,
        digAWSKBV2prodServer,
        federatedAwsProdKBV2Server,
        digawsdevnewKB,
        digawsqanewKB,
        digawsdevWorkflowKB,
        digawsqanewKB_fed,
        digawsqanewKB_fed_dedicated,
        ebiKB1,
        ebiKB2,
        digawsqanewKB_fed_dedicated_EBIv2,
        digawsprodmiKB,
        digawsprodstrokeKB,
        digawsdemoibdKB
//>>>>>>> phewasForest
]



//    default server on start up
server.URL = defaultRestServer.getUrl()
restServer.URL = 'http://dig-api-qa.broadinstitute.org/qa/gs/'

//default  BackEndRestServer
restServer.URL = new ServerBean("qarestserver", "http://dig-api-qa.broadinstitute.org/qa/gs/");
dbtRestServer.URL = 'http://diabetesgeneticsportal.broadinstitute.org:8888/test/burden/'
experimentalRestServer.URL = 'http://dig-qa.broadinstitute.org:8888/qa/gs/'


println("\n\n%%%%%%%%%  Your initial backend REST server will be ${defaultRestServer.getUrl()}, aka ${defaultRestServer.getName()} %%%%%%%%%%%%%%%%\n\n")




grails.project.groupId = appName // change this to alter the default package name and Maven publishing destination

// The ACCEPT header will not be used for content negotiation for user agents containing the following strings (defaults to the 4 major rendering engines)
grails.mime.disable.accept.header.userAgents = ['Gecko', 'WebKit', 'Presto', 'Trident']
grails.mime.types = [ // the first one is the default format
    all:           '*/*', // 'all' maps to '*' or the first available format in withFormat
    atom:          'application/atom+xml',
    css:           'text/css',
    csv:           'text/csv',
    form:          'application/x-www-form-urlencoded',
    html:          ['text/html','application/xhtml+xml'],
    js:            'text/javascript',
    json:          ['application/json', 'text/json'],
    multipartForm: 'multipart/form-data',
    rss:           'application/rss+xml',
    text:          'text/plain',
    hal:           ['application/hal+json','application/hal+xml'],
    xml:           ['text/xml', 'application/xml']
]

// URL Mapping Cache Max Size, defaults to 5000
//grails.urlmapping.cache.maxsize = 1000

// Legacy setting for codec used to encode data with ${}
grails.views.default.codec = "html"

// The default scope for controllers. May be prototype, session or singleton.
// If unspecified, controllers are prototype scoped.
grails.controllers.defaultScope = 'singleton'

// GSP settings
grails {
    views {
        gsp {
            encoding = 'UTF-8'
            htmlcodec = 'xml' // use xml escaping instead of HTML4 escaping
            codecs {
                expression = 'html' // escapes values inside ${}
                scriptlet = 'html' // escapes output from scriptlets in GSPs
                taglib = 'none' // escapes output from taglibs
                staticparts = 'none' // escapes output from static template parts
            }
        }
        // escapes all not-encoded output at final stage of outputting
        // filteringCodecForContentType.'text/html' = 'html'
    }
}

grails.converters.encoding = "UTF-8"
grails.converters.json.circular.reference.behaviour = 'INSERT_NULL'
// scaffolding templates configuration
grails.scaffolding.templates.domainSuffix = 'Instance'

// Set to false to use the new Grails 1.2 JSONBuilder in the render method
grails.json.legacy.builder = false
// enabled native2ascii conversion of i18n properties files
grails.enable.native2ascii = true
// packages to include in Spring bean scanning
grails.spring.bean.packages = []
// whether to disable processing of multi part requests
grails.web.disable.multipart=false

// request parameters to mask when logging exceptions
grails.exceptionresolver.params.exclude = ['password']

// configure auto-caching of queries by default (if false you can cache individual queries with 'cache: true')
grails.hibernate.cache.queries = false

// configure passing transaction's read-only attribute to Hibernate session, queries and criterias
// set "singleSession = false" OSIV mode in hibernate configuration after enabling
grails.hibernate.pass.readonly = false
// configure passing read-only to OSIV session by default, requires "singleSession = false" OSIV mode
grails.hibernate.osiv.readonly = false

environments {
    development {
        // DIGKB-23: keep this here as placeholder for U Michigan setup
//        grails.serverURL = "http://portaldev.sph.umich.edu/dig-diabetes-portal"
        grails.logging.jul.usebridge = true

        if (System.properties['server.URL']) {
            server.URL = System.properties['server.URL']
            println "server.URL=${server.URL}"
        }
        if (System.properties['app.version']) {
            app.version = System.properties['app.version']
            println "app.version=${app.version}"
        }
        if (System.properties['build.number']) {
            build.number = System.properties['build.number']
            println "build.number=${build.number}"
        }
        if (System.properties['site.version']) {
            site.version = System.properties['site.version']
            println "site.version=${site.version}"
        }
        if (System.properties['grails.serverURL']) {
            grails.serverURL= System.properties['grails.serverURL']
            println "grails.serverURL=${grails.serverURL}"
        }

        grails.dbconsole.enabled = true

    }
    production {



//        grails.serverURL = "http://stroke-qasrvr-1.us-east-1.elasticbeanstalk.com"

//       grails.serverURL = "http://www.type2diabetesgenetics.org"
//        grails.serverURL = "http://www.type2diabetesgenetics.org"
//        grails.serverURL = "http://variant2function.org"

//        grails.serverURL = "http://demo52k.us-east-1.elasticbeanstalk.com"
//      grails.serverURL = "http://ci-env.elasticbeanstalk.com"
      grails.serverURL = "http://type2diabetes-dev.elasticbeanstalk.com"
//     grails.serverURL = "http://type2diabetesgen-qasrvr.elasticbeanstalk.com"

//      grails.serverURL = "http://ec2-54-175-211-21.compute-1.amazonaws.com/"              // temp for now, will house new prdsrv1 URL

//      grails.serverURL = "http://sigmat2dqasrv-env.elasticbeanstalk.com"
//        grails.serverURL = "http://sigmat2dqasrv2.elasticbeanstalk.com"
//        grails.serverURL = "http://sigmat2ddev.elasticbeanstalk.com"
//        grails.serverURL = "http://sigmat2ddevsrv2.elasticbeanstalk.com"

//        grails.serverURL = "http://type2diabgen-prodsrv1.elasticbeanstalk.com"
//      grails.serverURL = "http://type2diabetesgenetics.elasticbeanstalk.com"

        //      grails.serverURL = "http://cerebrovascularportal.org"             // CDKP (stroke portal) production
        //      grails.serverURL = "http://stroke-qasrvr-1.us-east-1.elasticbeanstalk.com"      // CDKP (stroke portal) test site
//        grails.serverURL = "http://strokeprodnew.us-east-1.elasticbeanstalk.com"

//         grails.serverURL = "http://broadcvdi.org"                                             // CVDKP (MI portal) production
//        grails.serverURL = "http://mi-qasrvr.us-east-1.elasticbeanstalk.com"                    // CVDKP (MI portal) test site
//        grails.serverURL = "http://miprodportal.us-east-1.elasticbeanstalk.com"
//        grails.serverURL = "http://miprod-env.us-east-1.elasticbeanstalk.com"

//        grails.serverURL = "http://sleepportal-prodsrvr.us-east-1.elasticbeanstalk.com"
//
//        grails.serverURL = "http://intel-rp-env.us-east-1.elasticbeanstalk.com"             // intel portal dev for now
//        grails.serverURL = "http://distrib-dcc-portal-env.us-east-1.elasticbeanstalk.com"             // distributed portal dev for now


//        grails.serverURL = "http://gpad4-dcf.broadinstitute.org:8080"             // distributed portal dev for now
//        grails.serverURL = "http://preeti-test-clone.us-east-1.elasticbeanstalk.com"             // distributed portal dev for now


//          grails.serverURL = "http://ibdqa.us-east-1.elasticbeanstalk.com"


//        grails.serverURL = "http://portaldemo.us-east-1.elasticbeanstalk.com"

//        grails.serverURL = "http://portaldemo.us-east-1.elasticbeanstalk.com"

//          grails.serverURL = "http://ibdqa.us-east-1.elasticbeanstalk.com"

//        grails.serverURL = "http://testdistributed.us-east-1.elasticbeanstalk.com"             // distributed test portal dev for now


//        grails.serverURL = "http://mi-qasrvr.us-east-1.elasticbeanstalk.com"                    // CVDKP (MI portal) demo
//I         grails.serverURL = "http://epilepsytest.us-east-1.elasticbeanstalk.com"                  // Epilepsy test portal

//         grails.serverURL = "http://epilepsytest.us-east-1.elasticbeanstalk.com"


//        grails.serverURL = "http://default-environment-ia3djrq6pi.elasticbeanstalk.com"
//      grails.serverURL = "http://beacon.broadinstitute.org"
        grails.logging.jul.usebridge = false
        if (System.properties['server.URL']) {
            server.URL = System.properties['server.URL']
            println "server.URL=${server.URL}"
        }

    }
}

if  (Environment.current == Environment.PRODUCTION)  {
    println("\n\n>>>>>>>>>>>>grails.serverURL=${grails.serverURL}<<<<<<<<<<<<<<<<<<<<<<")
}   else {
    println("\nEnvironment = ${Environment.current}, therefore no grails.serverURL")
}


appName = grails.util.Metadata.current.'app.name'
//def baseURL = grails.serverURL ?: "http://GPAD4-DCF.broadinstitute.org:${System.getProperty('server.port', '8080')}/${appName}"

def baseURL = grails.serverURL ?: "http://127.0.0.1:${System.getProperty('server.port', '8080')}/${appName}"


println("\n\n>>>>>>>>>>>>baseURL=${baseURL}<<<<<<<<<<<<<<<<<<<<<<")

oauth {

    providers {

        google {
            api = org.grails.plugin.springsecurity.oauth.GoogleApi20
            key = '975413760331-d2nr5vq7sbbppjfog0cp9j4agesbeovt.apps.googleusercontent.com'
            successUri = "${baseURL}/springSecurityOAuth/onSuccess"   // never used?
            failureUri = "${baseURL}/springSecurityOAuth/onFailure"   // never used?
            callback = "${baseURL}/springSecurityOAuth/codeExchange?provider=google"
            scope = 'https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email'
        }

    }
}

googleapi {
    baseGoogleUrl = 'www.googleapis.com'
}




// email (gmail)
grails {
    mail {
        host = "smtp.gmail.com"
        port = 465
        username = "t2dportal@gmail.com"
        password = "diaPortal"
        props = ["mail.smtp.auth":"true",
                 "mail.smtp.socketFactory.port":"465",
                 "mail.smtp.socketFactory.class":"javax.net.ssl.SSLSocketFactory",
                 "mail.smtp.socketFactory.fallback":"false"]
    }
}

//security stuff
grails.plugin.springsecurity.securityConfigType = "InterceptUrlMap"
grails.plugin.springsecurity.interceptUrlMap = [
        '/':                        ['permitAll'],
        '/index':                   ['permitAll'],
        '/index.gsp':               ['permitAll'],
        '/home':                    ['permitAll'],
        '/home/**':                 ['permitAll'],
        '/articles/**':             ['permitAll'],
        '/resultsfilter/**':             ['permitAll'],
        '/about/**':                ['permitAll'],
        '/projects/**':             ['permitAll'],
        '/system/**':               ['ROLE_SYSTEM'],
        '/system/determineVersion':               ['permitAll'],
        '/admin/resetPassword':     ['permitAll'],
        '/admin/resetPasswordInteractive/**':     ['permitAll'],
        '/admin/updatePasswordInteractive/**':     ['permitAll'],
        '/admin/updatePassword/**': ['permitAll'],
        '/admin/**':            ['ROLE_ADMIN'],
        '/user/**':            ['ROLE_ADMIN'],
        '/geneData/**':            ['ROLE_ADMIN'],
        '/gene/index':          ['permitAll'],
        '/gene/**':             ['ROLE_USER'],
        '/informational/**':    ['permitAll'],
        '/region/**':           ['ROLE_USER'],
        '/trait/**':            ['ROLE_USER'],
        '/variant/**':          ['ROLE_USER'],
        '/variantInfo/**':      ['ROLE_USER'],
        '/grs/**':              ['ROLE_USER'],
        '/variantSearch/retrieveGwasSpecificPhenotypesAjax':    ['permitAll'],
        '/variantSearch/**':    ['ROLE_USER'],
        '/beacon/*':          ['permitAll'],
        '/assets/**':         ['permitAll'],
        '/**/js/**':          ['permitAll'],
        '/**/fonts/**':       ['permitAll'],
        '/**/css/**':         ['permitAll'],
        '/**/images/**':      ['permitAll'],
        '/**/*.ico':          ['permitAll'],
        '/login/**':          ['permitAll'],
        '/logout/**':         ['permitAll'],
        '/hypothesisGen/**':  ['ROLE_USER'],
        '/oauth/**':          ['permitAll'],
        '/springSecurityOAuth/**':          ['permitAll'],
        '/dbconsole/**':      ['ROLE_ADMIN'],
        '/localization/**':   ['ROLE_ADMIN'],
        '/metadatainfo/**':       ['ROLE_USER'],
        '/regionInfo/**':      ['ROLE_USER']
]
grails.plugin.auth.loginFormUrl='/Security/auth2'
grails.plugin.springsecurity.logout.postOnly = false
grails.plugin.springsecurity.rememberMe.cookieName="td2PortalRememberMe"
grails.plugin.springsecurity.rememberMe.key="td2PortalKey"
grails.plugin.springsecurity.rememberMe.rememberMe.persistent=true
grails.plugin.springsecurity.successHandler.alwaysUseDefault = false
grails.plugin.springsecurity.successHandler.defaultTargetUrl = "/home/portalHome"
grails.plugin.springsecurity.rejectIfNoRule = true     // pessimistic rule -- no rule means access rejected if true
grails.plugin.springsecurity.fii.rejectPublicInvocations = false  // if true then un-mapped URLs will trigger an IllegalArgumentException

grails.plugin.springsecurity.apf.storeLastUsername=true
grails.plugin.springsecurity.dao.hideUserNotFoundExceptions=false
grails.plugin.springsecurity.useSecurityEventListener=true
grails.plugin.springsecurity.errors.login.fail="Sorry, but your password has been reset.  Please check your email for a link with which you can re-initialize your password"
//springSecurity.errors.login.fail=Sorry, we were not able to find a user with that username and password.
grails.plugin.springsecurity.failureHandler.exceptionMappings = [
        'org.springframework.security.authentication.CredentialsExpiredException': '/admin/resetPassword'
]
//grails.plugin.springsecurity.failureHandler.exceptionMappings = [
//        'org.springframework.security.authentication.LockedException':             '/user/accountLocked',
//        'org.springframework.security.authentication.DisabledException':           '/user/accountDisabled',
//        'org.springframework.security.authentication.AccountExpiredException':     '/user/accountExpired',
//        'org.springframework.security.authentication.CredentialsExpiredException': '/user/passwordExpired'
//]

log4j = { root ->
    appenders {
        rollingFile name: 'stdout', file: "${logDirectory}/${appName}.log".toString(), maxFileSize: '10MB'
        rollingFile name: 'stacktrace', file: "${logDirectory}/${appName}_stack.log".toString(), maxFileSize: '1MB'
    }

    error 'org.codehaus.groovy.grails.web.servlet',  //  controllers
            'org.codehaus.groovy.grails.web.pages', //  GSP
            'org.codehaus.groovy.grails.web.sitemesh', //  layouts
            'org.codehaus.groovy.grails.web.mapping.filter', // URL mapping
            'org.codehaus.groovy.grails.web.mapping', // URL mapping
            'org.codehaus.groovy.grails.commons', // core / classloading
            'org.codehaus.groovy.grails.plugins', // plugins
            'org.codehaus.groovy.grails.orm.hibernate', // hibernate integration
            'org.springframework',
            'org.hibernate'
    warn 'grails',
            'grails.plugin.webxml.WebxmlGrailsPlugin',
            'grails.app.service',
            'grails.plugins.hawkeventing',
            'net.sf.ehcache.hibernate'
    info 'grails.app'
    root.level = org.apache.log4j.Level.INFO


    environments {
        development {
            appenders {
                console name: 'stdout', layout: pattern(conversionPattern: "%d [%t] %-5p %c %l %x - %m%n")
            }
        }

        staging {
            appenders {
                rollingFile name: 'stdout', file: "${logDirectory}/${appName}.log".toString(), maxFileSize: '10MB'
                rollingFile name: 'stacktrace', file: "${logDirectory}/${appName}_stack.log".toString(), maxFileSize: '10MB'
                //console name: 'stdout', layout: pattern(conversionPattern: "%d [%t] %-5p %c %x - %m%n")
            }

            // DO STUFF RELATED TO STAGING ENV
        }


        prod {
            appenders {
                rollingFile name: 'stdout', file: "${logDirectory}/${appName}.log".toString(), maxFileSize: '10MB'
                rollingFile name: 'stacktrace', file: "${logDirectory}/${appName}_stack.log".toString(), maxFileSize: '10MB'
                //console name: 'stdout', layout: pattern(conversionPattern: "%d [%t] %-5p %c %x - %m%n")
            }
            grails.logging.jul.usebridge = false
            // DO STUFF RELATED TO STAGING ENV
        }


        dbdiff {
            appenders {
                console name: 'stdout', layout: pattern(conversionPattern: "%d [%t] %-5p %c %x - %m%n")
            }

            // DO STUFF RELATED TO DBDIFF ENV
        }
    }
}

codenarc {
    reportName = 'target/test-reports/CodeNarcReport.xml'
    reportType = 'xml'
    propertiesFile = 'grails-app/conf/codenarc.properties'
}

grails.resources.adhoc.includes = [
        '/images/**', '/css/**', '/js/**', '/img/**', '/fonts/**'
]


// Added by the Spring Security Core plugin:
grails.plugin.springsecurity.userLookup.userDomainClassName = 'org.broadinstitute.mpg.people.User'
grails.plugin.springsecurity.userLookup.authorityJoinClassName = 'org.broadinstitute.mpg.people.UserRole'
grails.plugin.springsecurity.authority.className = 'org.broadinstitute.mpg.people.Role'


portal.type.override = "t2d"     // options are "t2d", "stroke", "mi", "ibd", "epilepsy", or "sleep".   What is the portal type for all nonsystem users?


portal.data.versionDesignator = [ new PortalVersionBean("t2d",      // label for this portal type
                                                        "T2D",  // displayable label for this portal type
                                                        "mdv35",    // the MDV number for this portal
                                                        "T2D",      // the default phenotype for this portal
                                                        "ExSeq_19k_mdv28",  // default data set.  Used rarely.
                                                        ["8_Genic_enhancer","9_Active_enhancer_1","10_Active_enhancer_2","11_Weak_enhancer"],
                                                        ["8_Genic_enhancer","9_Active_enhancer_1","10_Active_enhancer_2","11_Weak_enhancer"],
        ["Islets","Liver","SkeletalMuscle","Adipose"],  // tissues to display beneath a LocusZoom plot -- use these for the DCC
 //       ["islet of Langerhans","liver","adipocyte"],  // tissues to display beneath a LocusZoom plot -- use these for UCSD
                                                        ["GLYCEMIC", "ANTHROPOMETRIC", "RENAL", "HEPATIC", "LIPIDS", "CARDIOVASCULAR", "BLOOD PRESSURE"], // most important phenotype group name
                                                        [], // any data sets that should be omitted from LZ display
                                                        "[3]",  // the assays we should search
                                                        "ExSeq_13k_mdv23",
                                                "images/t2d_front_logo.svg",
                                                "portal.header.tagline",
                                                "portal.header.title.short",
                                                ["English", "Spanish"],
                                                ["SLC30A8"],
                                                ["rs13266634"],
                                                ["chr9:21,940,000-22,190,000"],
                                                "images/front_t2d_bg_2018.png",
                                                "pheno.help.text",
                                                "images/t2d_logo.svg",
                                                "images/menu_bg_2017_5.png",
                                                "true",
                                                "gene.genePage.warning",
                                                "",
                                                '5010306206573083521',
                                                1, // do we have parent level associations to show
                                                0, // Do we have gene level associations to show?
                                                1, // add a link to the GRS module into the headers. Note that the GRS module is available whether or not the link is in place
                                                1, // no longer used?
                                                0, // if true then entering a gene takes you to a region page around that chain
                                                1, // show the pheWAS plot
                                                1, // show the forest pheWAS plot
                                                1, // should we show the variant Association section on the variant info page
                                                0, // expose the green boxes on the variant info page
                                                0, // expose a secondary table and the credible set page built around genes, not just variants
                                                0, // clicking on a variant can take you to the variant info page, or else to a range page (as in V2F)
                                                0, // utilize bi-allelic gate, as opposed to the version that depends on multi-allelic definitions
                                                0,  // access UC San Diego data remotely? I'm not sure if this works anymore
                                                0, // LEDGE tab on the gene page
                                                0, // Hi-C tab on the gene page
                                                0  // expose dynamic UI

), // default data set used for a LocusZoom plot
                                  new PortalVersionBean("stroke",
                                                          "Stroke",
                                                          "mdv73",
                                                          "Stroke_all",
                                                          "GWAS_Stroke_mdv70",
                                                          ["8_Genic_enhancer","9_Active_enhancer_1","10_Active_enhancer_2","11_Weak_enhancer"],
                                                          ["8_Genic_enhancer","9_Active_enhancer_1","10_Active_enhancer_2","11_Weak_enhancer"],
                                                          ["InferiorTemporalLobe","AnteriorCaudate"],
                                                          ["STROKE", "ISCHEMIC STROKE", "HEMORRHAGIC STROKE", "CARDIOVASCULAR", "LIPIDS"], // most important phenotype group name
                                                          ["SIGN", "MetaStroke"], // any data sets that should be omitted from LZ display
                                                          "[3]",
                                                          "ExSeq_13k_mdv23",
                                          "images/stroke/front_stroke_logo_2018.svg",
                                          "portal.stroke.header.tagline",
                                          "portal.stroke.header.title.short",
                                          [],
                                          ["HDAC9"],
                                          ["rs2984613","APOE-e2"],
                                          ["chr7:18,100,000-18,300,000"],
                                          "images/stroke/front_stroke_bg_2018.png",
                                          "stroke.pheno.help.text",
                                          "images/stroke/stroke_header_logo.svg",
                                          "images/stroke/menu_bg_2017_stroke.png",
                                          "false",
                                          "",
                                          "",
                                          '7961982646849648720',
                                          1,
                                          0,
                                          0,
                                          1,
                                          0,
                                          1,0,1,
                                          0,
                                          0,
                                          0,
                                            0,
                                            0,0,0, // Hi-C tab on the gene page
                                          0
                                  ),
                                  new PortalVersionBean("mi",
                                                          "Myocardial Infarction",
                                                          "mdv94",
                                                          "MI",
                                                          "GWAS_CARDIoGRAM_mdv91",
                                                          ["8_Genic_enhancer","9_Active_enhancer_1","10_Active_enhancer_2","11_Weak_enhancer"],
                                                          ["8_Genic_enhancer","9_Active_enhancer_1","10_Active_enhancer_2","11_Weak_enhancer"],
                                                          ["SkeletalMuscle"],
                                                          ["CARDIOVASCULAR", "ATRIAL FIBRILLATION", "LIPIDS", "ECG TRAITS", "ANTHROPOMETRIC"], // most important phenotype group name
                                                          [],
                                                          "[3]",
                                                          "GWAS_CARDIoGRAM_mdv91",
                                          "images/mi/front_mi_logo_2018.svg",
                                          "portal.mi.header.tagline",
                                          "portal.mi.header.title.short",
                                          [],
                                          ["LPA"],
                                          ["rs10965215"],
                                          ["chr9:20,940,000-21,800,000"],
                                          "images/mi/front_mi_banner_2018.png",
                                        "",
                                          "images/mi/mi_header_logo_2017.svg",
                                          "images/mi/menu_band_2017_mi.png",
                                          "false",
                                          "",
                                          "",
                                          '3944203828206499294',
                                          1,
                                          0,
                                          0,
                                          1,
                                          0,
                                          1,0,1,
                                          0,
                                          0,
                                          0,
                                          0,
                                          0,
                                          0,0, // Hi-C tab on the gene page
                                          0
                                  ),
                                  new PortalVersionBean("ibd",
                                          //"Inflammatory Bowel Disease",
                                          "Variant to Function",
                                                          "mdv80",
                                                          "CD",// another option would be "IBD"
                                                            "GWAS_IBDGenomics_eu_mdv80",
                                                          ["UCSC annotation","ATACSeq_QTL","Enhancer-gene link"],
                                                          ["UCSC annotation","ATACSeq_QTL","Enhancer-gene link"],
                                                          ["E071","E106","E088","E085"],
                                                          ["INFLAMMATORY BOWEL"], // most important phenotype group name
                                                          [],
//                                          "[1,2,3,4,5,6,7,8,9,10,11,12,13,14]",
                                          "[1,2,4,5,6,9,10,11,12,13,14,15,16,17,18]",
                                                          "GWAS_IBDGenomics_eu_mdv80",
                                          "images/ibd/ibd_front_logo_WOnT2.png",
                                          "portal.ibd.header.tagline",
                                          "portal.ibd.header.title",
                                          [],
                                          ["IL23R"],
                                          ["6_31628397_T_A"],
                                          ["chr1:67,500,000-67,800,000"],
                                          "images/ibd/front_ibd_bg_2018.png",
                                        "",
                                         // "images/ibd/ibd_header_logo.svg",
                                          "images/ibd/v2f-little-logo.png",
                                          "images/ibd/ibd_menu_wrapper_bg.png",
                                          "false",
                                          "",
                                          "",
                                          '7857348124942584918',
                                          1,
                                          0,
                                          0,
                                          1,
                                          1,
                                          1,1,0,
                                          1,
                                          1,
                                          0,
                                          0,
                                          0,
                                          1,1, // Hi-C tab on the gene page
                                          0
                                  ),
                                  new PortalVersionBean("epilepsy",
                                          "Epilepsy",
                                          "mdv100",
                                          "GGE", // make sure your default phenotype exists in your default data set
                                          "ExSeq_Epi25k_mdv100",// used to pick a default data set for a gene query
                                          ["8_Genic_enhancer","9_Active_enhancer_1","10_Active_enhancer_2","11_Weak_enhancer"],
                                          ["8_Genic_enhancer","9_Active_enhancer_1","10_Active_enhancer_2","11_Weak_enhancer"],
                                          ["AnteriorCaudate"],
                                          ["PSYCHIATRIC"], // most important phenotype group name
                                          [],
                                          "[1,2]",
                                          "GWAS_IBDGenomics_eu_mdv80",
                                          "images/epilepsy/front_epilepsy_logo_2018.svg",
                                          "portal.epilepsy.header.tagline",
                                          "portal.epilepsy.header.title",
                                          [],
                                          ["CDKL5"],
                                          [],
                                          ["chr14:35,907,000-36,400,000"],
                                          "images/epilepsy/front_epilepsy_bg_2018.png",
                                          "",
                                          "images/epilepsy/epilepsy_header_logo.svg",
                                          "images/menu_bg_2017_5.png",
                                          "false",
                                          "",
                                          "",
                                          '5414069947481666863',
                                          0,
                                          1,
                                          0,
                                          1,
                                          0,
                                          0,0,0,
                                          0,
                                          0,
                                          0,
                                          0,
                                          0,
                                          0,0, // Hi-C tab on the gene page
                                          0
                                  ),
                                  new PortalVersionBean("sleep",
                                          "Sleep",
                                          "mdv110",
                                          "SleepChronotype", // make sure your default phenotype exists in your default data set
                                          "GWAS_UKBB_mdv110",// used to pick a default data set for a gene query
                                          ["8_Genic_enhancer","9_Active_enhancer_1","10_Active_enhancer_2","11_Weak_enhancer"],
                                          ["8_Genic_enhancer","9_Active_enhancer_1","10_Active_enhancer_2","11_Weak_enhancer"],
                                          ["AnteriorCaudate"],
                                          ["SLEEP AND CIRCADIAN", "GLYCEMIC", "ANTHROPOMETRIC"], // most important phenotype group name
                                          [],
                                          "[3]",
                                          "GWAS_UKBB_mdv110",
                                          "images/sleep/front_sleep_logo_2018.svg",
                                          "portal.sleep.header.tagline",
                                          "portal.sleep.header.title.short",
                                          [],
                                          ["PAX8"],
                                          ["rs62158211"],
                                          ["chr2:113,873,524-114,136,577"],
                                          "images/sleep/sleep_banner_2018.png",
                                          "",
                                          "images/sleep/sleep_menu_logo_2018.svg",
                                          "images/menu_bg_2017_5.png",
                                          "false",
                                          "",
                                          "",
                                          '3616035242050290841',
                                          1,
                                          0,
                                          0,
                                          1,
                                          0,
                                          1,0,1,
                                          0,
                                          0,
                                          0,
                                          0,
                                          0,0,0, // Hi-C tab on the gene page
                                          0
                                  )
]
