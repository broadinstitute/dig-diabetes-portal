


eventCreateWarStart = { warName, stagingDir ->

    def unknownValue = 'UNKNOWN'
    def buildNumberEnvironment = 'BUILD_NUMBER'
    def scmRevisionEnvironment = 'GIT_COMMIT'
    def buildNumberProperty = 'build.number'
    def scmRevisionProperty = 'build.revision'
    def buildNumber = System.getenv(buildNumberEnvironment)
    if( !buildNumber ) {
        buildNumber = System.getProperty(buildNumberProperty, unknownValue)
    }
    def scmRevision = System.getenv(scmRevisionEnvironment)
    if( !scmRevision ) {
        scmRevision = System.getProperty(scmRevisionProperty, unknownValue)
    }
    ant.propertyfile(file:"${stagingDir}/WEB-INF/classes/application.properties") {
        entry(key:'app.version.buildNumber', value: buildNumber)
    }
    ant.manifest(file: "${stagingDir}/META-INF/MANIFEST.MF", mode: "update") {
        attribute(name: "Build-Time", value: new Date())
        section(name: "Grails Application") {
            attribute(name: "Implementation-Build-Number", value: buildNumber)
            attribute(name: "Implementation-SCM-Revision", value: scmRevision)
        }
    }
}




eventCompileStart = { org.codehaus.gant.GantBinding gantBinding ->
    Date date = new Date()
    println "compiling on ${date.toString()}"

    // try a trick from http://wordpress.transentia.com.au/wordpress/2010/05/09/capturing-build-info-in-grails/
    // http://www.ehatchersolutions.com/JavaDevWithAnt/ant.html
    ant.property(environment: "env")
    ant.property(name: 'env.COMPUTERNAME', value: "${ant.antProject.properties.'env.HOSTNAME'}")

    def now = new Date().format('dd/MMM/yyyy; kk:mm:ss')
    ant.echo(message: 'Writing temporary.BuildInfo.groovy...')
    ant.echo(message: "buildTime: ${now}")
    ant.echo(message: "buildHost: ${ant.antProject.properties.'env.COMPUTERNAME'}")
    ant.echo(message: "buildWho: ${ant.antProject.properties."user.name"}")
    ant.mkdir(dir: 'src/groovy/temporary')
    new File('src/groovy/temporary/BuildInfo.groovy').withWriter { writer ->
        writer << """
package temporary

public interface BuildInfo {
  String buildTime = '${now}'
  String buildHost = '${ant.antProject.properties.'env.COMPUTERNAME'}'
  String buildWho = '${ant.antProject.properties."user.name"}'
}
"""
    }
}
//
//
//eventCompileStart = { warName, stagingDir ->
//
//    def unknownValue = 'UNKNOWN'
//    def buildNumberEnvironment = 'BUILD_NUMBER'
//    def scmRevisionEnvironment = 'GIT_COMMIT'
//    def buildNumberProperty = 'build.number'
//    def scmRevisionProperty = 'build.revision'
//    def buildNumber = System.getenv(buildNumberEnvironment)
//    if( !buildNumber ) {
//        buildNumber = System.getProperty(buildNumberProperty, unknownValue)
//    }
//    def scmRevision = System.getenv(scmRevisionEnvironment)
//    if( !scmRevision ) {
//        scmRevision = System.getProperty(scmRevisionProperty, unknownValue)
//    }
//
////
//
//}