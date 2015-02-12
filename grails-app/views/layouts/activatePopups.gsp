<style>
    .popover{
        min-width: 400px;
    }
    .popover-title {
        font-size: 14pt;
        font-weight: bold;
        text-align: left;
    }
    .popover-content {
        font-size: 12pt;
        max-width: 500px;
    }



</style>
<script>
    $(function () {
        $('[data-toggle="tooltip"]').tooltip({
            delay: { show: 300, hide: 0 },
            animation: true,
            html: true
        });
        $('[data-toggle="popover"]').popover({
            animation: true,
            html: true,
            placement: 'auto top',
            title: 'Note:',
            template: '<div class="popover" role="tooltip"><div class="arrow"></div><h5 class="popover-title"></h5><div class="popover-content"></div></div>'
        });
    });
</script>