<script id="versionTemplate"  type="x-tmpl-mustache">
    <g:form action='changeDataVersion' method='POST' class='form form-horizontal cssform' autocomplete='off'>
        <h4><g:message code="system.header.data_version" /></h4>
        <br/>
        <div class="row clearfix">
            <div class="col-md-3"><span class="headerForVersionTable">Portal type</span></div>
            <div class="col-md-3"><span class="headerForVersionTable">Description</span></div>
            <div class="col-md-3"><span class="headerForVersionTable">Version</span></div>
            <div class="col-md-3"></div>
        </div>
        {{#portalVersionList}}
        <input type="text" name="dataType" Value="{{PortalType}}" style="display:none">
        {{/portalVersionList}}
        {{#portalVersionList}}
            <div class="row clearfix">
                <div class="col-md-3"> <span class="elementForVersionTable">{{PortalType}}</span></div>
                <div class="col-md-3"> <span class="elementForVersionTable">{{PortalDescription}}</span></div>
                <div class="col-md-2"><input type="text" name="mdvName_{{PortalType}}" Value="{{MdvName}}" style="width:100%"></div>
                <div class="col-md-4"></div>
            </div>
       {{/portalVersionList}}
       <div class="row clearfix">
            <div class="col-md-9"></div>
            <div class="col-md-3">
                <div >
                    <div style="text-align:center; padding-top: 20px;">
                        <input class="btn btn-primary btn-lg" type='submit' id="submitDataVersionText"
                               value='Commit'/>
                    </div>
                </div>
            </div>
        </div>
        <div class="row clearfix">
            <div class="col-md-2"></div>
            <div class="col-md-8">
                <div >
                    <g:if test='${flash.message}'>
                        <div class="alert alert-danger">${flash.message}</div>
                    </g:if>
                </div>
            </div>
            <div class="col-md-2"></div>

        </div>

    </g:form>
</script>
