package dport.mgr

import dport.SharedToolsService
import dport.people.User
import grails.plugin.springsecurity.SpringSecurityService
import org.codehaus.groovy.grails.commons.GrailsApplication

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

    def forcePasswordExpire = {
        String username = params.id
        User user = User.findByUsername(username)
        if (user)  {
            user.setPasswordExpired(true)
            user.save(flush: true, failOnError: true)
        }
        String encodedUsers = sharedToolsService.urlEncodedListOfUsers()
        render(view: 'users', model: [encodedUsers:encodedUsers])
    }


    def forcePasswordUnexpire = {
        String username = params.id
        User user = User.findByUsername(username)
        if (user)  {
            user.setPasswordExpired(false)
            user.save(flush: true, failOnError: true)
        }
        String encodedUsers = sharedToolsService.urlEncodedListOfUsers()
        render(view: 'users', model: [encodedUsers:encodedUsers])
    }


    def forceAccountExpire = {
        String username = params.id
        User user = User.findByUsername(username)
        if (user)  {
            user.setAccountExpired(true)
            user.save(flush: true, failOnError: true)
        }
        String encodedUsers = sharedToolsService.urlEncodedListOfUsers()
        render(view: 'users', model: [encodedUsers:encodedUsers])
    }


    def forceAccountUnexpire = {
        String username = params.id
        User user = User.findByUsername(username)
        if (user)  {
            user.setAccountExpired(false)
            user.save(flush: true, failOnError: true)
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
        render(view: 'newPassword', model: [ username:session['SPRING_SECURITY_LAST_USERNAME']])
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
            render view: 'passwordExpired', model: [username: session['SPRING_SECURITY_LAST_USERNAME']]
            return
        }

        User user = User.findByUsername(username)
        if (!springSecurityService.passwordEncoder.isPasswordValid(user.password, password, null /*salt*/)) {
            flash.message = 'Current password is incorrect'
            render view: 'passwordExpired', model: [username: session['SPRING_SECURITY_LAST_USERNAME']]
            return
        }

        if (springSecurityService.passwordEncoder.isPasswordValid(user.password, newPassword, null /*salt*/)) {
            flash.message = 'Please choose a different password from your current one'
            render view: 'passwordExpired', model: [username: session['SPRING_SECURITY_LAST_USERNAME']]
            return
        }

        user.password = newPassword
        user.passwordExpired = false
        user.save() // if you have password constraints check them here

        redirect controller: 'login', action: 'auth'
    }

       // defines a new password?
//    def springSecurityService
//
//    def updateAction() {
//        def person = Person.get(params.id)
//
//        params.salt = person.salt
//        if (person.password != params.password) {
//            params.password = springSecurityService.encodePassword(password, salt)
//            def salt = … // e.g. randomly generated using some utility method
//            params.salt = salt
//        }
//        person.properties = params
//        if (!person.save(flush: true)) {
//            render view: 'edit', model: [person: person]
//            return
//        }
//        redirect action: 'show', id: person.id
//    }

}
