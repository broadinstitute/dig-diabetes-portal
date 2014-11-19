class UrlMappings {

	static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }
//        "/"(redirect:[controller: 'home', action: 'index',permanent:true])
        "/"{
            controller = "home"
            action = "index"
        }
        "500"(view:'/error')
	}
}
