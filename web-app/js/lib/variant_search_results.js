

var VariantSearchResultsView = Backbone.View.extend({

    initialize: function(options) {
        this.variants = options.variants;
        this.filters = options.filters;
        this.show_exseq = options.show_exseq || false;
        this.show_exchp = options.show_exchp || false;
        this.show_gwas = options.show_gwas || false;
        this.show_sigma = options.show_sigma || false;
    },

    className: "variant-search-results-view",

    template: _.template($('#tpl-variant-search-results').html()),

    render: function() {
        $(this.el).html(this.template({
            filters: this.filters,
            variants: this.variants,
            goback_link: '/variantsearch' + window.location.search,
        }));
        var variants_view = new VariantTableView({
            variants: this.variants,
            show_gene: true,
            show_exseq: this.show_exseq,
            show_exchp: this.show_exchp,
            show_gwas: this.show_gwas,
            show_sigma: this.show_sigma,
        });
        this.$('.variants-container').html(variants_view.render().el);
        return this;
    },

});


$(function() {

    var view = new VariantSearchResultsView({
        variants: VARIANTS,
        filters: FILTERS,
        show_sigma: SITE_VERSION == 'sigma', 
        show_exseq: SITE_VERSION == 't2dgenes', 
        show_exchp: SITE_VERSION == 't2dgenes', 
        show_gwas: true, 
    });
    $('#variant-search-results-container').html(view.render().el);

});