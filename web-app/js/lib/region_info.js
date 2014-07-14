$(function() {

    var variants_view = new VariantTableView({
        variants: VARIANTS,
        show_gene: true,
    });
    $('#variants-container').html(variants_view.render().el);

});