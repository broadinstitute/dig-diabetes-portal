<%@ page import="org.springframework.web.servlet.support.RequestContextUtils" %>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:layoutResources/>
</head>

<body>

<div id="main">
    <div class="container">
        <div id="about-sigma" class="tabbed-about-page">
            <div class="sidebar">
                <div class="tab active" data-section="about"><g:message code="sigma.information.home"/></div>
                <div class="sep"></div>
                <div class="tab" data-section="cohorts"><g:message code="sigma.information.data"/></div>
                <div class="sep"></div>
                <div class="tab" data-section="papers"><g:message code="sigma.information.papers"/></div>
                <div class="sep"></div>
                <div class="tab" data-section="people"><g:message code="sigma.information.people"/></div>
            </div>
            <div class="content">
                <div class="section section-content" data-section="about">
                    <% def locale = RequestContextUtils.getLocale(request) %>
                    <g:if test="${(locale.language == 'es')}">
                        <g:render template="sigma/es/about"/>
                    </g:if>
                    <g:else>
                        <g:render template="sigma/en/about"/>
                    </g:else>
                </div>
                <div class="section" data-section="cohorts" style="display:none;">
                    <g:render template="sigma/cohorts"/>
                </div>
                <div class="section" data-section="papers" style="display:none;">
                    <g:render template="sigma/papers"/>
                </div>
                <div class="section" data-section="people" style="display:none;">
                    <g:render template="sigma/people"/>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(function() {
        $('.tabbed-about-page .sidebar .tab').on('click', function(e) {
            var section = $(e.target).data('section');
            $('.tab').removeClass('active');
            $(e.target).addClass('active');
            $('.section').hide();
            $('.section[data-section="' + section + '"]').show();
        });
    });
</script>

</body>
</html>
