eventCompileStart = { org.codehaus.gant.GantBinding gantBinding ->
    Date date = new Date()
    println "compiling on ${date.toString()}"
    String unknownValue = 'UNKNOWN'
    String buildNumberProperty = 'build.number'
    String appVersionProperty = 'app.version'
    String buildNumber = System.getenv(buildNumberProperty)
    if( !buildNumber ) {
        buildNumber = System.getProperty(buildNumberProperty, unknownValue)
    }
    def appVersion = System.getenv(appVersionProperty)
    if( !appVersion ) {
        appVersion = System.getProperty(appVersionProperty, unknownValue)
    }
    ant.property(environment: "env")
    ant.property(name: 'env.COMPUTERNAME', value: "${ant.antProject.properties.'env.HOSTNAME'}")
    String userHome ="${ant.antProject.properties.'user.home'}".replaceAll('\\\\','/')
    String userDirectory ="${ant.antProject.properties.'user.dir'}".replaceAll('\\\\','/')
    String homePath ="${ant.antProject.properties.'environment.HOMEPATH'}".replaceAll('\\\\','/')
    String grailsHome ="${ant.antProject.properties.'env.GRAILS_HOME'}".replaceAll('\\\\','/')
    String javaHome ="${ant.antProject.properties.'user.dir'}".replaceAll('\\\\','/')
    String homeDrive ="${ant.antProject.properties.'env.HOMEDRIVE'}".replaceAll('\\\\','/')
    String environmentPath ="${ant.antProject.properties.'env.Path'}".replaceAll('\\\\','/')

    def now = new Date().format('dd/MMM/yyyy; kk:mm:ss')

    println "Compilation notes:"
    println """buildNumber = '${buildNumber}'
     appVersion =  '${appVersion}'
     buildTime = '${now}'
     buildHost = '${ant.antProject.properties.'env.USERDOMAIN'}'
     buildWho = '${ant.antProject.properties."user.name"}'
     userHome = '${userHome}'
     userDirectory ='${userDirectory}'
     osArch ='${ant.antProject.properties.'os.arch'}'
     homePath ='${homePath}'
     grailsHome ='${grailsHome}'
     javaHome='${javaHome}'
     homeDrive='${homeDrive}'
     computerName ='${ant.antProject.properties.'env.COMPUTERNAME'}'
     processorIdentifier ='${ant.antProject.properties.'environment.PROCESSOR_IDENTIFIER'}'
     environmentPath ='${environmentPath}'
     operatingSystem ='${ant.antProject.properties.'environment.OS'}'
     operatingSystemVersion ='${ant.antProject.properties.'os.version'}'
     antVersion='${ant.antProject.properties.'ant.version'}'""".toString()


    ant.mkdir(dir: 'src/groovy/temporary')
    new File('src/groovy/temporary/BuildInfo.groovy').withWriter { writer ->
        writer << """
package temporary

public interface BuildInfo {
  String buildNumber = '${buildNumber}'
  String appVersion =  '${appVersion}'
  String buildTime = '${now}'
  String buildHost = '${ant.antProject.properties.'env.USERDOMAIN'}'
  String buildWho = '${ant.antProject.properties."user.name"}'
  String userHome = '${userHome}'
  String userDirectory ='${userDirectory}'
  String osArch ='${ant.antProject.properties.'os.arch'}'
  String homePath ='${homePath}'
  String grailsHome ='${grailsHome}'
  String javaHome='${javaHome}'
  String homeDrive='${homeDrive}'
  String computerName ='${ant.antProject.properties.'env.COMPUTERNAME'}'
  String processorIdentifier ='${ant.antProject.properties.'environment.PROCESSOR_IDENTIFIER'}'
  String environmentPath ='${environmentPath}'
  String operatingSystem ='${ant.antProject.properties.'environment.OS'}'
  String operatingSystemVersion ='${ant.antProject.properties.'os.version'}'
  String antVersion='${ant.antProject.properties.'ant.version'}'
}
"""
    }
}