import org.broadinstitute.mpg.Gene
import org.broadinstitute.mpg.ProteinEffect
import org.broadinstitute.mpg.RestServerService
import org.broadinstitute.mpg.SharedToolsService
import org.broadinstitute.mpg.people.Role
import org.broadinstitute.mpg.people.User
import org.broadinstitute.mpg.people.UserRole
import org.apache.juli.logging.LogFactory
import org.grails.plugins.localization.Localization

class BootStrap {
    private static final log = LogFactory.getLog(this)
    def grailsApplication
    RestServerService restServerService
    SharedToolsService sharedToolsService
    def springSecurityService

    def init = { servletContext ->

        log.info( "BBBBBBB Starting bootstrap BBBBBBBBBBB")

        //
        // first handles users
        //
        def samples  = [:]  // put users here as a temporary holding location

        //********************** TODO: find a better way!!!
//        log.info( "Crazy plan.  Delete all users. Current number= ${User.count()}")
//        User.executeUpdate("delete User")
//        log.info( "Done.  number of users= ${User.count()}")

        // read in users from file
        if (User.count()) {
            log.info( "Users already loaded. Total operational number = ${User.count()}")
        } else {
            String fileLocation = grailsApplication.mainContext.getResource("/WEB-INF/resources/users.tsv").file.toString()
            log.info( "Actively loading users from file = ${fileLocation}")
            File file = new File(fileLocation)
            int counter = 1
            boolean headerLine = true
            file.eachLine {
                if (headerLine) {
                    headerLine = false
                } else {
                    List<String> fields = it.split('\t')
                    if (fields.size() != 5)  {
                        log.error("*****Flawed user file.  number fields = ${fields.size()}. Aboring on line ${counter}****")
                        log.error("*****${it}****")
                        if (fields.size()> 3)  {
                            log.error(">>>Problematic line  field #1 with ${fields[0]}")
                        }
                        if (fields.size()> 2)  {
                            log.error(">>>Problematic line  field #2 with ${fields[1]}")
                        }
                        if (fields.size()> 3)  {
                            log.error(">>>Problematic line  field #3 with ${fields[2]}")
                        }
                        if (fields.size()==0) {
                            log.error("Line appeared to be empty.")
                        }

                        assert false
                    }
                    LinkedHashMap attributes = [:]
                    String username =  fields[0];
                    attributes['password'] = "bloodglucose"
                    attributes['fullName'] = fields[1]
                    attributes['nickname'] = fields[2]
                    attributes['email'] = fields[0]
                    samples[username] = attributes
                 }
                counter++
            }
            samples['ben'] = [fullName:'Ben Alexander',
                              password:'ben',
                              nickname:'ben',
                              email: "benjamin.alexander96@yahoo.com"]
        }

        def userRole = Role.findByAuthority('ROLE_USER')  ?: new Role (authority: "ROLE_USER").save()
        def adminRole = Role.findByAuthority('ROLE_ADMIN')  ?: new Role (authority: "ROLE_ADMIN").save()
        def systemRole = Role.findByAuthority('ROLE_SYSTEM')  ?: new Role (authority: "ROLE_SYSTEM").save()

        // now we actually fill up the user domain object
        def users = User.list () ?: []
        if (!users){
            samples.each {username, attributes->
                    def user = new User(
                            username: username,
                            password: attributes.password,
                            fullName: attributes.fullName,
                            nickname: attributes.nickname,
                            email: attributes.email,
                            hasLoggedIn: false,
                            enabled: true)
                    if (user.validate()) {
                        log.info("Creating user ${username}")
                        user.save(flush: true)
                        UserRole.create user, userRole
                        if ((username == 'ben') ||
                                (username == 'balexand@broadinstitute.org') ||
                                (username == 'kyuksel@broadinstitute.org') ||
                                (username == 'flannick@broadinstitute.org') ||
                                (username == 'andrew@broadinstitute.org') ||
                                (username == 'mduby@broadinstitute.org') ||
                                (username == 'mvon@broadinstitute.org') ||
                                (username == 'tgreen@broadinstitute.org') ||
                                (username == 'mvg@broadinstitute.org') ||
                                (username == 'ryank@broadinstitute.org') ||
                                (username == 'msanders@broadinstitute.org') ) {
                            UserRole.create user, adminRole
                            UserRole.create user, systemRole
                        }
                        if ((username == 'dsiedzik@broadinstitute.org') ||
                            (username == 'maryc@broadinstitute.org')) {
                            UserRole.create user, adminRole
                        }
                    } else {
                        log.error("problem in bootstrap for username ${username}")
                    }
            }
        }
        log.error( "# of users = ${User.list().size()}")

        // for the time being fill up our gene table locally. In the long run
        // we need to be pulling this information from the backend, of course
        if (Gene.count()) {
            log.info( "Genes already loaded. Total operational number = ${Gene.count()}" )
        } else {
            String fileLocation = grailsApplication.mainContext.getResource("/WEB-INF/resources/genes.tsv").file.toString()
            log.info( "Actively loading genes from file = ${fileLocation}")
            File file = new File(fileLocation)
            int counter = 1
            boolean headerLine = true
            file.eachLine {
                if (headerLine){
                    headerLine = false
                }  else {
                    String rawLine = it
                    String[] columnData =  rawLine.split(",")
                    Long addrStart = Long.parseLong(columnData[3],10)
                    Long addrEnd = Long.parseLong(columnData[4],10)
                    new Gene (
                            name1:columnData[0],
                            name2:columnData[1],
                            chromosome:columnData[2],
                            addrStart :addrStart,
                            addrEnd:addrEnd ).save(failOnError: true)
                }
                counter++
            }
            log.info( "Genes successfully loaded: ${counter}" )
        }


        if (ProteinEffect.count()) {
            log.info( "ProteinEffect already loaded. Total operational number = ${ProteinEffect.count()}" )
        } else {
            String fileLocation = grailsApplication.mainContext.getResource("/WEB-INF/resources/so_consequences.yaml").file.toString()
            log.info( "Actively loading ProteinEffect from file = ${fileLocation}" )
            File file = new File(fileLocation)
            int counter = 1
            int fieldCount = 0
            boolean headerLine = true
            String key = ''
            String name = ''
            String description = ''
            file.eachLine {
                if (headerLine){
                    headerLine = false
                }  else {
                    String rawLine = it
                    if (rawLine.startsWith("-")) {
                        fieldCount = 0
                    }  else {
                        fieldCount++
                        String[] columnData =  rawLine.split(":")
                        if (columnData.length > 1)
                        {
                            String rawKey = columnData[0].trim()
                            String rawValue = columnData[1].trim()
                            switch (rawKey) {
                                case  "key" : key = rawValue;
                                    break;
                                case  "name" : name = rawValue;
                                    break;
                                case  "description" : description = rawValue;
                                    new ProteinEffect (
                                            key:key,
                                            name:name,
                                            description:description ).save(failOnError: true)
                                    break;
                            }

                        }
                    }
                }
                counter++
            }
            log.info( "ProteinEffect successfully loaded: ${counter}" )
        }

        // reload the localizations database, so that any updates to the properties files
        // get picked up (the default behavior of the plugin is to assume the database is
        // more current, and thus ignore any changes in the properties files
        Localization.reload();

        // any services that need to be initialized should be referenced here
        restServerService.initialize()
        sharedToolsService.initialize()

    }
    def destroy = {
    }
}
