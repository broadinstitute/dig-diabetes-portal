package dport

import dport.people.Role
import dport.people.User
import dport.people.UserRole
import grails.transaction.Transactional


@Transactional
class SharedToolsService {

     def mailService
     def grailsApplication



    static public LinkedHashMap<String,Boolean> sectionsToDisplay = [show_gene:1,
                                                                     show_gwas:1,
                                                                     show_exchp: 1,
                                                                     show_exseq: 1,
                                                                     show_sigma: 0]


    /***
     *  urlEncodedListOfPhenotypes delivers the information in the Phenotype domain object
     *  for convenient delivery to the browser
     * @return
     */
    public String urlEncodedListOfPhenotypes() {
        List<Phenotype> phenotypeList=Phenotype.list()
        StringBuilder sb   = new StringBuilder ("")
        int numberOfPhenotypes  =  phenotypeList.size()
        int iterationCount  = 0
        for (Phenotype phenotype in phenotypeList){
            sb<< (phenotype.databaseKey + ":" + phenotype.name )
            iterationCount++
            if (iterationCount  < numberOfPhenotypes){
                sb<< ","
            }
        }
        return java.net.URLEncoder.encode( sb.toString())
    }



    public String  parseChromosome (String rawChromosomeString) {
        String returnValue = ""
        java.util.regex.Matcher chromosome = rawChromosomeString =~ /chr[\dXY]*/
        if (chromosome.size() == 0) {  // let's try to help if the user forgot to specify the chr
            chromosome = rawChromosomeString =~ /[\dXY]*/
        }
        if (chromosome.size() > 0) {
            java.util.regex.Matcher chromosomeString = chromosome[0] =~ /[\dXY]+/
            if (chromosomeString.size() > 0) {
                returnValue = chromosomeString[0]
            }
        }
        return returnValue;
    }


    public String  parseExtent (String rawExtentString) {
        String returnValue = ""
        java.util.regex.Matcher startExtentString = rawExtentString =~ /\d+/
        if (startExtentString.size()>0)  {
           returnValue =  startExtentString[0]
        }
        return returnValue;
    }






    /***
     * urlEncodedListOfProteinEffect delivers the information in of the ProteinEffect domain object
     * For convenient delivery to the browser
     * @return
     */
    public String urlEncodedListOfProteinEffect() {
        List<ProteinEffect> proteinEffectList=ProteinEffect.list()
        StringBuilder sb   = new StringBuilder ("")
        int numberOfProteinEffects  =  proteinEffectList.size()
        int iterationCount  = 0
        for (ProteinEffect proteinEffect in proteinEffectList){
            sb<< (proteinEffect.key + ":" + proteinEffect.name )
            iterationCount++
            if (iterationCount  < numberOfProteinEffects){
                sb<< "~"
            }
        }
        return java.net.URLEncoder.encode( sb.toString())
    }



    /***
     * urlEncodedListOfProteinEffect delivers the information in of the ProteinEffect domain object
     * For convenient delivery to the browser
     * @return
     */
    public String urlEncodedListOfUsers() {
        List<User> userList=User.list()
        StringBuilder sb   = new StringBuilder ("")
        int numberOfUsers  =  userList.size()
        int iterationCount  = 0
        for (User user in userList){
            sb<< (user.username + ":" + (user.getPasswordExpired()?'T':'F') + ":" + (user.getAccountExpired()?'T':'F')+ ":" + user.getId())
            iterationCount++
            if (iterationCount  < numberOfUsers){
                sb<< "~"
            }
        }
        return java.net.URLEncoder.encode( sb.toString())
    }

    /***
     * Given a user, translate their privileges into a flag integer
     *
     * @param userInstance
     * @return
     */
    public int extractPrivilegeFlags (User userInstance)  {
        int flag = 0
        List<UserRole> userRoleList = UserRole.findAllByUser(userInstance)
        for (UserRole oneUserRole in userRoleList) {
            if (oneUserRole.role == Role.findByAuthority("ROLE_USER")) {
                flag += 1
            }  else  if (oneUserRole.role == Role.findByAuthority("ROLE_ADMIN")) {
                flag += 2
            }  else  if (oneUserRole.role == Role.findByAuthority("ROLE_SYSTEM")) {
                flag += 4
            }
        }
        return flag
    }




    private void adjustPrivileges (User userInstance, int targetFlag,int currentFlag, int bitToConsider, String targetRole )  {
        if ((targetFlag&bitToConsider) > 0 ) {
            // we want them to have it

            if ((currentFlag&bitToConsider) == 0) {
                // we want them to have it and they don't. Give it to them
                Role role =  Role.findByAuthority(targetRole)
                UserRole.create userInstance,role
            }  // else we want them to have it and they do already == no-op

        }   else {
            // we don't want them to have it

            if ((currentFlag&bitToConsider) > 0) {
                // we don't want them to have it but they do. Take it away
                Role role =  Role.findByAuthority(targetRole)
                UserRole userRole = UserRole.findByUserAndRole(userInstance,role)
                        //               UserRole userRole =  UserRole.get(userInstance.id,role.id)
                userRole.delete()
            }  // else we don't want them to have it and they don't already == no-op

        }

    }



    /***
     * Give the user the privileges we want them to have – no more, no less
     * @param userInstance
     * @param flag
     * @return
     */
    public int storePrivilegesFromFlags (User userInstance,int targetFlag)  {
        // what privileges do they have already
        int currentFlag = extractPrivilegeFlags ( userInstance)

        // Now go through the flags we want them to have one by one and adjust accordingly
        adjustPrivileges ( userInstance,  targetFlag, currentFlag, 0x1, "ROLE_USER" )
        adjustPrivileges ( userInstance,  targetFlag, currentFlag, 0x2, "ROLE_ADMIN" )
        adjustPrivileges ( userInstance,  targetFlag, currentFlag, 0x4, "ROLE_SYSTEM" )

        return targetFlag
    }

    public int convertCheckboxesToPrivFlag(params){
        int flag = 0
        if (params["userPrivs"]=="on"){
            flag += 1
        }
        if (params["mgrPrivs"]=="on"){
            flag += 2
        }
        if (params["systemPrivs"]=="on"){
            flag += 4
        }
        return flag
    }

    /***
     * packageUpFiltersForRoundTrip get back a list of filters that we need to pass to the backend. We package them up for a round trip to the client
     * and back via the Ajax call
     *
     * @param listOfAllFilters
     * @return
     */
    public String packageUpFiltersForRoundTrip (List <String> listOfAllFilters)  {

        StringBuilder sb = new  StringBuilder()
        if (listOfAllFilters) {
            for ( int i=0 ; i<listOfAllFilters.size() ; i++ ) {
                sb <<  listOfAllFilters[i]
                if ((i+1)<listOfAllFilters.size()) {
                    sb << ","
                }
            }
        }
        return java.net.URLEncoder.encode(sb.toString())

    }

    /***
     *  we need to  encode the list of parameters so that we can reset them when we reenter  the filter setting form.  It
     *  is certainly true that this is a different form of the same information that is held in BOTH the filter list and the
     *  filterDescription  list.  This one could be passed from a different page, however, so we really want a simple, unambiguous
     *  way to store it and pass it around
     *
     *  Note that these values will be interpreted by the client (browser) and they are guaranteed to have no funny characters.  Therefore
     *  we don't need to URL encode them
     *
     * @param listOfAllEncodedParameters
     * @return
     */
    public String packageUpEncodedParameters (List <String> listOfAllEncodedParameters ) {
        StringBuilder sbEncoded = new  StringBuilder()
        for ( int i=0 ; i<listOfAllEncodedParameters.size() ; i++ ) {
            sbEncoded <<  listOfAllEncodedParameters[i]
            if ((i+1)<listOfAllEncodedParameters.size()) {
                sbEncoded << ","
            }
        }

        return sbEncoded.toString()
    }


    public String encodeUser (String putativeUsername)  {
        int key=47
        String coded = ""
        for ( int i = 0; i < putativeUsername.length(); ++i )
        {

            char c = putativeUsername.charAt( i );
            int j = (int) c + key;
            coded+=(j+"-")


        }
        return  coded
    }



    public String unencodeUser (String encodedUsername)  {
        String returnValue = ""
        String[] elements = encodedUsername.split("-")
        for  ( int i = 0; i < elements.size(); ++i ){
            String encChar = elements[i]
            if (encChar.length()>0)    {
                int codedVal = encChar.toInteger()
                int decoded=codedVal-47
                String aChar = new Character((char) decoded).toString();
                returnValue +=  aChar
            }
        }
        return returnValue

    }



    public String sendTestEmail(){
        mailService.sendMail {
            from "t2dPortal@gmail.com"
            to "balexand@broadinstitute.org"
            subject "Hello"
            body "Test"
        }

    }




    public String sendForgottenPasswordEmail(String userEmailAddress){
        String serverUrl = "http://localhost:8080/dport"
        if (grailsApplication.config.grails.serverURL.size()!=0){
            serverUrl =   grailsApplication.config.grails.serverURL
        }
        String bodyOfMessage = "Dear diabetes portal user;\n In order to access the updated version of the diabetes portal it will be necessary for you to reset your password."+
        "Please copy the following string into the URL of your browser:\n" +
                serverUrl+"/admin/resetPasswordInteractive/"+  encodeUser(userEmailAddress) +"\n"+
                "\n"+
                "If you did not request a password reset then you can safely ignore this e-mail"
        mailService.sendMail {
            from "t2dPortal@gmail.com"
            to userEmailAddress
            subject "Password reset necessary"
            body bodyOfMessage
        }

    }





}
