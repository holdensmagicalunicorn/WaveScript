
// This file contains a 

include "stdlib.ws";
include "marmot_heatmap.ws";

nodes =
  [(100, -0.0, 0.000891, 222.746048),
   (105, 13282.529583, -4587.759179, 17.01309),
   (110, 7663.663345, -6068.768937, 244.168915),
   (104, 0.0, -4890.001043, 181.457764),
   (106, 13801.727366, -924.578002, 129.536758),
   (108, 6719.793799, 552.692044, 131.25087)];


data = Curry:map(List:toArray)$

[[0.682236,0.685759,0.689640,0.693812,0.698219,0.702851,0.707672,0.712544,0.717365,0.722049,0.726511,0.730673,0.734456,0.737792,0.740618,0.742883,0.744547,0.745580,0.745968,0.745708,0.744810,0.743300,0.741215,0.738608,0.735534,0.732051,0.728221,0.724121,0.719844,0.715496,0.711167,0.706962,0.703037,0.699624,0.697034,0.695419,0.694663,0.694526,0.694934,0.695895,0.697438,0.699572,0.702268,0.705460,0.709029,0.712865,0.716863,0.720923,0.724959,0.728893,0.732654,0.736175,0.739397,0.742267,0.744739,0.746775,0.748342,0.749420,0.749995,0.750062,0.749625,0.748698,0.747301,0.745461,0.743211,0.740589,0.737637,0.734402,0.730932,0.727279,0.723500,0.719678,0.715918,0.712214,0.708585,0.705048,0.701621,0.698330,0.695200,0.692249,0.689490,0.686930,0.684581,0.682481,0.680657,0.679053,0.677592,0.676231,0.674950,0.673737,0.672587,0.671494,0.670459,0.669486,0.668581,0.667746,0.666968,0.666228,0.665509,0.664796,0.664079,0.663351,0.662725,0.662263,0.661786,0.661311,0.660889,0.660542,0.660399,0.660625,0.661163,0.661968,0.663133,0.664693,0.666583,0.668806,0.671479,0.674801,0.678647,0.683028,0.687989,0.693570,0.699807,0.706729,0.714350,0.722682,0.731725,0.741475,0.751930,0.763085,0.774934,0.787469,0.800660,0.814429,0.828654,0.843197,0.857909,0.872638,0.887229,0.901527,0.915378,0.928628,0.941132,0.952746,0.963336,0.972777,0.980957,0.987777,0.993153,0.997015,0.999310,1.000000,0.999068,0.996514,0.992355,0.986625,0.979378,0.970678,0.960609,0.949265,0.936754,0.923195,0.908713,0.893442,0.877522,0.861098,0.844318,0.827334,0.810299,0.793364,0.776681,0.760417,0.744790,0.730043,0.716266,0.703396,0.691479,0.680622,0.670944,0.662549,0.655617,0.650573,0.647112,0.644879,0.643747,0.643649,0.644553,0.646807,0.651175,0.657092,0.664599,0.673540,0.683804,0.695309,0.707975,0.721693,0.736318,0.751690,0.767647,0.784022,0.800646,0.817348,0.833956,0.850296,0.866191,0.881469,0.895960,0.909508,0.921963,0.933191,0.943069,0.951491,0.958371,0.963638,0.967243,0.969159,0.969380,0.967916,0.964803,0.960096,0.953870,0.946217,0.937247,0.927085,0.915867,0.903740,0.890860,0.877386,0.863480,0.849306,0.835024,0.820791,0.806758,0.793065,0.779843,0.767209,0.755269,0.744120,0.733856,0.724522,0.716091,0.708537,0.701863,0.696101,0.691296,0.687483,0.684703,0.683015,0.682423,0.682714,0.683601,0.684881,0.686396,0.688050,0.689812,0.691731,0.693702,0.695703,0.697730,0.699790,0.701904,0.704110,0.706447,0.708962,0.711711,0.714744,0.718089,0.721750,0.725702,0.729908,0.734326,0.738918,0.743654,0.748499,0.753426,0.758409,0.763422,0.768445,0.773453,0.778423,0.783337,0.788177,0.792931,0.797563,0.802010,0.806217,0.810134,0.813713,0.816911,0.819683,0.821987,0.823785,0.825040,0.825719,0.825797,0.825253,0.824073,0.822252,0.819793,0.816707,0.813016,0.808750,0.803950,0.798664,0.792950,0.786873,0.780505,0.773921,0.767197,0.760405,0.753606,0.746855,0.740200,0.733691,0.727539,0.721643,0.716062,0.711070,0.706496,0.702363,0.698715,0.695564,0.692890,0.690677,0.688906,0.687553,0.686607,0.686098,0.686022,0.686222,0.686564,0.686954,0.687314,0.687589,0.687740,0.687736,0.687547,0.687155,0.686555,0.685749,0.684748,0.683572,0.682250,0.680819,0.679326,0.677830,0.676408,0.675120,0.673998,0.673039,0.672222,0.671536,0.671013,0.670824,0.671086,0.671698,0.672799,0.674405,0.676518,0.679137],

    [0.829365,0.827450,0.825901,0.824731,0.823924,0.823436,0.823228,0.823272,0.823540,0.824013,0.824672,0.825501,0.826487,0.827613,0.828864,0.830230,0.831707,0.833290,0.834981,0.836784,0.838707,0.840766,0.842970,0.845328,0.847852,0.850559,0.853462,0.856576,0.859912,0.863479,0.867282,0.871321,0.875592,0.880085,0.884784,0.889669,0.894716,0.899888,0.905144,0.910439,0.915721,0.920934,0.926017,0.930906,0.935533,0.939831,0.943729,0.947160,0.950058,0.952361,0.954010,0.954954,0.955147,0.954553,0.953145,0.950903,0.947821,0.943901,0.939157,0.933615,0.927310,0.920290,0.912613,0.904343,0.895557,0.886338,0.876774,0.866963,0.857003,0.847000,0.837064,0.827300,0.817805,0.808671,0.799991,0.791858,0.784357,0.777560,0.771543,0.766387,0.762130,0.758799,0.756409,0.755065,0.755316,0.756782,0.759159,0.762412,0.766490,0.771579,0.777627,0.784509,0.792169,0.800594,0.809721,0.819435,0.829651,0.840282,0.851238,0.862425,0.873746,0.885104,0.896400,0.907539,0.918426,0.928972,0.939090,0.948698,0.957716,0.966061,0.973653,0.980412,0.986263,0.991141,0.994991,0.997768,0.999444,1.000000,0.999433,0.997755,0.994988,0.991170,0.986352,0.980596,0.973974,0.966569,0.958474,0.949791,0.940637,0.931146,0.921428,0.911560,0.901629,0.891732,0.881967,0.872424,0.863190,0.854338,0.845938,0.838046,0.830712,0.823980,0.817890,0.812481,0.807801,0.803903,0.800834,0.798576,0.797018,0.796010,0.795455,0.795274,0.795343,0.795615,0.796072,0.796791,0.797697,0.798593,0.799426,0.800141,0.800707,0.801111,0.801387,0.801531,0.801515,0.801339,0.801016,0.800558,0.799984,0.799313,0.798565,0.797761,0.796923,0.796072,0.795231,0.794421,0.793663,0.792979,0.792384,0.791893,0.791519,0.791277,0.791174,0.791202,0.791369,0.791724,0.792377,0.793270,0.794348,0.795602,0.797033,0.798636,0.800398,0.802298,0.804315,0.806422,0.808592,0.810794,0.813000,0.815178,0.817298,0.819330,0.821245,0.823016,0.824614,0.826018,0.827206,0.828164,0.828874,0.829330,0.829525,0.829462,0.829149,0.828596,0.827823,0.826853,0.825714,0.824445,0.823088,0.821697,0.820354,0.819173,0.818262,0.817628,0.817266,0.817262,0.817673,0.818446,0.819527,0.820900,0.822575,0.824597,0.827057,0.829967,0.833243,0.836812,0.840617,0.844611,0.848747,0.852976,0.857237,0.861458,0.865565,0.869485,0.873151,0.876499,0.879470,0.882011,0.884076,0.885625,0.886629,0.887066,0.886925,0.886203,0.884909,0.883059,0.880681,0.877812,0.874499,0.870791,0.866738,0.862395,0.857820,0.853078,0.848230,0.843339,0.838466,0.833668,0.829001,0.824516,0.820261,0.816278,0.812601,0.809252,0.806243,0.803586,0.801308,0.799533,0.798481,0.797958,0.797731,0.797740,0.797957,0.798357,0.798909,0.799579,0.800329,0.801125,0.801930,0.802714,0.803450,0.804118,0.804703,0.805197,0.805599,0.805935,0.806228,0.806473,0.806699,0.806944,0.807252,0.807673,0.808257,0.809050,0.810105,0.811475,0.813201,0.815320,0.817865,0.820884,0.824438,0.828487,0.832947,0.837761,0.842883,0.848264,0.853853,0.859591,0.865418,0.871267,0.877076,0.882777,0.888303,0.893589,0.898570,0.903189,0.907391,0.911130,0.914366,0.917067,0.919209,0.920775,0.921760,0.922161,0.921985,0.921247,0.919963,0.918156,0.915852,0.913084,0.909889,0.906308,0.902387,0.898177,0.893730,0.889100,0.884342,0.879509,0.874655,0.869830,0.865080,0.860450,0.855980,0.851704,0.847656,0.843862,0.840346,0.837127,0.834216,0.831625],

    [0.407734,0.395841,0.384470,0.373791,0.363956,0.355096,0.347311,0.340675,0.335231,0.331000,0.328003,0.326267,0.325809,0.326550,0.328269,0.330777,0.333932,0.337602,0.341645,0.345911,0.350242,0.354482,0.358479,0.362095,0.365206,0.367709,0.369523,0.370594,0.370891,0.370414,0.369188,0.367270,0.364739,0.361701,0.358285,0.354639,0.350925,0.347319,0.344004,0.341164,0.338981,0.337632,0.337285,0.338097,0.340212,0.343755,0.348828,0.355506,0.363834,0.373826,0.385466,0.398710,0.413484,0.429693,0.447214,0.465903,0.485593,0.506101,0.527232,0.548781,0.570540,0.592298,0.613846,0.634982,0.655508,0.675240,0.694004,0.711640,0.728007,0.742978,0.756443,0.768311,0.778509,0.786981,0.793687,0.798603,0.801721,0.803045,0.802592,0.800392,0.796482,0.790911,0.783732,0.775007,0.764804,0.753196,0.740259,0.726074,0.710728,0.694308,0.676909,0.658627,0.639565,0.619830,0.599533,0.578795,0.557738,0.536495,0.515204,0.494010,0.473065,0.452529,0.432567,0.413350,0.395053,0.377854,0.361934,0.347473,0.334649,0.323642,0.314625,0.307756,0.303123,0.300702,0.300612,0.303043,0.308123,0.315743,0.325892,0.338521,0.353543,0.370832,0.390232,0.411549,0.434555,0.458986,0.484549,0.510927,0.537783,0.564762,0.591502,0.617633,0.642790,0.666613,0.688757,0.708896,0.726730,0.741991,0.754446,0.763904,0.770215,0.773279,0.773042,0.769502,0.762704,0.752744,0.739765,0.723952,0.705536,0.684780,0.661984,0.637474,0.611599,0.584723,0.557223,0.529481,0.501879,0.474792,0.448586,0.423610,0.400195,0.378648,0.359248,0.342247,0.327871,0.316333,0.307830,0.302486,0.300156,0.300577,0.304034,0.310815,0.320750,0.333875,0.349893,0.368653,0.389980,0.413679,0.439532,0.467301,0.496732,0.527558,0.559496,0.592258,0.625544,0.659052,0.692476,0.725513,0.757859,0.789219,0.819305,0.847839,0.874559,0.899216,0.921584,0.941455,0.958648,0.973007,0.984403,0.992739,0.997949,1.000000,0.998892,0.994660,0.987372,0.977128,0.964061,0.948335,0.930141,0.909695,0.887237,0.863024,0.837330,0.810437,0.782635,0.754217,0.725471,0.696678,0.668110,0.640020,0.612646,0.586200,0.560871,0.536819,0.514177,0.493046,0.473497,0.455573,0.439283,0.424614,0.411524,0.399952,0.389817,0.381022,0.373458,0.367008,0.361551,0.356964,0.353121,0.349907,0.347209,0.344926,0.342967,0.341252,0.339716,0.338306,0.336981,0.335713,0.334488,0.333299,0.332147,0.331042,0.329999,0.329033,0.328164,0.327410,0.326788,0.326311,0.325989,0.325823,0.325806,0.325925,0.326155,0.326468,0.326827,0.327197,0.327538,0.327813,0.327986,0.328025,0.327904,0.327604,0.327111,0.326421,0.325537,0.324474,0.323257,0.321920,0.320506,0.319065,0.317648,0.316312,0.315124,0.314156,0.313494,0.313227,0.313416,0.314056,0.315127,0.316650,0.318674,0.321197,0.324183,0.327589,0.331366,0.335453,0.339776,0.344250,0.348782,0.353271,0.357616,0.361713,0.365465,0.368780,0.371579,0.373795,0.375378,0.376297,0.376542,0.376124,0.375076,0.373455,0.371337,0.368821,0.366022,0.363069,0.360104,0.357275,0.354732,0.352622,0.351085,0.350247,0.350224,0.351116,0.353009,0.355973,0.360052,0.365264,0.371592,0.378988,0.387372,0.396636,0.406649,0.417255,0.428278,0.439531,0.450810,0.461908,0.472618,0.482733,0.492058,0.500408,0.507616,0.513535,0.518041,0.521040,0.522463,0.522274,0.520466,0.517065,0.512124,0.505730,0.497994,0.489051,0.479061,0.468198,0.456654,0.444629,0.432329,0.419963],

    [0.527392,0.527656,0.527921,0.528174,0.528414,0.528758,0.529080,0.529387,0.529702,0.530109,0.530553,0.530957,0.531297,0.531571,0.531792,0.531981,0.532178,0.532425,0.532761,0.533210,0.533783,0.534489,0.535351,0.536377,0.537554,0.538865,0.540299,0.541856,0.543546,0.545416,0.547657,0.550709,0.554575,0.559068,0.564103,0.569632,0.575618,0.582018,0.588782,0.595846,0.603134,0.610557,0.618017,0.625414,0.632648,0.639618,0.646232,0.652400,0.658042,0.663087,0.667475,0.671157,0.674096,0.676267,0.677658,0.678269,0.678111,0.677207,0.675590,0.673301,0.670392,0.666917,0.662937,0.658515,0.653718,0.648611,0.643260,0.637728,0.632076,0.626360,0.620634,0.614946,0.609337,0.603845,0.598502,0.593336,0.588367,0.583613,0.579087,0.574798,0.570756,0.566964,0.563424,0.560139,0.557106,0.554323,0.551786,0.549484,0.547406,0.545538,0.543862,0.542360,0.541014,0.539805,0.538717,0.537736,0.536858,0.536082,0.535397,0.534804,0.534296,0.533865,0.533527,0.533313,0.533271,0.533430,0.533842,0.534571,0.535668,0.537162,0.539083,0.541478,0.544407,0.547942,0.552160,0.557138,0.562948,0.569660,0.577341,0.586047,0.595825,0.606709,0.618719,0.631859,0.646115,0.661455,0.677825,0.695152,0.713338,0.732270,0.751812,0.771811,0.792097,0.812489,0.832792,0.852803,0.872315,0.891118,0.909007,0.925780,0.941243,0.955216,0.967533,0.978048,0.986635,0.993193,0.997640,0.999919,1.000000,0.997881,0.993584,0.987157,0.978671,0.968220,0.955917,0.941893,0.926298,0.909291,0.891043,0.871733,0.851544,0.830663,0.809279,0.787578,0.765741,0.743948,0.722368,0.701167,0.680501,0.660513,0.641340,0.623106,0.605925,0.589902,0.575132,0.561703,0.549694,0.539172,0.530181,0.522852,0.517118,0.512742,0.509769,0.508124,0.507943,0.509679,0.513503,0.519204,0.526612,0.535636,0.546191,0.558211,0.571637,0.586401,0.602424,0.619616,0.637877,0.657093,0.677137,0.697875,0.719157,0.740827,0.762718,0.784657,0.806465,0.827955,0.848942,0.869237,0.888655,0.907012,0.924132,0.939850,0.954007,0.966463,0.977091,0.985783,0.992450,0.997027,0.999465,0.999745,0.997867,0.993858,0.987766,0.979665,0.969646,0.957825,0.944334,0.929319,0.912943,0.895379,0.876806,0.857410,0.837380,0.816904,0.796167,0.775347,0.754617,0.734138,0.714060,0.694520,0.675640,0.657529,0.640279,0.623969,0.608662,0.594407,0.581240,0.569186,0.558261,0.548473,0.539824,0.532342,0.526047,0.520798,0.516552,0.513291,0.511033,0.509735,0.509130,0.508856,0.508749,0.508742,0.509592,0.511984,0.515078,0.518848,0.523278,0.528348,0.534036,0.540322,0.547184,0.554604,0.562563,0.571043,0.580021,0.589474,0.599377,0.609698,0.620402,0.631449,0.642792,0.654379,0.666151,0.678042,0.689978,0.701880,0.713660,0.725228,0.736484,0.747327,0.757652,0.767351,0.776317,0.784444,0.791629,0.797776,0.802795,0.806604,0.809135,0.810331,0.810150,0.808569,0.805579,0.801192,0.795438,0.788366,0.780045,0.770561,0.760019,0.748538,0.736251,0.723303,0.709848,0.696045,0.682059,0.668053,0.654190,0.640629,0.627522,0.615016,0.603247,0.592337,0.582366,0.573363,0.565314,0.558199,0.552011,0.546763,0.542492,0.539195,0.536697,0.534794,0.533372,0.532390,0.531828,0.531659,0.531844,0.532327,0.533025,0.533836,0.534663,0.535428,0.536073,0.536556,0.536850,0.536938,0.536815,0.536485,0.535962,0.535270,0.534440,0.533507,0.532506,0.531474,0.530449,0.529466,0.528564,0.527807,0.527318,0.527198],

    [0.955528,0.954174,0.952872,0.951647,0.950492,0.949401,0.948363,0.947371,0.946423,0.945594,0.945360,0.945212,0.945072,0.944956,0.944888,0.944898,0.945007,0.945227,0.945574,0.946092,0.946921,0.948036,0.949277,0.950560,0.951835,0.953063,0.954217,0.955279,0.956234,0.957076,0.957807,0.958439,0.959003,0.959564,0.960226,0.961032,0.961906,0.962773,0.963589,0.964329,0.964973,0.965509,0.965927,0.966221,0.966390,0.966436,0.966361,0.966169,0.965867,0.965467,0.964985,0.964439,0.963851,0.963246,0.962652,0.962102,0.961623,0.961231,0.960920,0.960676,0.960486,0.960341,0.960234,0.960163,0.960123,0.960115,0.960138,0.960193,0.960286,0.960424,0.960635,0.960948,0.961339,0.961756,0.962168,0.962562,0.962936,0.963296,0.963643,0.963964,0.964263,0.964570,0.965033,0.965986,0.967257,0.968565,0.969838,0.971059,0.972222,0.973328,0.974380,0.975381,0.976335,0.977248,0.978132,0.978993,0.979836,0.980664,0.981478,0.982279,0.983067,0.983848,0.984625,0.985407,0.986201,0.987015,0.987849,0.988701,0.989565,0.990436,0.991307,0.992173,0.993027,0.993864,0.994680,0.995466,0.996217,0.996924,0.997579,0.998173,0.998697,0.999144,0.999504,0.999771,0.999938,1.000000,0.999953,0.999794,0.999522,0.999137,0.998641,0.998037,0.997332,0.996532,0.995646,0.994687,0.993666,0.992600,0.991503,0.990392,0.989276,0.988164,0.987056,0.985949,0.984836,0.983714,0.982577,0.981423,0.980248,0.979044,0.977807,0.976532,0.975216,0.973860,0.972463,0.971027,0.969559,0.968070,0.966569,0.965050,0.963516,0.961975,0.960446,0.958951,0.957509,0.956167,0.954950,0.953792,0.952676,0.951645,0.951038,0.950649,0.950332,0.950063,0.949817,0.949609,0.949455,0.949289,0.949089,0.948843,0.948534,0.948148,0.947676,0.947105,0.946425,0.945637,0.944767,0.943955,0.943405,0.942944,0.942426,0.941815,0.941098,0.940269,0.939327,0.938276,0.937127,0.935912,0.934631,0.933304,0.931965,0.930647,0.929360,0.928096,0.926848,0.925620,0.924420,0.923256,0.922135,0.921065,0.920052,0.919092,0.918179,0.917311,0.916487,0.915705,0.914966,0.914267,0.913601,0.912960,0.912336,0.911721,0.911108,0.910493,0.909873,0.909247,0.908614,0.907978,0.907348,0.906737,0.906170,0.905676,0.905280,0.904981,0.904746,0.904528,0.904291,0.904008,0.903667,0.903260,0.902792,0.902272,0.901722,0.901171,0.900645,0.900158,0.899719,0.899339,0.899038,0.898846,0.898806,0.898992,0.899479,0.900210,0.901064,0.901965,0.902872,0.903764,0.904626,0.905452,0.906239,0.906995,0.907780,0.908673,0.909577,0.910443,0.911261,0.912029,0.912746,0.913413,0.914030,0.914601,0.915131,0.915632,0.916126,0.916628,0.917181,0.917822,0.918519,0.919247,0.920000,0.920773,0.921561,0.922365,0.923191,0.924049,0.924951,0.925902,0.926902,0.927949,0.929064,0.930252,0.931489,0.932795,0.934155,0.935539,0.936942,0.938365,0.939808,0.941273,0.942760,0.944269,0.945798,0.947349,0.948929,0.950523,0.952114,0.953690,0.955244,0.956769,0.958259,0.959709,0.961115,0.962482,0.963831,0.965222,0.966672,0.968105,0.969480,0.970783,0.972015,0.973186,0.974311,0.975388,0.976403,0.977337,0.978177,0.978918,0.979554,0.980085,0.980510,0.980827,0.981038,0.981141,0.981138,0.981027,0.980811,0.980491,0.980070,0.979553,0.978951,0.978284,0.977580,0.976862,0.976113,0.975304,0.974416,0.973440,0.972376,0.971224,0.969990,0.968686,0.967339,0.965946,0.964510,0.963044,0.961551,0.960039,0.958529,0.957023],

    [0.561481,0.569430,0.576464,0.582566,0.587793,0.592205,0.595833,0.598699,0.600817,0.602226,0.603038,0.603443,0.603863,0.604278,0.604723,0.605317,0.606033,0.606703,0.607134,0.607180,0.606763,0.605866,0.604516,0.602786,0.600777,0.598597,0.596374,0.594256,0.592375,0.590859,0.590029,0.590362,0.591351,0.592927,0.595129,0.597966,0.601465,0.605618,0.610420,0.615851,0.621875,0.628439,0.635465,0.642830,0.650373,0.657947,0.665447,0.672827,0.680098,0.687370,0.694741,0.702120,0.709375,0.716305,0.722745,0.728572,0.733693,0.738061,0.741660,0.744417,0.746194,0.746911,0.746505,0.745026,0.742743,0.739307,0.734751,0.729118,0.722474,0.714929,0.706437,0.696991,0.686664,0.675568,0.663850,0.651657,0.639162,0.626565,0.614101,0.602010,0.590464,0.579521,0.569162,0.559377,0.550174,0.541575,0.533572,0.526143,0.519312,0.513033,0.507288,0.502056,0.497247,0.492714,0.488286,0.483833,0.479271,0.474540,0.469579,0.464349,0.458851,0.453141,0.447398,0.442060,0.438136,0.437212,0.439802,0.444740,0.450954,0.457926,0.465443,0.473431,0.481901,0.490937,0.500741,0.511724,0.524636,0.540422,0.559551,0.581779,0.606527,0.633083,0.660886,0.689542,0.718735,0.748130,0.777351,0.806027,0.833813,0.860380,0.885414,0.908614,0.929700,0.948417,0.964554,0.977910,0.988299,0.995566,0.999524,1.000000,0.996896,0.990198,0.979964,0.966313,0.949425,0.929541,0.906977,0.882161,0.855682,0.828073,0.799488,0.770044,0.739985,0.709626,0.679300,0.649346,0.620099,0.591866,0.564902,0.539424,0.515614,0.493624,0.473566,0.455512,0.440502,0.428858,0.419032,0.411322,0.406544,0.405556,0.407262,0.410379,0.414461,0.419382,0.425084,0.431511,0.438600,0.446284,0.454513,0.463257,0.472537,0.482356,0.492761,0.503822,0.515624,0.528259,0.541677,0.555791,0.570567,0.586129,0.602223,0.618862,0.635995,0.653466,0.671102,0.688728,0.706283,0.723826,0.740923,0.757484,0.773548,0.789240,0.804219,0.818322,0.831468,0.843639,0.854830,0.864987,0.874032,0.881917,0.888613,0.894118,0.898450,0.901743,0.904278,0.905940,0.906999,0.907273,0.906780,0.905570,0.903660,0.901042,0.897700,0.893647,0.888946,0.883710,0.878080,0.872296,0.866741,0.861851,0.857859,0.854151,0.850353,0.846241,0.841701,0.836675,0.831147,0.825133,0.818671,0.811801,0.804560,0.797020,0.789608,0.781930,0.773947,0.765666,0.757108,0.748300,0.739272,0.730056,0.720620,0.710900,0.700836,0.690383,0.679525,0.668286,0.656739,0.644993,0.633178,0.621432,0.610859,0.601356,0.591886,0.582304,0.572590,0.562692,0.552488,0.541936,0.531043,0.519854,0.508445,0.496926,0.485446,0.474173,0.463236,0.452684,0.442556,0.432942,0.424012,0.416077,0.409887,0.408617,0.413722,0.422310,0.433428,0.446492,0.461173,0.477293,0.494742,0.513435,0.533274,0.554124,0.575829,0.598214,0.621076,0.644205,0.667375,0.690333,0.712821,0.734574,0.755317,0.774784,0.792716,0.808864,0.822996,0.834898,0.844385,0.851298,0.855519,0.856968,0.855613,0.851471,0.844615,0.835178,0.823349,0.809357,0.793435,0.775778,0.756536,0.735845,0.713874,0.690836,0.666948,0.642473,0.617694,0.592901,0.568385,0.544448,0.521361,0.499412,0.478892,0.460064,0.443112,0.428145,0.415241,0.404469,0.395897,0.389572,0.385680,0.384735,0.386277,0.389971,0.395543,0.402679,0.411063,0.420404,0.430431,0.440899,0.451602,0.462304,0.472810,0.482957,0.492610,0.501671,0.510103,0.517971,0.525534,0.533739,0.543220,0.552683]];


colormap = List:toArray$
 [(0,     0,   143),
  (0,     0,   159),
  (0,     0,   175),
  (0,     0,   191),
  (0,     0,   207),
  (0,     0,   223),
  (0,     0,   239),
  (0,     0,   255),
  (0,    16,   255),
  (0,    32,   255),
  (0,    48,   255),
  (0,    64,   255),
  (0,    80,   255),
  (0,    96,   255),
  (0,   112,   255),
  (0,   128,   255),
  (0,   143,   255),
  (0,   159,   255),
  (0,   175,   255),
  (0,   191,   255),
  (0,   207,   255),
  (0,   223,   255),
  (0,   239,   255),
  (0,   255,   255),
  (16,   255,   239),
  (32,   255,   223),
  (48,   255,   207),
  (64,   255,   191),
  (80,   255,   175),
  (96,   255,   159),
  (112,   255,   143),
  (128,   255,   128),
  (143,   255,   112),
  (159,   255,    96),
  (175,   255,    80),
  (191,   255,    64),
  (207,   255,    48),
  (223,   255,    32),
  (239,   255,    16),
  (255,   255,     0),
  (255,   239,     0),
  (255,   223,     0),
  (255,   207,     0),
  (255,   191,     0),
  (255,   175,     0),
  (255,   159,     0),
  (255,   143,     0),
  (255,   128,     0),
  (255,   112,     0),
  (255,    96,     0),
  (255,    80,     0),
  (255,    64,     0),
  (255,    48,     0),
  (255,    32,     0),
  (255,    16,     0),
  (255,     0,     0),
  (239,     0,     0),
  (223,     0,     0),
  (207,     0,     0),
  (191,     0,     0),
  (175,     0,     0),
  (159,     0,     0),
  (143,     0,     0),
  (128,     0,     0)]

//******************************************************************************//


// Takes, file, width, height, red-array, green-array, blue-array
c_write_ppm_file 
  = (foreign("write_ppm_file", ["ppm_write.c"]) 
  :: (String, Int, Int, Array Int, Array Int, Array Int) -> Int)

type RGB = (Int * Int * Int);
write_ppm_file :: (String, Matrix RGB) -> Int;
fun write_ppm_file(file, mat) {
  let (r,c) = Matrix:dims(mat);
  dat = Matrix:toArray(mat);
  R = Array:map(fun((r,g,b)) r, dat);
  G = Array:map(fun((r,g,b)) g, dat);
  B = Array:map(fun((r,g,b)) b, dat);
  cstr = file ++ String:implode([intToChar(0)]);
  c_write_ppm_file(cstr, c, r, R,G,B);
}

colorize_likelihoods :: Matrix Float -> Matrix RGB;
fun colorize_likelihoods(lhoods) {
  fst = Matrix:get(lhoods,0,0);
  mx = Matrix:fold(max, fst, lhoods);
  mn = Matrix:fold(min, fst, lhoods);
  //println("Color max/min: "++mx++" / "++mn);
  //  Matrix:map(fun(v) colormap[f2i$ roundF(v / mx * 63.0)], 
  Matrix:map(fun(v) {
          colorind = f2i((v-mn) / (mx - mn) * 63.0);
          //println("ColorInd: "++ colorind);
          colormap[colorind]
	},
	lhoods);
}

axes = (-2000.0, 15801.0, -11659.0, 6142.0)
//grid_scale = 50.0
grid_scale = 2000.0

BASE <- iterate _ in timer(3.0) {
  println("Executing test_heatmap...");

  nodesAndData = List:map2(fun(x,y)(x,y), 
                  nodes, 
  	          map(normalize_doas, data));

  let coordsys = coord_converters(axes, grid_scale);
  let mat = doa_fuse(coordsys, nodesAndData);

  pic = colorize_likelihoods(mat);

  file = "temp.ppm";
  write_ppm_file(file,pic);

  emit ("Wrote image to file: " ++ file);
  //emit pic;
}


