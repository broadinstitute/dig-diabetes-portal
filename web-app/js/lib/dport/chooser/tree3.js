(function() {
    var root;

    root = typeof window !== "undefined" && window !== null ? window : global;

    root.tree = [
        {
            'name': 'ExSeq_13k',
            'version': 'v1',
            'technology': 'ExSeq',
            'sample_groups': [
                {
                    'name': '13k',
                    'id': 'ExSeq_13k_v1',
                    'properties': [
                        {
                            'name': 'EAF',
                            'type': 'FLOAT'
                        }, {
                            'name': 'MAC',
                            'type': 'INTEGER'
                        }, {
                            'name': 'MAF',
                            'type': 'FLOAT'
                        }, {
                            'name': 'F_MISS',
                            'type': 'FLOAT'
                        }, {
                            'name': 'QCFAIL',
                            'type': 'INTEGER'
                        }, {
                            'name': 'O_R',
                            'type': 'FLOAT'
                        }, {
                            'name': 'P',
                            'type': 'FLOAT'
                        }
                    ],
                    'phenotypes': [
                        {
                            'name': 'T2D',
                            'properties': [
                                {
                                    'name': 'HETA',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'HETU',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'HOMA',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'HOMU',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'MINA',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'MINU',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'OBSA',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'OBSU',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'OR_WALD_DOS_FE_IV',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'P_EMMAX_FE_IV',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'SE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }
                    ],
                    'sample_groups': [
                        {
                            'name': '13k_ea_genes',
                            'id': 'ExSeq_13k_ea_genes_v1',
                            'properties': [
                                {
                                    'name': 'EAF',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'MAC',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'MAF',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'F_MISS',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'QCFAIL',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'O_R',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'P',
                                    'type': 'FLOAT'
                                }
                            ],
                            'phenotypes': [
                                {
                                    'name': 'T2D',
                                    'properties': [
                                        {
                                            'name': 'HETA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'HETU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'HOMA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'HOMU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'MINA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'MINU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'OBSA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'OBSU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'OR_WALD_DOS_FE_IV',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'P_EMMAX_FE_IV',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'SE',
                                            'type': 'FLOAT'
                                        }
                                    ]
                                }
                            ],
                            'sample_groups': []
                        }, {
                            'name': '13k_aa_genes',
                            'id': 'ExSeq_13k_aa_genes_v1',
                            'properties': [
                                {
                                    'name': 'EAF',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'MAC',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'MAF',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'F_MISS',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'QCFAIL',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'O_R',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'P',
                                    'type': 'FLOAT'
                                }
                            ],
                            'phenotypes': [
                                {
                                    'name': 'T2D',
                                    'properties': [
                                        {
                                            'name': 'HETA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'HETU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'HOMA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'HOMU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'MINA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'MINU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'OBSA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'OBSU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'OR_WALD_DOS_FE_IV',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'P_EMMAX_FE_IV',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'SE',
                                            'type': 'FLOAT'
                                        }
                                    ]
                                }
                            ],
                            'sample_groups': []
                        }, {
                            'name': '13k_eu',
                            'id': 'ExSeq_13k_eu_v1',
                            'properties': [
                                {
                                    'name': 'EAF',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'MAC',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'MAF',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'F_MISS',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'QCFAIL',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'O_R',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'P',
                                    'type': 'FLOAT'
                                }
                            ],
                            'phenotypes': [
                                {
                                    'name': 'T2D',
                                    'properties': [
                                        {
                                            'name': 'HETA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'HETU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'HOMA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'HOMU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'MINA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'MINU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'OBSA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'OBSU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'OR_WALD_DOS_FE_IV',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'P_EMMAX_FE_IV',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'SE',
                                            'type': 'FLOAT'
                                        }
                                    ]
                                }
                            ],
                            'sample_groups': [
                                {
                                    'name': '13k_eu_genes',
                                    'id': 'ExSeq_13k_eu_genes_v1',
                                    'properties': [
                                        {
                                            'name': 'EAF',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'MAC',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'MAF',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'F_MISS',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'QCFAIL',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'O_R',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'P',
                                            'type': 'FLOAT'
                                        }
                                    ],
                                    'phenotypes': [
                                        {
                                            'name': 'T2D',
                                            'properties': [
                                                {
                                                    'name': 'HETA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HETU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HOMA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HOMU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MINA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MINU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OBSA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OBSU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OR_WALD_DOS_FE_IV',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'P_EMMAX_FE_IV',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'SE',
                                                    'type': 'FLOAT'
                                                }
                                            ]
                                        }
                                    ],
                                    'sample_groups': []
                                }, {
                                    'name': '13k_eu_go',
                                    'id': 'ExSeq_13k_eu_go_v1',
                                    'properties': [
                                        {
                                            'name': 'EAF',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'MAC',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'MAF',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'F_MISS',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'QCFAIL',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'O_R',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'P',
                                            'type': 'FLOAT'
                                        }
                                    ],
                                    'phenotypes': [
                                        {
                                            'name': 'T2D',
                                            'properties': [
                                                {
                                                    'name': 'HETA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HETU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HOMA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HOMU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MINA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MINU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OBSA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OBSU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OR_WALD_DOS_FE_IV',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'P_EMMAX_FE_IV',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'SE',
                                                    'type': 'FLOAT'
                                                }
                                            ]
                                        }
                                    ],
                                    'sample_groups': []
                                }
                            ]
                        }, {
                            'name': '13k_sa_genes',
                            'id': 'ExSeq_13k_sa_genes_v1',
                            'properties': [
                                {
                                    'name': 'EAF',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'MAC',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'MAF',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'F_MISS',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'QCFAIL',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'O_R',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'P',
                                    'type': 'FLOAT'
                                }
                            ],
                            'phenotypes': [
                                {
                                    'name': 'T2D',
                                    'properties': [
                                        {
                                            'name': 'HETA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'HETU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'HOMA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'HOMU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'MINA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'MINU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'OBSA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'OBSU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'OR_WALD_DOS_FE_IV',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'P_EMMAX_FE_IV',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'SE',
                                            'type': 'FLOAT'
                                        }
                                    ]
                                }
                            ],
                            'sample_groups': []
                        }, {
                            'name': '13k_hs_genes',
                            'id': 'ExSeq_13k_hs_genes_v1',
                            'properties': [
                                {
                                    'name': 'EAF',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'MAC',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'MAF',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'F_MISS',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'QCFAIL',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'O_R',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'P',
                                    'type': 'FLOAT'
                                }
                            ],
                            'phenotypes': [
                                {
                                    'name': 'T2D',
                                    'properties': [
                                        {
                                            'name': 'HETA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'HETU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'HOMA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'HOMU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'MINA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'MINU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'OBSA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'OBSU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'OR_WALD_DOS_FE_IV',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'P_EMMAX_FE_IV',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'SE',
                                            'type': 'FLOAT'
                                        }
                                    ]
                                }
                            ],
                            'sample_groups': []
                        }
                    ]
                }
            ]
        }, {
            'name': 'ExSeq_26k',
            'version': 'v2',
            'technology': 'ExSeq',
            'sample_groups': [
                {
                    'name': '26k',
                    'id': 'ExSeq_26k_v2',
                    'properties': [
                        {
                            'name': 'EAF',
                            'type': 'FLOAT'
                        }, {
                            'name': 'MAC',
                            'type': 'INTEGER'
                        }, {
                            'name': 'MAF',
                            'type': 'FLOAT'
                        }, {
                            'name': 'F_MISS',
                            'type': 'FLOAT'
                        }, {
                            'name': 'QCFAIL',
                            'type': 'INTEGER'
                        }, {
                            'name': 'O_R',
                            'type': 'FLOAT'
                        }, {
                            'name': 'P',
                            'type': 'FLOAT'
                        }
                    ],
                    'phenotypes': [
                        {
                            'name': 'T2D',
                            'properties': [
                                {
                                    'name': 'HETA',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'HETU',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'HOMA',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'HOMU',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'MINA',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'MINU',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'OBSA',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'OBSU',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'OR_WALD_DOS_FE_IV',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'P_EMMAX_FE_IV',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'SE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }
                    ],
                    'sample_groups': [
                        {
                            'name': '26k_sa_genes',
                            'id': 'ExSeq_26k_sa_genes_v2',
                            'properties': [
                                {
                                    'name': 'EAF',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'MAC',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'MAF',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'F_MISS',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'QCFAIL',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'O_R',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'P',
                                    'type': 'FLOAT'
                                }
                            ],
                            'phenotypes': [
                                {
                                    'name': 'T2D',
                                    'properties': [
                                        {
                                            'name': 'HETA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'HETU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'HOMA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'HOMU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'MINA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'MINU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'OBSA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'OBSU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'OR_WALD_DOS_FE_IV',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'P_EMMAX_FE_IV',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'SE',
                                            'type': 'FLOAT'
                                        }
                                    ]
                                }
                            ],
                            'sample_groups': [
                                {
                                    'name': '26k_sa_genes_sl',
                                    'id': 'ExSeq_26k_sa_genes_sl_v2',
                                    'properties': [
                                        {
                                            'name': 'EAF',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'MAC',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'MAF',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'F_MISS',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'QCFAIL',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'O_R',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'P',
                                            'type': 'FLOAT'
                                        }
                                    ],
                                    'phenotypes': [
                                        {
                                            'name': 'T2D',
                                            'properties': [
                                                {
                                                    'name': 'HETA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HETU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HOMA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HOMU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MINA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MINU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OBSA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OBSU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OR_WALD_DOS_FE_IV',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'P_EMMAX_FE_IV',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'SE',
                                                    'type': 'FLOAT'
                                                }
                                            ]
                                        }
                                    ],
                                    'sample_groups': []
                                }, {
                                    'name': '26k_sa_genes_ss',
                                    'id': 'ExSeq_26k_sa_genes_ss_v2',
                                    'properties': [
                                        {
                                            'name': 'EAF',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'MAC',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'MAF',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'F_MISS',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'QCFAIL',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'O_R',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'P',
                                            'type': 'FLOAT'
                                        }
                                    ],
                                    'phenotypes': [
                                        {
                                            'name': 'T2D',
                                            'properties': [
                                                {
                                                    'name': 'HETA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HETU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HOMA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HOMU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MINA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MINU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OBSA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OBSU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OR_WALD_DOS_FE_IV',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'P_EMMAX_FE_IV',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'SE',
                                                    'type': 'FLOAT'
                                                }
                                            ]
                                        }
                                    ],
                                    'sample_groups': []
                                }
                            ]
                        }, {
                            'name': '26k_ea_genes',
                            'id': 'ExSeq_26k_ea_genes_v2',
                            'properties': [
                                {
                                    'name': 'EAF',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'MAC',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'MAF',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'F_MISS',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'QCFAIL',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'O_R',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'P',
                                    'type': 'FLOAT'
                                }
                            ],
                            'phenotypes': [
                                {
                                    'name': 'T2D',
                                    'properties': [
                                        {
                                            'name': 'HETA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'HETU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'HOMA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'HOMU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'MINA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'MINU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'OBSA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'OBSU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'OR_WALD_DOS_FE_IV',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'P_EMMAX_FE_IV',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'SE',
                                            'type': 'FLOAT'
                                        }
                                    ]
                                }
                            ],
                            'sample_groups': [
                                {
                                    'name': '26k_ea_genes_es',
                                    'id': 'ExSeq_26k_ea_genes_es_v2',
                                    'properties': [
                                        {
                                            'name': 'EAF',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'MAC',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'MAF',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'F_MISS',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'QCFAIL',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'O_R',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'P',
                                            'type': 'FLOAT'
                                        }
                                    ],
                                    'phenotypes': [
                                        {
                                            'name': 'T2D',
                                            'properties': [
                                                {
                                                    'name': 'HETA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HETU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HOMA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HOMU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MINA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MINU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OBSA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OBSU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OR_WALD_DOS_FE_IV',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'P_EMMAX_FE_IV',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'SE',
                                                    'type': 'FLOAT'
                                                }
                                            ]
                                        }
                                    ],
                                    'sample_groups': []
                                }, {
                                    'name': '26k_ea_genes_ek',
                                    'id': 'ExSeq_26k_ea_genes_ek_v2',
                                    'properties': [
                                        {
                                            'name': 'EAF',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'MAC',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'MAF',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'F_MISS',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'QCFAIL',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'O_R',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'P',
                                            'type': 'FLOAT'
                                        }
                                    ],
                                    'phenotypes': [
                                        {
                                            'name': 'T2D',
                                            'properties': [
                                                {
                                                    'name': 'HETA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HETU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HOMA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HOMU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MINA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MINU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OBSA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OBSU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OR_WALD_DOS_FE_IV',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'P_EMMAX_FE_IV',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'SE',
                                                    'type': 'FLOAT'
                                                }
                                            ]
                                        }
                                    ],
                                    'sample_groups': []
                                }
                            ]
                        }, {
                            'name': '26k_eu',
                            'id': 'ExSeq_26k_eu_v2',
                            'properties': [
                                {
                                    'name': 'EAF',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'MAC',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'MAF',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'F_MISS',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'QCFAIL',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'O_R',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'P',
                                    'type': 'FLOAT'
                                }
                            ],
                            'phenotypes': [
                                {
                                    'name': 'T2D',
                                    'properties': [
                                        {
                                            'name': 'HETA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'HETU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'HOMA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'HOMU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'MINA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'MINU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'OBSA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'OBSU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'OR_WALD_DOS_FE_IV',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'P_EMMAX_FE_IV',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'SE',
                                            'type': 'FLOAT'
                                        }
                                    ]
                                }
                            ],
                            'sample_groups': [
                                {
                                    'name': '26k_eu_go',
                                    'id': 'ExSeq_26k_eu_go_v2',
                                    'properties': [
                                        {
                                            'name': 'EAF',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'MAC',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'MAF',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'F_MISS',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'QCFAIL',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'O_R',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'P',
                                            'type': 'FLOAT'
                                        }
                                    ],
                                    'phenotypes': [
                                        {
                                            'name': 'T2D',
                                            'properties': [
                                                {
                                                    'name': 'HETA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HETU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HOMA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HOMU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MINA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MINU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OBSA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OBSU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OR_WALD_DOS_FE_IV',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'P_EMMAX_FE_IV',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'SE',
                                                    'type': 'FLOAT'
                                                }
                                            ]
                                        }
                                    ],
                                    'sample_groups': []
                                }, {
                                    'name': '26k_eu_esp',
                                    'id': 'ExSeq_26k_eu_esp_v2',
                                    'properties': [
                                        {
                                            'name': 'EAF',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'MAC',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'MAF',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'F_MISS',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'QCFAIL',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'O_R',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'P',
                                            'type': 'FLOAT'
                                        }
                                    ],
                                    'phenotypes': [
                                        {
                                            'name': 'T2D',
                                            'properties': [
                                                {
                                                    'name': 'HETA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HETU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HOMA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HOMU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MINA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MINU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OBSA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OBSU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OR_WALD_DOS_FE_IV',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'P_EMMAX_FE_IV',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'SE',
                                                    'type': 'FLOAT'
                                                }
                                            ]
                                        }
                                    ],
                                    'sample_groups': []
                                }, {
                                    'name': '26k_eu_genes',
                                    'id': 'ExSeq_26k_eu_genes_v2',
                                    'properties': [
                                        {
                                            'name': 'EAF',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'MAC',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'MAF',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'F_MISS',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'QCFAIL',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'O_R',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'P',
                                            'type': 'FLOAT'
                                        }
                                    ],
                                    'phenotypes': [
                                        {
                                            'name': 'T2D',
                                            'properties': [
                                                {
                                                    'name': 'HETA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HETU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HOMA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HOMU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MINA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MINU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OBSA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OBSU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OR_WALD_DOS_FE_IV',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'P_EMMAX_FE_IV',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'SE',
                                                    'type': 'FLOAT'
                                                }
                                            ]
                                        }
                                    ],
                                    'sample_groups': [
                                        {
                                            'name': '26k_eu_genes_ua',
                                            'id': 'ExSeq_26k_eu_genes_ua_v2',
                                            'properties': [
                                                {
                                                    'name': 'EAF',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'MAC',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MAF',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'F_MISS',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'QCFAIL',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'O_R',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'P',
                                                    'type': 'FLOAT'
                                                }
                                            ],
                                            'phenotypes': [
                                                {
                                                    'name': 'T2D',
                                                    'properties': [
                                                        {
                                                            'name': 'HETA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'HETU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'HOMA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'HOMU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'MINA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'MINU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'OBSA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'OBSU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'OR_WALD_DOS_FE_IV',
                                                            'type': 'FLOAT'
                                                        }, {
                                                            'name': 'P_EMMAX_FE_IV',
                                                            'type': 'FLOAT'
                                                        }, {
                                                            'name': 'SE',
                                                            'type': 'FLOAT'
                                                        }
                                                    ]
                                                }
                                            ],
                                            'sample_groups': []
                                        }, {
                                            'name': '26k_eu_genes_um',
                                            'id': 'ExSeq_26k_eu_genes_um_v2',
                                            'properties': [
                                                {
                                                    'name': 'EAF',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'MAC',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MAF',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'F_MISS',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'QCFAIL',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'O_R',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'P',
                                                    'type': 'FLOAT'
                                                }
                                            ],
                                            'phenotypes': [
                                                {
                                                    'name': 'T2D',
                                                    'properties': [
                                                        {
                                                            'name': 'HETA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'HETU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'HOMA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'HOMU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'MINA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'MINU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'OBSA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'OBSU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'OR_WALD_DOS_FE_IV',
                                                            'type': 'FLOAT'
                                                        }, {
                                                            'name': 'P_EMMAX_FE_IV',
                                                            'type': 'FLOAT'
                                                        }, {
                                                            'name': 'SE',
                                                            'type': 'FLOAT'
                                                        }
                                                    ]
                                                }
                                            ],
                                            'sample_groups': []
                                        }
                                    ]
                                }, {
                                    'name': '26k_eu_lucamp',
                                    'id': 'ExSeq_26k_eu_lucamp_v2',
                                    'properties': [
                                        {
                                            'name': 'EAF',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'MAC',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'MAF',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'F_MISS',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'QCFAIL',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'O_R',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'P',
                                            'type': 'FLOAT'
                                        }
                                    ],
                                    'phenotypes': [
                                        {
                                            'name': 'T2D',
                                            'properties': [
                                                {
                                                    'name': 'HETA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HETU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HOMA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HOMU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MINA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MINU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OBSA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OBSU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OR_WALD_DOS_FE_IV',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'P_EMMAX_FE_IV',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'SE',
                                                    'type': 'FLOAT'
                                                }
                                            ]
                                        }
                                    ],
                                    'sample_groups': []
                                }
                            ]
                        }, {
                            'name': '26k_aa',
                            'id': 'ExSeq_26k_aa_v2',
                            'properties': [
                                {
                                    'name': 'EAF',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'MAC',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'MAF',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'F_MISS',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'QCFAIL',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'O_R',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'P',
                                    'type': 'FLOAT'
                                }
                            ],
                            'phenotypes': [
                                {
                                    'name': 'T2D',
                                    'properties': [
                                        {
                                            'name': 'HETA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'HETU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'HOMA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'HOMU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'MINA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'MINU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'OBSA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'OBSU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'OR_WALD_DOS_FE_IV',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'P_EMMAX_FE_IV',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'SE',
                                            'type': 'FLOAT'
                                        }
                                    ]
                                }
                            ],
                            'sample_groups': [
                                {
                                    'name': '26k_aa_esp',
                                    'id': 'ExSeq_26k_aa_esp_v2',
                                    'properties': [
                                        {
                                            'name': 'EAF',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'MAC',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'MAF',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'F_MISS',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'QCFAIL',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'O_R',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'P',
                                            'type': 'FLOAT'
                                        }
                                    ],
                                    'phenotypes': [
                                        {
                                            'name': 'T2D',
                                            'properties': [
                                                {
                                                    'name': 'HETA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HETU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HOMA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HOMU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MINA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MINU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OBSA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OBSU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OR_WALD_DOS_FE_IV',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'P_EMMAX_FE_IV',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'SE',
                                                    'type': 'FLOAT'
                                                }
                                            ]
                                        }
                                    ],
                                    'sample_groups': []
                                }, {
                                    'name': '26k_aa_genes',
                                    'id': 'ExSeq_26k_aa_genes_v2',
                                    'properties': [
                                        {
                                            'name': 'EAF',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'MAC',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'MAF',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'F_MISS',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'QCFAIL',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'O_R',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'P',
                                            'type': 'FLOAT'
                                        }
                                    ],
                                    'phenotypes': [
                                        {
                                            'name': 'T2D',
                                            'properties': [
                                                {
                                                    'name': 'HETA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HETU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HOMA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HOMU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MINA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MINU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OBSA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OBSU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OR_WALD_DOS_FE_IV',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'P_EMMAX_FE_IV',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'SE',
                                                    'type': 'FLOAT'
                                                }
                                            ]
                                        }
                                    ],
                                    'sample_groups': [
                                        {
                                            'name': '26k_aa_genes_aw',
                                            'id': 'ExSeq_26k_aa_genes_aw_v2',
                                            'properties': [
                                                {
                                                    'name': 'EAF',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'MAC',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MAF',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'F_MISS',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'QCFAIL',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'O_R',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'P',
                                                    'type': 'FLOAT'
                                                }
                                            ],
                                            'phenotypes': [
                                                {
                                                    'name': 'T2D',
                                                    'properties': [
                                                        {
                                                            'name': 'HETA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'HETU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'HOMA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'HOMU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'MINA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'MINU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'OBSA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'OBSU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'OR_WALD_DOS_FE_IV',
                                                            'type': 'FLOAT'
                                                        }, {
                                                            'name': 'P_EMMAX_FE_IV',
                                                            'type': 'FLOAT'
                                                        }, {
                                                            'name': 'SE',
                                                            'type': 'FLOAT'
                                                        }
                                                    ]
                                                }
                                            ],
                                            'sample_groups': []
                                        }, {
                                            'name': '26k_aa_genes_aj',
                                            'id': 'ExSeq_26k_aa_genes_aj_v2',
                                            'properties': [
                                                {
                                                    'name': 'EAF',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'MAC',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MAF',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'F_MISS',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'QCFAIL',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'O_R',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'P',
                                                    'type': 'FLOAT'
                                                }
                                            ],
                                            'phenotypes': [
                                                {
                                                    'name': 'T2D',
                                                    'properties': [
                                                        {
                                                            'name': 'HETA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'HETU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'HOMA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'HOMU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'MINA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'MINU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'OBSA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'OBSU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'OR_WALD_DOS_FE_IV',
                                                            'type': 'FLOAT'
                                                        }, {
                                                            'name': 'P_EMMAX_FE_IV',
                                                            'type': 'FLOAT'
                                                        }, {
                                                            'name': 'SE',
                                                            'type': 'FLOAT'
                                                        }
                                                    ]
                                                }
                                            ],
                                            'sample_groups': []
                                        }
                                    ]
                                }
                            ]
                        }, {
                            'name': '26k_hs',
                            'id': 'ExSeq_26k_hs_v2',
                            'properties': [
                                {
                                    'name': 'EAF',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'MAC',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'MAF',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'F_MISS',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'QCFAIL',
                                    'type': 'INTEGER'
                                }, {
                                    'name': 'O_R',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'P',
                                    'type': 'FLOAT'
                                }
                            ],
                            'phenotypes': [
                                {
                                    'name': 'T2D',
                                    'properties': [
                                        {
                                            'name': 'HETA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'HETU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'HOMA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'HOMU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'MINA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'MINU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'OBSA',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'OBSU',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'OR_WALD_DOS_FE_IV',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'P_EMMAX_FE_IV',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'SE',
                                            'type': 'FLOAT'
                                        }
                                    ]
                                }
                            ],
                            'sample_groups': [
                                {
                                    'name': '26k_hs_genes',
                                    'id': 'ExSeq_26k_hs_genes_v2',
                                    'properties': [
                                        {
                                            'name': 'EAF',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'MAC',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'MAF',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'F_MISS',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'QCFAIL',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'O_R',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'P',
                                            'type': 'FLOAT'
                                        }
                                    ],
                                    'phenotypes': [
                                        {
                                            'name': 'T2D',
                                            'properties': [
                                                {
                                                    'name': 'HETA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HETU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HOMA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HOMU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MINA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MINU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OBSA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OBSU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OR_WALD_DOS_FE_IV',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'P_EMMAX_FE_IV',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'SE',
                                                    'type': 'FLOAT'
                                                }
                                            ]
                                        }
                                    ],
                                    'sample_groups': [
                                        {
                                            'name': '26k_hs_genes_hs',
                                            'id': 'ExSeq_26k_hs_genes_hs_v2',
                                            'properties': [
                                                {
                                                    'name': 'EAF',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'MAC',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MAF',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'F_MISS',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'QCFAIL',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'O_R',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'P',
                                                    'type': 'FLOAT'
                                                }
                                            ],
                                            'phenotypes': [
                                                {
                                                    'name': 'T2D',
                                                    'properties': [
                                                        {
                                                            'name': 'HETA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'HETU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'HOMA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'HOMU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'MINA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'MINU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'OBSA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'OBSU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'OR_WALD_DOS_FE_IV',
                                                            'type': 'FLOAT'
                                                        }, {
                                                            'name': 'P_EMMAX_FE_IV',
                                                            'type': 'FLOAT'
                                                        }, {
                                                            'name': 'SE',
                                                            'type': 'FLOAT'
                                                        }
                                                    ]
                                                }
                                            ],
                                            'sample_groups': []
                                        }, {
                                            'name': '26k_hs_genes_ha',
                                            'id': 'ExSeq_26k_hs_genes_ha_v2',
                                            'properties': [
                                                {
                                                    'name': 'EAF',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'MAC',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MAF',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'F_MISS',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'QCFAIL',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'O_R',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'P',
                                                    'type': 'FLOAT'
                                                }
                                            ],
                                            'phenotypes': [
                                                {
                                                    'name': 'T2D',
                                                    'properties': [
                                                        {
                                                            'name': 'HETA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'HETU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'HOMA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'HOMU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'MINA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'MINU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'OBSA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'OBSU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'OR_WALD_DOS_FE_IV',
                                                            'type': 'FLOAT'
                                                        }, {
                                                            'name': 'P_EMMAX_FE_IV',
                                                            'type': 'FLOAT'
                                                        }, {
                                                            'name': 'SE',
                                                            'type': 'FLOAT'
                                                        }
                                                    ]
                                                }
                                            ],
                                            'sample_groups': []
                                        }
                                    ]
                                }, {
                                    'name': '26k_hs_sigma',
                                    'id': 'ExSeq_26k_hs_sigma_v2',
                                    'properties': [
                                        {
                                            'name': 'EAF',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'MAC',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'MAF',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'F_MISS',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'QCFAIL',
                                            'type': 'INTEGER'
                                        }, {
                                            'name': 'O_R',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'P',
                                            'type': 'FLOAT'
                                        }
                                    ],
                                    'phenotypes': [
                                        {
                                            'name': 'T2D',
                                            'properties': [
                                                {
                                                    'name': 'HETA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HETU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HOMA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'HOMU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MINA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MINU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OBSA',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OBSU',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'OR_WALD_DOS_FE_IV',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'P_EMMAX_FE_IV',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'SE',
                                                    'type': 'FLOAT'
                                                }
                                            ]
                                        }
                                    ],
                                    'sample_groups': [
                                        {
                                            'name': '26k_hs_sigma_mexb2',
                                            'id': 'ExSeq_26k_hs_sigma_mexb2_v2',
                                            'properties': [
                                                {
                                                    'name': 'EAF',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'MAC',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MAF',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'F_MISS',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'QCFAIL',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'O_R',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'P',
                                                    'type': 'FLOAT'
                                                }
                                            ],
                                            'phenotypes': [
                                                {
                                                    'name': 'T2D',
                                                    'properties': [
                                                        {
                                                            'name': 'HETA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'HETU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'HOMA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'HOMU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'MINA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'MINU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'OBSA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'OBSU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'OR_WALD_DOS_FE_IV',
                                                            'type': 'FLOAT'
                                                        }, {
                                                            'name': 'P_EMMAX_FE_IV',
                                                            'type': 'FLOAT'
                                                        }, {
                                                            'name': 'SE',
                                                            'type': 'FLOAT'
                                                        }
                                                    ]
                                                }
                                            ],
                                            'sample_groups': []
                                        }, {
                                            'name': '26k_hs_sigma_mexb3',
                                            'id': 'ExSeq_26k_hs_sigma_mexb3_v2',
                                            'properties': [
                                                {
                                                    'name': 'EAF',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'MAC',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MAF',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'F_MISS',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'QCFAIL',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'O_R',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'P',
                                                    'type': 'FLOAT'
                                                }
                                            ],
                                            'phenotypes': [
                                                {
                                                    'name': 'T2D',
                                                    'properties': [
                                                        {
                                                            'name': 'HETA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'HETU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'HOMA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'HOMU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'MINA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'MINU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'OBSA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'OBSU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'OR_WALD_DOS_FE_IV',
                                                            'type': 'FLOAT'
                                                        }, {
                                                            'name': 'P_EMMAX_FE_IV',
                                                            'type': 'FLOAT'
                                                        }, {
                                                            'name': 'SE',
                                                            'type': 'FLOAT'
                                                        }
                                                    ]
                                                }
                                            ],
                                            'sample_groups': []
                                        }, {
                                            'name': '26k_hs_sigma_mexb1',
                                            'id': 'ExSeq_26k_hs_sigma_mexb1_v2',
                                            'properties': [
                                                {
                                                    'name': 'EAF',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'MAC',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MAF',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'F_MISS',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'QCFAIL',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'O_R',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'P',
                                                    'type': 'FLOAT'
                                                }
                                            ],
                                            'phenotypes': [
                                                {
                                                    'name': 'T2D',
                                                    'properties': [
                                                        {
                                                            'name': 'HETA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'HETU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'HOMA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'HOMU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'MINA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'MINU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'OBSA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'OBSU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'OR_WALD_DOS_FE_IV',
                                                            'type': 'FLOAT'
                                                        }, {
                                                            'name': 'P_EMMAX_FE_IV',
                                                            'type': 'FLOAT'
                                                        }, {
                                                            'name': 'SE',
                                                            'type': 'FLOAT'
                                                        }
                                                    ]
                                                }
                                            ],
                                            'sample_groups': []
                                        }, {
                                            'name': '26k_hs_sigma_mec',
                                            'id': 'ExSeq_26k_hs_sigma_mec_v2',
                                            'properties': [
                                                {
                                                    'name': 'EAF',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'MAC',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'MAF',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'F_MISS',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'QCFAIL',
                                                    'type': 'INTEGER'
                                                }, {
                                                    'name': 'O_R',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'P',
                                                    'type': 'FLOAT'
                                                }
                                            ],
                                            'phenotypes': [
                                                {
                                                    'name': 'T2D',
                                                    'properties': [
                                                        {
                                                            'name': 'HETA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'HETU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'HOMA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'HOMU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'MINA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'MINU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'OBSA',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'OBSU',
                                                            'type': 'INTEGER'
                                                        }, {
                                                            'name': 'OR_WALD_DOS_FE_IV',
                                                            'type': 'FLOAT'
                                                        }, {
                                                            'name': 'P_EMMAX_FE_IV',
                                                            'type': 'FLOAT'
                                                        }, {
                                                            'name': 'SE',
                                                            'type': 'FLOAT'
                                                        }
                                                    ]
                                                }
                                            ],
                                            'sample_groups': []
                                        }
                                    ]
                                }
                            ]
                        }
                    ]
                }
            ]
        }, {
            'name': 'ExChip_82k',
            'version': 'v1',
            'technology': 'ExChip',
            'sample_groups': [
                {
                    'name': '82k',
                    'id': 'ExChip_82k_v1',
                    'properties': [
                        {
                            'name': 'MAF',
                            'type': 'FLOAT'
                        }
                    ],
                    'phenotypes': [
                        {
                            'name': 'T2D',
                            'properties': [
                                {
                                    'name': 'BETA',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'Direction',
                                    'type': 'STRING'
                                }, {
                                    'name': 'NEFF',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'P_value',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'SE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }
                    ],
                    'sample_groups': []
                }
            ]
        }, {
            'name': 'ExChip_82k',
            'version': 'v2',
            'technology': 'ExChip',
            'sample_groups': [
                {
                    'name': '82k',
                    'id': 'ExChip_82k_v2',
                    'properties': [
                        {
                            'name': 'MAF',
                            'type': 'FLOAT'
                        }
                    ],
                    'phenotypes': [
                        {
                            'name': 'T2D',
                            'properties': [
                                {
                                    'name': 'BETA',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'Direction',
                                    'type': 'STRING'
                                }, {
                                    'name': 'NEFF',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'P_value',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'SE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }
                    ],
                    'sample_groups': []
                }
            ]
        }, {
            'name': 'GWAS_MAGIC',
            'version': 'v1',
            'technology': 'GWAS',
            'sample_groups': [
                {
                    'name': 'MAGIC',
                    'id': 'GWAS_MAGIC_v1',
                    'properties': [],
                    'phenotypes': [
                        {
                            'name': '2hrGLU_BMIAdj',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }, {
                            'name': '2hrIns_BMIAdj',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }, {
                            'name': 'FastGlu',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }, {
                            'name': 'FastIns',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }, {
                            'name': 'HOMAB',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }, {
                            'name': 'HOMAIR',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }, {
                            'name': 'HbA1c',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }, {
                            'name': 'ProIns',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }
                    ],
                    'sample_groups': []
                }
            ]
        }, {
            'name': 'GWAS_MAGIC',
            'version': 'v2',
            'technology': 'GWAS',
            'sample_groups': [
                {
                    'name': 'MAGIC',
                    'id': 'GWAS_MAGIC_v2',
                    'properties': [],
                    'phenotypes': [
                        {
                            'name': '2hrG',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }, {
                            'name': 'FG',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }, {
                            'name': 'HbA1C',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }, {
                            'name': 'IS',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }
                    ],
                    'sample_groups': []
                }
            ]
        }, {
            'name': 'GWAS_PGC',
            'version': 'v1',
            'technology': 'GWAS',
            'sample_groups': [
                {
                    'name': 'PGC',
                    'id': 'GWAS_PGC_v1',
                    'properties': [],
                    'phenotypes': [
                        {
                            'name': 'BIP',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }, {
                            'name': 'SCZMDD',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }, {
                            'name': 'SCZSCZ',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }
                    ],
                    'sample_groups': []
                }
            ]
        }, {
            'name': 'GWAS_PGC',
            'version': 'v2',
            'technology': 'GWAS',
            'sample_groups': [
                {
                    'name': 'PGC',
                    'id': 'GWAS_PGC_v2',
                    'properties': [],
                    'phenotypes': [
                        {
                            'name': 'DHD',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }, {
                            'name': 'BIP',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }, {
                            'name': 'MDD',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }, {
                            'name': 'SCZ',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }
                    ],
                    'sample_groups': []
                }
            ]
        }, {
            'name': 'GWAS_GIANT',
            'version': 'v1',
            'technology': 'GWAS',
            'sample_groups': [
                {
                    'name': 'GIANT',
                    'id': 'GWAS_GIANT_v1',
                    'properties': [],
                    'phenotypes': [
                        {
                            'name': 'BMI',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }, {
                            'name': 'Height',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }, {
                            'name': 'WHR',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }
                    ],
                    'sample_groups': [
                        {
                            'name': 'GIANT_females',
                            'id': '',
                            'properties': [],
                            'phenotypes': [],
                            'sample_groups': []
                        }, {
                            'name': 'GIANT_males',
                            'id': '',
                            'properties': [],
                            'phenotypes': [],
                            'sample_groups': []
                        }, {
                            'name': 'GIANT_eu',
                            'id': '',
                            'properties': [],
                            'phenotypes': [],
                            'sample_groups': [
                                {
                                    'name': 'GIANT_eu_females',
                                    'id': '',
                                    'properties': [],
                                    'phenotypes': [],
                                    'sample_groups': []
                                }, {
                                    'name': 'GIANT_eu_males',
                                    'id': '',
                                    'properties': [],
                                    'phenotypes': [],
                                    'sample_groups': []
                                }
                            ]
                        }
                    ]
                }
            ]
        }, {
            'name': 'GWAS_GIANT',
            'version': 'v2',
            'technology': 'GWAS',
            'sample_groups': [
                {
                    'name': 'GIANT',
                    'id': 'GWAS_GIANT_v2',
                    'properties': [],
                    'phenotypes': [
                        {
                            'name': 'Height',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }, {
                            'name': 'HIP',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }, {
                            'name': 'WC',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }, {
                            'name': 'WHR',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }
                    ],
                    'sample_groups': [
                        {
                            'name': 'GIANT_females',
                            'id': 'GWAS_GIANT_females_v2',
                            'properties': [],
                            'phenotypes': [
                                {
                                    'name': 'HIP',
                                    'properties': [
                                        {
                                            'name': 'OR',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'PVALUE',
                                            'type': 'FLOAT'
                                        }
                                    ]
                                }, {
                                    'name': 'WC',
                                    'properties': [
                                        {
                                            'name': 'OR',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'PVALUE',
                                            'type': 'FLOAT'
                                        }
                                    ]
                                }, {
                                    'name': 'WHR',
                                    'properties': [
                                        {
                                            'name': 'OR',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'PVALUE',
                                            'type': 'FLOAT'
                                        }
                                    ]
                                }
                            ],
                            'sample_groups': []
                        }, {
                            'name': 'GIANT_males',
                            'id': 'GWAS_GIANT_males_v2',
                            'properties': [],
                            'phenotypes': [
                                {
                                    'name': 'HIP',
                                    'properties': [
                                        {
                                            'name': 'OR',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'PVALUE',
                                            'type': 'FLOAT'
                                        }
                                    ]
                                }, {
                                    'name': 'WC',
                                    'properties': [
                                        {
                                            'name': 'OR',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'PVALUE',
                                            'type': 'FLOAT'
                                        }
                                    ]
                                }, {
                                    'name': 'WHR',
                                    'properties': [
                                        {
                                            'name': 'OR',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'PVALUE',
                                            'type': 'FLOAT'
                                        }
                                    ]
                                }
                            ],
                            'sample_groups': []
                        }, {
                            'name': 'GIANT_eu',
                            'id': 'GWAS_GIANT_eu_v2',
                            'properties': [],
                            'phenotypes': [
                                {
                                    'name': 'HIP',
                                    'properties': [
                                        {
                                            'name': 'OR',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'PVALUE',
                                            'type': 'FLOAT'
                                        }
                                    ]
                                }, {
                                    'name': 'WC',
                                    'properties': [
                                        {
                                            'name': 'OR',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'PVALUE',
                                            'type': 'FLOAT'
                                        }
                                    ]
                                }, {
                                    'name': 'WHR',
                                    'properties': [
                                        {
                                            'name': 'OR',
                                            'type': 'FLOAT'
                                        }, {
                                            'name': 'PVALUE',
                                            'type': 'FLOAT'
                                        }
                                    ]
                                }
                            ],
                            'sample_groups': [
                                {
                                    'name': 'GIANT_eu_females',
                                    'id': 'GWAS_GIANT_eu_females_v2',
                                    'properties': [],
                                    'phenotypes': [
                                        {
                                            'name': 'HIP',
                                            'properties': [
                                                {
                                                    'name': 'OR',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'PVALUE',
                                                    'type': 'FLOAT'
                                                }
                                            ]
                                        }, {
                                            'name': 'WC',
                                            'properties': [
                                                {
                                                    'name': 'OR',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'PVALUE',
                                                    'type': 'FLOAT'
                                                }
                                            ]
                                        }, {
                                            'name': 'WHR',
                                            'properties': [
                                                {
                                                    'name': 'OR',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'PVALUE',
                                                    'type': 'FLOAT'
                                                }
                                            ]
                                        }
                                    ],
                                    'sample_groups': []
                                }, {
                                    'name': 'GIANT_eu_males',
                                    'id': 'GWAS_GIANT_eu_males_v2',
                                    'properties': [],
                                    'phenotypes': [
                                        {
                                            'name': 'HIP',
                                            'properties': [
                                                {
                                                    'name': 'OR',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'PVALUE',
                                                    'type': 'FLOAT'
                                                }
                                            ]
                                        }, {
                                            'name': 'WC',
                                            'properties': [
                                                {
                                                    'name': 'OR',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'PVALUE',
                                                    'type': 'FLOAT'
                                                }
                                            ]
                                        }, {
                                            'name': 'WHR',
                                            'properties': [
                                                {
                                                    'name': 'OR',
                                                    'type': 'FLOAT'
                                                }, {
                                                    'name': 'PVALUE',
                                                    'type': 'FLOAT'
                                                }
                                            ]
                                        }
                                    ],
                                    'sample_groups': []
                                }
                            ]
                        }
                    ]
                }
            ]
        }, {
            'name': 'GWAS_CARDIoGRAM',
            'version': 'v1',
            'technology': 'Metabochip',
            'sample_groups': [
                {
                    'name': 'CARDIoGRAM',
                    'id': 'GWAS_CARDIoGRAM_v1',
                    'properties': [],
                    'phenotypes': [
                        {
                            'name': 'CAD',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }
                    ],
                    'sample_groups': []
                }, {
                    'name': 'C4D',
                    'id': '',
                    'properties': [],
                    'phenotypes': [],
                    'sample_groups': []
                }, {
                    'name': 'CARDIoGRAMplusC4D',
                    'id': '',
                    'properties': [],
                    'phenotypes': [],
                    'sample_groups': []
                }
            ]
        }, {
            'name': 'GWAS_CARDIoGRAM',
            'version': 'v2',
            'technology': 'Metabochip',
            'sample_groups': [
                {
                    'name': 'CARDIoGRAM',
                    'id': 'GWAS_CARDIoGRAM_v2',
                    'properties': [],
                    'phenotypes': [
                        {
                            'name': 'CAD',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }
                    ],
                    'sample_groups': []
                }, {
                    'name': 'C4D',
                    'id': 'GWAS_C4D_v2',
                    'properties': [],
                    'phenotypes': [
                        {
                            'name': 'CAD',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }
                    ],
                    'sample_groups': []
                }, {
                    'name': 'CARDIoGRAMplusC4D',
                    'id': 'GWAS_CARDIoGRAMplusC4D_v2',
                    'properties': [],
                    'phenotypes': [
                        {
                            'name': 'CAD',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }
                    ],
                    'sample_groups': []
                }
            ]
        }, {
            'name': 'GWAS_CKDGen',
            'version': 'v1',
            'technology': 'GWAS',
            'sample_groups': [
                {
                    'name': 'CKDGen',
                    'id': 'GWAS_CKDGen_v1',
                    'properties': [],
                    'phenotypes': [
                        {
                            'name': 'CKD',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }, {
                            'name': 'MA',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }, {
                            'name': 'UACR',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }, {
                            'name': 'eGFRcrea',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }, {
                            'name': 'eGFRcys',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }
                    ],
                    'sample_groups': []
                }
            ]
        }, {
            'name': 'GWAS_GLGC',
            'version': 'v1',
            'technology': 'GWAS',
            'sample_groups': [
                {
                    'name': 'GLGC',
                    'id': 'GWAS_GLGC_v1',
                    'properties': [],
                    'phenotypes': [
                        {
                            'name': 'HDL',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }, {
                            'name': 'LDL',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }, {
                            'name': 'TC',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }, {
                            'name': 'TG',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }
                    ],
                    'sample_groups': []
                }
            ]
        }, {
            'name': 'GWAS_GLGC',
            'version': 'v2',
            'technology': 'GWAS',
            'sample_groups': [
                {
                    'name': 'GLGC',
                    'id': 'GWAS_GLGC_v2',
                    'properties': [],
                    'phenotypes': [
                        {
                            'name': 'HDL',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }, {
                            'name': 'LDL',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }, {
                            'name': 'TC',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }, {
                            'name': 'TG',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }
                    ],
                    'sample_groups': []
                }
            ]
        }, {
            'name': 'GWAS_DIAGRAM',
            'version': 'v1',
            'technology': 'GWAS',
            'sample_groups': [
                {
                    'name': 'DIAGRAM',
                    'id': 'GWAS_DIAGRAM_v1',
                    'properties': [],
                    'phenotypes': [
                        {
                            'name': 'T2D',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }
                    ],
                    'sample_groups': []
                }
            ]
        }, {
            'name': 'GWAS_DIAGRAM',
            'version': 'v2',
            'technology': 'GWAS',
            'sample_groups': [
                {
                    'name': 'DIAGRAM',
                    'id': 'GWAS_DIAGRAM_v2',
                    'properties': [],
                    'phenotypes': [
                        {
                            'name': 'T2D',
                            'properties': [
                                {
                                    'name': 'OR',
                                    'type': 'FLOAT'
                                }, {
                                    'name': 'PVALUE',
                                    'type': 'FLOAT'
                                }
                            ]
                        }
                    ],
                    'sample_groups': []
                }
            ]
        }
    ];

}).call(this);
