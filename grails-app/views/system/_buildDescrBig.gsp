<%@ page import="temporary.BuildInfo" %>
<div class="row clearfix" style="margin-top:20px; padding: 10px">

    <div class="col-md-8 col-sm-12">
        <div style="border: 2px solid darkblue; padding: 10px">
            <span style="font-decoration:underline"><Strong><em><g:message code="buildInfo.shared.build_info" />:</em></Strong><br /></span>
            Grails <g:message code="buildInfo.shared.environment" />: ${grails.util.Environment.current.name}.<br />
            <g:message code="buildInfo.shared.built_by" /> ${BuildInfo.buildWho}
<g:if test="${BuildInfo.buildHost != 'null'}">
                <g:message code="buildInfo.shared.on" /> ${BuildInfo.buildHost}
</g:if>
            <br />
            <g:message code="buildInfo.shared.compiled" />: ${BuildInfo.buildTime}<br />
<g:if test="${BuildInfo.homePath!= 'null'}">
            <g:message code="buildInfo.shared.user" /> <g:message code="buildInfo.shared.home" />: ${BuildInfo.homePath}<br />
</g:if>
<g:if test="${BuildInfo.grailsHome!= 'null'}">
            <g:message code="buildInfo.shared.user" /> <g:message code="buildInfo.shared.home" />: ${BuildInfo.grailsHome}<br />
</g:if>
            Grails <g:message code="buildInfo.shared.home" />: ${BuildInfo.grailsHome}<br />
            Java <g:message code="buildInfo.shared.home" />: ${BuildInfo.javaHome}<br />
            <g:message code="buildInfo.shared.compilation_dir" />: ${BuildInfo.userDirectory}<br />
            <g:message code="buildInfo.shared.os" /> <g:message code="buildInfo.shared.arch" />: ${BuildInfo.osArch}<br />
<g:if test="${BuildInfo.processorIdentifier!= 'null'}">
            <g:message code="buildInfo.shared.processor" />: ${BuildInfo.processorIdentifier}<br />
</g:if>
<g:if test="${BuildInfo.operatingSystem!= 'null'}">
            <g:message code="buildInfo.shared.os" />: ${BuildInfo.operatingSystem}<br />
</g:if>
            <g:message code="buildInfo.shared.os" /> <g:message code="buildInfo.shared.version" />: ${BuildInfo.operatingSystemVersion}<br />
            Ant <g:message code="buildInfo.shared.version" />: ${BuildInfo.antVersion}<br />
        </div>
    </div>
    <div class="col-md-4"></div>

</div>