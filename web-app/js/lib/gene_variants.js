

var GeneVariantsView = Backbone.View.extend({

    initialize: function(options) {
        this.gene = options.gene;
        this.variants = options.variants;
        this.filters = options.filters;
    },

    className: "gene-variants-view",

    template: _.template($('#tpl-gene-variants').html()),

    render: function() {
        $(this.el).html(this.template({
            gene: this.gene,
            filters: this.filters,
            variants: this.variants,
        }));
        var variants_view = new VariantTableView({
            variants: this.variants,
        });
        this.$('.variants-container').html(variants_view.render().el);
        return this;
    },

});


$(function() {

    var form = new GeneVariantsView({
        gene: GENE,
        variants: VARIANTS,
        filters: FILTERS,
    });
    $('#gene-variants-container').html(form.render().el);

});