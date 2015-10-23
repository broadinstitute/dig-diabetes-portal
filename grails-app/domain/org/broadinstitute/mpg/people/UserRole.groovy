package org.broadinstitute.mpg.people

import org.apache.commons.lang.builder.HashCodeBuilder

class UserRole implements Serializable {

    private static final long serialVersionUID = 1

    User user
    Role role

    boolean equals(other) {
        if (!(other instanceof UserRole)) {
            return false
        }

        other.user?.id == User?.id &&
                other.role?.id == Role?.id
    }

    int hashCode() {
        def builder = new HashCodeBuilder()
        if (User) builder.append(User.id)
        if (Role) builder.append(Role.id)
        builder.toHashCode()
    }

    static UserRole get(long userId, long roleId) {
        UserRole.where {
            User == User.load(userId) &&
                    Role == Role.load(roleId)
        }.get()
    }

    static boolean exists(long userId, long roleId) {
        UserRole.where {
            User == User.load(userId) &&
                    Role == Role.load(roleId)
        }.count() > 0
    }

    static UserRole create(User user, Role role, boolean flush = false) {
        def instance = new UserRole(user: user, role: role)
        instance.save(flush: flush, insert: true)
        instance
    }

    static boolean remove(User u, Role r, boolean flush = false) {
        if (u == null || r == null) return false

        int rowCount = UserRole.where {
            User == User.load(u.id) &&
                    Role == Role.load(r.id)
        }.deleteAll()

        if (flush) {
            UserRole.withSession { it.flush() }
        }

        rowCount > 0
    }

    static void removeAll(User u, boolean flush = false) {
        if (u == null) return

        UserRole.where {
            User == User.load(u.id)
        }.deleteAll()

        if (flush) {
            UserRole.withSession { it.flush() }
        }
    }

    static void removeAll(Role r, boolean flush = false) {
        if (r == null) return

        UserRole.where {
            Role == Role.load(r.id)
        }.deleteAll()

        if (flush) {
            UserRole.withSession { it.flush() }
        }
    }

    static constraints = {
//        Role validator: { Role r, UserRole ur ->
//            if (ur.user == null) return
//            boolean existing = false
//            UserRole.withNewSession {
//                existing = UserRole.exists(ur.user.id, r.id)
//            }
//            if (existing) {
//                return 'userRole.exists'
//            }
//        }
    }

    static mapping = {
        id composite: ['role', 'user']
        version false
    }
}
