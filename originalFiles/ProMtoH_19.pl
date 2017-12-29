#!/bin/perl
#---------------------------------------
#
# ProMtoH_19.pl
# Fork of process.pl - convert MPS codes to Hoelscher codes
#
#
#----------------------------------------
# process_19.pl
# 20131107
# Modified:
# MHM
# MHN
# VLB
# VLW
# VLG
# BBG
# BBW
#----------------------------------------
# process_18.pl
# 20130621
# Change *_QA_lines.cor and *_QA_spots.cor to *_PtLn.cor
# Change *_QA_symbols.cor to *_cell.cor
# Remove all QA output files
# Removed the DTM file
# added:
#   RPF = point of frog - 1" point
#   RPS = point of switch
#   RSW = switch box
# Goals:
# rename variables
# add cathodic protection
#
####################################
# process_17.pl
# 20130322
# added:
#     VNG Gas Vent
#     PDF Pedestal Fiber Optic
#     HHF Handhole Fiber Optic
#     HHV Handhole TV
#     HHR Traffic Signal Handhole
#     HHE Handhole Electric
# change HHT from traffic signal handhole to Handhole Traffic
#     MHS Manhole Traffic Fiber Optic
############################################
##################################
# process_16.pl 20130116
# added BWC - Bridge Deck Sidewalk Concrete - BSW is depreciated
# added BSS - Bridge Structural Steel
# added BSC - Bridge Scupper
# added BDP - Bridge Deck Plate
# change BPA from 624 to 633 and eliminated 'required Comment'"PARAPET'
# depreciated edge of pavement/edge of shoulder combinations used on IL-83 (fail). ERB-EWC.
# depreciated RNW Runway
# depreciated 667 as IDOT code for crown (CRB/CRC) using breakline 607 with material comments for 
  # pavement areas with no stripeing - use stripeing as breakline where possible
# Crown now has material types: CNB = HMA, CNC = CONC, etc. - see 667 above
# I'm going to stop using the B6B codes and start using CRB on all curbs unless they are 
  # odd (not B6.12 or B6.24).  Use the IDOT codes of odd curbs. - LV - The B6B and B62 will still
  # work.
# Changed BBA/BBB/BBC/BBR from 619 to 621 so that spots land on the Topo_BridgeStructures level
# added BUC - Building Commercial - BLD is being depreciated
# added BUP - Building Public - BLD is being depreciated
# added BUR - Building Residential - BLD is being depreciated
# changed RR centerline from CLR to RCL
# added BRR the base of a Barrier Wall
# added SBW Splice Box Water - weird sprinkler system above ground splice box at US-14 in Mt. Pleasant
###################################
#####################################       
# PROCESS_15.pl                             
# added SNN - Warning Sign - Sanitary
# added SNW - Warning Sign - Water     
########################
#####################################
# PROCESS_14.pl
#   added RCK - Rock or Boulder
########################
#-----------------------
# PROCESS_13.PL
#  ADDED SWA,B,C,R
# ADDED SBT - SPLICE BOX TELEPHONE
# added PDE - Pedestal Electric\
# ADDED BBA, BBB, BBC, BBR - BRIDGE DECK AGG, BIT, CONC, BRICK
# ADDED BSW - BRIDGE SIDEWALK

#
####################################
#----------------------------
# Process_12.pl
# added:
#  LNB = Lane Lines - HMA/BIT 
#  LNC = Lance Lines - Conc
#  TOE = Toe of Slope
#  TOP = Top of Slope
#  RIP = Riprap  
#  DCA = Driveway/Commercial Aggregate
#  DCB = Driveway/Commercial BIT/HMA
#  DCC = Driveway/Commercial Concrete
#  DCG = Driveway/Commercial Ground
#  DCR = Driveway/Commercial Brick
#  DFA = Driveway/Field Aggregate
#  DFB = Driveway/Field BIT/HMA
#  DFC = Driveway/Field Concrete
#  DFG = Driveway/Field Ground
#  DFR = Driveway/Field Brick
#  DPA = Driveway/Private-Residential Aggregate
#  DPB = Driveway/Private-Residential BIT/HMA
#  DPC = Driveway/Private-Residential Concrete
#  DPG = Driveway/Private-Residential Ground
#  DPR = Driveway/Private-Residential Brick
########################################   
#-----------------------
# Process_11.pl 20111028
#
# Added: FOU = Foundation
#  
########################
# Process_10.pl 20110729
#
# Process_8 had many improvements - however I also migrated to "Mapping Codes"
# (instead of "Line Codes") as an option in Geopak.  Using the "Mapping Codes" I was
# finally able to get the curves to work. These codes also needed to be at the beginning of 
# code like BL*EOP1.
#
# But the Mapping Code option forced the lines to be created in
# point number order.  This caused problems in processing.  It ignored 
# the order of the points in the ASCII file.
# For example, say you missed an EOP1 shot on a cross section and went back to it at the
# next set up.
# Now to draw that line correctly using the "Line Coding" option you can reorder the records in
# the ASCII file like:
# 1,1000,1000,EOP1,L
# 2,1000,1010,EOP1,
# 40,1000,1020,EOP1,
# 3,1000,1030,EOP1,
#
# In the "Mapping Codes" option, the order of the ASCII file is ignored and the EOP1 are sorted
# so that the line goes 1,2,3,40.
#
# This was too big of a complication to screw with; we would need to RENUMBER points to 
# get the line to draw correctly.
# So this version has the latest code changes (MPS_IDOTCodes_V02_15.xlsx) and reverts back to 
# processing with the "Line Coding" option.
#
##############################################################################
#
#########################################################################
# The following array maps keys used by Field Surveyors 
#
#
# Codes not in the list pass through unchanged
#####################################################################################
%pointCodes = (  # ABC -> 123
 #"XXX" => "XXX",
 "AEM" => "930", # AG Electric Main
 #"AGE" => "674", # Shoulder Aggregate Edge
 "B62" => "516", # Curb B6-24 Top Back - depreciated
 "B6B" => "509", # Curb B6-12 Top Back - depreciated
 "B6F" => "510", # Curb B6-12 Flowline #deleted v6 # added back v15 - depreciated
 #"B6T" => "508", # Curb B6-12 Top Front #deleted v6
 "BAB" => "615", # Bridge Abutment Cap Top.  The outline of the face,sides,
                  # and top of the abutment.  A 3d line.
 "BAL" => "613", # The outline of the face of the abutment and the face of the
                  # wingwalls.  A 2d line, usually collected prismless.
 "BAR" => "274", #H Stop Bar
 "BAS" => "618", # Bridge Approach Slab
 #"BAT" => "615", # Bridge Abutment Top
 "BBA" => "619", # Bridge Deck - AGG - Spots only
 "BBB" => "619", # Bridge Deck - BIT - Spots only
 "BBC" => "619", # Bridge Deck - CONC - Spots only
 "BBG" => "319", # Buffalo Box - Gas
 "BBR" => "619", # Bridge Deck - BRICK - Spots only
 "BBS" => "620", # Bridge Seat.  The bridge seat elevation.  For elevation only.  Usually collected
                  # with the "hook".
 "BBW" => "320", # Buffalo Box - Water
 #"BBX" => "320", # Water Buffalo Box
 "BCB" => "611", # Bridge Curb.  The top back of any curb or median on a bridge.
 "BDB" => "619", # Bridge Deck. The line of the bit bridge deck.  A 3d line.
 "BDC" => "619", # Bridge Deck. The line of the concrete bridge deck.  A 3d line.
 "BDP" => "619", # Bridge Deck Plate
 "BDT" => "619", # Bridge Desk Timber
 #"BDK" => "619", # Bridge Deck
 "BEX" => "623", # Bridge Expansion Joint.  A 3d line.
 "BHR" => "624", # Bridge Handrail
 "BLD" => "601", # v16 start of depreciation
 "BLC" => "626", # The bottom of the concrete bridge beams.  Usually taken at
                  # the beginning middle and end oof each span of the bridge beams.
                  # Usually only required on the outside (upstream and downstream) beams.
 "BLS" => "627", # The bottom of the steel bridge beams.  Usually taken at
                  # the beginning middle and end oof each span of the bridge beams.
                  # Usually only required on the outside (upstream and downstream) beams.
 "BLT" => "628", # The bottom of the timber bridge beams.  Usually taken at
                  # the beginning middle and end oof each span of the bridge beams.
                  # Usually only required on the outside (upstream and downstream) beams.
 "BMK" => "102", #H Benchmark
 "BOL" => "372", #H Bollard / Post
 "BOR" => "158", #H Soil Boring?
 "BPA" => "633", # Bridge Parapet / Handrail.  A 2d line.
 "BPC" => "629", # The outline of the face of the pier cap. A 2d line usually
                  # collected "prismless".
 "BPR" => "615", # Pier Cap.  The outline of the face, sides and top of the pier cap.  A 3d line.
 "BPT" => "631", # The pier cap elevation,  For elevation only.  Usually collected
                  # with the "hook".
 
 #"BRC" => "611", # Bridge Curb
 "BRK" => "154", #H Breakline
 "BRR" => "579", # Barrier Wall
 "BSC" => "641", # Bridge Scupper
 "BSH" => "800", #H Bush/Shrub
 "BSL" => "803", #H Bush Line/ Hedgerow added v6
 "BSS" => "633", # Bridge Structural Steel
 #"BSW" => "291", # Bridge Sidewalk - depreciated
 "BUC" => "300", #H Building - Commercial
 "BUP" => "601", # Building - Public
 "BUR" => "602", # Building - Residential
 "BWC" => "619", # Bridge Deck Sidewalk Concrete
 "BWL" => "612", # Bridge Backwall The outline of the face and sides of the
                  # bridge back wall.  A 3d line.
 #"BWT" => "635", # Bridge Wing Wall Top Elevation
 "BWW" => "635", # The outline of the face and sides of the wingwall.  A 3d line with
                  # points at each elevation change.
 "CBM" => "943", #H Catch Basin Grate
 "CDE" => "400", #H Conduit Electrical
 "CDF" => "600", #H Conduit Telephone
 "CKH" => "120", #H Check Horizontal Control
 "CKV" => "120", #H Check Vertical Control
 "CLR" => "450", # RR centerline - depreciated
 "CNA" => "607", # Crown - AGG
 "CNB" => "607", # Crown - BIT/HMA - use stripeing as breakline where possible
 "CNC" => "607", # Crown - CONC - use stripeing as breakline where possible
 "CNR" => "607", # Crown - BRICK
 "CNP" => "683", # Canopy
 "CNT" => "225", # Traffic Signal Cantilever/Mast Arm
 "COL" => "352", #H Column
 "CPH" => "100", #H Control Point - modified v6
 "CRB" => "263", #H Curb Top - Generic
 "CRN" => "667", # Depreciated see CNA-CNR
 "CRP" => "411", # Crop Line
 "CRW" => "274", #H Crosswalk
 "CUB" => "303",
 "CUE" => "302",
 "CUP" => "970", #H Culvert 
 "DAM" => "369",
 "DCA" => "652", # ver12 - Driveway/Commercial Aggregate                 
 "DCB" => "652", # ver12 - Driveway/Commercial BIT/HMA           
 "DCC" => "652", # ver12 - Driveway/Commercial Concrete          
 "DCG" => "652", # ver12 - Driveway/Commercial Ground - Field Entrance          
 "DCR" => "652", # ver12 - Driveway/Commercial Brick             
 "DFA" => "654", # ver12 - Driveway/Field Aggregate              
 "DFB" => "654", # ver12 - Driveway/Field BIT/HMA                
 "DFC" => "654", # ver12 - Driveway/Field Concrete               
 "DFG" => "654", # ver12 - Driveway/Field Ground - Field Entrance                 
 "DFR" => "654", # ver12 - Driveway/Field Brick                  
 "DPA" => "656", # ver12 - Driveway/Private-Residential Aggregate
 "DPB" => "656", # ver12 - Driveway/Private-Residential BIT/HMA  
 "DPC" => "656", # ver12 - Driveway/Private-Residential Concrete 
 "DPG" => "656", # ver12 - Driveway/Private-Residential Ground - Field Entrance
 "DPR" => "656", # ver12 - Driveway/Private-Residential Brick    
 "DRA" => "649", # Driveway - aggregate
 "DRB" => "649", # Driveway - HMA
 "DRC" => "649", # Driveway - Concrete
 "DRG" => "649", # Field Entrance
 "DRR" => "649", # Driveway - Brick 
 "DRV" => "649", # Depreciated see DCA Thru DPR
 "DSP" => "304", # Downspout
 "DTH" => "151", #H Ditch Flowline
 "DTP" => "359", # Ditch - Paved - Centerline
 "EOA" => "246", #H Edge of pavement - aggregate
 "EOB" => "241", #H Edge of pavement - bit/hma
 "EOC" => "243", #H Edge of pavement - concrete 
 "EOL" => "678", # Edge of Lanes - added v6
 "EOR" => "242", #H Edge of pavement - Brick
 #"EOP" => "668", # Edge of pavement
 "FES" => "309",
 "FFL" => "354", #H Finish Floor/Threshold Elevation
 #"FLO" => "363", # Flowline / Ditch
 "FNC" => "374", #H Fence
 "FND" => "100", #H 
 "FNG" => "381", #H Gate Post
 "FOU" => "795", # Foundation
 "GND" => "144", #H
 "GRL" => "420", # Guard Rail
 "GUT" => "253", #H Gutter/Flowline
 "GUY" => "402", #H
 "H2O" => "867", # Water Line
 "HHD" => "275", # Traffic Signal Handhole Double - added v6
 "HHE" => "403", #H Handhole - Electric
 "HHF" => "274", # Handhole - Fiber Optic
 "HHT" => "603", #H Handhole - Telephone
 "HHR" => "274", # Handhole - Traffic Signal Handhole
 "HHV" => "274", # Handhole - Cable TV
 "HWL" => "311",
 "HYD" => "702", #H Hydrant
 "INL" => "945", #H Inlet
 "JUE" => "405", #H JULIE Electric Mark
 "JUF" => "600", #H JULIE Communications Fiber Optic Mark
 "JUG" => "942",
 "JUM" => "962", # JULIE Storm Mark"
 "JUN" => "960", # JULIE Sanitary Mark
 "JUR" => "224",
 "JUS" => "224", # JULIE  Traffic Signal Fiber Optic Mark
 "JUT" => "286",
 "JUV" => "288",
 "JUW" => "689", # JULIE Waterline Mark
 "LNB" => "678", # Lane Line - HMA
 "LNC" => "678", # Lane Line - CONC 
 "LND" => "318",
 "LNM" => "274", #H Lane Mark - Stripeing
 "MBX" => "400",
 "MCS" => "323", #H Misc. Concrete Slab
 "MED" => "578", # Median
 "MHE" => "406", #H Manhole Electric
 "MHF" => "346", # Manhole Fiber Optic
 "MHG" => "346", # Manhole Gas
 "MHS" => "346", # Manhole Traffic Fiber Optic
 "MHM" => "956", #H Manhole Storm
 "MHN" => "337", # Manhole Sanitary
 "MHT" => "606", #H Manhole Telephone/Communications
 "MHV" => "280", # Manhole Cable TV
 "MHW" => "346", # Manhole Water
 "MSC" => "699", # Misc - added v6
 "MTE" => "330", # Meter - Electric
 "MTG" => "329", # Meter - Gas
 "MTW" => "331", # Meter Water
 "NPS" => "274", #H No passing line
 "PBB" => "666", # A spot elevation on a bit bridge deck.
 "PBC" => "666", # A spot elevation on a conc bridge deck.
 "PDE" => "413", #H Pedestal Electric
 "PDF" => "283", # Pedestal Fiber Optic
 "PDT" => "283",
 "PDV" => "284",
 "PLF" => "691",
 "PLT" => "383", #H Pole - Light Only
 "PMA" => "146", #H Pavement Spot- Aggregate
 "PMB" => "141", #H Pavement Spot- Bituminous
 "PMC" => "143", #H Pavement Spot- Concrete
 "PMR" => "666", # Pavement Spot- Brick
 "PMT" => "666", # Pavement
 "PPL" => "254", # Power Pole with Light added v6
 "PPT" => "255", # Power Pole with Transformer
 "PPU" => "409", #H Power Pole 
 "PRK" => "682", # Parking Meter
 "RCK" => "699", # Rock or Boulder
 "RCL" => "450", # Railroad Centerline
 "RGG" => "335", # Regulator - Gas
 "RIP" => "605", # Riprap
 #"RNW" => "376",
 "ROW" => "213",
 "RPF" => "463", # RR Point of Frog - 1" point
 "RPS" => "462", # RR Point of Switch
 "RRC" => "458",
 "RRG" => "466",
 "RRR" => "451",
 "RRS" => "456",
 "RSW" => "455", # RR Switch Box
 "RVT" => "606",
 "RWL" => "343", #H Retaining Wall
 "SBE" => "282",
 "SBR" => "223", # Traffic Signal Controller - changed v6
 "SBT" => "281", # SPLICE BOX TELEPHONE
 "SBV" => "281", # SPLICE BOX TELEVISION
 "SBW" => "281", # Splice Box for Sprinkler System
 "SHA" => "674", # Shoulder - Aggregate
 "SHB" => "674", # Shoulder - Bituminous
 "SHC" => "674", # Shoulder - Concrete
 "SNC" => "423", # Sign - Commercial
 "SNE" => "350",
 "SNF" => "350",
 "SNG" => "350",
 "SNN" => "350", # Warning Sign - Sanitary
 "SNL" => "387", #H Sign Line - for large signs 
 "SNP" => "350",
 "SNR" => "390", # Sign - Traffic
 "SNT" => "350",
 "SNV" => "350",
 "SNW" => "350", # Warning Sign - Water
 "SPC" => "699", # Special / Misc.
 "STR" => "609", # Stairs/Porch
 "SWK" => "291",
 "SWA" => "291", # SIDEWALK - AGG
 "SWB" => "291", # SIDEWALK - BIT/HMA
 "SWC" => "333", # SIDEWALK - CONC
 "SWR" => "291", # SIDEWALK - BRICK
 #"TOB" => "881", # Top of Bank
 "TIL" => "304", # Tile
 "TOE" => "860", # Toe of Slope
 "TOP" => "861", # Top of Slope
 "TRC" => "C00", #H Tree Coniferous 
 "TRD" => "D00", #H Tree deciduous
 "TRF" => "220", # Traffic Signal
 "TRL" => "224", # Traffic Signal Loop Detector
 "THW" => "858",
 "UND" => "381", # Underdrain 
 "VLB" => "342", # Valve Box
 "VLG" => "344", # Gas Valve
 "VLe" => "344",
 "VLN" => "337", # Valve for sanitary force main
 "VLW" => "716", #H Water Valve By Hydrant
 "VNG" => "354", # Gas Vent Pipe
 "VNT" => "354",
 "VNN" => "354",
 "WAL" => "343", #H Wall
 "WDE" => "410",
 "WET" => "379",
 "WTR" => "867",
# IDOT Codes Flow Through without change to code  ##################
 "100" => "100",
 "101" => "101",
 "102" => "102",
 "103" => "103",
 "104" => "104",
 "105" => "105",
 "106" => "106",
 "107" => "107",
 "108" => "108",
 "109" => "109",
 "110" => "110",
 "111" => "111",
 "112" => "112",
 "113" => "113",
 "114" => "114",
 "115" => "115",
 "116" => "116",
 "117" => "117",
 "118" => "118",
 "119" => "119",
 "120" => "120",
 "121" => "121",
 "122" => "122",
 "123" => "123",
 "124" => "124",
 "125" => "125",
 "126" => "126",
 "127" => "127",
 "128" => "128",
 "129" => "129",
 "130" => "130",
 "131" => "131",
 "132" => "132",
 "133" => "133",
 "134" => "134",
 "135" => "135",
 "136" => "136",
 "137" => "137",
 "138" => "138",
 "139" => "139",
 "140" => "140",
 "141" => "141",
 "142" => "142",
 "143" => "143",
 "144" => "144",
 "145" => "145",
 "146" => "146",
 "147" => "147",
 "148" => "148",
 "149" => "149",
 "150" => "150",
 "151" => "151",
 "152" => "152",
 "153" => "153",
 "154" => "154",
 "155" => "155",
 "156" => "156",
 "157" => "157",
 "158" => "158",
 "159" => "159",
 "160" => "160",
 "161" => "161",
 "162" => "162",
 "163" => "163",
 "164" => "164",
 "165" => "165",
 "166" => "166",
 "167" => "167",
 "168" => "168",
 "169" => "169",
 "170" => "170",
 "171" => "171",
 "172" => "172",
 "173" => "173",
 "174" => "174",
 "175" => "175",
 "176" => "176",
 "177" => "177",
 "178" => "178",
 "179" => "179",
 "180" => "180",
 "181" => "181",
 "182" => "182",
 "183" => "183",
 "184" => "184",
 "185" => "185",
 "186" => "186",
 "187" => "187",
 "188" => "188",
 "189" => "189",
 "190" => "190",
 "191" => "191",
 "192" => "192",
 "193" => "193",
 "194" => "194",
 "195" => "195",
 "196" => "196",
 "197" => "197",
 "198" => "198",
 "199" => "199",
 "200" => "200",
 "201" => "201",
 "202" => "202",
 "203" => "203",
 "204" => "204",
 "205" => "205",
 "206" => "206",
 "207" => "207",
 "208" => "208",
 "209" => "209",
 "210" => "210",
 "211" => "211",
 "212" => "212",
 "213" => "213",
 "214" => "214",
 "215" => "215",
 "216" => "216",
 "217" => "217",
 "218" => "218",
 "219" => "219",
 "220" => "220",
 "221" => "221",
 "222" => "222",
 "223" => "223",
 "224" => "224",
 "225" => "225",
 "226" => "226",
 "227" => "227",
 "228" => "228",
 "229" => "229",
 "230" => "230",
 "231" => "231",
 "232" => "232",
 "233" => "233",
 "234" => "234",
 "235" => "235",
 "236" => "236",
 "237" => "237",
 "238" => "238",
 "239" => "239",
 "240" => "240",
 "241" => "241",
 "242" => "242",
 "243" => "243",
 "244" => "244",
 "245" => "245",
 "246" => "246",
 "247" => "247",
 "248" => "248",
 "249" => "249",
 "250" => "250",
 "251" => "251",
 "252" => "252",
 "253" => "253",
 "254" => "254",
 "255" => "255",
 "256" => "256",
 "257" => "257",
 "258" => "258",
 "259" => "259",
 "260" => "260",
 "261" => "261",
 "262" => "262",
 "263" => "263",
 "264" => "264",
 "265" => "265",
 "266" => "266",
 "267" => "267",
 "268" => "268",
 "269" => "269",
 "270" => "270",
 "271" => "271",
 "272" => "272",
 "273" => "273",
 "274" => "274",
 "275" => "275",
 "276" => "276",
 "277" => "277",
 "278" => "278",
 "279" => "279",
 "280" => "280",
 "281" => "281",
 "282" => "282",
 "283" => "283",
 "284" => "284",
 "285" => "285",
 "286" => "286",
 "287" => "287",
 "288" => "288",
 "289" => "289",
 "290" => "290",
 "291" => "291",
 "292" => "292",
 "293" => "293",
 "294" => "294",
 "295" => "295",
 "296" => "296",
 "297" => "297",
 "298" => "298",
 "299" => "299",
 "300" => "300",
 "301" => "301",
 "302" => "302",
 "303" => "303",
 "304" => "304",
 "305" => "305",
 "306" => "306",
 "307" => "307",
 "308" => "308",
 "309" => "309",
 "310" => "310",
 "311" => "311",
 "312" => "312",
 "313" => "313",
 "314" => "314",
 "315" => "315",
 "316" => "316",
 "317" => "317",
 "318" => "318",
 "319" => "319",
 "320" => "320",
 "321" => "321",
 "322" => "322",
 "323" => "323",
 "324" => "324",
 "325" => "325",
 "326" => "326",
 "327" => "327",
 "328" => "328",
 "329" => "329",
 "330" => "330",
 "331" => "331",
 "332" => "332",
 "333" => "333",
 "334" => "334",
 "335" => "335",
 "336" => "336",
 "337" => "337",
 "338" => "338",
 "339" => "339",
 "340" => "340",
 "341" => "341",
 "342" => "342",
 "343" => "343",
 "344" => "344",
 "345" => "345",
 "346" => "346",
 "347" => "347",
 "348" => "348",
 "349" => "349",
 "350" => "350",
 "351" => "351",
 "352" => "352",
 "353" => "353",
 "354" => "354",
 "355" => "355",
 "356" => "356",
 "357" => "357",
 "358" => "358",
 "359" => "359",
 "360" => "360",
 "361" => "361",
 "362" => "362",
 "363" => "363",
 "364" => "364",
 "365" => "365",
 "366" => "366",
 "367" => "367",
 "368" => "368",
 "369" => "369",
 "370" => "370",
 "371" => "371",
 "372" => "372",
 "373" => "373",
 "374" => "374",
 "375" => "375",
 "376" => "376",
 "377" => "377",
 "378" => "378",
 "379" => "379",
 "380" => "380",
 "381" => "381",
 "382" => "382",
 "383" => "383",
 "384" => "384",
 "385" => "385",
 "386" => "386",
 "387" => "387",
 "388" => "388",
 "389" => "389",
 "390" => "390",
 "391" => "391",
 "392" => "392",
 "393" => "393",
 "394" => "394",
 "395" => "395",
 "396" => "396",
 "397" => "397",
 "398" => "398",
 "399" => "399",
 "400" => "400",
 "401" => "401",
 "402" => "402",
 "403" => "403",
 "404" => "404",
 "405" => "405",
 "406" => "406",
 "407" => "407",
 "408" => "408",
 "409" => "409",
 "410" => "410",
 "411" => "411",
 "412" => "412",
 "413" => "413",
 "414" => "414",
 "415" => "415",
 "416" => "416",
 "417" => "417",
 "418" => "418",
 "419" => "419",
 "420" => "420",
 "421" => "421",
 "422" => "422",
 "423" => "423",
 "424" => "424",
 "425" => "425",
 "426" => "426",
 "427" => "427",
 "428" => "428",
 "429" => "429",
 "430" => "430",
 "431" => "431",
 "432" => "432",
 "433" => "433",
 "434" => "434",
 "435" => "435",
 "436" => "436",
 "437" => "437",
 "438" => "438",
 "439" => "439",
 "440" => "440",
 "441" => "441",
 "442" => "442",
 "443" => "443",
 "444" => "444",
 "445" => "445",
 "446" => "446",
 "447" => "447",
 "448" => "448",
 "449" => "449",
 "450" => "450",
 "451" => "451",
 "452" => "452",
 "453" => "453",
 "454" => "454",
 "455" => "455",
 "456" => "456",
 "457" => "457",
 "458" => "458",
 "459" => "459",
 "460" => "460",
 "461" => "461",
 "462" => "462",
 "463" => "463",
 "464" => "464",
 "465" => "465",
 "466" => "466",
 "467" => "467",
 "468" => "468",
 "469" => "469",
 "470" => "470",
 "471" => "471",
 "472" => "472",
 "473" => "473",
 "474" => "474",
 "475" => "475",
 "476" => "476",
 "477" => "477",
 "478" => "478",
 "479" => "479",
 "480" => "480",
 "481" => "481",
 "482" => "482",
 "483" => "483",
 "484" => "484",
 "485" => "485",
 "486" => "486",
 "487" => "487",
 "488" => "488",
 "489" => "489",
 "490" => "490",
 "491" => "491",
 "492" => "492",
 "493" => "493",
 "494" => "494",
 "495" => "495",
 "496" => "496",
 "497" => "497",
 "498" => "498",
 "499" => "499",
 "500" => "500",
 "501" => "501",
 "502" => "502",
 "503" => "503",
 "504" => "504",
 "505" => "505",
 "506" => "506",
 "507" => "507",
 "508" => "508",
 "509" => "509",
 "510" => "510",
 "511" => "511",
 "512" => "512",
 "513" => "513",
 "514" => "514",
 "515" => "515",
 "516" => "516",
 "517" => "517",
 "518" => "518",
 "519" => "519",
 "520" => "520",
 "521" => "521",
 "522" => "522",
 "523" => "523",
 "524" => "524",
 "525" => "525",
 "526" => "526",
 "527" => "527",
 "528" => "528",
 "529" => "529",
 "530" => "530",
 "531" => "531",
 "532" => "532",
 "533" => "533",
 "534" => "534",
 "535" => "535",
 "536" => "536",
 "537" => "537",
 "538" => "538",
 "539" => "539",
 "540" => "540",
 "541" => "541",
 "542" => "542",
 "543" => "543",
 "544" => "544",
 "545" => "545",
 "546" => "546",
 "547" => "547",
 "548" => "548",
 "549" => "549",
 "550" => "550",
 "551" => "551",
 "552" => "552",
 "553" => "553",
 "554" => "554",
 "555" => "555",
 "556" => "556",
 "557" => "557",
 "558" => "558",
 "559" => "559",
 "560" => "560",
 "561" => "561",
 "562" => "562",
 "563" => "563",
 "564" => "564",
 "565" => "565",
 "566" => "566",
 "567" => "567",
 "568" => "568",
 "569" => "569",
 "570" => "570",
 "571" => "571",
 "572" => "572",
 "573" => "573",
 "574" => "574",
 "575" => "575",
 "576" => "576",
 "577" => "577",
 "578" => "578",
 "579" => "579",
 "580" => "580",
 "581" => "581",
 "582" => "582",
 "583" => "583",
 "584" => "584",
 "585" => "585",
 "586" => "586",
 "587" => "587",
 "588" => "588",
 "589" => "589",
 "590" => "590",
 "591" => "591",
 "592" => "592",
 "593" => "593",
 "594" => "594",
 "595" => "595",
 "596" => "596",
 "597" => "597",
 "598" => "598",
 "599" => "599",
 "600" => "600",
 "601" => "601",
 "602" => "602",
 "603" => "603",
 "604" => "604",
 "605" => "605",
 "606" => "606",
 "607" => "607",
 "608" => "608",
 "609" => "609",
 "610" => "610",
 "611" => "611",
 "612" => "612",
 "613" => "613",
 "614" => "614",
 "615" => "615",
 "616" => "616",
 "617" => "617",
 "618" => "618",
 "619" => "619",
 "620" => "620",
 "621" => "621",
 "622" => "622",
 "623" => "623",
 "624" => "624",
 "625" => "625",
 "626" => "626",
 "627" => "627",
 "628" => "628",
 "629" => "629",
 "630" => "630",
 "631" => "631",
 "632" => "632",
 "633" => "633",
 "634" => "634",
 "635" => "635",
 "636" => "636",
 "637" => "637",
 "638" => "638",
 "639" => "639",
 "640" => "640",
 "641" => "641",
 "642" => "642",
 "643" => "643",
 "644" => "644",
 "645" => "645",
 "646" => "646",
 "647" => "647",
 "648" => "648",
 "649" => "649",
 "650" => "650",
 "651" => "651",
 "652" => "652",
 "653" => "653",
 "654" => "654",
 "655" => "655",
 "656" => "656",
 "657" => "657",
 "658" => "658",
 "659" => "659",
 "660" => "660",
 "661" => "661",
 "662" => "662",
 "663" => "663",
 "664" => "664",
 "665" => "665",
 "666" => "666",
 "667" => "667",
 "668" => "668",
 "669" => "669",
 "670" => "670",
 "671" => "671",
 "672" => "672",
 "673" => "673",
 "674" => "674",
 "675" => "675",
 "676" => "676",
 "677" => "677",
 "678" => "678",
 "679" => "679",
 "680" => "680",
 "681" => "681",
 "682" => "682",
 "683" => "683",
 "684" => "684",
 "685" => "685",
 "686" => "686",
 "687" => "687",
 "688" => "688",
 "689" => "689",
 "690" => "690",
 "691" => "691",
 "692" => "692",
 "693" => "693",
 "694" => "694",
 "695" => "695",
 "696" => "696",
 "697" => "697",
 "698" => "698",
 "699" => "699",
 "700" => "700",
 "701" => "701",
 "702" => "702",
 "703" => "703",
 "704" => "704",
 "705" => "705",
 "706" => "706",
 "707" => "707",
 "708" => "708",
 "709" => "709",
 "710" => "710",
 "711" => "711",
 "712" => "712",
 "713" => "713",
 "714" => "714",
 "715" => "715",
 "716" => "716",
 "717" => "717",
 "718" => "718",
 "719" => "719",
 "720" => "720",
 "721" => "721",
 "722" => "722",
 "723" => "723",
 "724" => "724",
 "725" => "725",
 "726" => "726",
 "727" => "727",
 "728" => "728",
 "729" => "729",
 "730" => "730",
 "731" => "731",
 "732" => "732",
 "733" => "733",
 "734" => "734",
 "735" => "735",
 "736" => "736",
 "737" => "737",
 "738" => "738",
 "739" => "739",
 "740" => "740",
 "741" => "741",
 "742" => "742",
 "743" => "743",
 "744" => "744",
 "745" => "745",
 "746" => "746",
 "747" => "747",
 "748" => "748",
 "749" => "749",
 "750" => "750",
 "751" => "751",
 "752" => "752",
 "753" => "753",
 "754" => "754",
 "755" => "755",
 "756" => "756",
 "757" => "757",
 "758" => "758",
 "759" => "759",
 "760" => "760",
 "761" => "761",
 "762" => "762",
 "763" => "763",
 "764" => "764",
 "765" => "765",
 "766" => "766",
 "767" => "767",
 "768" => "768",
 "769" => "769",
 "770" => "770",
 "771" => "771",
 "772" => "772",
 "773" => "773",
 "774" => "774",
 "775" => "775",
 "776" => "776",
 "777" => "777",
 "778" => "778",
 "779" => "779",
 "780" => "780",
 "781" => "781",
 "782" => "782",
 "783" => "783",
 "784" => "784",
 "785" => "785",
 "786" => "786",
 "787" => "787",
 "788" => "788",
 "789" => "789",
 "790" => "790",
 "791" => "791",
 "792" => "792",
 "793" => "793",
 "794" => "794",
 "795" => "795",
 "796" => "796",
 "797" => "797",
 "798" => "798",
 "799" => "799",
 "800" => "800",
 "801" => "801",
 "802" => "802",
 "803" => "803",
 "804" => "804",
 "805" => "805",
 "806" => "806",
 "807" => "807",
 "808" => "808",
 "809" => "809",
 "810" => "810",
 "811" => "811",
 "812" => "812",
 "813" => "813",
 "814" => "814",
 "815" => "815",
 "816" => "816",
 "817" => "817",
 "818" => "818",
 "819" => "819",
 "820" => "820",
 "821" => "821",
 "822" => "822",
 "823" => "823",
 "824" => "824",
 "825" => "825",
 "826" => "826",
 "827" => "827",
 "828" => "828",
 "829" => "829",
 "830" => "830",
 "831" => "831",
 "832" => "832",
 "833" => "833",
 "834" => "834",
 "835" => "835",
 "836" => "836",
 "837" => "837",
 "838" => "838",
 "839" => "839",
 "840" => "840",
 "841" => "841",
 "842" => "842",
 "843" => "843",
 "844" => "844",
 "845" => "845",
 "846" => "846",
 "847" => "847",
 "848" => "848",
 "849" => "849",
 "850" => "850",
 "851" => "851",
 "852" => "852",
 "853" => "853",
 "854" => "854",
 "855" => "855",
 "856" => "856",
 "857" => "857",
 "858" => "858",
 "859" => "859",
 "860" => "860",
 "861" => "861",
 "862" => "862",
 "863" => "863",
 "864" => "864",
 "865" => "865",
 "866" => "866",
 "867" => "867",
 "868" => "868",
 "869" => "869",
 "870" => "870",
 "871" => "871",
 "872" => "872",
 "873" => "873",
 "874" => "874",
 "875" => "875",
 "876" => "876",
 "877" => "877",
 "878" => "878",
 "879" => "879",
 "880" => "880",
 "881" => "881",
 "882" => "882",
 "883" => "883",
 "884" => "884",
 "885" => "885",
 "886" => "886",
 "887" => "887",
 "888" => "888",
 "889" => "889",
 "890" => "890",
 "891" => "891",
 "892" => "892",
 "893" => "893",
 "894" => "894",
 "895" => "895",
 "896" => "896",
 "897" => "897",
 "898" => "898",
 "899" => "899",
 "900" => "900",
 "901" => "901",
 "902" => "902",
 "903" => "903",
 "904" => "904",
 "905" => "905",
 "906" => "906",
 "907" => "907",
 "908" => "908",
 "909" => "909",
 "910" => "910",
 "911" => "911",
 "912" => "912",
 "913" => "913",
 "914" => "914",
 "915" => "915",
 "916" => "916",
 "917" => "917",
 "918" => "918",
 "919" => "919",
 "920" => "920",
 "921" => "921",
 "922" => "922",
 "923" => "923",
 "924" => "924",
 "925" => "925",
 "926" => "926",
 "927" => "927",
 "928" => "928",
 "929" => "929",
 "930" => "930",
 "931" => "931",
 "932" => "932",
 "933" => "933",
 "934" => "934",
 "935" => "935",
 "936" => "936",
 "937" => "937",
 "938" => "938",
 "939" => "939",
 "940" => "940",
 "941" => "941",
 "942" => "942",
 "943" => "943",
 "944" => "944",
 "945" => "945",
 "946" => "946",
 "947" => "947",
 "948" => "948",
 "949" => "949",
 "950" => "950",
 "951" => "951",
 "952" => "952",
 "953" => "953",
 "954" => "954",
 "955" => "955",
 "956" => "956",
 "957" => "957",
 "958" => "958",
 "959" => "959",
 "960" => "960",
 "961" => "961",
 "962" => "962",
 "963" => "963",
 "964" => "964",
 "965" => "965",
 "966" => "966",
 "967" => "967",
 "968" => "968",
 "969" => "969",
 "970" => "970",
 "971" => "971",
 "972" => "972",
 "973" => "973",
 "974" => "974",
 "975" => "975",
 "976" => "976",
 "977" => "977",
 "978" => "978",
 "979" => "979",
 "980" => "980",
 "981" => "981",
 "982" => "982",
 "983" => "983",
 "984" => "984",
 "985" => "985",
 "986" => "986",
 "987" => "987",
 "988" => "988",
 "989" => "989",
 "990" => "990",
 "991" => "991",
 "992" => "992",
 "993" => "993",
 "994" => "994",
 "995" => "995",
 "996" => "996",
 "997" => "997",
 "998" => "998",
 "999" => "999"   
);
#################################
# Begin QAQC lists
#
# last used scales for field check 
# General = 10
# Lines = 2
# Symbols = 40
########################################
                      
%lineCodes = ( # as of version 18 this list contains lines AND spots
#                the QA lists are depreciated
 "216" => "Existing Easement",
 "217" => "Prop. Perm. Easement",
 "218" => "Prop. Temp. Easement",
 "224" => "Detector Loop",
 "226" => "No Pass Paint Stripe",
 "229" => "Gutter Flow - Left",
 "230" => "Gutter Flow - Right",
 "231" => "Top of Curb - Left",
 "232" => "Top of Curb - Right",
 "233" => "Back of Curb - Left",
 "234" => "Back of Curb - Right",
 "235" => "Sidewalk - Near Left",
 "236" => "Sidewalk - Near Right",
 "237" => "Sidewalk - Far Left",
 "238" => "Sidewalk - Far Right",
 "240" => "SIDEWALK ST. NEAR RT",
 "241" => "SIDEWALK ST. NEAR LT",
 "242" => "SIDEWALK ST. FAR RT.",
 "243" => "SIDEWALK ST. FAR LT",
 "245" => "Bk Curb Edg Sw Lt",
 "246" => "Bk Curb Edg Sw Rt",
 "247" => "BIKE PATH - LEFT",
 "248" => "BIKE PATH - RIGHT",
 "279" => "Crosswalk",
 "285" => "Cable - Power",
 "286" => "Cable - Telephone",
 "287" => "Cable - Telegraph",
 "288" => "Cable - Television",
 "289" => "Fiber Optic Cable",
 "291" => "Sidewalk",
 "292" => "Sidewalk Edge",
 "293" => "Sidewalk Center",
 "294" => "Wall",
 "295" => "Wall - Noise",
 "296" => "Wall - Retaining",
 "297" => "Misc. Concrete Slab",
 "300" => "Culvert - Pipe",
 "301" => "Culvert - Pipe Arch",
 "302" => "Cul. Pipe Elliptical",
 "303" => "Culvert - Box",
 "304" => "Tile",
 "305" => "Drop Box",
 "310" => "End Sec. Fl. W/Grate",
 "311" => "Headwall",
 "314" => "FLOOD PLAIN SECTION",
 "315" => "GRASS WATERWAY",
 "316" => "WINNEBAGO INLET",
 "317" => "DITCH CHECK",
 "318" => "LANDSCAPE EDGE",
 "359" => "Paved Ditch",
 "360" => "Paved Ditch - Flat",
 "361" => "Paved Ditch - Round",
 "362" => "Paved Ditch - V",
 "363" => "Ditch",
 "364" => "Stream",
 "365" => "River",
 "366" => "Pond",
 "367" => "Lake",
 "368" => "Retention Basin",
 "369" => "Levee Top",
 "370" => "Levee Toe",
 "371" => "Dam Crest",
 "372" => "Spillway",
 "373" => "Apron",
 "374" => "Apron Top",
 "375" => "Apron Base",
 "376" => "Runway",
 "379" => "Wetland",
 "380" => "Gravel Wetland",
 "381" => "Underdrain Outlet Lt.",
 "382" => "Underdrain Outlet Rt.",
 "403" => "Grain Bin + Silo",
 "404" => "Oil Spill Dike",
 "410" => "Timber Edge",
 "411" => "Crop Line",
 "412" => "Hedgerow",
 "413" => "Cattle Guard",
 "414" => "Fence",
 "420" => "Guardrail",
 "421" => "Steel Plate Beam G.R.",
 "424" => "Sign Foundation",
 "425" => "Landscape",
 "450" => "Railroad Center Line",
 "451" => "Top of Rail",
 "452" => "Top Rail@ Guage Line",
 "453" => "R.R. Crossing Corner",
 "460" => "R.R. Battery Box",
 "500" => "Curb",
 "501" => "Curb - Top",
 "502" => "Curb - Back",
 "503" => "Curb - Depressed-Back",
 "504" => "Curb - Depressed-Front",
 "505" => "Curb - Type B - Top",
 "506" => "Curb - Type B - Back",
 "507" => "Curb & Gutter",
 "508" => "C.& G. - B-6-12 - Top",
 "509" => "C.& G. - B-6-12 - Back",
 "510" => "C.& G. - B-6-12 - FL",
 "511" => "C.& G. - B-6-18 - FL",
 "512" => "C.& G. - B-6-18 - Top",
 "513" => "C.& G. - B-6-18 - Back",
 "514" => "C.& G. - B-6-24 - FL",
 "515" => "C.& G. - B-6-24 - Top",
 "516" => "C.& G. - B-6-24 - Back",
 "517" => "C.& G. - B-9-12 - FL",
 "518" => "C.& G. - B-9-12 - Top",
 "519" => "C.& G. - B-9-12 - Back",
 "520" => "C.& G. - B-9-18 - FL",
 "521" => "C.& G. - B-9-18 - Top",
 "522" => "C.& G. - B-9-18 - Back",
 "523" => "C.& G. - B-9-24 - FL",
 "524" => "C.& G. - B-9-24 - Top",
 "525" => "C.& G. - B-9-24 - Back",
 "526" => "C.& G. - M-6-06 - FL",
 "527" => "C.& G. - M-6-06 - Top",
 "528" => "C.& G. - M-6-06 - Back",
 "529" => "C.& G. - M-6-12 - FL",
 "530" => "C.& G. - M-6-12 - Top",
 "531" => "C.& G. - M-6-12 - Back",
 "532" => "C.& G. - M-6-18 - FL",
 "533" => "C.& G. - M-6-18 - Top",
 "534" => "C.& G. - M-6-18 - Back",
 "535" => "C.& G. - M-6-24 - FL",
 "536" => "C.& G. - M-6-24 - Top",
 "537" => "C.& G. - M-6-24 - Back",
 "538" => "C.& G. - M-2-06 - FL",
 "539" => "C.& G. - M-2-06 - Top",
 "540" => "C.& G. - M-2-06 - Back",
 "541" => "C.& G. - M-2-12 - FL",
 "542" => "C.& G. - M-2-12 - Top",
 "543" => "C.& G. - M-2-12 - Back",
 "544" => "Median - SB-6-06 - Top",
 "545" => "Median - SB-6-06 - FL",
 "546" => "Median - SB-6-12 - Top",
 "547" => "Median - SB-6-24 - FL",
 "548" => "Median - SB-6-24 - Top",
 "549" => "Median - SB-9-6 - FL",
 "550" => "Median - SB-9-6 - Top",
 "551" => "Median - SB-9-12 - Top",
 "552" => "Median - SB-9-24 - FL",
 "553" => "Median - SB-9-24 - Top",
 "554" => "Median - SM-6-06 - FL",
 "555" => "Median - SM-6-06 - Top",
 "556" => "Median - SM-6-12 - FL",
 "557" => "Median - SM-6-12 - Top",
 "558" => "Median - SM-6-24 - FL",
 "559" => "Median - SM-6-24 - Top",
 "560" => "Median - SM-6-06 - FL",
 "561" => "Median - M-2-06 - FL",
 "562" => "Median - M-2-06 - Top",
 "563" => "Median - M-2-12 - FL",
 "564" => "Median - M-2-12 - Top",
 "565" => "Median - C-4",
 "566" => "Median - FL - SB-6.12",
 "567" => "Non-Standard Median",
 "570" => "Gutter",
 "571" => "Gutter - Back",
 "572" => "Gutter - Depressed",
 "573" => "Gutter - Edge",
 "574" => "Gutter - Flag",
 "575" => "Gutter - Flowline",
 "576" => "Gutter - Outlet",
 "577" => "Island",
 "578" => "Median",
 "579" => "Concrete Barrier",
 "580" => "Standard Outlet",
 "600" => "Building - Commercial",
 "601" => "Building - Public",
 "602" => "Building - Private",
 "605" => "Riprap",
 "606" => "Revetment Mat",
 "607" => "BREAKLINE",
 "608" => "Deck",
 "609" => "Porch",
 "611" => "Bridge Curb",
 "612" => "Bridge Headwall",
 "614" => "Ground @ Abutment",
 "615" => "Abutment - Top",
 "618" => "Bridge Approach Slab",
 "619" => "Bridge Deck",
 "621" => "Deck",
 "624" => "Handrail",
 "625" => "Hub Guard",
 "630" => "Ground @ Pier",
 "632" => "Slope Wall",
 "633" => "Parapet",
 "634" => "Wingwall",
 "635" => "Wingwall - Top",
 "648" => "Gore",
 "649" => "Entrance Edge",
 "651" => "Entrance - Centerline",
 "652" => "Entrance - Commercial",
 "653" => "Entrance - Comm. - Edge",
 "654" => "Entrance - Field",
 "655" => "Entrance - Field - Edge",
 "656" => "Entrance - Private",
 "657" => "Entrance - Priv. - Edge",
 "658" => "Entrance - At Return",
 "659" => "Handicap Ramp",
 "660" => "Alley",
 "661" => "Alley - Centerline",
 "662" => "Alley - Edge of Surf.",
 "663" => "Road",
 "664" => "Road - Centerline",
 "665" => "Road - Edge of Surf.",
 "667" => "CL-PVMT",
 "668" => "EOP",
 "670" => "Street",
 "671" => "Street - Centerline",
 "672" => "Street - Edge",
 "674" => "Shoulder",
 "675" => "Surface - Edge",
 "676" => "Surface - Centerline",
 "677" => "Center of Lanes",
 "678" => "Edge of Lanes",
 "681" => "Parking Lot - Edge",
 "683" => "Canopy",
 "685" => "Pump Island",
 "687" => "PARKING STALL STRIPE",
 "688" => "U.G. Gas Pipe",
 "689" => "U.G. Water Pipe",
 "690" => "U.G. Oil Pipe",
 "692" => "HEADSTONE",
 "693" => "L.P. Gas Tank",
 "694" => "Lane Marking Stripe",
 "695" => "Stop Bar",
 "696" => "Mailbox Turnout",
 "697" => "Ramp",
 "743" => "App. Line of Poss.",
 "751" => "Aerial",
 "765" => "Cable TV",
 "768" => "CL",
 "786" => "Edge of Water",
 "793" => "FL",
 "795" => "Foundation",
 "797" => "Garage",
 "801" => "HSE",
 "848" => "Shed",
 "852" => "Step",
 "858" => "Thalweg",
 "860" => "Toe",
 "861" => "Top",
 "862" => "Top of Bank",
 "864" => "Vegetation Line",
 "867" => "Water",
 "871" => "Pavement Edge, Left",
 "872" => "Pavement Edge, Right",
 "873" => "Shoulder - Left",
 "874" => "Shoulder - Right",
 "875" => "Top - Left",
 "876" => "Top - Right",
 "877" => "Ditch - Left",
 "878" => "Ditch - Right",
 "879" => "Flowline - Left",
 "880" => "Flowline - Right",
 "881" => "Top of Bank - Left",
 "882" => "Top of Bank - Right",
 "883" => "Fence - Left",
 "884" => "Fence - Right",
 "885" => "Cropline - Left",
 "886" => "Cropline - Right",
 "887" => "Toe - Left",
 "888" => "Toe - Right",
 "889" => "Center of Lanes - Left",
 "890" => "Center of Lanes - Right",
 "891" => "Median Edge - Lt.",
 "892" => "Median Edge - Rt.",
 "893" => "Edge of Lanes - Lt.",
 "894" => "Edge of Lanes - Rt.",
 "895" => "Top of Paved Ditch - Lt.",
 "896" => "Top of Paved Ditch - Rt.",
 "897" => "Bot. of Paved Ditch - Lt.",
 "898" => "Bot. of Paved Ditch - Rt.",
 "899" => "Ramp-Lt",
 "900" => "Ramp-Rt",
 "901" => "Timber edge-Lt ",
 "902" => "Timber edge-Rt",
 "903" => "Edge of water-Lt",
 "904" => "Edge of water-Rt",
 "906" => "Catch Basin Peremiter",
 "908" => "Drop Inlet Perimeter",
 "920" => "CATV AG-MAIN",
 "921" => "CATV AG-FEED",
 "922" => "CATV UG-MAIN",
 "923" => "CATV UG-FEED",
 "924" => "CATV AG-FIBER",
 "925" => "CATV UG-FIBER",
 "930" => "ELEC. AG-MAIN",
 "931" => "ELEC. AG-FEED",
 "932" => "ELEC. UG-MAIN",
 "933" => "ELEC. UG-FEED",
 "940" => "GAS AG-MAIN",
 "941" => "GAS AG-FEED",
 "942" => "GAS UG-MAIN",
 "943" => "GAS UG-FEED",
 "950" => "IDOT ELEC. AG",
 "951" => "IDOT ELEC. UG",
 "952" => "IDOT TELECOM AG",
 "953" => "IDOT TELECOM UG",
 "960" => "SAN. SEWER-MAIN",
 "961" => "SAN. SEWER-FEED",
 "962" => "STORM SEWER-MAIN",
 "963" => "STORM SEWER-FEED",
 "970" => "TELEPHONE AG-MAIN",
 "971" => "TELEPHONE AG-FEED",
 "972" => "TELEPHONE UG-MAIN",
 "973" => "TELEPHONE UG-FEED",
 "974" => "TELEPHONE AG-FIBER",
 "975" => "TELEPHONE UG-FIBER",
 "980" => "WATER-MAIN",
 "981" => "WATER-FEED",
# );
#
# %generalCodes = (  # as of version 18 spots are included in the same file as the lines
 "100" => "Backsight Station",
 "101" => "Foresight Station",
 "102" => "Closing Azimuth",
 "104" => "Elevation Control",
 "105" => "Survey Work Point",
 "106" => "Vertical Curve Data",
 "107" => "Horizontal Curve Data",
 "108" => "Vertical Control Station",
 "110" => "Remote Point",
 "111" => "Calculated Point",
 "112" => "GPS Control Point",
 "113" => "Vertical Check",
 "114" => "Set Turning Point",
 "116" => "SHINER",
 "117" => "Bench Tie",
 "118" => "NGS Monument",
 "119" => "District Network Monument",
 "124" => "Read Turning Point",
 "134" => "Check Elevation Control",
 "135" => "Check Horizontal Control",
 "196" => "Photo Control Horiz.",
 "197" => "Photo Control Vert.",
 "198" => "Photo Control H.& V.",
 "199" => "Photo Control Q.P.",
 "202" => "1/16th Corner",
 "203" => "Meander Corner",
 "204" => "Witness Corner",
 "205" => "Reference Corner",
 "206" => "Property Corner",
 "211" => "R.O.W. Corner",
 "212" => "Project Marker",
 "214" => "Drainage Marker",
 "215" => "Chiseled Square",
 "219" => "Barricade",
 "221" => "Traffic Signal Foundation",
 "222" => "Traffic Signal Cantilever",
 "250" => "Pole Foundation",
 "266" => "Vapor Light",
 "270" => "Transmission Tower",
 "290" => "Radius Point",
 "298" => "Telephone Booth",
 "299" => "Physical Ties",
 "312" => "Flap Gate",
 "313" => "Misc. Flowline Elevation",
 "321" => "Curb Cock - Gas",
 "322" => "Curb Cock - Water",
 "325" => "Lift Station",
 "326" => "Lift Sta. Sanitary",
 "327" => "Lift Station Storm",
 "333" => "Pipe",
 "336" => "Sewer",
 "338" => "Sewer - Storm",
 "340" => "Tee",
 "348" => "Line Crossing",
 "355" => "High Water Elevation",
 "356" => "Invert",
 "377" => "Well",
 "378" => "Cistern",
 "401" => "Oil Well",
 "402" => "Oil Storage Tank",
 "415" => "Fence Corner",
 "416" => "Fence End",
 "417" => "Fence Post",
 "418" => "Gate Post",
 "422" => "End Section G.R. ",
 "456" => "R.R. Semaphore",
 "457" => "R.R. Crossbuck",
 "461" => "R.R. Mile Post",
 "462" => "R.R. Point of Switch",
 "463" => "R.R. Point of Frog",
 "464" => "R.R. Derail",
 "603" => "Profile",
 "604" => "GND",
 "610" => "Bridge Section",
 "613" => "Abutment",
 "616" => "Beam Seat",
 "617" => "Bottom of Beam",
 "620" => "Bridge Seat",
 "622" => "Footing",
 "623" => "Expansion Joint",
 "626" => "Low Concrete",
 "627" => "Low Steel",
 "628" => "Low Timber",
 "629" => "Pier",
 "631" => "Pier - Top",
 "639" => "Gasoline Monitoring Well",
 "641" => "Stand Pipe",
 "650" => "Entrance",
 "666" => "PVMT",
 "669" => "Pavement Sta. Number",
 "679" => "Parking Lot",
 "680" => "Parking Lot - Corner",
 "682" => "Parking Meter",
 "684" => "Gas Pump",
 "686" => "U.G. Tank Filler Cap",
 "699" => "Miscellaneous",
 "701" => "Traverse Survey Point",
 "702" => "X-Section Survey Point",
 "703" => "Topo Survey Point",
 "707" => "Cut Square", 
);
%symbolCodes = ( # symbols in IDOTsmd
 "103" => "Traverse Station",
 "109" => "Horizontal Control Station",
 "200" => "Section Corner",
 "201" => "Quarter Corner",
 "207" => "Lot Corner",
 "208" => "Block Corner",
 "209" => "Plat Corner",
 "210" => "Parcel Corner",
 "213" => "R.O.W. Marker",
 "220" => "Traffic Signal",
 "223" => "Traffic Signal Controller",
 "225" => "Combination Mast Arm",
 "227" => "Vehicle Detector",
 "228" => "Flashing Signal",
 "249" => "Pole",
 "251" => "GP",
 "252" => "LP",
 "253" => "PP",
 "254" => "PP W/Light",
 "255" => "PP W/Trans.",
 "256" => "Pole - Sign",
 "257" => "Pole - Telegraph",
 "258" => "Pole - Telephone",
 "259" => "Pole - T.pho.& T.grap",
 "260" => "Pole - Television",
 "261" => "Pole - Meter",
 "262" => "Pole - Street Light",
 "265" => "Guy Wire",
 "267" => "Street Light",
 "268" => "St. Light Cantilever",
 "269" => "St. Light Control Box",
 "272" => "Anchor (Deadman)",
 "274" => "Handhole",
 "275" => "Double Handhole",
 "276" => "Heavy Duty Handhole",
 "278" => "Crosswalk Signal",
 "280" => "Junction Box",
 "281" => "Above Grd Splice Box",
 "282" => "Splice Box - Elect.",
 "283" => "Splice Box - T.Phone",
 "284" => "Splice Box - Cable TV",
 "306" => "Catch Basin",
 "307" => "Catch Basin Grate",
 "308" => "Drop Inlet",
 "309" => "End Section Flared",
 "319" => "Buffalo Box - Gas",
 "320" => "Buffalo Box - Water",
 "323" => "Hydrant",
 "324" => "Hydrant - Water",
 "328" => "Meter",
 "329" => "Meter - Gas",
 "330" => "Meter - Electric",
 "331" => "Meter - Water",
 "332" => "Meter - Petro",
 "334" => "Regulator",
 "335" => "Regulator - Gas",
 "337" => "Sewer - Sanitary",
 "339" => "Standard Inlet",
 "341" => "Valve",
 "342" => "Valve Box",
 "343" => "Valve - Water",
 "344" => "Valve - Gas",
 "345" => "Vault",
 "346" => "Vault - Valve",
 "347" => "Vault - Meter",
 "349" => "Fire Hydrant",
 "350" => "Warning Sign",
 "351" => "Manhole",
 "352" => "Manhole Lid",
 "353" => "Manhole Grate",
 "354" => "Vent Pipe",
 "383" => "Cleanout",
 "400" => "Mailbox",
 "405" => "Tree Deciduous",
 "406" => "Tree Coniferous",
 "407" => "Stump",
 "408" => "Bush",
 "409" => "Shrub",
 "419" => "Guardpost",
 "423" => "Sign",
 "454" => "R.R. Relay Box",
 "455" => "R.R. Switch Control",
 "458" => "R.R. Signal Cabinet",
 "459" => "R.R. Sig. Foundation",
 "465" => "R.R. Flashing Signal",
 "466" => "R.R. Crossing Gate",
 "590" => "RMA1",
 "591" => "RMA2",
 "592" => "RMC1",
 "640" => "Inspection Well",
 "673" => "Street - Sign",
 "682" => "Parking Meter",
 "691" => "Flag Pole",
);
###############################################################################################3                        
%idotcommands = (
  # "(" => "BL*", # Begin Line 20110615   removed process_09.pl
 # "%" => "OC*", # PC or PT 20110615     removed process_09.pl
 # "+" => "CL*", # Close Figure 20110615 removed process_09.pl
 # "." => "L", # Begin Line #H
 "(" => "B", # Begin Line #H  
 "-" => "C", # Begin Curve
 "+" => "E", # Close Figure
 ")" => "E", # End Line #H
 #".." => "X", # End Line #H
 # "@" => "X", # End Line
 # "q" => "X", # End Line
);                        
####################################################################################################
############################################################################################
%typePrefix = (
 # created to make unique numbers for different material types using the same 
 # IDOT code
 "BAR" => "1", #H 274 - Stop BAR
 "CRW" => "2", #H 274 - Crosswalk
 "LNM" => "3", #H 274 - Lane Mark
 "NPS" => "4", #H 274 - No Pass Stripe
 "RWL" => "1", #H 343 - Retaining Wall
 "WAL" => "2", #H 343 - Wall
 "BSW" => "1", # 291 - SIDEWALK BRIDGE
 "SWA" => "2", # 291 - SIDEWALK - AGG
 "SWB" => "3", # 291 - SIDEWALK - BIT/HMA
 "SWC" => "4", # 291 - SIDEWALK - CONC
 "SWR" => "5", # 291 - SIDEWALK - BRICK
 "BAB" => "1", # 615 - BRIDGE ABUTMENT TOP FACE 
 "BPR" => "2", # 615 - BRIDGE PIER TOP FACE 
 "BBA" => "1", # 619 - BRIDGE DECK SPOT AGG
 "BBB" => "5", # 619 - BRIDGE dECK SPOT BIT
 "BBC" => "6", # 619 - BRIDGE DECK SPOT CONC
 "BBR" => "4", # 619 - BRIDGE DECK SPOT BRICK
 "BDB" => "2", # 619 - BRIDGE DECK LINE BIT 
 "BDC" => "3", # 619 - BRIDGE DECK LINE CONC
 "BDT" => "6", # 619 - Bridge Deck Timber
 "BWC" => "7", # 619 - Bridge Deck Sidewalk Conc
 "BPA" => "1", # 624 - BRIDGE PARAPET
 "BHR" => "2", # 624 - BRIDGE HANDRAIL
 "DCA" => "1", # 652 - Driveway/Commercial Aggregate                 
 "DCB" => "2", # 652 - Driveway/Commercial BIT/HMA           
 "DCC" => "3", # 652 - Driveway/Commercial Concrete          
 "DCG" => "4", # 652 - Driveway/Commercial Ground            
 "DCR" => "5", # 652 - Driveway/Commercial Brick             
 "DFA" => "1", # 654 - Driveway/Field Aggregate              
 "DFB" => "2", # 654 - Driveway/Field BIT/HMA                
 "DFC" => "3", # 654 - Driveway/Field Concrete               
 "DFG" => "4", # 654 - Driveway/Field Ground                 
 "DFR" => "5", # 654 - Driveway/Field Brick                  
 "DPA" => "1", # 656 - Driveway/Private-Residential Aggregate
 "DPB" => "2", # 656 - Driveway/Private-Residential BIT/HMA  
 "DPC" => "3", # 656 - Driveway/Private-Residential Concrete 
 "DPG" => "4", # 656 - Driveway/Private-Residential Ground   
 "DPR" => "5", # 656 - Driveway/Private-Residential Brick    
 "DRA" => "1", # 649 - DRIVEWAY AGG 
 "DRB" => "2", # 649 - DRIVEWAY BIT/HMA
 "DRC" => "3", # 649 - DRIVEWAY CONC
 "DRG" => "4", # 649 - FIELD ENTRANCE 
 "DRR" => "5", # 649 - DRIVEWAY BRICK
 "EOA" => "1", # 668 - EDGE OF PAVMENT AGG
 "EOB" => "2", # 668 - EDGE OF PAVMENT BIT/HMA
 "EOC" => "3", # 668 - EDGE OF PAVMENT CONC
 "EOR" => "4", # 668 - EDGE OF PAVMENT BRICK
 "JUR" => "1", # 224 - TRAFFIC PAINT MARK QL-B
 "JUS" => "2", # 224 - TRAFFIC PAINT MARK FIBER OPTIC QL-B
 "LNB" => "2", # 678 - LANE LINES BIT/HMA
 "LNC" => "3", # 678 - LANE LINES CONC
 "SHA" => "1", # 674 - SHOULDER AGG
 "SHB" => "2", # 674 - SHOULDER BIT/HMA
 "SHC" => "3", # 674 - SHOULDER CONC
 "TRL" => "3", # 224 - LOOP DETECTOR
 "TIL" => "1", # 304 - TILE
 "DSP" => "2", # 304 - DOWNSPOUT
);
########################################################################################################
#########################################################################################################
#####################
# Some Global Vars
$figname="";
$curPtNum="";
$lastPtNum="";
$lastFigname="";
%activeStrings=();
$curIsString=0;
$lastWasString=0;
$comment=""; #lv added
$Icode=""; #lv added (Process01)
$hold = "";
$noLineCounter=1;


# ====================================================================================================
#                                             Start of Main Program
# ====================================================================================================
#                                             Syntax - process ARG1
if ($#ARGV<0)
  {
    print q{
===================================================================================
|                                                                                 |
|                         Process script requires file name                       |
|                                                                                 |
|                            Syntax:  process filename                            |
|                                                                                 |
===================================================================================
  };
    exit;
  }
$filename=$ARGV[0];
$filename =~ s/\.[^.]*$//;
open(IN,$ARGV[0]);
# open(OUT1,">${filename}_dtm.cor");
# open(OUT2,">${filename}_bridge.cor"); #H
# open(OUT3,">${filename}_ptln.cor"); #H
# open(OUT4,">${filename}_cell.cor"); #H
# open(OUT5,">${filename}_qc_spots.cor");
open(OUT6,">${filename}_topo.cor");
# if ($#ARGV>0) {
#  $_nextAutogenPtNum=$ARGV[1];
# }
# else {
#  $_nextAutogenPtNum=100000;
# }
while (<IN>) {
 $curIsString=0;
 @in = split(/,/, substr(uc, 0, -1), 5); #note: the substr forces text to be uppercase; the split creates:
   #$in[0] = point number
   #$in[1] = northing
   #$in[2] = easting
   #$in[3] = elevation
   #$in[4] = full description (3 Letter Code-Line Number-Line Code-Comment)
 my @fsplit = split(/\s+/,$in[4],2); #added lv - this separates the Codes from the Comments
   #using the first whitespace as the separator so:
   #$fsplit[0] = 3 Letter Code-Line Number-Line Code
   #$fsplit[1] = the Comment
 my @ssplit = ($fsplit[0] =~ /(\w+)*(\W*)/); #added lv - this separates the 3 Letter Code and 
   # line number from the line coding symbol
   # \w is alpha or numeric - \W is non alpha or numeric:
   # $ssplit[0] = the 3 Letter Code and Line Number
   # $ssplit[1] = the Line Code 
 $tok[0] = $ssplit[1]; #added lv:
   # $tok[0} = the Line Code
 $tok[1] = "$ssplit[0] $fsplit[1]"; #added lv:
   # $tok[1] = the code and the comment, no line code
 my @csplit = ($ssplit[0] =~ /(\w\w\w)(\d*)/); # this is for QAQC
   # $csplit[0] = 3 letter code
   # $csplit[1] = line number 
 if (length($fsplit[1])>0) {##############lv
  $fsplit[1]="\;$fsplit[1]"; ########lv - adds the semi-colon before the Comment
 }
 $Icode=$pointCodes{$csplit[0]}; ## if the three letter code matches any of the codes 

##############Test Section 
#print OUT1 "alksdf;alkdj   $pointCodes{$csplit[0]}\n";
#print OUT5 "\n\n\n\in[0] point number      = $in[0]\n";                            
#print OUT5 "in[4] full code & comment      = $in[4]\n";                            
#print OUT5 "fsplit[0] full code no comment = $fsplit[0]\n";                        
#print OUT5 "fsplit[1] comment              = $fsplit[1]\n";                        
#print OUT5 "ssplit[0] code and line no.    = $ssplit[0]\n";                        
#print OUT5 "ssplit[1] line code            = $ssplit[1]\n";                        
#print OUT5 "tok[0] line code               = $tok[0]\n";                           
#print OUT5 "tok[1] code, line no., comment = $tok[1]\n";                           
#print OUT5 "csplit[0] alpha code           = $csplit[0]\n";                        
#print OUT5 "csplit[1] line number          = $csplit[1]\n";                        
#print OUT5 "hold                           = $hold\n";                             
#print OUT5 "c linecode                     = $c\n"; 
#print OUT5 "Icode idot code, line no.      = $Icode\n\n";                     
#####################
#Material type prefix
  if  (exists ($typePrefix{$csplit[0]})) {
    $prefix = $typePrefix{$csplit[0]};
    $csplit[1] = "$prefix$csplit[1]";
  }
#############################
			 # Testing Section
       # print OUT6 "the bridgeCode is            $bridgeCodes{$csplit[0]}\n";
       # print OUT6 "the line code is           $idotcommands{$tok[0]}\n";
###############################
  if ($c = $idotcommands{$tok[0]}) {
     print OUT6 "$in[0],$in[1],$in[2],$in[3],$c $Icode$csplit[1]$fsplit[1],\n"; 
  }
  else  {
     print OUT6 "$in[0],$in[1],$in[2],$in[3],$Icode$csplit[1]$fsplit[1],\n";
  }
 }

####################### TEST SECTION                               
#print OUT5 "in[0] point number             = $in[0]\n";            
#print OUT5 "in[1] northing                 = $in[1]\n";            
#print OUT5 "in[2] easting                  = $in[2]\n";            
#print OUT5 "in[3] elevation                = $in[3]\n";            
#print OUT5 "in[4] full code & comment      = $in[4]\n";            
#print OUT5 "fsplit[0] full code no comment = $fsplit[0]\n";        
#print OUT5 "fsplit[1] comment              = $fsplit[1]\n";        
#print OUT5 "ssplit[0] code and line no.    = $ssplit[0]\n";        
#print OUT5 "ssplit[1] line code            = $ssplit[1]\n";        
#print OUT5 "tok[0] line code               = $tok[0]\n";           
#print OUT5 "tok[1] code, line no., comment = $tok[1]\n";
#print OUT5 "csplit[0] alpha code           = $csplit[0]\n";
#print OUT5 "csplit[1] line number          = $csplit[1]\n";  
#print OUT1 "hold                           = $hold\n";            
#print OUT5 "c linecode                     = $c\n";                
#print OUT5 "Icode idot code, line no.      = $Icode\n\n\n\n\n";           

 
 #prepare for next loop
 if ($curIsString) {
  $activeStrings{$figname}=1; #make sure the list contains an entry for this string
 }
 $lastWasString=$curIsString;
 $lastFigname=$figname;
 $lastPtNum=$in[0];
 $figname="";
 $comment="";  #### added lv 
 $Icode="";
 $prefix="";  
   
   
 $fsplit[0]="";       
 $fsplit[1]="";       
 $ssplit[0]="";       
 $ssplit[1]="";       
 $tok[0]="";          
 $tok[1]="";          
 $csplit[0]="";        
 $csplit[1]="";        
        


close(IN);
#close(OUT1);
#close(OUT2);
#close(OUT3);
#close(OUT4);
#close(OUT5);
close(OUT6);