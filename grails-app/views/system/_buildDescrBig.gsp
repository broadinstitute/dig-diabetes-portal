<%@ page import="temporary.BuildInfo" %>
<div class="row clearfix" style="margin-top:20px; padding: 10px">

    <div class="col-md-8 col-sm-12">
        <div style="border: 2px solid darkblue; padding: 10px">
            <span style="font-decoration:underline"><Strong><em>Build information:</em></Strong><br /></span>
            Grails environment: ${grails.util.Environment.current.name}.<br />
            Built by ${BuildInfo.buildWho}
<g:if test="${BuildInfo.buildHost != 'null'}">
                on ${BuildInfo.buildHost}
</g:if>
            <br />
            Compiled: ${BuildInfo.buildTime}<br />
<g:if test="${BuildInfo.homePath!= 'null'}">
            User home: ${BuildInfo.homePath}<br />
</g:if>
<g:if test="${BuildInfo.grailsHome!= 'null'}">
            User home: ${BuildInfo.grailsHome}<br />
</g:if>
            Grails home: ${BuildInfo.grailsHome}<br />
            Java home: ${BuildInfo.javaHome}<br />
            Compilation dir: ${BuildInfo.userDirectory}<br />
            OS architecture: ${BuildInfo.osArch}<br />
<g:if test="${BuildInfo.processorIdentifier!= 'null'}">
            Processor: ${BuildInfo.processorIdentifier}<br />
</g:if>
<g:if test="${BuildInfo.operatingSystem!= 'null'}">
            OS: ${BuildInfo.operatingSystem}<br />
</g:if>
            OS version: ${BuildInfo.operatingSystemVersion}<br />
            Ant version: ${BuildInfo.antVersion}<br />
        </div>
    </div>
    <div class="col-md-4"></div>

</div>