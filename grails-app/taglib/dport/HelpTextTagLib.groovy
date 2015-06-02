package dport

class HelpTextTagLib {
   // static defaultEncodeAs = [taglib: 'html']
    static String defaultPopupPlacement = "left"
    static String defaultQuestionmarkPlacement = "0"
    SharedToolsService sharedToolsService

    def helpText = { attrs,body ->
        // We have to have some help text or else don't bother displaying indicator icon
        if ( (sharedToolsService?.getHelpTextSetting()==2) ||
                ( (sharedToolsService?.getHelpTextSetting()==1) &&
                    ( ( g.message(code:attrs.title) ) ||
                      ( g.message(code:attrs.body) ) ) ) ){
                    String encoding = "HTML"
                    if (attrs.encodeAs != null) {
                        encoding = attrs.encodeAs;
                    }
                    String popupPlacement = (attrs.placement) ?: defaultPopupPlacement
                    String questionmarkPlacement = (attrs.qplacer) ?: defaultQuestionmarkPlacement
                out <<  render(contextPath: "/home", template: "helpText",
                        model: [title:attrs.title,  body:attrs.body, encodeAs:encoding, qplacer:questionmarkPlacement, placement: popupPlacement ])
                }

    }


}
