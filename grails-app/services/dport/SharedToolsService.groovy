package dport

import dport.people.Role
import dport.people.User
import dport.people.UserRole
import dport.people.UserSession
import grails.plugin.mail.MailService
import grails.transaction.Transactional
import org.apache.juli.logging.LogFactory
import org.codehaus.groovy.grails.commons.GrailsApplication
import org.codehaus.groovy.grails.web.mapping.LinkGenerator


@Transactional
class SharedToolsService {

     MailService mailService
    GrailsApplication grailsApplication
    LinkGenerator grailsLinkGenerator
     private static final log = LogFactory.getLog(this)


    Integer showGwas = -1
    Integer showExomeChip = -1
    Integer showExomeSequence = -1
    Integer showSigma = -1
    Integer showGene = -1
    Integer showBeacon = -1



    public void  initialize(){
        showGwas = (grailsApplication.config.portal.sections.show_gwas)?1:0
        showExomeChip = (grailsApplication.config.portal.sections.show_exchp)?1:0
        showExomeSequence = (grailsApplication.config.portal.sections.show_exseq)?1:0
        showSigma = (grailsApplication.config.portal.sections.show_sigma)?1:0
        showGene = (grailsApplication.config.portal.sections.show_gene)?1:0
        showBeacon = (grailsApplication.config.portal.sections.show_beacon)?1:0
    }

    public enum TypeOfSection {
        show_gwas, show_exchp, show_exseq, show_sigma,show_gene, show_beacon
    }


    public Boolean getSectionToDisplay( typeOfSection) {
        showGwas = (showGwas==-1)?grailsApplication.config.portal.sections.show_gwas:showGwas
        showExomeChip = (showExomeChip==-1)?grailsApplication.config.portal.sections.show_exchp:showExomeChip
        showExomeSequence = (showExomeSequence==-1)?grailsApplication.config.portal.sections.show_exseq:showExomeSequence
        showSigma = (showSigma==-1)?grailsApplication.config.portal.sections.show_sigma:showSigma
        showGene = (showGene==-1)?grailsApplication.config.portal.sections.show_gene:showGene
        showBeacon = (showBeacon==-1)?grailsApplication.config.portal.sections.show_beacon:showBeacon
        Boolean returnValue = false
        switch (typeOfSection) {
            case TypeOfSection.show_gwas:
                returnValue = showGwas
                break;
            case TypeOfSection.show_exchp:
                returnValue = showExomeChip
                break;
            case TypeOfSection.show_exseq:
                returnValue = showExomeSequence
                break;
            case TypeOfSection.show_sigma:
                returnValue = showSigma
                break;
            case TypeOfSection.show_gene:
                returnValue = showGene
                break;
            case TypeOfSection.show_beacon:
                returnValue = showBeacon
                break;
            default:break;
        }
        return returnValue
    }



    public Boolean setApplicationToSigma() {
        showGwas = 1
        showExomeChip = 0
        showExomeSequence = 0
        showSigma = 1
        showBeacon = 0
    }

    public Boolean getApplicationIsSigma() {
        return ((showSigma) &&
                (!showBeacon) &&
                (showGwas || showExomeChip  || showExomeSequence))
    }

    public Boolean setApplicationToT2dgenes() {
        showGwas = 1
        showExomeChip = 1
        showExomeSequence = 1
        showSigma = 0
        showBeacon = 0
    }


    public Boolean getApplicationIsT2dgenes() {
        return ((!showSigma) &&
                (!showBeacon) &&
                (showGwas || showExomeChip  || showExomeSequence))
    }


    public Boolean setApplicationToBeacon() {
        showGwas = 0
        showExomeChip = 0
        showExomeSequence = 0
        showSigma = 0
        showBeacon = 1
    }

    public Boolean getApplicationIsBeacon() {
        return ((showBeacon)   &&
                (!showSigma) )
    }


    public String  applicationName () {
        String returnValue = ""
        if (getApplicationIsT2dgenes())   {
            returnValue = "t2dGenes"
        }  else  if (getApplicationIsSigma())   {
            returnValue = "Sigma"
        }  else  if (getApplicationIsBeacon())   {
            returnValue = "Beacon"
        }  else  {
            returnValue = "Undetermined application: internal error"
        }
        return returnValue
    }


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


    public String convertMultipartFileToString(org.springframework.web.multipart.commons.CommonsMultipartFile incomingFile) {
        StringBuilder sb = []
        if (!incomingFile.empty) {
            java.io.InputStream inputStream = incomingFile.getInputStream()
            try {
                int temp
                while ((temp = inputStream.read()) != -1) {
                    sb << ((char) temp).toString()
                }
            } catch (Exception ex) {
                log.error('Problem reading input file=' + ex.toString() + '.')
            }
        } else {
            log.info('User passed us an empty file.')
        }
        return sb.toString()
    }

    /***
     * split up a compound string on the basis of commas.  Turn it into a nice clean list
     *
     * @param initialString
     * @return
     */
    List<String> convertStringToArray (String initialString){
        List<String> returnValue = []
        List<String> rawList = []
        if (initialString){
            rawList =  initialString.split(',')
        }
        for (String oneString in rawList){
            returnValue << oneString.replaceAll("[^a-zA-Z_\\d\\s:]","")
        }
        return returnValue
    }



    /***
     * Convert a simple list into a collection of strings enclosed in quotation marks and separated
     * by commas
     * @param list
     * @return
     */
    String convertListToString (List <String> list){
        String returnValue = ""
        if (list) {
            List filteredList = list.findAll{it.toString().size()>0} // make sure everything is a string with at least size > 0
            if (filteredList.size()>0){
                returnValue = "\""+filteredList.join("\",\"")+"\"" // put them together in a way that Json can consume
            }
        }
        return returnValue
    }

    /***
     * take the data from a multiple line representation (as one might find in a datafile) and
     * put every line into its own element in a list. While were at it remove quotation marks
     * as well as everything else that is in a digit, character, or underscore.
     *
     * @param multiline
     * @return
     */
    List<String> convertMultilineToList (String multiline){
        List<String> returnValue = []
        multiline.eachLine {
            if (it) {
                String filteredVersion =  it.toString().replaceAll("[^a-zA-Z_\\d\\s:]","")
                if (filteredVersion){
                    returnValue <<  filteredVersion
                }
            }
        }
        return returnValue
    }






    String createDistributedBurdenTestInput(List <String> variantList){
        String returnValue ="""{
            "variants":[
               ${convertListToString(variantList)}
        ],
            "covariates": [],
            "samples": []
        }"""
        return returnValue
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


    public String urlEncodedListOfUserSessions(List<UserSession> userSessionList) {
        StringBuilder sb   = new StringBuilder ("")
        int numberOfUsers  =  userSessionList.size()
        int iterationCount  = 0
        for (UserSession userSession in userSessionList){
            sb<< (userSession.user.username + "#" + (userSession.getStartSession().toString()) + "#" + (userSession.getEndSession()?:'none')+ "#" +
                    (userSession.getRemoteAddress()?:'none') + "#" + (userSession.getDataField()?:'none') )
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
        String passwordResetUrl = grailsLinkGenerator.link(controller:'admin', action:'resetPasswordInteractive',absolute: true)
        String bodyOfMessage = "Dear diabetes portal user;\n\n In order to access the updated version of the diabetes portal it will be necessary for you to reset your password."+
        "Please copy the following string into the URL of your browser:\n\n" +
                passwordResetUrl+ "/"+ encodeUser(userEmailAddress) +"\n"+
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
