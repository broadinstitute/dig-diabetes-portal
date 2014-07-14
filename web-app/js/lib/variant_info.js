

var VariantInfoView = Backbone.View.extend({

    initialize: function(options) {
        this.variant = options.variant;
        this.ethnicities = options.ethnicities;
        this.phenotypes = options.phenotypes;
        this.so_consequences = options.so_consequences;

        // use all 4 params for consistency, but in practice we just use show_exseq as a proxy for all the sigma fields
        this.show_exseq = options.show_exseq;
        this.show_exchp = options.show_exchp;
        this.show_gwas = options.show_gwas;
        this.show_sigma = options.show_sigma;
    },

    className: "variant-info-view",

    template: _.template($('#tpl-variant-info').html()),

    events: {
        "click .transcript-radio": "show_transcript_click",
    },

    render: function() {
        var that = this;
        $(this.el).html(this.template({
            variant: this.variant,
            ethnicities: this.ethnicities,
            phenotypes: this.phenotypes,
            so_consequences: this.so_consequences,

            show_exseq: this.show_exseq,
            show_exchp: this.show_exchp,
            show_gwas: this.show_gwas,
            show_sigma: this.show_sigma,

        }));
        for (var k in this.variant._13k_T2D_TRANSCRIPT_ANNOT) {
            that.show_transcript(k);
            break;
        }
        return this;
    },

    show_transcript_click: function(e) {
        var transcript_id = $(e.target).val();
        this.show_transcript(transcript_id);
    },

    show_transcript: function(transcript_id) {
        this.$('.transcript-annotation').hide();
        this.$('input[name="transcript_check"][value="' + transcript_id + '"]').prop('checked', true);
        this.$('.transcript-annotation[data-transcript_id="' + transcript_id + '"]').show();
    },

});


$(function() {

    var view = new VariantInfoView({
        variant: VARIANT,
        ethnicities: CONSTANTS.ethnicities,
        phenotypes: CONSTANTS.gwas_phenotypes,
        so_consequences: CONSTANTS.so_consequences,
        show_exseq: SITE_VERSION == 't2dgenes',
        show_exchp: SITE_VERSION == 't2dgenes',
        show_gwas: true,
        show_sigma: SITE_VERSION == 'sigma',
    });
    $('#variant-info-container').html(view.render().el);

});