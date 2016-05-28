<%--
  Created by IntelliJ IDEA.
  User: ben
  Date: 8/23/2014
  Time: 5:09 PM
--%>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:layoutResources/>

    <script>

        var encodedSessionList = decodeURIComponent("<%=encodedSessionList%>");
        console.log('encodedUsers='+encodedSessionList+'.');
        var listOfUserSessions = [];
        if ((typeof encodedSessionList !== 'undefined')  &&
                (encodedSessionList.length > 0)){
            var listOfUserSessionData =  encodedSessionList.split ('~') ;
            if ((listOfUserSessionData) &&
                    (listOfUserSessionData.length > 0)) {
                for ( var i = 0 ; i < listOfUserSessionData.length ; i++ )  {
                    var listOfFields = listOfUserSessionData[i].split ('#');
                    if (listOfFields.length > 3) {
                        listOfUserSessions.push(
                                {'name':listOfFields[0],
                                    'startSession':listOfFields[1],
                                    'endSession':listOfFields[2],
                                    'remoteAddress':listOfFields[3],
                                    'dataField':listOfFields[4]
                                } )
                    }
                }

            }
            console.log('encodedUsers='+encodedSessionList+'.');
        }

    </script>

</head>

<body>
<script>
    var fillUserSessionTable =  function ( userSessionData) {
        var retVal = "";

        if (!userSessionData) {   // error condition
            return;
        }
        for (var i = 0; i < userSessionData.length; i++) {

            var userSession = userSessionData[i];

            retVal += "<tr>"

            // username
            retVal += "<td>"+ userSession.name + "</td>";
            var replacePeriodsInUsername =  encodeURIComponent(userSession.name.replace(/\./g, '&#46;')) ;

            //date 1
            var startSessionString =  userSession.startSession.replace(/\+/g, ' ') ;
            retVal += "<td>"+startSessionString+"</td>";
            retVal += "<td>"+userSession.endSession+"</td>";
            retVal += "<td>"+userSession.remoteAddress+"</td>";
            retVal += "<td>"+userSession.dataField+"</td>";

            // password expired
//            if (user.expired) {
//                retVal += "<td><a href='" + autoPasswordUnexpireUrl + "/" + replacePeriodsInUsername + "' class='boldlink'>expired</a></td>";
//            } else {
//                retVal += "<td><a href='" + autoPasswordExpireUrl + "/" + replacePeriodsInUsername + "' class='boldlink'>active</a></td>";
//            }

            retVal += "</tr>";

        }
        return  retVal;
    };
    var constructUserTable =  function (data)  {
        $('#userSessionsTable').append(fillUserSessionTable(data));


        $('#userTable').dataTable({
            pageLength: 20,
            filter: false,
            order: [[ 0, "asc" ]],
            columnDefs: [{ type: "allnumeric", targets: [] } ]
        });
        console.log('constructed userTable Fields');
    } ;
    $( document ).ready(function() {
        if ((typeof listOfUserSessions !== 'undefined')) {
            constructUserTable(listOfUserSessions);
        }
        ;
    });
</script>


<div id="main">

    <div class="container">

        <div class="dport-template">
            <div class="dport-template-view">

                <div class="row">
                    <div class="col-md-4"><h1><g:message code="users.admin.edit"/></h1></div>

                    <div class="col-md-8"></div>
                </div>

                <div class="row">
                    <div class="col-md-2"></div>

                    <div class="col-md-10">

                        <g:if test="${flash.message}">
                            <div class="message" role="status">${flash.message}</div>
                        </g:if>

                    </div>
                </div>

                <div class="row">
                    <div class="col-md-2"></div>

                    <div class="col-md-10">

                        <g:hasErrors bean="${userInstance}">
                            <ul class="errors" role="alert">
                                <g:eachError bean="${userInstance}" var="error">
                                    <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message
                                            error="${error}"/></li>
                                </g:eachError>
                            </ul>
                        </g:hasErrors>

                    </div>
                </div>


                <g:form url="[resource: userInstance, action: 'update']" method="PUT" >
                    <g:hiddenField name="version" value="${userInstance?.version}" />

                    <div class="row">

                        <div class="col-md-2"></div>

                        <div class="col-md-10">


                            <fieldset class="form">
                                <g:render template="userContents"/>
                            </fieldset>



                        </div>


                    </div>

                    <div class="row adminform">

                        <div class="col-md-6"></div>

                        <div class="col-md-4">


                            <fieldset class="buttons">
                                <g:actionSubmit class="save btn btn-lg btn-primary pull-right"   action="update"
                                                value="Update"/>
                            </fieldset>


                        </div>

                        <div class="col-md-2"></div>
                    </div>


                </g:form>


                <div class="row adminform">

                    <div class="col-xs-12">

                        <table id="userSessionsTable" class="table table-striped basictable">
                            <thead>
                            <tr>
                                <th><g:message code="users.admin.user"/></th>
                                <th><g:message code="users.attributes.startSession"/></th>
                                <th><g:message code="users.attributes.endSession"/></th>
                                <th><g:message code="users.attributes.remoteAddress"/></th>
                                <th><g:message code="users.attributes.dataField"/></th>
                            </tr>
                            </thead>
                            <tbody id="userSessionsBody">
                            </tbody>
                        </table>

                    </div>


                </div>




            </div>
        </div>

    </div>
</div>
</body>
</html>
