<%--
  Created by IntelliJ IDEA.
  User: ben
  Date: 8/23/2014
  Time: 5:09 PM
--%>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="core"/>
    <r:require modules="core"/>
    <r:layoutResources/>

    <script>

    var encodedUsers = decodeURIComponent("<%=encodedUsers%>");
    console.log('encodedUsers='+encodedUsers+'.');
    var listOfUsers = [];
    if ((typeof encodedUsers !== 'undefined')  &&
        (encodedUsers.length > 0)){
        var listOfUserData =  encodedUsers.split ('~') ;
        if ((listOfUserData) &&
            (listOfUserData.length > 0)) {
            for ( var i = 0 ; i < listOfUserData.length ; i++ )  {
                var listOfFields = listOfUserData[i].split (':');
                if (listOfFields.length > 2) {
                    listOfUsers.push(
                            {'name':listOfFields[0],
                             'enabled':(listOfFields[1]==='T'),
                             'expired':(listOfFields[2]==='T')
                            } )
                }
           }

        }
        console.log('encodedUsers='+encodedUsers+'.');
    }

    </script>

</head>

<body>
<script>
</script>


<div id="main">

    <div class="container" >

        <div class="variant-info-container" >
            <div class="variant-info-view" >

                <g:render template="displayUsers" />


            </div>

        </div>
    </div>

</div>
<script>
    var fillUserTable =  function ( userData,
                                    variantRootUrl,
                                    geneRootUrl) {
        var retVal = "";

        if (!userData) {   // error condition
            return;
        }
        for (var i = 0; i < userData.length; i++) {

            var user = userData[i];

            retVal += "<tr>"

            // username
            retVal += "<td>" + user.name + "</td>";
            //"<td><a href='" + geneRootUrl + "/" + vRec[i].CLOSEST_GENE + "' class='boldlink'>" + vRec[i].CLOSEST_GENE + "</td>";

            // expired
            if (user.expired) {
                retVal += "<td>expired</td>";
            } else {
                retVal += "<td>active</td>";
            }

            // enabled
            if (user.enabled) {
                retVal += "<td>enabled</td>";
            } else {
                retVal += "<td>not enabled</td>"
            }
            retVal += "</tr>";

        }
        return  retVal;
    };
    var constructUserTable =  function (data)  {
        $('#userTableBody').append(fillUserTable(data,
                '<g:createLink controller="variant" action="variantInfo" />',
                '<g:createLink controller="gene" action="geneInfo" />'));

        $('#userTable').dataTable({
            iDisplayLength: 20,
            bFilter: false,
            aaSorting: [[ 0, "asc" ]],
            aoColumnDefs: [{ sType: "allnumeric", aTargets: [] } ]
        });
        console.log('constructed userTable Fields');
    } ;
    if ((typeof listOfUsers !== 'undefined'))  {
        constructUserTable(listOfUsers) ;
    }
</script>
</body>
</html>

