package dport

class HelpTextTagLib {
   // static defaultEncodeAs = [taglib: 'html']
    static String defaultPopupPlacement = "auto"
    static String defaultQuestionmarkPlacement = "0"

    def helpText = { attrs,body ->
        // We have to have some help text or else don't bother displaying indicator icon
        if ( ( g.message(code:attrs.title) ) ||
             ( g.message(code:attrs.body) ) ){
                    String popupPlacement = (attrs.placement) ?: defaultPopupPlacement
                    String questionmarkPlacement = (attrs.qplacer) ?: defaultQuestionmarkPlacement
                out <<  render(contextPath: "/home", template: "helpText",
                        model: [title:attrs.title, body:attrs.body, qplacer:questionmarkPlacement, placement: popupPlacement ])
                }

    }


}
