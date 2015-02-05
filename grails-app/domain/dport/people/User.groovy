package dport.people

class User {

	transient springSecurityService

	String username
	String password
    String email
    String fullName = ""
    String nickname = "default"
//    String primaryOrganization = "default"
//    String webSiteUrl = "default"
 //   String preferredLanguage = "default"
    boolean hasLoggedIn
	boolean enabled = true
	boolean accountExpired
	boolean accountLocked
	boolean passwordExpired

	static transients = ['springSecurityService']

	static constraints = {
		username blank: false, unique: true
		password blank: false
        fullName blank:true
        nickname blank:true
        email blank: true
//        primaryOrganization blank: true
//        webSiteUrl blank:true
//        preferredLanguage blank:true
	}

	static mapping = {
		password column: '`password`'
//        password preferredLanguage: '`prflang`'
//        password primaryOrganization: '`primorg`'
    }

	Set<Role> getAuthorities() {
		UserRole.findAllByUser(this).collect { it.role }
	}

	def beforeInsert() {
		encodePassword()
	}

	def beforeUpdate() {
		if (isDirty('password')) {
			encodePassword()
		}
	}

	protected void encodePassword() {
		password = springSecurityService?.passwordEncoder ? springSecurityService.encodePassword(password) : password
	}
}
