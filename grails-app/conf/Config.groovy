import org.apache.log4j.DailyRollingFileAppender
import org.apache.log4j.PatternLayout

// locations to search for config files that get merged into the main config;
// config files can be ConfigSlurper scripts, Java properties files, or classes
// in the classpath in ConfigSlurper format

def appName = "${appName}"
def catalinaBase = System.properties.getProperty('catalina.base')
if (!catalinaBase) catalinaBase = '.'   // just in case
def logDirectory = "${catalinaBase}/logs"

grails.plugin.databasemigration.updateOnStart = true

// grails.config.locations = [ "classpath:${appName}-config.properties",
//                             "classpath:${appName}-config.groovy",
//                             "file:${userHome}/.grails/${appName}-config.properties",
//                             "file:${userHome}/.grails/${appName}-config.groovy"]

// if (System.properties["${appName}.config.location"]) {
//    grails.config.locations << "file:" + System.properties["${appName}.config.location"]
// }

site.version = 't2dgenes' // could be 'sigma' or 't2dgenes'
site.title = 'Type 2 Diabetes Genetics'  // could be 'SIGMA T2D' or 'Type 2 Diabetes Genetics'
//server.URL = 'http://t2dgenetics.org/mysql/rest/server/'
server.URL = 'http://t2dgenetics.org/dev/rest/server/'
t2dRestServer {
    base = 'http://t2dgenetics.org/'
    mysql =  'mysql/'
    bigquery =  'dev/'
    path = 'rest/server/'
}


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


oauth {

    providers {

        google {
            api = org.scribe.builder.api.GoogleApi20
            key = '975413760331-d2nr5vq7sbbppjfog0cp9j4agesbeovt.apps.googleusercontent.com'
            secret = 'HKIxi3AOLAgyFV6lDJQCfEgY'
            successUri = '/oauth/google/success'
            failureUri = '/oauth/google/error'
            callback = "${baseURL}/oauth/google/callback"
            scope = 'https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email'
        }

    }
}
            grails.converters.encoding = "UTF-8"
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
        grails.logging.jul.usebridge = true
    }
    production {
        grails.logging.jul.usebridge = false
     //   grails.serverURL = "http://Default-Environment-igfrae3vpi.elasticbeanstalk.com"
     //   grails.serverURL = "http://type2diabetesgenetics.elasticbeanstalk.com"
     //   grails.serverURL = "http://type2diabetesgenetics.org"

        grails.serverURL = "http://type2diabetes-dev.elasticbeanstalk.com"


    }
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
        '/home':                    ['permitAll'],
        '/home/index':              ['ROLE_USER'],
        '/home/portalHome':         ['ROLE_USER'],
        '/system/**':               ['ROLE_SYSTEM'],
        '/admin/resetPassword':     ['permitAll'],
        '/admin/resetPasswordInteractive/**':     ['permitAll'],
        '/admin/updatePasswordInteractive/**':     ['permitAll'],
        '/admin/updatePassword/**': ['permitAll'],
        '/admin/**':            ['ROLE_ADMIN'],
        '/user/**':            ['ROLE_ADMIN'],
        '/gene/**':             ['ROLE_USER'],
        '/informational/**':    ['ROLE_USER'],
        '/region/**':           ['ROLE_USER'],
        '/trait/**':            ['ROLE_USER'],
        '/variant/**':          ['ROLE_USER'],
        '/variantSearch/**':    ['IS_AUTHENTICATED_ANONYMOUSLY'],
        '/assets/**':         ['permitAll'],
        '/**/js/**':          ['permitAll'],
        '/**/css/**':         ['permitAll'],
        '/**/images/**':      ['permitAll'],
        '/**/favicon.ico':    ['permitAll'],
        '/login/**':          ['permitAll'],
        '/logout/**':         ['permitAll'],
        '/finance/**':        ['ROLE_FINANCE', 'isFullyAuthenticated()'],
]
grails.plugin.auth.loginFormUrl='/Security/auth2'
grails.plugin.springsecurity.logout.postOnly = false
grails.plugin.springsecurity.rememberMe.cookieName="td2PortalRememberMe"
grails.plugin.springsecurity.rememberMe.key="td2PortalKey"
grails.plugin.springsecurity.rememberMe.persistent=true
grails.plugin.logout.postOnly=false
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
    info 'grails.app.services'
    root.level = org.apache.log4j.Level.INFO

    environments {
        development {
            appenders {
                console name: 'stdout', layout: pattern(conversionPattern: "%d [%t] %-5p %c %x - %m%n")
            }
//            grails.logging.jul.usebridge = true
//            grails.plugin.springsecurity.debug.useFilter = true

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

// Added by the Spring Security Core plugin:
grails.plugin.springsecurity.userLookup.userDomainClassName = 'dport.people.User'
grails.plugin.springsecurity.userLookup.authorityJoinClassName = 'dport.people.UserRole'
grails.plugin.springsecurity.authority.className = 'dport.people.Role'


