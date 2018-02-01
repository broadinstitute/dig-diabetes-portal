<!DOCTYPE html>
<%@ page import="org.springframework.web.servlet.support.RequestContextUtils" %>
<%@ page import="temporary.BuildInfo" %>
<!--[if lt IE 7 ]> <html lang="en" class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html lang="en" class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang="en" class="no-js"><!--<![endif]-->
<html>
    <head>
        <g:if test="${g.portalTypeString()?.equals('stroke')}">
            <title><g:message code="portal.stroke.header.title.short"/> <g:message code="portal.stroke.header.title.genetics"/></title>
        </g:if>
        <g:elseif test="${g.portalTypeString()?.equals('mi')}">
            <title><g:message code="portal.mi.header.title.short"/> <g:message code="portal.mi.header.title.genetics"/></title>
        </g:elseif>
        <g:else>
            <title><g:message code="portal.header.title.short"/> <g:message code="portal.header.title.genetics"/></title>
        </g:else>

        <r:require modules="core"/>
        <r:layoutResources/>

        <link href="https://fonts.googleapis.com/css?family=Lato|Oswald" rel="stylesheet">


        <g:layoutHead/>



        <g:if test="${g.portalTypeString()?.equals('stroke')}">
            <g:renderT2dGenesSection>
                <g:applyLayout name="analyticsStrokePortal"/>
            </g:renderT2dGenesSection>
        </g:if>
        <g:if test="${g.portalTypeString()?.equals('mi')}">
            <g:renderT2dGenesSection>
                <g:applyLayout name="analyticsMiPortal"/>
            </g:renderT2dGenesSection>
        </g:if>

        <g:else>
            <g:renderT2dGenesSection>
                <g:applyLayout name="analyticsT2dGenes"/>
            </g:renderT2dGenesSection>
        </g:else>

        <style>
            <g:if test="${g.portalTypeString()?.equals('stroke')}">
                a {color:#5cbc6d;}
                a:hover, a:active {color:#43957e; text-decoration: none;}
                .dk-t2d-yellow {  background-color: #d5cc29;  }
                .dk-t2d-orange {  background-color: #F68920;  }
                .dk-t2d-green {  background-color: #71CD73;  }
                .dk-t2d-blue {  background-color: #62B4C5;  }
                .dk-blue-bordered {
                    display:block;
                    border-top: solid 1px #5cbc6d;
                    border-bottom: solid 1px #5cbc6d;
                    color: #5cbc6d;
                    padding: 5px 0;
                    text-align:left;
                    line-height:26px;
                }
            </g:if>
            <g:elseif test="${g.portalTypeString()?.equals('mi')}">
                a {color:#de8800;}
                a:hover, a:active {color:#ad6700; text-decoration: none;}
                .dk-t2d-green {  background-color: #e6af00;  }
                .dk-t2d-orange {  background-color: #F68920;  }
                .dk-t2d-blue {  background-color: #7ece93;  }
                .dk-t2d-yellow {  background-color: #62B4C5;  }
                .dk-blue-bordered {
                    display:block;
                    border-top: solid 1px #de8800;
                    border-bottom: solid 1px #de8800;
                    color: #de8800;
                    padding: 5px 0;
                    text-align:left;
                    line-height:26px;
                }
            </g:elseif>
            <g:else>
                a {color:#50AABB;}
                a:hover, a:active {color:#2779a7; text-decoration: none;}
                .dk-t2d-yellow {  background-color: #D2BC2C;  }
                .dk-t2d-orange {  background-color: #F68920;  }
                .dk-t2d-green {  background-color: #7fc343;  }
                .dk-t2d-blue {  background-color: #62B4C5;  }
                .dk-blue-bordered {
                    display:block;
                    border-top: solid 1px #57A7BA;
                    border-bottom: solid 1px #57A7BA;
                    color: #57A7BA;
                    padding: 5px 0;
                    text-align:left;
                    line-height:26px;
                }
            </g:else>
        </style>

        <script>
            $(function () {
                /*DK: find out if the user is viewing the front page*/

                if ($(".dk-user-name").length) {
                    var userName = $(".dk-user-name").find(".user-name-initial").text();
                    $(".dk-user-name").find(".user-name-initial").html(userName.charAt(0).toUpperCase()).attr("title",userName).css({"display":"block","color":"#fffff", "text-shadow":"none", "text-align":"center","font-size":"12px","width":"22px","padding":"2px 0","border-radius":"5px 0 0 5px"});
                }

                /* set the visibility of the user notification blob */
                var warningMessage = "";
                $("#userNotificationDisplay").text(warningMessage).attr("message",warningMessage);
                ($("#userNotificationDisplay").text() == "")? $("#userNotificationDisplay").css("display","none") : $("#userNotificationDisplay").css("display","inline-block");

                /* display notification as the mouse pointer rolls over the notification blob */
                $("#userNotificationDisplay").hover(function(){
                    $(this).append("<div class='user-notification-full' style='position:absolute; right: 15px; top: 35px; padding-top: 10px; width:200px;'><span style='display:block; font-size: 14px; background-color:#fff; box-shadow: 0 2px 3px rgba(0, 0, 0, .5); text-align:left; width: 200px !important; border-radius: 3px; padding: 5px 10px 5px 10px; color:#333;'>"+$(this).attr("message")+"</span></div>");
                }, function() {$( this ).find('.user-notification-full').remove();});

                var pathFullName = location.pathname.toLowerCase();
                var pathName = location.pathname.toLowerCase().split("/");
                var theLastPath = pathName.slice(-1)[0];

                switch(theLastPath){
                    case "":

                        var menuWidth = $(".dk-user-menu").width() + $(".dk-general-menu").width()+50;

                        if ($(".portal-front-banner").length){
                            $(".dk-logo-wrapper").css({"display":"none"});
                            setMenuTriangle(".home-btn");
                            $(".dk-menu-wrapper").css({"width":menuWidth,"margin-top":"0","border-bottom":"solid 1px #ffffff"});
                        } else {
                            $(".dk-menu-wrapper").css({"width":menuWidth,"margin-top":"0","border-bottom":"none"});
                        }
                        break;

                    case "portalhome":
                        $(".dk-logo-wrapper").css({"display":"none"});
                        var menuWidth = $(".dk-user-menu").width() + $(".dk-general-menu").width()+50;
                        $(".dk-menu-wrapper").css({"width":menuWidth,"margin-top":"0","border-bottom":"solid 1px #ffffff"})
                        setMenuTriangle(".home-btn")
                        break;

                    case "variantsearchwf":
                        setMenuTriangle(".variant-search-btn");
                        break;

                    case "data":
                        setMenuTriangle(".data-btn")
                        break;


                    case "about":
                        setMenuTriangle(".about-btn")
                        break;

                    case "policies":
                        setMenuTriangle(".policies-btn")
                        break;

                    case "tutorials":
                        setMenuTriangle(".tutorials-btn")
                        break;

                    case "contact":
                        setMenuTriangle(".contact-btn")
                        break;

                    case "datasubmission":
                        setMenuTriangle(".data-submission-btn")
                        break;

                    case "downloads":
                        setMenuTriangle(".downloads-btn")
                        break;
                }

                menuHeaderSet();
            });

            function setMenuTriangle(SELEVTEDBTN) {$(SELEVTEDBTN).css({"background-image":"url(${resource(dir: 'images', file: 'menu-triangle.svg')})","background-repeat":"no-repeat","background-position":"center bottom","background-size":"18px 9px"})}


            function menuHeaderSet() {
                var menuHeaderWidth = $(".dk-logo-wrapper").width() + $(".dk-general-menu").width() + 50;
                var windowWidth = $(window).width();

                if(menuHeaderWidth > windowWidth) {

                    $(".dk-menu-wrapper").css({"margin-top":"0px"});
                    $(".dk-menu-wrapper").find("ul").css({"float":"left"});
                } else {
                    var pathName = location.pathname.toLowerCase().split("/");
                    var theLastPath = pathName.slice(-1)[0];

                    if(theLastPath != "" && theLastPath != "portalhome") {

                        $(".dk-menu-wrapper").css({"margin-top":"-50px"});
                        $(".dk-menu-wrapper").find("ul").css({"float":"right"});
                    }
                }
            }

            /* copy url of varian search result page to clipboard*/

            $( window ).load( function() {
                document.addEventListener('copy', function(e){

                    e.clipboardData.setData('text/plain', $(location).attr("href"));
                    e.preventDefault(); // default behaviour is to copy any selected text

                });

                $("#copyURL").click(function() {
                    document.execCommand('copy');
                })
            });




            $( window ).resize(function() {
                menuHeaderSet();
            });

        </script>

    </head>

<body>


<g:applyLayout name="errorReporter"/>


<div id="spinner" class="dk-loading-wheel center-block" style="display:none;">
    <img id="img-spinner" src="${resource(dir: 'images', file: 'ajax-loader.gif')}" alt="Loading"/>
</div>
<div id="header">

        <g:applyLayout name="headerTopT2dgenes"/>

        <g:applyLayout name="headerBottomT2dgenes"/>

        <g:applyLayout name="notice"/>

</div>
</div>

<g:layoutBody/>
<g:if test="${g.portalTypeString()?.equals('stroke')}">
    <div class="container-fluid dk-stroke-footer"><div class="container">
</g:if>
<g:elseif test="${g.portalTypeString()?.equals('mi')}">
    <div class="container-fluid dk-mi-footer"><div class="container">
</g:elseif>
<g:else>
    <div class="container-fluid dk-t2d-footer"><div class="container">
</g:else>

    <div class="row">
        <div class="col-md-12" style="text-align: center;">
            <div style="padding-top:10px;"><span class="glyphicon glyphicon-comment" style="color:#fff"></span> <a href="${createLink(controller:'informational', action:'contact')}"><g:message code="mainpage.send.feedback"/></a><div>
            <div style="font-size: 10px;"><g:message code="buildInfo.shared.build_message" args="${[BuildInfo?.buildHost, BuildInfo?.buildTime]}"/>.  <g:message code='buildInfo.shared.version'/>=${BuildInfo?.appVersion}.${BuildInfo?.buildNumber}</div>
        </div>
    </div>
        </div></div>

<g:applyLayout name="activatePopups"/>

</body>
</html>