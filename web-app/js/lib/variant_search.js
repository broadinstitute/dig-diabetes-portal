

var VariantSearchForm = Backbone.View.extend({

    initialize: function(options) {
        this.filters = options.filters;
        this.phenotypes = options.phenotypes;
        this.ethnicities = options.ethnicities;

        this.show_exseq = options.show_exseq;
        this.show_exchp = options.show_exchp;
        this.show_gwas = options.show_gwas;
        this.show_sigma = options.show_sigma;

        // unfortunately this is needed so we know which fields to use for "only cases" or "only controls"
        // ideally we could parametrize everything so this is permissions based
        this.site_version = options.site_version;
    },

    className: "variant-search-form",

    template: _.template($('#tpl-variant-search').html()),

    events: {
        "click #variant-search-go": "run_search",
    },

    render: function() {
        var that = this;
        $(this.el).html(this.template({
            phenotypes: this.phenotypes,
            ethnicities: this.ethnicities,

            show_exseq: this.show_exseq,
            show_exchp: this.show_exchp,
            show_gwas: this.show_gwas,
            show_sigma: this.show_sigma,
        }));
        this.$('input[name="function"]').on('click', function(e) {
            if ($(e.target).val() == 'missense') {
                that.$('#missense-options').show();
            } else {
                that.$('#missense-options').hide();
            }
        });
        if (this.filters) {
            this.populate_dom_from_filters(this.filters);
        }
        return this;
    },

    get_filters: function() {
        var that = this;
        var filters = [];

        // datatypes
        var datatype_operand = '';
        if (this.$('#id_datatype_exomeseq').prop('checked')) {
            datatype_operand = '_13k_T2D_P_EMMAX_FE_IV';
            filters.push({
                filter_type: 'STRING',
                operand: 'IN_EXSEQ',
                operator: 'EQ',
                value: "1",
            });
        }
        else if (this.$('#id_datatype_exomechip').prop('checked')) {
            datatype_operand = 'EXCHP_T2D_P_value';
            filters.push({
                filter_type: 'STRING',
                operand: 'IN_EXCHP',
                operator: 'EQ',
                value: "1",
            });
        }
        else if (this.$('#id_datatype_gwas').prop('checked')) {
            datatype_operand = 'GWAS_T2D_PVALUE';
            filters.push({
                filter_type: 'FLOAT',
                operand: 'GWAS_T2D_PVALUE',
                operator: 'GTE',
                value: 0,
            });
        }
        else if (this.$('#id_datatype_sigma').prop('checked')) {
            datatype_operand = 'SIGMA_T2D_P';
            filters.push({
                filter_type: 'FLOAT',
                operand: 'SIGMA_T2D_P',
                operator: 'GTE',
                value: 0,
            });
        }

        // region
        if (this.$('#region_gene_input').val() != '') {
            filters.push({
                filter_type: 'STRING',
                operand: 'IN_GENE',
                operator: 'EQ',
                value: this.$('#region_gene_input').val(),
            })
        }
        if (this.$('#region_chrom_input').val() != '') {
            filters.push({
                filter_type: 'STRING',
                operand: 'CHROM',
                operator: 'EQ',
                value: this.$('#region_chrom_input').val(),
            })
        }
        if (this.$('#region_start_input').val() != '') {
            filters.push({
                filter_type: 'STRING',
                operand: 'POS',
                operator: 'GTE',
                value: this.$('#region_start_input').val(),
            })
        }
        if (this.$('#region_stop_input').val() != '') {
            filters.push({
                filter_type: 'STRING',
                operand: 'POS',
                operator: 'LTE',
                value: this.$('#region_stop_input').val(),
            })
        }

        // t2d significance
        var significance = 0;
        if (this.$('#id_significance_genomewide').prop('checked')) {
            significance = 5e-8;
        } else if (this.$('#id_significance_nominal').prop('checked')) {
            significance = .05;
        } else if (this.$('#id_significance_custom').prop('checked')) {
            significance = parseFloat(this.$('#custom_significance_input').val());
        }
        if (significance > 0) {
            filters.push({
                filter_type: 'FLOAT',
                operand: datatype_operand,
                operator: 'LTE',
                value: significance,
            });
        }

        // ethnicities
        _.each(this.ethnicities, function(e) {

            // is there a minimum freq? if so add filter
            var min_str = that.$('#ethnicity_af_' + e.key + '-min').val();
            if (min_str != "" && min_str != undefined) {
                filters.push({
                    filter_type: 'FLOAT',
                    operand: '_13k_T2D_' + e.small_key + '_MAF',
                    operator: 'GTE',
                    value: parseFloat(min_str),
                });
            }

            // is there a maximum freq? if so add filter
            var max_str = that.$('#ethnicity_af_' + e.key + '-max').val();
            if (max_str != "" && max_str != undefined) {
                filters.push({
                    filter_type: 'FLOAT',
                    operand: '_13k_T2D_' + e.small_key + '_MAF',
                    operator: 'LTE',
                    value: parseFloat(max_str),
                });
            }

        });
        // frequencies for sigma
        // todo: SIGMA should probably be parametrized as another population 
        // (we should probably use "population" here instead of "ethinicity")
        var min_str = that.$('#ethnicity_af_sigma-min').val();
        if (min_str != "" && min_str != undefined) {
            filters.push({
                filter_type: 'FLOAT',
                operand: 'SIGMA_T2D_MAF',
                operator: 'GTE',
                value: parseFloat(min_str),
            });
        }

        // is there a maximum freq? if so add filter
        var max_str = that.$('#ethnicity_af_sigma-max').val();
        if (max_str != "" && max_str != undefined) {
            filters.push({
                filter_type: 'FLOAT',
                operand: 'SIGMA_T2D_MAF',
                operator: 'LTE',
                value: parseFloat(max_str),
            });
        }


        // predictions
        if (that.$('#protein_truncating_checkbox').prop('checked')) {
            filters.push({
                filter_type: 'FLOAT',  // note that we send MOST_DEL_SCORE filters as a float, not string
                operand: 'MOST_DEL_SCORE',
                operator: 'EQ',
                value: 1,
            });
        }
        if (that.$('#missense_checkbox').prop('checked')) {
            filters.push({
                filter_type: 'FLOAT',
                operand: 'MOST_DEL_SCORE',
                operator: 'EQ',
                value: 2,
            });

            // only consider these functional effects if missense is checked
            if (that.$('#polyphen_select').val() != "") {
                filters.push({
                    filter_type: 'STRING',
                    operand: 'PolyPhen_PRED',
                    operator: 'EQ',
                    value: that.$('#polyphen_select').val(),
                });
            }
            if (that.$('#condel_select').val() != "") {
                filters.push({
                    filter_type: 'STRING',
                    operand: 'Condel_PRED',
                    operator: 'EQ',
                    value: that.$('#condel_select').val(),
                });
            }
            if (that.$('#sift_select').val() != "") {
                filters.push({
                    filter_type: 'STRING',
                    operand: 'SIFT_PRED',
                    operator: 'EQ',
                    value: that.$('#sift_select').val(),
                });
            }
        }
        if (that.$('#synonymous_checkbox').prop('checked')) {
            filters.push({
                filter_type: 'FLOAT',
                operand: 'MOST_DEL_SCORE',
                operator: 'EQ',
                value: 3,
            });
        }
        if (that.$('#noncoding_checkbox').prop('checked')) {
            filters.push({
                filter_type: 'FLOAT',
                operand: 'MOST_DEL_SCORE',
                operator: 'EQ',
                value: 4,
            });
        }

        // only seen
        if (that.$('#id_onlyseen_t2dcases').prop('checked')) {
            filters.push({
                filter_type: 'FLOAT',
                operand: that.site_version == 't2dgenes' ? '_13k_T2D_MINU' : 'SIGMA_T2D_MINU',
                operator: 'EQ',
                value: 0,
            })
        }

        if (that.$('#id_onlyseen_t2dcontrols').prop('checked')) {
            filters.push({
                filter_type: 'FLOAT',
                operand: that.site_version == 't2dgenes' ? '_13k_T2D_MINA' : 'SIGMA_T2D_MINA',
                operator: 'EQ',
                value: 0,
            })
        }

        if (that.$('#id_onlyseen_homozygotes').prop('checked')) {
            filters.push({
                filter_type: 'FLOAT',
                operand: '_13k_T2D_HOM',
                operator: 'GT',
                value: 0,
            })
        }

        return filters;
    },

    populate_dom_from_filters: function(filters) {
        var that = this;

        var values = filters.get_values_map();

        // datatype section
        var datatype = filters.get_datatype();
        if (datatype == 'exseq') {
            this.$('#id_datatype_exomeseq').prop('checked', true);
        }
        if (datatype == 'exchp') {
            this.$('#id_datatype_exomechip').prop('checked', true);
        }
        if (datatype == 'gwas') {
            this.$('#id_datatype_gwas').prop('checked', true);
        }

        // region section
        if (values.IN_GENE) {
            this.$('#region_gene_input').val(values.IN_GENE);
        }
        if (values.CHROM) {
            this.$('#region_chrom_input').val(values.CHROM);
        }
        var start_filter = that.filters.find(function(f){
            return f.get('operand') == 'POS' && f.get('operator') == 'GTE';
        });
        if (start_filter) {
            that.$('#region_start_input').val(start_filter.get('value'));
        }
        var stop_filter = that.filters.find(function(f){
            return f.get('operand') == 'POS' && f.get('operator') == 'LTE';
        });
        if (stop_filter) {
            that.$('#region_stop_input').val(stop_filter.get('value'));
        }

        // significance section
        var datatype_operand = '_13k_T2D_P_EMMAX_FE_IV';
        if (datatype == 'exchp') {
            datatype_operand = 'EXCHP_T2D_P_value';
        }
        else if (datatype == 'gwas') {
            datatype_operand = 'GWAS_T2D_PVALUE';
        }

        if (values[datatype_operand] == 5e-8) {
            this.$('#id_significance_genomewide').prop('checked', true);
        }
        else if (values[datatype_operand] == 5e-2) {
            this.$('#id_significance_nominal').prop('checked', true);
        }
        else if (values[datatype_operand]) {
            this.$('#id_significance_custom').prop('checked', true);
            this.$('#custom_significance_input').val(values[datatype_operand]);
        }

        // frequencies
        _.each(this.ethnicities, function(e) {
            var min_filter = that.filters.find(function(f){
                return f.get('operand') == '_13k_T2D_' + e.small_key + '_MAF' && f.get('operator') == 'GTE';
            });
            if (min_filter) {
                that.$('#ethnicity_af_' + e.key + '-min').val(min_filter.get('value'));
            }

            var max_filter = that.filters.find(function(f){
                return f.get('operand') == '_13k_T2D_' + e.small_key + '_MAF' && f.get('operator') == 'LTE';
            });
            if (max_filter) {
                that.$('#ethnicity_af_' + e.key + '-max').val(max_filter.get('value'));
            }
        });
        // frequencies for sigma
        var min_filter = that.filters.find(function(f){
            return f.get('operand') == 'SIGMA_T2D_MAF' && f.get('operator') == 'GTE';
        });
        if (min_filter) {
            that.$('#ethnicity_af_sigma-min').val(max_filter.get('value'));
        }

        var max_filter = that.filters.find(function(f){
            return f.get('operand') == 'SIGMA_T2D_MAF' && f.get('operator') == 'LTE';
        });
        if (max_filter) {
            that.$('#ethnicity_af_sigma-max').val(max_filter.get('value'));
        }

        // biological function
        if (values.MOST_DEL_SCORE == '1') {
            this.$('#protein_truncating_checkbox').prop('checked', true);
        }
        else if (values.MOST_DEL_SCORE == '2') {
            this.$('#missense_checkbox').prop('checked', true);
            this.$('#missense-options').show();
        }
        else if (values.MOST_DEL_SCORE == '3') {
            this.$('#synonymous_checkbox').prop('checked', true);
        }
        else if (values.MOST_DEL_SCORE == '4') {
            this.$('#noncoding_checkbox').prop('checked', true);
        }

        if (values.PolyPhen_PRED) {
            this.$('#polyphen_select').val(values.PolyPhen_PRED);
        }
        if (values.SIFT_PRED) {
            this.$('#sift_select').val(values.SIFT_PRED);
        }
        if (values.Condel_PRED) {
            this.$('#condel_select').val(values.Condel_PRED);
        }

        if (values._13k_T2D_MINU == 0) {
            this.$('#id_onlyseen_t2dcases').prop('checked', true);
        }
        if (values._13k_T2D_MINA == 0) {
            this.$('#id_onlyseen_t2dcontrols').prop('checked', true);
        }
    },

    set_significance: function(significance) {
        if (significance == 5e-8) {
            this.$('#id_significance_genomewide').prop('checked', true);
        } else if (significance == .05) {
            this.$('#id_significance_nominal').prop('checked', true);
        } else {
            this.$('#id_significance_custom').prop('checked', true);
            this.$('#custom_significance_input').val(significance);
        }
    },

    run_search: function(e) {
        e.preventDefault();  // override standard form submit
        var filters = this.get_filters();
        var filters_input = $('<input type="hidden" name="filters_json" value="' + encodeURI(JSON.stringify(filters)) + '" />');
        this.$('#dummy-form').append(filters_input);
        this.$('#dummy-form').submit()
    },

});


$(function() {

    var form = new VariantSearchForm({
        phenotypes: CONSTANTS.phenotypes,
        ethnicities: CONSTANTS.ethnicities,
        filters: FILTERS,
        site_version: SITE_VERSION,

        show_exseq: SITE_VERSION == 't2dgenes',
        show_exchp: SITE_VERSION == 't2dgenes',
        show_gwas: true,
        show_sigma: SITE_VERSION == 'sigma',        
    });
    $('#variant-search-container').html(form.render().el);

});