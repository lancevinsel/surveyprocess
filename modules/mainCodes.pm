package mainCodes;
use strict;
use warnings;

our %legalCodes = (
 "ACU" => "282 ACU", #Air Conditioning Unit
 "BAB" => "615 615", #Bridge Abutment - Top Face - 3D
 "BAL" => "613 613", #Bridge Abut/Wingwall - Prismless - The outline of the face of the abutment
			# and the face of the wingwalls.  A 2d line, usually collected prismless.
 "BAR" => "695 695", #Stop Bar
 "BAS" => "618 618", #Bridge Approach Slab
 "BBA" => "619 BBA", #Bridge Deck Spot � Aggregate
 "BBB" => "619 BBA", #Bridge Deck Spot � HMA
 "BBC" => "619 BBA", #Bridge Deck Spot � Concrete
 "BBG" => "319 319", #Buffalo Box - Gas
 "BBR" => "619 BBA", #Bridge Deck Spot � Brick
 "BBS" => "620 620", #Bridge Beam Seat Elevation - The bridge seat elevation.  For elevation only.
			# Usually collected with the "hook".
 "BBV" => "619 BBA", #Bridge Deck Spot � Vinyl
 "BBW" => "320 320", #Buffalo Box - Water
 "BCB" => "611 611", #Bridge Curb - Top Front
 "BDB" => "619 619", #Bridge Deck Edge � Bit
 "BDC" => "619 619", #Bridge Deck Edge � Conc
 "BDT" => "619 619", #Bridge Deck Edge � Timber
 "BEX" => "623 623", #Bridge Expansion Joint
 "BHR" => "624 624", #Bridge Handrail
 "BLC" => "626 626", #Bridge Low Element Elevation � Concrete - The bottom of the concrete bridge
			# beams.  Usually taken at the beginning middle and end of each span of
			# the bridge beams. Usually only required on the outside (upstream and 
			# downstream) beams.
 "BLS" => "627 627", #Bridge Low Element Elevation � Steel - The bottom of the steel bridge beams.
			# Usually taken at the beginning middle and end oof each span of the
			# bridge beams. Usually only required on the outside (upstream and
			# downstream) beams.
 "BLT" => "628 628", #Bridge Low Element Elevation � Timber - The bottom of the timber bridge
			# beams.  Usually taken at the beginning middle and end of each span of
			# the bridge beams. Usually only required on the outside (upstream and
			# downstream) beams.
 "BOL" => "419 419", #Post / Bollard
 "BOR" => "640 640", #Soil Boring / Coring
 "BPA" => "633 633", #Bridge Parapet � 3D
 "BPC" => "629 629", #Bridge Pier - 2D Prismless - The outline of the face of the pier cap.
			# A 2d line usually collected "prismless".
 "BPR" => "615 BPR", #Bridge Pier - Top Face - 3D
 "BPT" => "631 631", #Bridge Pier Top Elevation Only - The pier cap elevation - For elevation
			# only.  Usually collected with the "hook".
 "BRK" => "607 607", #Breakline
 "BRR" => "579 579", #Barrier Wall - base
 "BSC" => "641 641", #Bridge Scupper (drain)
 "BSH" => "408 408", #Bush / Shrub
 "BSL" => "412 412", #Bush Line / Hedgerow
 "BSS" => "633 BSS", #Bridge Structural Steel Member (not low steel)
 "BWL" => "612 612", #Bridge Backwall � 3D
 "BWW" => "635 635", #Bridge Wingwall - Top Face & Back � 3D - The outline of the face and
			# sides of the wingwall.  A 3d line with points at each elevation change.
 "CBM" => "307 307", #Storm - CB - round open
 "CKH" => "135 135", #Check horizontal control point
 "CKV" => "134 134", #Check BM
 "CNA" => "607 CNA", #Pavement Crown � aggregate � use where no stripeing
 "CNB" => "607 CNB", #Pavement Crown � HMA - use where no stripeing
 "CNC" => "607 CNC", #Pavement Crown � Concrete - use where no stripeing
 "CNP" => "683 683", #Canopy
 "CNT" => "225 225", #Signal Cantilever/Mast Arm
 "COL" => "609 COL", #Column
 "CPH" => "103 103", #Control Point
 "CPT" => "354 CPT", #Cathodic Protection Test Station � Gas
 "CRB" => "501 501", #Curb Top Back - concrete
 "CRP" => "411 411", #Crop / Cultivation Line
 "CRW" => "279 279", #Crosswalk
 "CUB" => "303 303", #Storm-culvert-box
 "CUE" => "302 302", #Storm-culvert-Elliptical
 "CUP" => "300 300", #Storm-culvert-pipe
 "DAM" => "369 369", #Dam/Levee Top
 "DCA" => "652 DCA", #Driveway � Commercial � Aggregate
 "DCB" => "652 DCB", #Driveway � Commercial � HMA
 "DCC" => "652 DCC", #Driveway � Commercial � Concrete
 "DCK" => "608 608", #Deck
 "DCR" => "652 DCR", #Driveway � Commercial � Brick
 "DFA" => "654 DFA", #Driveway � Field � Aggregate
 "DFB" => "654 DFB", #Driveway � Field � HMA
 "DFC" => "654 DFC", #Driveway � Field � Conc
 "DFG" => "654 DFG", #Driveway � Field � Ground
 "DFO" => "654 DFO", #Driveway � Field � Oil & Chip
 "DFR" => "654 DFR", #Driveway � Field � Brick
 "DPA" => "656 DPA", #Driveway � Public � Aggregate
 "DPB" => "656 DPB", #Driveway � Public � HMA
 "DPC" => "656 DPC", #Driveway � Public � Concrete
 "DPR" => "656 DPR", #Driveway � Public � Brick
 "DRA" => "649 DRA", #Driveway � Residential � Aggregate
 "DRB" => "649 DRB", #Driveway � Residential � HMA
 "DRC" => "649 DRC", #Driveway � Residential � Concrete
 "DRR" => "649 DRR", #Driveway � Residential � Brick
 "DSP" => "304 DSP", #Downspout
 "DTH" => "363 363", #Ditch - Flowline
 "DTP" => "359 359", #Paved Ditch Centerline
 "EOA" => "668 EOA", #EOP Line � Aggregate
 "EOB" => "668 EOB", #EOP Line � HMA
 "EOC" => "668 EOC", #EOP Line � Concrete
 "EOG" => "668 EOG", #EOP Line � Ground � Travelled Way
 "EOO" => "668 EOO", #EOP Line � Oil & Chip
 "EOR" => "668 EOR", #EOP Line � Brick
 "FES" => "309 309", #Flared End Section
 "FFL" => "650 650", #Finish Floor Elevation
 "FNG" => "418 418", #Fence - Gate post
 "FNI" => "414 414", #Fence � Iron
 "FNL" => "414 414", #Fence � Chain Link
 "FNM" => "414 414", #Fence � Masonry
 "FNN" => "414 414", #Fence � Stone
 "FNR" => "414 414", #Fence � Brick
 "FNT" => "414 414", #Fence � Wood
 "FNV" => "414 414", #Fence � Vinyl
 "FNW" => "414 414", #Fence � Wire
 "FNX" => "414 414", #Fence � Barbed Wire
 "FOU" => "795 795", #Foundation
 "GCC" => "600 600", #Building � Commercial � Concrete
 "GCF" => "600 600", #Building � Commercial � Frame
 "GCM" => "600 600", #Building � Commercial � Masonry
 "GCN" => "600 600", #Building � Commercial � Stone
 "GCR" => "600 600", #Building � Commercial � Brick
 "GCS" => "600 600", #Building � Commercial � Steel
 "GCT" => "600 600", #Building � Commercial � Timber/Log
 "GND" => "604 604", #Ground Shot
 "GPC" => "601 601", #Building � Residential � Concrete
 "GPF" => "601 601", #Building � Public � Frame
 "GPM" => "601 601", #Building � Public � Masonry
 "GPN" => "601 601", #Building � Public � Stone
 "GPR" => "601 601", #Building � Public � Brick
 "GPS" => "601 601", #Building � Public � Steel
 "GPT" => "601 601", #Building � Public � Timber/Log
 "GRC" => "602 602", #Building � Residential � Concrete
 "GRF" => "602 602", #Building � Residential � Frame
 "GRL" => "420 420", #Guard Rail
 "GRM" => "602 602", #Building � Residential � Masonry
 "GRN" => "602 602", #Building � Residential � Stone
 "GRR" => "602 602", #Building � Residential � Brick
 "GRS" => "602 602", #Building � Residential � Steel
 "GRT" => "602 602", #Building � Residential � Timber/Log
 "GUP" => "251 251", #Pole-Guy 
 "GUT" => "575 575", #Gutter/Flowline
 "GUY" => "265 265", #Pole-Guy Wire
 "H2O" => "867 867", #Water Line
 "HHD" => "275 275", #Handhole - Traffic Signal - Double
 "HHE" => "274 274", #Handhole � Electric
 "HHF" => "274 HHF", #Handhole � Fiber Optic
 "HHR" => "274 HHR", #Handhole � Traffic
 "HHS" => "274 HHS", #Handhole � Traffic Fiber Optic
 "HHT" => "274 HHT", #Handhole � Telephone
 "HHV" => "274 HHV", #Handhole � TV
 "HWL" => "311 311", #Headwall
 "HYD" => "323 323", #Hydrant
 "INL" => "339 339", #Inlet - Rectangular
 "JUE" => "285 285", #QL-B Paint Mark Line - Electric
 "JUF" => "289 289", #QL-B Paint Mark Line - Fiber Optic
 "JUG" => "942 942", #QL-B Paint Mark Line - Gas
 "JUM" => "962 962", #QL-B Paint Mark Line - Storm
 "JUN" => "960 960", #QL-B Paint Mark Line - Sanitary
 "JUP" => "688 942", #QL-B Paint Mark Line - Petroleum
 "JUR" => "224 224", #QL-B Paint Mark Line - Traffic Signal
 "JUS" => "224 224", #QL-B Paint Mark Line - Traffic Signal Fiber Optic
 "JUT" => "286 286", #QL-B Paint Mark Line - Telephone
 "JUV" => "288 288", #QL-B Paint Mark Line - Television
 "JUW" => "689 689", #QL-B Paint Mark Line - Water
 "LNB" => "678 678", #Lane Line � HMA
 "LNC" => "678 678", #Lane Line � Concrete
 "LND" => "318 318", #Landscape edge
 "LNM" => "694 694", #Lane Paint Mark
 "MBX" => "400 400", #Mailbox
 "MCS" => "297 297", #Misc Concrete Slab
 "MED" => "578 578", #Top Front of Median
 "MHE" => "280 MHE", #Manhole � Electric
 "MHF" => "346 MHF", #Manhole � Fiber
 "MHG" => "346 346", #Gas Valve Vault
 "MHM" => "351 351", #Manhole � Storm
 "MHN" => "337 337", #Manhole -Sanitary
 "MHT" => "280 280", #Manhole � Telephone
 "MHW" => "346 MHW", #Water Valve Vault
 "MSC" => "699 699", #Misc.
 "MTE" => "330 330", #Meter � Electric
 "MTG" => "329 329", #Meter � Gas
 "MTW" => "331 331", #Meter � Water
 "MWL" => "640 640", #Well - Inspection/Monitoring
 "NPS" => "226 226", #No Pass
 "PAB" => "297 297", #Patio Edge � HMA
 "PAC" => "297 297", #Patio Edge � Concrete
 "PAM" => "297 297", #Patio Edge � Masonry
 "PAN" => "297 297", #Patio Edge � Stone
 "PAR" => "297 297", #Patio Edge � Brick
 "PDE" => "282 282", #Pedestal/Riser � Electric
 "PDF" => "283 283", #Pedestal/Riser � Fiber
 "PDT" => "283 283", #Pedestal/Riser � Telephone
 "PDV" => "284 284", #Pedestal/Riser � TV
 "PHB" => "298 298", #Phone Booth
 "PLF" => "691 691", #Flag Pole
 "PLT" => "252 252", #Pole-light only
 "PMA" => "666 666", #Spot-Pavement � Aggregate
 "PMB" => "666 666", #Spot-Pavement � HMA
 "PMC" => "666 666", #Spot-Pavement � Concrete
 "PMO" => "666 666", #Spot-Pavement � Oil & Chip
 "PMR" => "666 666", #Spot-Pavement � Brick
 "PPL" => "254 254", #Pole-Utility with light
 "PPT" => "255 255", #Pole-Utility w/ transformer
 "PPU" => "253 253", #Pole-Utility
 "PRK" => "682 682", #Parking Meter
 "PUG" => "684 684", #Pump � Gas
 "PUM" => "962 ???", #Pump � Storm
 "PUN" => "960 ???", #Pump � Sanitary
 "PUP" => "819 ???", #Pump � Petroleum
 "PUW" => "980 ???", #Pump � Water
 "RCK" => "699 699", #Rock or Boulder
 "RCL" => "450 450", #RR centerline
 "RDR" => "464 464", #RR Derailer
 "RGG" => "335 335", #Gas Regulator
 "RIP" => "605 605", #Riprap
 "RMP" => "461 461", #RR Mile Post Marker
 "ROW" => "213 213", #ROW Monument
 "RPA" => "659 659", #Ramp � Aggregate
 "RPB" => "659 659", #Ramp � HMA
 "RPC" => "659 659", #Ramp � Concrete
 "RPF" => "659 659", #Ramp � Frame
 "RPG" => "659 659", #Ramp � Ground
 "RPM" => "659 659", #Ramp � Masonry
 "RPN" => "659 659", #Ramp � Stone
 "RPR" => "659 659", #Ramp � Brick
 "RPS" => "659 659", #Ramp - Steel
 "RPT" => "659 659", #Ramp � Wood
 "RRC" => "458 458", #RR signal cabinet
 "RRF" => "463 463", #RR Point of Frog - 1 point
 "RRG" => "466 466", #RR crossing gate
 "RRH" => "455 455", #RR Switch Heater 
 "RRP" => "456 456", #RR Semaphore
 "RRR" => "451 451", #RR top of rail
 "RRS" => "462 462", #RR Point of Switch take shot on side of switch box
 "RRT" => "467 467", #RR Tie
 "RRW" => "455 455", #RR Switch Box
 "RVT" => "606 606", #Revetment Mat
 "RWC" => "296 296", #Retaining Wall � Concrete
 "RWM" => "296 296", #Retaining Wall � Masonry
 "RWN" => "296 296", #Retaining Wall � Stone
 "RWR" => "296 296", #Retaining Wall � Brick
 "RWS" => "296 296", #Retaining Wall � Steel
 "RWT" => "296 296", #Retaining Wall � Timber
 "SBE" => "282 282", #Splice Box � Electric
 "SBF" => "283 ???", #Splice Box � Fiber
 "SBR" => "281 223", #Splice Box � Traffic
 "SBS" => "281 ???", #Splice Box � Traffic Fiber
 "SBT" => "283 281", #Splice Box � Telephone
 "SBV" => "284 SBV", #Splice Box � TV
 "SHA" => "674 674", #Shoulder � Aggregate
 "SHB" => "674 674", #Shoulder � HMA
 "SHC" => "674 674", #Shoulder � Concrete
 "SLB" => "297 297", #Slab � HMA
 "SLC" => "297 297", #Slab � Concrete
 "SNC" => "423 423", #Sign - Commercial
 "SNE" => "350 350", #Sign - Warning - UG Electric
 "SNF" => "350 350", #Sign - Warning - Fiber Optic
 "SNG" => "350 350", #Sign - Warning - Gas
 "SNL" => "424 424", #Sign - For Line Coding
 "SNN" => "350 350", #Sign - Warning - Sanitary Line
 "SNP" => "350 350", #Sign - Warning - Petroleum
 "SNR" => "673 673", #Sign - Traffic
 "SNS" => "350 ???", #Sign - Traffic Fiber Optic
 "SNT" => "350 674", #Sign - Warning - Telephone/Communications
 "SNV" => "350 675", #Sign - Warning - Cable TV
 "SNW" => "350 676", #Sign - Warning - Water line
 "SPA" => "103 677", #Survey Point - Traverse Point
 "SPB" => "207 678", #Survey Point - Axle
 "SPC" => "207 SPC", #Survey Point - Cut Cross
 "SPD" => "207 680", #Survey Point - Concrete Monument
 "SPE" => "207 681", #Survey Point - Crimp Pipe
 "SPF" => "103 682", #Survey Point - Benchmark
 "SPG" => "103 683", #Survey Point - GPS Monument
 "SPH" => "103 684", #Survey Point - Control Point
 "SPI" => "207 SPI", #Survey Point - Iron Pipe
 "SPJ" => "207 686", #Survey Point - Nail
 "SPK" => "207 687", #Survey Point - Nail & Washer/Shiner
 "SPL" => "207 688", #Survey Point - PK Nail
 "SPM" => "207 SPM", #Survey Point - Mag Nail
 "SPN" => "213 690", #Survey Point - ROW Marker
 "SPO" => "207 691", #Survey Point - RR Spike
 "SPP" => "207 SPP", #Survey Point - Pole Barn Spike
 "SPQ" => "207 693", #Survey Point - Stone
 "SPR" => "207 694", #Survey Point - Cotton Picker Spindle
 "SPS" => "103 SPS", #Survey Point - Hub
 "SPT" => "207 696", #Survey Point - Cut Square
 "SPU" => "207 697", #Survey Point - Rebar
 "SPV" => "207 698", #Survey Point - Drill Hole
 "SPW" => "207 699", #Survey Point - Brass Marker
 "SPX" => "207 700", #Survey Point - Iron Rod/Pin
 "SPY" => "103 701", #Survey Point -
 "SPZ" => "207 702", #Survey Point - Other
 "STR" => "609 STR", #Stairs / Porch
 "SWA" => "291 291", #Sidewalk - Agg
 "SWB" => "291 291", #Sidewalk - HMA/BIT
 "SWC" => "291 291", #Sidewalk - Conc
 "SWN" => "291 291", #Sidewalk - Stone/Rock
 "SWR" => "291 291", #Sidewalk - Brick
 "THW" => "858 THW", #Thalweg - Lowest Point
 "TIL" => "304 709", #Field Tile/ Downspout
 "TNG" => "693 710", #Tank � Gas
 "TNP" => "693 711", #Tank � Petroleum
 "TNW" => "693 ???", #Tank � Water
 "TOE" => "860 TOE", #Toe of Slope
 "TOP" => "861 TOP", #Top of Slope
 "TRC" => "406 TRC", #Tree - Coniferous
 "TRD" => "405 TRD", #Tree - Deciduous
 "TRE" => "280 716", #Electric Transformer
 "TRF" => "220 717", #Traffic Signal
 "TRL" => "224 TRL", #Traffic Loop Detector
 "TWR" => "270 720", #Transmission Tower
 "UND" => "381 721", #Storm-underdrain
 "VLG" => "344 723", #Valve � Gas
 "VLN" => "341 VLN", #Valve � Sanitary
 "VLP" => "341 ???", #Valve � Petroleum
 "VLW" => "343 343", #Valve � Water
 "VNG" => "354 354", #Vent � Gas
 "VNN" => "354 354", #Vent � Sanitary
 "WAC" => "294 294", #Wall � not retaining �  Concrete
 "WAF" => "294 294", #Wall � not retaining � Frame
 "WAM" => "294 294", #Wall � not retaining � Masonry
 "WAN" => "294 294", #Wall � not retaining � Stone
 "WAR" => "294 294", #Wall � not retaining � Brick
 "WAS" => "294 294", #Wall � not retaining �  Steel
 "WAT" => "294 294", #Wall � not retaining � Timber 
 "WDE" => "410 410", #Wooded Edge
 "WEL" => "377 379", #Well - water
 "WET" => "379 379", #Wetland
 "WTR" => "867 867", #Water - Top Elevation
 "103" => "103 ???", #
 "111" => "111 ???", #
 "112" => "112 ???", #
 "118" => "118 ???", #
 "119" => "119 ???", #
 "134" => "134 ???", #
 "135" => "135 ???", #
 "200" => "200 ???", #
 "207" => "207 ???", #
 "210" => "210 ???", #
 "213" => "213 ???", #
 "220" => "220 ???", #
 "222" => "222 ???", #
 "223" => "223 ???", #
 "224" => "224 ???", #
 "225" => "225 ???", #
 "226" => "226 ???", #
 "252" => "252 ???", #
 "253" => "253 ???", #
 "254" => "254 ???", #
 "255" => "255 ???", #
 "265" => "265 ???", #
 "274" => "274 ???", #
 "275" => "275 ???", #
 "279" => "279 ???", #
 "280" => "280 ???", #
 "282" => "282 ???", #
 "283" => "283 ???", #
 "284" => "284 ???", #
 "285" => "285 ???", #
 "286" => "286 ???", #
 "288" => "288 ???", #
 "289" => "289 ???", #
 "291" => "291 ???", #
 "294" => "294 ???", #
 "296" => "296 ???", #
 "297" => "297 ???", #
 "300" => "300 ???", #
 "302" => "302 ???", #
 "303" => "303 ???", #
 "304" => "304 ???", #
 "307" => "307 ???", #
 "309" => "309 ???", #
 "311" => "311 ???", #
 "318" => "318 ???", #
 "319" => "319 ???", #
 "320" => "320 ???", #
 "323" => "323 ???", #
 "329" => "329 ???", #
 "330" => "330 ???", #
 "331" => "331 ???", #
 "335" => "335 ???", #
 "337" => "337 ???", #
 "339" => "339 ???", #
 "342" => "342 ???", #
 "343" => "343 ???", #
 "344" => "344 ???", #
 "346" => "346 ???", #
 "350" => "350 ???", #
 "351" => "351 ???", #
 "354" => "354 ???", #
 "359" => "359 ???", #
 "361" => "361 ???", #
 "363" => "363 ???", #
 "369" => "369 ???", #
 "377" => "377 ???", #
 "379" => "379 ???", #
 "381" => "381 ???", #
 "400" => "400 ???", #
 "405" => "405 ???", #
 "406" => "406 ???", #
 "408" => "408 ???", #
 "410" => "410 ???", #
 "411" => "411 ???", #
 "412" => "412 ???", #
 "414" => "414 ???", #
 "415" => "415 ???", #
 "417" => "417 ???", #
 "418" => "418 ???", #
 "419" => "419 ???", #
 "420" => "420 ???", #
 "423" => "423 ???", #
 "424" => "424 ???", #
 "450" => "450 ???", #
 "451" => "451 ???", #
 "455" => "455 ???", #
 "456" => "456 ???", #
 "458" => "458 ???", #
 "461" => "461 ???", #
 "462" => "462 ???", #
 "463" => "463 ???", #
 "466" => "466 ???", #
 "501" => "501 ???", #
 "509" => "509 ???", #
 "516" => "516 ???", #
 "575" => "575 ???", #
 "578" => "578 ???", #
 "579" => "579 ???", #
 "600" => "600 ???", #
 "601" => "601 ???", #
 "602" => "602 ???", #
 "604" => "604 ???", #
 "605" => "605 ???", #
 "606" => "606 ???", #
 "607" => "607 ???", #
 "609" => "609 ???", #
 "611" => "611 ???", #
 "612" => "612 ???", #
 "613" => "613 ???", #
 "615" => "615 ???", #
 "616" => "616 ???", #
 "618" => "618 ???", #
 "619" => "619 ???", #
 "620" => "620 ???", #
 "621" => "621 ???", #
 "623" => "623 ???", #
 "624" => "624 ???", #
 "626" => "626 ???", #
 "627" => "627 ???", #
 "628" => "628 ???", #
 "629" => "629 ???", #
 "631" => "631 ???", #
 "633" => "633 ???", #
 "634" => "634 ???", #
 "635" => "635 ???", #
 "640" => "640 ???", #
 "641" => "641 ???", #
 "649" => "649 ???", #
 "650" => "650 ???", #
 "652" => "652 ???", #
 "654" => "654 ???", #
 "656" => "656 ???", #
 "664" => "664 ???", #
 "666" => "666 ???", #
 "668" => "668 ???", #
 "669" => "669 ???", #
 "673" => "673 ???", #
 "674" => "674 ???", #
 "678" => "678 ???", #
 "682" => "682 ???", #
 "683" => "683 ???", #
 "689" => "689 ???", #
 "691" => "691 ???", #
 "694" => "694 ???", #
 "695" => "695 ???", #
 "699" => "699 ???", #
 "776" => "776 ???", #
 "795" => "795 ???", #
 "858" => "858 ???", #
 "860" => "860 ???", #
 "861" => "861 ???", #
 "867" => "867 ???", #
 "881" => "881 ???", #
 "930" => "930 ???", #
 "942" => "942 ???", #
 "960" => "960 ???", #
 "962" => "962 ???", #
 "980" => "980 ???", #
);

1;
