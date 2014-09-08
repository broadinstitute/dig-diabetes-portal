package dport.mgr

import dport.SharedToolsService
import dport.people.Role
import dport.people.User
import dport.people.UserRole
import grails.transaction.Transactional

import static org.springframework.http.HttpStatus.CREATED
import static org.springframework.http.HttpStatus.NOT_FOUND
import static org.springframework.http.HttpStatus.NO_CONTENT
import static org.springframework.http.HttpStatus.OK

class UserController {
    SharedToolsService sharedToolsService

    def edit(User userInstance) {
//        int id =  userInstance.id
//        List<UserRole> userRoleList = UserRole.findAllByUser(userInstance)
        int flag =   sharedToolsService.extractPrivilegeFlags  (userInstance)
//        int flag = 0
//        for (UserRole oneUserRole in userRoleList) {
//            if (oneUserRole.role == Role.findByAuthority("ROLE_USER")) {
//                flag += 1
//            }  else  if (oneUserRole.role == Role.findByAuthority("ROLE_ADMIN")) {
//                flag += 2
//            }  else  if (oneUserRole.role == Role.findByAuthority("ROLE_SYSTEM")) {
//                flag += 4
//            }
//         }
        respond userInstance,model:[userPrivs: flag]
    }

    @Transactional
    def update(User userInstance) {
        if (userInstance == null) {
            notFound()
            return
        }

        if (userInstance.hasErrors()) {
            respond userInstance.errors, view:'edit'
            return
        }

        userInstance.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'User.label', default: 'User'), userInstance.id])
                redirect userInstance
            }
            '*'{
                respond userInstance, [status: OK,userPrivs: 1] }
        }
    }



    @Transactional
    def save(User userInstance) {
        if (userInstance == null) {
            notFound()
            return
        }

        if (userInstance.hasErrors()) {
            respond userInstance.errors, view:'create'
            return
        }
        Role userRole = Role.findByAuthority("ROLE_USER")
        userInstance.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: ['User', userInstance.id])
                redirect userInstance
            }
            UserRole.create userInstance,userRole
            '*' { respond userInstance, [status: CREATED, privsFlag: 3] }
        }
    }


    def show(User userInstance) {
        respond userInstance
    }


    @Transactional
    def delete(User userInstance) {

        if (userInstance == null) {
            notFound()
            return
        }

        userInstance.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'User.label', default: 'User'), userInstance.id])
                redirect controller: "admin", action:"users", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }


    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'user.label', default: 'User'), params.id])
                redirect controller: "admin", action:"users", method:"GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }



    def index() {

    }
}
