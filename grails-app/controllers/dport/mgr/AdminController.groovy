package dport.mgr

import dport.SharedToolsService
import dport.people.User
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.codehaus.groovy.grails.commons.GrailsApplication

import static org.springframework.http.HttpStatus.CREATED

class AdminController {

    GrailsApplication grailsApplication
    SharedToolsService sharedToolsService
    SpringSecurityService springSecurityService


    def index = {
        java.util.LinkedHashMap variableStrings = [:]
        ["vars": variableStrings]
    }

    def users = {
        String encodedUsers = sharedToolsService.urlEncodedListOfUsers()

        render(view: 'users', model: [encodedUsers:encodedUsers])
    }

    def create = {
        respond new User(params),model:[userPrivs: 1]
    }

    @Transactional
    def save(User userInstance) {
        if (userInstance == null) {
            notFound()
            return
        }

        if (userInstance.hasErrors()) {
            respond userInstance.errors, view:'create',model:[userPrivs: 1]
            return
        }

        userInstance.save flush:true

        int flagsUserWants = sharedToolsService.convertCheckboxesToPrivFlag(params)

        sharedToolsService.storePrivilegesFromFlags ( userInstance, flagsUserWants)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: ['User', userInstance.id])
                redirect userInstance
            }
            '*' { respond userInstance, [status: CREATED, privsFlag: flagsUserWants] }
        }
    }


    def forcePasswordExpire = {
        if (params.id)  {
            String username = params.id.replaceAll("&#46;",".")

            User user = User.findByUsername(username)
            if (user)  {
                user.setPasswordExpired(true)
                user.save(flush: true, failOnError: true)
            }
        }
        String encodedUsers = sharedToolsService.urlEncodedListOfUsers()
        render(view: 'users', model: [encodedUsers:encodedUsers])
    }


    def forcePasswordUnexpire = {
        if (params.id) {
            String username = params.id.replaceAll("&#46;", ".")

            User user = User.findByUsername(username)
            if (user) {
                user.setPasswordExpired(false)
                user.save(flush: true, failOnError: true)
            }
        }
        String encodedUsers = sharedToolsService.urlEncodedListOfUsers()
        render(view: 'users', model: [encodedUsers:encodedUsers])
    }


    def forceAccountExpire = {
        if (params.id) {
            String username = params.id.replaceAll("&#46;", ".")

            User user = User.findByUsername(username)
            if (user) {
                user.setAccountExpired(true)
                user.save(flush: true, failOnError: true)
            }
        }
        String encodedUsers = sharedToolsService.urlEncodedListOfUsers()
        render(view: 'users', model: [encodedUsers:encodedUsers])
    }


    def forceAccountUnexpire = {
        if (params.id) {
            String username = params.id.replaceAll("&#46;", ".")

            User user = User.findByUsername(username)
            if (user) {
                user.setAccountExpired(false)
                user.save(flush: true, failOnError: true)
            }
        }
        String encodedUsers = sharedToolsService.urlEncodedListOfUsers()
        render(view: 'users', model: [encodedUsers:encodedUsers])
    }



    def forceAccountLocked = {
        String username = params.id
        User user = User.findByUsername(username)
        if (user)  {
            user.setAccountLocked(true)
            user.save(flush: true, failOnError: true)
        }
        String encodedUsers = sharedToolsService.urlEncodedListOfUsers()
        render(view: 'users', model: [encodedUsers:encodedUsers])
    }


    def forceAccountUnlocked = {
        String username = params.id
        User user = User.findByUsername(username)
        if (user)  {
            user.setAccountLocked(false)
            user.save(flush: true, failOnError: true)
        }
        String encodedUsers = sharedToolsService.urlEncodedListOfUsers()
        render(view: 'users', model: [encodedUsers:encodedUsers])
    }


    def resetPassword = {
        String username = session['SPRING_SECURITY_LAST_USERNAME']
        render(view: 'newPassword', model: [ username:username])
    }

    def updatePassword() {
        String username = session['SPRING_SECURITY_LAST_USERNAME']
        if (!username) {
            flash.message = 'Sorry, an error has occurred'
            redirect controller: 'login', action: 'auth'
            return
        }
        String password = params.oldPassword
        String newPassword = params.newPassword
        String newPassword2 = params.newPassword2
        if (!password || !newPassword || !newPassword2 || newPassword != newPassword2) {
            flash.message = 'Please enter your current password and a valid new password'
            render view: 'newPassword', model: [username: session['SPRING_SECURITY_LAST_USERNAME']]
            return
        }

        User user = User.findByUsername(username)
        if (!springSecurityService.passwordEncoder.isPasswordValid(user.password, password, null /*salt*/)) {
            flash.message = 'Current password is incorrect'
            render view: 'newPassword', model: [username: session['SPRING_SECURITY_LAST_USERNAME']]
            return
        }

        if (springSecurityService.passwordEncoder.isPasswordValid(user.password, newPassword, null /*salt*/)) {
            flash.message = 'Please choose a different password from your current one'
            render view: 'newPassword', model: [username: session['SPRING_SECURITY_LAST_USERNAME']]
            return
        }

        user.password = newPassword
        user.passwordExpired = false
        user.save() // if you have password constraints check them here

        redirect controller: 'login', action: 'auth'
    }


    def resetPasswordInteractive = {
        String encodedUsername = params.id
        String username =  sharedToolsService.unencodeUser(encodedUsername)
        if (username.endsWith("broadinstitute")) {
            username += ".org"
        }
        render(view: 'resetPassword', model: [ username:username])
//        sharedToolsService.sendEmail()
    }

    def updatePasswordInteractive() {
        String username = params.username
        if (!username) {
            flash.message = 'Sorry, you need to provide a username'
            redirect controller: 'login', action: 'auth'
            return
        }
        String newPassword = params.newPassword
        String newPassword2 = params.newPassword2
        if (!newPassword || !newPassword2 || newPassword != newPassword2) {
            flash.message = 'Please two matching password records'
            render view: 'passwordExpired', model: [username: session['SPRING_SECURITY_LAST_USERNAME']]
            return
        }

        User user = User.findByUsername(username)

        user.password = newPassword
        user.passwordExpired = false
        user.save() // if you have password constraints check them here

        redirect controller: 'login', action: 'auth'
    }

}
