<%@ page import="temporary.BuildInfo" %>
<div class="row clearfix" style="margin-top:20px; padding: 10px">

    <div class="col-md-4">
        <div style="border: 2px solid darkblue; padding: 10px">
            <span style="font-decoration:underline"><Strong><em>Build information:</em></Strong><br /></span>
            Grails environment: ${grails.util.Environment.current.name}.<br />
            Built by ${BuildInfo.buildWho} on ${BuildInfo.buildHost}<br />
            Compiled: ${BuildInfo.buildTime}<br />
            User home: ${BuildInfo.homePath}<br />
            Grails home: ${BuildInfo.grailsHome}<br />
            Java home: ${BuildInfo.javaHome}<br />
            Compilation dir: ${BuildInfo.userDirectory}<br />
            OS architecture: ${BuildInfo.osArch}<br />
            Processor: ${BuildInfo.processorIdentifier}<br />
            OS: ${BuildInfo.operatingSystem}<br />
            OS version: ${BuildInfo.operatingSystemVersion}<br />
            Ant version: ${BuildInfo.antVersion}<br />
        </div>
    </div>
    <div class="col-md-8"></div>

</div>