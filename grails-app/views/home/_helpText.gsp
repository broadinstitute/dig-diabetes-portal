<script type="text/javascript">
    $(document).ready(function(){
        $(".pop-top").popover({placement : 'top'});
        $(".pop-right").popover({placement : 'right'});
        $(".pop-bottom").popover({placement : 'bottom'});
        $(".pop-left").popover({ placement : 'left'});
    });
</script>
<div
      style="padding:${qplacer}"
      class="glyphicon glyphicon-question-sign pop-${placement}"
      aria-hidden="true"
      data-toggle="popover"
      animation="true"
      trigger="hover"
      html="true"
      data-container="body"
      data-placement="${placement}"
      title="<g:message code='${title}'/>"
      data-content="<g:message code='${body}'/>"
></div>