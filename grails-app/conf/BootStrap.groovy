import dport.Gene
import dport.Phenotype
import dport.ProteinEffect
import dport.RestServerService
import dport.people.Role
import dport.people.User
import dport.people.UserRole

class BootStrap {
    def grailsApplication
    RestServerService restServerService
    def springSecurityService

    def init = { servletContext ->

        //
        // first handles users
        //
        def samples  = [:]  // put users here as a temporary holding location

        // read in users from file
        if (User.count()) {
            println "Users already loaded. Total operational number = ${User.count()}"
        } else {
            String fileLocation = grailsApplication.mainContext.getResource("/WEB-INF/resources/users.tsv").file.toString()
            println "Actively loading users from file = ${fileLocation}"
            File file = new File(fileLocation)
            int counter = 1
            boolean headerLine = true
            file.eachLine {
                if (headerLine) {
                    headerLine = false
                } else {
                    List<String> fields = it.split('\t')
                    if (fields.size() != 5)  {
                        println "Flawed user file.  number fields = ${fields.size()}. Aborting..."
                        assert false
                    }
                    LinkedHashMap attributes = [:]
                    String username =  fields[0];
                    attributes['password'] = "123"
                    attributes['fullName'] = fields[1]
                    attributes['nickname'] = fields[2]
                    attributes['email'] = fields[0]
                    samples[username] = attributes
                 }
            }
            samples['ben'] = [fullName:'Ben Alexander',
                              password:'ben',
                              nickname:'ben',
                              email: "benjamin.alexander96@yahoo.com"]
            samples['mary'] = [fullName:'Mary Carmichael',
                              password:'Mary',
                              nickname:'Mary',
                              email: "balexand@broadinstitute.org"]
            samples['fred'] = [fullName:'Fred friendly',
                              password:'Fred',
                              nickname:'Fred',
                              email: "balexand@broadinstitute.org"]
        }

        def userRole = Role.findByAuthority('ROLE_USER')  ?: new Role (authority: "ROLE_USER").save()
        def adminRole = Role.findByAuthority('ROLE_ADMIN')  ?: new Role (authority: "ROLE_ADMIN").save()
        def systemRole = Role.findByAuthority('ROLE_SYSTEM')  ?: new Role (authority: "ROLE_SYSTEM").save()

        // now we actually fill up the user domain object
        def users = User.list () ?: []
        if (!users){
            samples.each {username, attributes->
                def user  = new User (
                        username: username,
                        password: attributes.password,
                        fullName: attributes.fullName,
                        nickname: attributes.nickname,
                        email: attributes.email,
                        hasLoggedIn: false,
                        enabled: true)
                if (user.validate ()) {
                    println "Creating user ${username}"
                    user.save(flush: true)
                    UserRole.create user,userRole
                    if ((username=='ben')||
                            (username=='balexand@broadinstitute.org')||
                            (username=='tgreen@broadinstitute.com')||
                            (username=='kyuksel@broadinstitute.org')||
                            (username=='tjordan@broadinstitute.org')||
                            (username=='flannick@broadinstitute.org')){
                        UserRole.create user,adminRole
                        UserRole.create user,systemRole
                    }
                    if ((username=='mary')||
                        (username=='maryc@broadinstitute.org')){
                        UserRole.create user,adminRole
                    }
                }  else {
                    println "problem in bootstrap for username ${username}"
                }

            }
        }
        println "# of users = ${User.list().size()}"

        // for the time being fill up our gene table locally. In the long run
        // we need to be pulling this information from the backend, of course
        if (Gene.count()) {
            println "Genes already loaded. Total operational number = ${Gene.count()}"
        } else {
            String fileLocation = grailsApplication.mainContext.getResource("/WEB-INF/resources/genes.tsv").file.toString()
            println "Actively loading genes from file = ${fileLocation}"
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
            println "Genes successfully loaded: ${counter}"
        }

        if (Phenotype.count()) {
            println "Phenotypes already loaded. Total operational number = ${Phenotype.count()}"
        } else {
            String fileLocation = grailsApplication.mainContext.getResource("/WEB-INF/resources/gwas_phenotypes.yaml").file.toString()
            println "Actively loading phenotypes from file = ${fileLocation}"
            File file = new File(fileLocation)
            int counter = 1
            int fieldCount = 0
            boolean headerLine = true
            String key = ''
            String name = ''
            String databaseKey = ''
            String dataSet = ''
            String category = ''
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
                                case  "db_key" : databaseKey = rawValue;
                                    break;
                                case  "dataset" : dataSet = rawValue;
                                    break;
                                case  "category" : category = rawValue;
                                    new Phenotype (
                                            key:key,
                                            name:name,
                                            databaseKey:databaseKey,
                                            dataSet :dataSet,
                                            category:category ).save(failOnError: true)
                                    break;
                            }

                        }
                    }
                }
                counter++
            }
            println "Phenotypes successfully loaded: ${counter}"
        }


        if (ProteinEffect.count()) {
            println "ProteinEffect already loaded. Total operational number = ${ProteinEffect.count()}"
        } else {
            String fileLocation = grailsApplication.mainContext.getResource("/WEB-INF/resources/so_consequences.yaml").file.toString()
            println "Actively loading ProteinEffect from file = ${fileLocation}"
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
            println "ProteinEffect successfully loaded: ${counter}"
        }


        // any services that need to be initialized should be referenced here
        restServerService.initialize()

    }
    def destroy = {
    }
}
