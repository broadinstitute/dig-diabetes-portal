import grails.util.Environment
import org.broadinstitute.mpg.diabetes.bean.ServerBean
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
 * dataExport-commons-config.groovy is used to holed generic, non envrironment-specific configurations such as external api credentials, etc.
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

//
//    default server on start up
//
//server.URL = 'http://t2dgenetics.org/mysql/rest/server/'
server.URL = 'http://69.173.71.178:8080/dev/rest/server/'

// load balancers with multiple servers behind them
/*
t2dProdLoadBalancedServer {
    base = 'http://dig-api-prod.broadinstitute.org/'
    name =  'prod/'
    path = 'gs/'
}
// EBI
t2dProdLoadBalancedServer {
    base = 'https://www.ebi.ac.uk/'
    name =  'ega/t2d/dig-genome-store/'
    path = 'gs/'
}
*/
t2dDistributedLocalhostServer {
    base = 'http://localhost:8090/'
    name =  'dccservices/'
    path = 'distributed/'
}
t2dProdLoadBalancedServer {
    base = 'http://ec2-52-207-40-241.compute-1.amazonaws.com:8085/'
    name =  'dccservices/'
    path = 'distributed/'
}
t2dQaLoadBalancedServer {
    base = 'http://dig-api-qa.broadinstitute.org/'
    name =  'qa/'
    path = 'gs/'
}
t2dQa01BehindLoadBalancer {
    base = 'http://dig-qa-01.broadinstitute.org:8888/'
    name =  'qa/'
    path = 'gs/'
}
t2dQa02BehindLoadBalancer {
    base = 'http://dig-qa-02.broadinstitute.org:8888/'
    name =  'qa/'
    path = 'gs/'
}
t2dDevLoadBalancedServer {
    base = 'http://dig-api-dev.broadinstitute.org/'
    name =  'dev/'
    path = 'gs/'
}
t2dDev01BehindLoadBalancer {
    base = 'http://dig-dev-01.broadinstitute.org:8888/'
    name =  'dev/'
    path = 'gs/'
}
t2dDev02BehindLoadBalancer {
    base = 'http://dig-dev-02.broadinstitute.org:8888/'
    name =  'dev/'
    path = 'gs/'
}
t2dProd01BehindLoadBalancer {
    base = 'http://dig-prod-01.broadinstitute.org:8888/'
    name =  'prod/'
    path = 'gs/'
}
t2dProd02BehindLoadBalancer {
    base = 'http://dig-prod-02.broadinstitute.org:8888/'
    name =  'prod/'
    path = 'gs/'
}

// individual servers
t2dAws01RestServer {
//    base = 'http://ec2-52-4-20-11.compute-1.amazonaws.com:8888/'
    base = 'http://ec2-52-90-97-40.compute-1.amazonaws.com:8888/'
    name =  'aws/'
    path = 'gs/'
}


t2dAwsStage01RestServer {
//    base = 'http://localhost:8888/'
//    name =  'dig-genome-store/'
    base = 'http://ec2-52-207-40-241.compute-1.amazonaws.com:8888/'
    name =  'aws01/'
    path = 'gs/'
}

toddServer {
    base = 'http://dig-prod.broadinstitute.org:8087/'
    name =  'todd/'
    path = 'gs/'
}

t2dLocalhostRestServer {
    base = 'http://localhost:8888/'
    name =  'dig-genome-store/'
    path = 'gs/'
}

// individual servers
// NOTE: the bottom two are most likely used for the CI build testing, so keep them at steady AWS pointer for CI testing
// DIGP-136: changed to load balanced development machine
t2dDevRestServer {
    base = 'http://dig-api-prod.broadinstitute.org/'
    name =  'prod/'
    path = 'gs/'
}
// DIGP-136: changed to load balanced production machine
t2dProdRestServer {//current 'prod'
    base = 'http://dig-api-prod.broadinstitute.org/'
    name =  'prod/'
    path = 'gs/'
}
// DIGP-136: changed to load balanced development machine
t2dNewDevRestServer { //current 'dev'
    base = 'http://dig-api-prod.broadinstitute.org/'
    name =  'prod/'
    path = 'gs/'
}

//server.URL = t2dDevRestServer.base+t2dDevRestServer.name+t2dDevRestServer.path
//server.URL = t2dAws01RestServer.base+t2dAws01RestServer.name+t2dAws01RestServer.path
//server.URL = t2dProdRestServer.base+t2dProdRestServer.name+t2dProdRestServer.path

//server.URL = 'http://localhost:8888/dig-genome-store/gs/'
// qa is probably right, the right now we need the tests to pass
//server.URL = t2dQaLoadBalancedServer.base+t2dQaLoadBalancedServer.name+t2dQaLoadBalancedServer.path
// currently operational t2d server
//server.URL = "http://ec2-52-90-97-40.compute-1.amazonaws.com:8888/aws/gs/"
//for stroke
server.URL = "http://dig-api-dev.broadinstitute.org/dev/gs/"


dbtRestServer.URL = 'http://diabetesgeneticsportal.broadinstitute.org:8888/test/burden/'
//dbtRestServer.URL = 'http://diabetesgeneticsportal2.broadinstitute.org:8888/dev/burden/'
//experimentalRestServer.URL = 'http://69.173.71.178:8888/dev2/server/'
//experimentalRestServer.URL = 'http://dig-dev.broadinstitute.org:8888/dev/gs/'
experimentalRestServer.URL = 'http://dig-qa.broadinstitute.org:8888/qa/gs/'

burdenRestServerAws01 = new ServerBean("AWS01 burden server", "http://dig-dev.broadinstitute.org:8090/prod/burden");
burdenRestServerAws02 = new ServerBean("AWS02 burden server", "http://ec2-52-207-40-241.compute-1.amazonaws.com:8888/aws01/gs/burden");
burdenRestServerDev = new ServerBean("dev burden server", "http://dig-dev.broadinstitute.org:8888/dev/burden");
burdenRestServerQa = new ServerBean("qa burden server", "http://dig-api-qa.broadinstitute.org/qa/gs/burden");
burdenRestServerStaging = new ServerBean("staging burden server", "http://dig-api-prod.broadinstitute.org/prod/gs/burden");
burdenRestServerLocalhost = new ServerBean("localhost (DEV USE ONLY)", "http://localhost:8888/dig-genome-store/gs/burden");
burdenRestServerProd = new ServerBean("DIRECT prod burden server", "http://dig-dev.broadinstitute.org:8090/prod/burden");

println("\n\n%%%%%%%%%  Your initial backend REST server will be ${server.URL} %%%%%%%%%%%%%%%%\n\n")




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
//      grails.serverURL = "http://type2diabetesgenetics.elasticbeanstalk.com"
//      grails.serverURL = "http://type2diabetesgenetics.elasticbeanstalk.com"
//      grails.serverURL = "http://www.type2diabetesgenetics.org"
//      grails.serverURL = "http://ec2-54-175-211-21.compute-1.amazonaws.com/"              // temp for now, will house new prdsrv1 URL
      grails.serverURL = "http://type2diabetes-dev.elasticbeanstalk.com"
//      grails.serverURL = "http://sigmat2dqasrv-env.elasticbeanstalk.com"
//        grails.serverURL = "http://sigmat2dqasrv2.elasticbeanstalk.com"
//        grails.serverURL = "http://sigmat2ddev.elasticbeanstalk.com"
//        grails.serverURL = "http://sigmat2ddevsrv2.elasticbeanstalk.com"
//      grails.serverURL = "http://type2diabgen-prodsrv1.elasticbeanstalk.com"
//      grails.serverURL = "http://ci-env.elasticbeanstalk.com"
//      grails.serverURL = "http://type2diabetesgen-qasrvr.elasticbeanstalk.com"
//      grails.serverURL = "http://default-environment-igfrae3vpi.elasticbeanstalk.com"             // stroke portal dev for now
//        grails.serverURL = "http://intel-rp-env.us-east-1.elasticbeanstalk.com"             // intel portal dev for now
//        grails.serverURL = "http://distrib-dcc-portal-env.us-east-1.elasticbeanstalk.com"             // distributed portal dev for now
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
        '/metadatainfo/**':       ['ROLE_USER']
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

// placeholder for data version
diabetes.data.version = "mdv23";
portal.data.version.map = ["t2d": "mdv23", "stroke": "mdv70", "mi" : "mdv90", "EBI": "mdv25"];
portal.data.default.phenotype.map = ["t2d": "T2D", "stroke": "Stroke_all", "mi" : "CAD", "EBI":"FG"];
portal.data.default.dataset.abbreviation.map = ["t2d": "ExSeq_17k_", "stroke": "GWAS_Stroke_", "mi" : "GWAS_CARDIoGRAM_", "EBI":"FG"]
portal.type.override = "t2d"     // options are "t2d" or "stroke" or "mi"



distributed.kb.override = "Broad"     // options are "Broad" or "EBI"


