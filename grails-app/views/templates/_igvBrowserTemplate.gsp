<script>
    function  igvSearch(searchString) { // does this function have to reside in the global namespace, or could we restrict the scope a little?
        igv.browser.search(searchString);
        return true;
    }
</script>
<script id="igvHolderTemplate"  type="x-tmpl-mustache">
    <div id="igvDiv">
        <p>
        {{igvIntro}}
        </p>

        <nav class="navbar" role="navigation" style="margin:0;padding:0">
            <div class="container-fluid">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle" data-toggle="collapse"
                            data-target="#bs-example-navbar-collapse-1"><span class="sr-only"><g:message code="controls.shared.igv.toggle_nav" /></span><span
                            class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span></button>
                <div id="bs-example-navbar-collapse-1" class="collapse navbar-collapse" style="margin:0;padding:0">
                    <ul class="nav navbar-nav navbar-left">
                        <li class="dropdown" id="tracks-menu-dropdown" style="margin:0;padding:0">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown"><g:message code="controls.shared.igv.tracks" /><b class="caret"></b></a>
                            <ul id="mytrackList" class="dropdown-menu" style="margin:0;padding:0">
                            </ul>
                        </li>
                    </ul>
                </div>
                </div>
            </div>
        </nav>

    </div>
</script>

<script id="phenotypeDropdownTemplate"  type="x-tmpl-mustache">
        {{ #dataSources }}
            <li>
            <a onclick="igv.browser.loadTrack({ type: '{{type}}',
                url: '{{url}}',
                    trait: '{{trait}}',
                    dataset: '{{dataset}}',
                    pvalue: '{{pvalue}}',
                    name: '{{name}}',
                    variantURL: '{{variantURL}}',
                    traitURL: '{{traitURL}}'
                })">{{name}}</a>
            </li>
        {{ /dataSources }}
        {{ ^dataSources }}
        <li>No phenotypes available</li>
        {{ /dataSources }}
</script>
