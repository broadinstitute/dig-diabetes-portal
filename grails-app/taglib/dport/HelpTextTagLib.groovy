package dport

class HelpTextTagLib {
   // static defaultEncodeAs = [taglib: 'html']

    def helpText = { attrs,body ->
        if (attrs.placer){
            out <<  render(contextPath: "/home", template: "helpText",
                    model: [title:attrs.title, body:attrs.body, placer:attrs.placer ])
        } else {
            out <<  render(contextPath: "/home", template: "helpText",
                    model: [title:attrs.title, body:attrs.body, placer:"0" ])

        }
    }


}
