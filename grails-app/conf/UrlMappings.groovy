class UrlMappings {

	static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }
        "/"(redirect:[controller: 'home', action: 'portalHome',permanent:true])
        "500"(view:'/error')
	}
}
