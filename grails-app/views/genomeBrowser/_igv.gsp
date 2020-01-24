

<script>
    $( document ).ready(function() {
        mpgSoftware.igvInit.setVariable('#igv-div',
            {
                storedGWASData:'${g.createLink(controller: "variantInfo", action: "gwasFile")}',
                retrieveBottomLineVariants:'${g.createLink(controller: "variantInfo", action: "retrieveBottomLineVariants")}',
                rawAPIData:'${createLink(controller: "trait", action: "retrievePotentialIgvTracks")}'
            });
        mpgSoftware.igvInit.igvLaunch('igv-div');

    });
</script>