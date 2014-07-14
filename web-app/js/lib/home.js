$(function() {

    $('#gene-input').typeahead(
        {
            source: function(query, process) {
                $.get('/autocomplete/gene', {query: query}, function(data) {
                    process(data);
                })
            }
        }
    );

    $('#gene-go').on('click', function() {
        var gene_symbol = $('#gene-input').val();
        window.location.href = '/gene/' + gene_symbol;
    });

    $('#variant-go').on('click', function() {
        var variant_id = $('#variant-input').val();
        window.location.href = '/variant/' + variant_id;
    });

    $('#region-go').on('click', function() {
        var region_str = $('#region-input').val();
        window.location.href = '/region/' + region_str;
    });

    $('#trait-go').on('click', function() {
        var trait_val = $('#trait-input option:selected').val();
        var significance = 0;
        if ($('#id_significance_genomewide').prop('checked')) {
            significance = 5e-8;
        } else {
            significance = $('#custom_significance_input').val();
        }
        if (trait_val == "" || significance == 0) {
            alert('Please choose a trait and enter a valid significance!')
        }
        window.location.href = '/trait-search?trait=' + trait_val + '&significance=' + significance;
    });

});