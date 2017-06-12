#---------------------------------------
#
# chkMtoH_21.pl
# Fork of checkin_21process.pl - convert MPS codes to Hoelscher codes
#
#
#----------------------------------------
# checkin_21.pl
# 20131107
# added (modified):
#      MHM Storm Manhole 351
#      MHN Sanitary Manhole 337
#      VLB Valve Box 342
#      VLW Water Valve 343
#      VLG Gas Valve 344
#      BBG Gas Buffalo Box 319
#      BBW Water Buffalo Box 320
#####################################
####################################
# checkin_20.pl
# 20130322
# added:
#     VNG Gas Vent
#     PDF Pedestal Fiber Optic
#     HHF Handhole Fiber Optic
#     HHV Handhole TV
#     HHR Handhole Traffic
#     HHE Handhole Electric
#     MHS Manhole Traffic Fiber Optic
#     RPF Point of Frog
#     RPS Point of Switch
#     RSW Switch Box
############################################
##################################
# checkin_19.pl 20130116
# added BWC - Bridge Walk Concrete - BSW is depreciated
# added BSS - Bridge Structural Steel 610
# added BSC - Bridge Scupper
# added BDP - Bridge Deck Plate
# changed BPA from 624 to 633 and eliminated 'Required Comment' "PARAPET"
# depreciated edge of pavement/edge of shoulder combinations used on IL-83 (fail). ERB-EWC.
# depreciated RNW Runway
# depreciated 667 as IDOT code for crown (CRB/CRC) using breakline 607 with material comments for 
#    pavement areas with no stripeing - use stripeing as breakline where possible
# Crown now has material types: CNB = HMA, CNC = CONC, etc. - see 667 above
# I'm going to stop using the B6B codes and start using CRB on all curbs unless they are 
#    odd (not B6.12 or B6.24).  Use the IDOT codes of odd curbs. - LV - The B6B and B62 will still
#    work.
# added BUC - Building Commercial - BLD is being depreciated
# added BUP - Building Public - BLD is being depreciated
# added BUR - Building Residential - BLD is being depreciated
# Changed BBA/BBB/BBC/BBR from 619 to 621 so that spots land on the Topo_BridgeStructures level
# changed RR centerline from CLR to RCL
# added BRR Barrier Wall - base
# added SBW for weird sprinkler system splice box on US14 
####################################
##################################
# checkin_18.pl
# added B6F back in
##################################
#------------------------
# ver checkin_15.pl
#
# added SWA,B,C,R
# added WEL well
# added BBA,BBB,BBC.BBR - Bridge Deck with AGG,BIT.Conc,Bridk
# added BSW - Bridge Sidewalk
# added RCK - Rock/boulder
#                 
%legalCodes = (
 "AEM" => "legal", # Electric Above Ground Main - Center of Tower 
 #"AGE" => "legal",
 "B62" => "legal", # B6-24 Curb - added v6 - depreciated
 "B6B" => "legal", # B6-12 Top Back Curb - depreciated
 "B6F" => "legal", # added back v18 - depreciated
 #"B6T" => "legal", # deleted v6
 "BAB" => "legal", # The outline of the face,sides, and top of the abutment.  A 3d line.
 "BAL" => "legal", # The outline of the face of the abutment and the face of the
                   # Wingwalls.  A 2d line, usually collected prismless.
 "BAR" => "legal", # Stop Bar - Painted
 "BAS" => "legal", # Bridge Approach Slab
 #"BAT" => "legal",
 "BBA" => "legal", # Bridge Deck - AGG
 "BBB" => "legal", # Bridge Deck - BIT/HMA
 "BBC" => "legal", # Bridge Deck - Concrete
 "BBG" => "legal", # Buffalo Box - Gas
 "BBR" => "legal", # Bridge Deck - Bridk
 "BBS" => "legal", # The bridge seat elevation.  For elevation only.  Usually collected
                   # with the "hook".
 "BBW" => "legal", # Buffalo Box - Water
 "BBU" => "legal", # Buffalo Box - Gas
 #"BBX" => "legal", # Buffalo Box - Water
 "BCB" => "legal", # The top front of any curb or median on a bridge.
 "BDB" => "legal", # The line of the bit bridge deck.  A 3d line.
 "BDC" => "legal", # The line of the conc bridge deck.  A 3d line.
 "BDP" => "legal", # Bridge Deck Plate
 "BDT" => "legal", # Bridge Deck Timber
 #"BDK" => "legal",
 "BEX" => "legal", # The bridge expansion joint.  A 3d line.
 "BHR" => "legal", # Building# Bridge Handrail.  A 3D line.
 "BLD" => "legal", # Building
 "BLC" => "legal", # The bottom of the concrete bridge beams.  Usually taken at
                   # the beginning middle and end oof each span of the bridge beams.
                   # Usually only required on the outside (upstream and downstream) beams.
 "BLS" => "legal", # The bottom of the steel bridge beams.  Usually taken at
                   # the beginning middle and end oof each span of the bridge beams.
                   # Usually only required on the outside (upstream and downstream) beams.
 "BLT" => "legal", # The bottom of the timber bridge beams.  Usually taken at
                   # the beginning middle and end oof each span of the bridge beams.
                   # Usually only required on the outside (upstream and downstream) beams.
 "BMK" => "legal", #H Benchmark
 "BOL" => "legal", # Bollard
 "BOR" => "legal", # Boring/Coring
 "BPA" => "legal", # The bridge parapet. A 3d line.
 "BPC" => "legal", # The outline of the face of the pier cap. A 2d line usually
                   # collected "prismless".
 "BPR" => "legal", # The outline of the face, sides and top of the pier cap.  A 3d line.
 "BPT" => "legal", # The pier cap elevation,  For elevation only.  Usually collected
                   # with the "hook".
 #"BRC" => "legal",
 "BRK" => "legal", # Break Line
 "BRR" => "legal", # Barrier Wall - base
 "BSC" => "legal", # Bridge Scupper
 "BSH" => "legal", # Bush / Shrub
 "BSL" => "legal", # Bush line / Hedgerow
 "BSS" => "legal", # Bridge Structural Steel
 #"BSW" => "legal", # Bridge - Sidewalk - depreciated v19
 "BUC" => "legal", # Building - Commercial
 "BUP" => "legal", # Building - Public
 "BUR" => "legal", # Building - Residential
 "BWC" => "legal", # Bridge Deck Sidewalk Conc
 "BWL" => "legal", # The outline of the face and sides of the bridge back wall.  A 3d line.
  #"BWT" => "legal",
 "BWW" => "legal", # The outline of the face and sides of the wingwall.  A 3d line with
                   # points at each elevation change.
 "CBM" => "legal", # Catch Basin - Round Open
 "CDE" => "legal", #H Conduit - Electrical
 "CKH" => "legal", # Control Point Check - Horizontal
 "CKV" => "legal", # Control Point Check - Vertical
 "CLR" => "legal", # Centerline Railroad Track - depreciated
 #"CMA" => "legal",
 "CNP" => "legal", # Canopy
 "CNT" => "legal", # Traffic Signal Cantelever/Mast Arm
 "CPH" => "legal", # Control Point Horizontal
 "CRB" => "legal", # Curb - Top Back
 "CNA" => "legal", # Crown of roadway - Agg - use where there is no stripeing
 "CNB" => "legal", # Crown of roadway - HMA - use where there is no stripeing
 "CNC" => "legal", # Crown of roadway - CONC - use where there is no stripeing
 "CNR" => "legal", # Crown of roadway - BRICK - use where there is no stripeing
 #"CRN" => "legal", # Crown Line
 "CRP" => "legal", # Crop Line
 "CRW" => "legal", # Crosswalk
 "CUB" => "legal", # Culvert - Box
 "CUE" => "legal", # Culvert - Elliptical
 "CUP" => "legal", # Culvert - Pipe
 "DAM" => "legal", # Levee/Dam Top
 "DCA" => "legal", # Driveway/Commercial Aggregate
 "DCB" => "legal", # Driveway/Commercial BIT/HMA
 "DCC" => "legal", # Driveway/Commercial Concrete
 "DCG" => "legal", # Driveway/Commercial Ground
 "DCR" => "legal", # Driveway/Commercial Brick
 "DFA" => "legal", # Driveway/Field Aggregate
 "DFB" => "legal", # Driveway/Field BIT/HMA
 "DFC" => "legal", # Driveway/Field Concrete
 "DFG" => "legal", # Driveway/Field Ground
 "DFR" => "legal", # Driveway/Field Brick
 "DPA" => "legal", # Driveway/Private-Residential Aggregate
 "DPB" => "legal", # Driveway/Private-Residential BIT/HMA
 "DPC" => "legal", # Driveway/Private-Residential Concrete
 "DPG" => "legal", # Driveway/Private-Residential Ground
 "DPR" => "legal", # Driveway/Private-Residential Brick
 "DRB" => "legal", # Driveway/Entrance HMA
 "DRV" => "legal", # Driveway/Entrance
 "DRA" => "legal", # Driveway/Entrance Aggregate
 "DRB" => "legal", # Driveway/Entrance HMA
 "DRC" => "legal", # Driveway/Entrance Concrete
 "DRG" => "legal", # Field Entrance
 "DRR" => "legal", # Driveway/Entrance Brick
 "DSP" => "legal", # Downspout
 "DTH" => "legal", # Ditch Flowline 
 "DTP" => "legal", # Paved Ditch Centerline
 "EOA" => "legal", # Edge of Pavement - Aggregate
 "EOB" => "legal", # Edge of Pavement - BIT/HMA
 "EOC" => "legal", # Edge of Pavement - Concrete
 "EOL" => "legal", # Edge of Lanes - added v6
 #"EOP" => "legal", # Edge of Pavement
 "EOR" => "legal", # Edge of Pavement - Brick 
 #"ERB" => "legal", # Edge of Bit Pavement - Bit Shoulder - no curb
 #"ERC" => "legal", # Edge of Conc Pavement - Bit Shoulder - no curb
 #"ESC" => "legal", # Edge of Conc Pavement - Concrete Shoulder - no curb
 #"ETB" => "legal", # Edge of Bit Pavement - Bit Shoulder with curb
 #"ETC" => "legal", # Edge of Conc Pavement - Bit Shoulder with curb
 #"EUB" => "legal", # Edge of Bit Pavement - curb - no shoulder
 #"EUC" => "legal", # Edge of Conc Pavement - curb - no shoulder
 #"EWC" => "legal", # Edge of Conc Pavement - Concrete SDhoulder with curb
 "FES" => "legal", # Flared End Section
 "FFL" => "legal", # Finish Floor Elevation
 #"FLW" => "legal",
 #"FLO" => "legal", # Flow Line / Ditch
 "FNC" => "legal", # Fence Line
 "FND" => "legal", # Found Survey Evidence
 "FNG" => "legal", # Fence Gate Post
 "FOU" => "legal", # Foundation
 "GND" => "legal", # Ground Shot
 "GRL" => "legal", # Guard Rail
 "GUT" => "legal", # Gutter/Flowline
 "GUY" => "legal", # Guy Wire
 "H2O" => "legal", # Edge of Water
 "HHD" => "legal", # Handhole - Traffic Signal - Double
 "HHE" => "legal", # Handhole - Electric
 "HHF" => "legal", # Handhole - Fiber Optic
 "HHR" => "legal", # Handhole - Traffic
 "HHT" => "legal", # Handhole - Telephone
 "HHV" => "legal", # Handhole - TV 
 "HWL" => "legal", # Headwall
 "HYD" => "legal", # Hydrant
 "INL" => "legal", # Inlet - Rectangular
 "JUE" => "legal", # QL-B Paint Mark Line - Electric
 "JUF" => "legal", # QL-B Paint Mark Line - Fiber Optic
 "JUG" => "legal", # QL-B Paint Mark Line - Gas
 "JUM" => "legal", # QL-B Paint Mark Line - Storm    
 "JUN" => "legal", # QL-B Paint Mark Line - Sanitary
 #"JUO" => "legal",
 "JUR" => "legal", # QL-B Paint Mark Line - Traffic Signal
 "JUS" => "legal", # QL-B Paint Mark Line - Traffic Signal Fiber Optic
 "JUT" => "legal", # QL-B Paint Mark Line - Telephone
 "JUV" => "legal", # QL-B Paint Mark Line - Television
 "JUW" => "legal", # QL-B Paint Mark Line - Water
 "LNB" => "legal", # Lane Line - BIT/HMA
 "LNC" => "legal", # Lane Line - Concrete 
 "LND" => "legal", # Landscape Edge
 "LNM" => "legal", # Lane Paint Mark
 "MBX" => "legal", # Mailbox
 "MCS" => "legal", # Misc Concrete Slab
 "MED" => "legal", # Top Front of Median
 #"MGR" => "legal",
 "MHE" => "legal", # Manhole Electrical
 "MHF" => "legal", # Manhole Fiber Optic
 "MHG" => "legal", # Manhole Gas
 "MHM" => "legal", # Mahhole Storm
 "MHN" => "legal", # Manhole Sanitary
 "MHT" => "legal", # Manhole Telephone/Communications
 "MHV" => "legal", # Manhole Cable TV
 "MHW" => "legal", # Manhole Water
 "MHS" => "legal", # Manhole Traffic Fiber Optic
 "MSC" => "legal", # Misc - added v6
 "MTE" => "legal", # Meter Electrical
 "MTG" => "legal", # Meter Gas
 "MTW" => "legal", # Meter Water
 "NPS" => "legal", # No Pass Stripe
 "PBB" => "legal", # A spot elevation on a bit bridge deck
 "PBC" => "legal", # A spot elevation on a conc bridge deck
 "PDE" => "legal", # Pedestal Electric
 "PDF" => "legal", # Pedestal Fiber Optic
 "PDT" => "legal", # Pedestal Telephone/Communications
 "PDV" => "legal", # Pedestal Cable TV
 "PLF" => "legal", # Flag Pole
 "PLT" => "legal", # Pole Light Only
 "PMA" => "legal", # Spot - Aggregate
 "PMB" => "legal", # Spot - HMA/BIT
 "PMC" => "legal", # Spot - Concrete
 "PMR" => "legal", # Spot - Brick
 "PMT" => "legal",
 "PPL" => "legal", # Pole Utility with Light
 "PPT" => "legal", # Pole Utility with Transformer
 "PPU" => "legal", # Pole Utility
 "RCK" => "legal", # Rock or Boulder
 "PRK" => "legal", # Parking Meter
 "RCL" => "legal", # Railroad Centerline
 "RGG" => "legal", # Regulator Gas
 "RIP" => "legal", # Rip Rap
 #"RNW" => "legal",
 "ROW" => "legal", # ROW Monument
 "RPF" => "legal", # RR Point of Frog - 1" point
 "RPS" => "legal", # RR Point of Switch take shot on side of switch box
 "RRC" => "legal", # RR Signal Cabinet
 "RRG" => "legal", # RR Crossing Gate
 "RRR" => "legal", # RR Rail - Top
 "RRS" => "legal", # RR Semaphore
 "RSW" => "legal", # RR Switch Box 
 "RVT" => "legal", # Revetment Mat
 "RWL" => "legal", # Retaining Wall
 "SBE" => "legal", # Splice Box - Electrical
 "SBR" => "legal", # Splice Box - Traffic Signals
 "SBT" => "legal", # Splice Box - Telephone
 "SBV" => "legal", # Splice Box - Television
 "SBW" => "legal", # Splice Box - Water Sprinkler
 "SHA" => "legal", # Shoulder - Aggregate 
 "SHB" => "legal", # Shoulder - HMA/BIT
 "SHC" => "legal", # Shoulder - Concrete
 "SNC" => "legal", # Sign - Commercial
 "SNE" => "legal", # Sign - Warning - UG Electric
 "SNF" => "legal", # Sign - Warning - Fiber Optic
 "SNG" => "legal", # Sign - Warning - Gas
 "SNL" => "legal", # Sign - For Line Coding
 "SNN" => "legal", # Sign - Warning - Sanitary Line
# "SNO" => "legal", # Sign - Warning - Fiber Optic
 "SNP" => "legal", # Sign - Warning - Petroleum
 "SNR" => "legal", # Sign - Traffic
 "SNT" => "legal", # Sign - Warning - Telephone/Communications
 "SNV" => "legal", # Sign - Warning - Cable TV
 "SNW" => "legal", # Sign - Warning - Water line
 "SPC" => "legal", # Special - Misc
 "STR" => "legal", # Stairs/Porch
 "SWK" => "legal", # Sidewalk
 "SWA" => "legal", # Sidewalk - Agg
 "SWB" => "legal", # Sidewalk - HMA/BIT
 "SWC" => "legal", # Sidewalk - Conc
 "SWR" => "legal", # Sidewalk - Brick
 "TIL" => "legal", # Tile
 #"TOB" => "legal",
 "TOE" => "legal", # Toe of Slope
 "TOP" => "legal", # Top of Slope
 "TRC" => "legal", # Tree - Coniferous
 "TRD" => "legal", # Tree - Deciduous
 "TRF" => "legal", # Traffic Signal
 "TRL" => "legal", # Traffic Loop Detector
 "THW" => "legal", # Thalweg - Lowest Point
 "UND" => "legal", # Underdrain
 "VLB" => "legal", # Valve - Box
 "VLG" => "legal", # Valve - Gas
 "VLN" => "legal", # Valve - Sanitary
 "VLW" => "legal", # Valve - Water (By Hydrant)
 "VLE" => "legal", # Valve - Electric
 "VNG" => "legal", # Vent - Gas
 "VNT" => "legal", # Vent - Gas
 "VNN" => "legal", # Vent - Sanitary
 "WAL" => "legal", # Wall - Not Retaining
 "WDE" => "legal", # Wooded Edge
 "WEL" => "legal", # Well
 "WET" => "legal", # Wetland
 "WTR" => "legal", # Water - Top Elevation
###
 "103" => "legal",
 "111" => "legal",
 "112" => "legal",
 "118" => "legal",
 "119" => "legal",
 "134" => "legal",
 "135" => "legal",
 "200" => "legal",
 "207" => "legal",
 "210" => "legal", # parcel corner ILI
 "213" => "legal",
 "220" => "legal",
 "222" => "legal",
 "223" => "legal",
 "224" => "legal",
 "225" => "legal",
 "226" => "legal",
 "252" => "legal",
 "253" => "legal",
 "254" => "legal",
 "255" => "legal",
 "265" => "legal",
 "274" => "legal",
 "275" => "legal",
 "279" => "legal", # crosswalk
 "280" => "legal",
 "282" => "legal",
 "283" => "legal",
 "284" => "legal",
 "285" => "legal",
 "286" => "legal",
 "288" => "legal",
 "289" => "legal",
 "291" => "legal",
 "294" => "legal",
 "296" => "legal",
 "297" => "legal",
 "300" => "legal",
 "302" => "legal",
 "303" => "legal",
 "304" => "legal",
 "307" => "legal",
 "309" => "legal",
 "311" => "legal",
 "318" => "legal",
 "319" => "legal",
 "320" => "legal",
 "323" => "legal",
 "329" => "legal",
 "330" => "legal",
 "331" => "legal",
 "335" => "legal",
 "337" => "legal",
 "339" => "legal",
 "342" => "legal",
 "343" => "legal",
 "344" => "legal",
 "346" => "legal",
 "350" => "legal",
 "351" => "legal",
 "354" => "legal",
 "359" => "legal",
 "361" => "legal",
 "363" => "legal",
 "369" => "legal",
 #"376" => "legal",
 "377" => "legal",
 "379" => "legal",
 "381" => "legal",
 "400" => "legal",
 "405" => "legal",
 "406" => "legal",
 "408" => "legal",
 "410" => "legal",
 "411" => "legal",
 "412" => "legal",
 "414" => "legal",
 "415" => "legal",
 "417" => "legal",
 "418" => "legal",
 "419" => "legal",
 "420" => "legal",
 "423" => "legal",
 "424" => "legal",
 "450" => "legal",
 "451" => "legal",
 "455" => "legal",
 "456" => "legal",
 "458" => "legal",
 "461" => "legal", # RR Mile Post
 "462" => "legal",
 "463" => "legal",
 "466" => "legal",
 "501" => "legal",
 #"508" => "legal", # deleted v6
 "509" => "legal",
 #"510" => "legal", # deleted v6
 "516" => "legal", # B6-24 added v6
 "575" => "legal",
 "578" => "legal",
 "579" => "legal", # Barrier Wall
 "600" => "legal",
 "601" => "legal",
 "602" => "legal",
 "604" => "legal",
 "605" => "legal",
 "606" => "legal",
 "607" => "legal",
 "609" => "legal",
 "611" => "legal",
 "612" => "legal",
 "613" => "legal",
 "615" => "legal",
 "616" => "legal",
 "618" => "legal",
 "619" => "legal",
 "620" => "legal",
 "621" => "legal",
 "623" => "legal",
 "624" => "legal",
 "626" => "legal",
 "627" => "legal",
 "628" => "legal",
 "629" => "legal",
 "631" => "legal",
 "633" => "legla",
 "634" => "legal",
 "635" => "legal",
 "640" => "legal",
 "641" => "legal",
 "649" => "legal",
 "650" => "legal",
 "652" => "legal",
 "654" => "legal",
 "656" => "legal",
 "664" => "legal",
 "666" => "legal",
 #"667" => "legal",
 "668" => "legal",
 "669" => "legal",
 "673" => "legal",
 "674" => "legal",
 "678" => "legal", # Edge of Lanes - added v6
 "682" => "legal",
 "683" => "legal",
 "689" => "legal",
 "691" => "legal",
 "694" => "legal",
 "695" => "legal",
 "699" => "legal", # Misc - added v6
 "760" => "legal", # V14 
 "776" => "legal", # 
 "795" => "legal",
 "858" => "legal",
 "860" => "legal",
 "861" => "legal",
 "867" => "legal",
 "881" => "legal",
 "930" => "legal",
 "942" => "legal",
 "960" => "legal",
 "962" => "legal",
);
%requiredComments = (
 "AEM" => "MAIN",
 "BAB" => "ABUTMENT CAP",
 "BAL" => "LOCATION ONLY",
 "BAR" => "White", #H
 "BBA" => "AGG",
 "BBB" => "HMA",
 "BBC" => "CONC",
 "BBG" => "GAS BUFFALO BOX",
 "BBW" => "WATER BUFFALO BOX",
 "BBR" => "BRICK",
 "BBS" => "ELEV ONLY",
 "BDB" => "HMA",
 "BDC" => "CONC",
 "BDP" => "BRIDGE DECK PLATE",
 "BDT" => "TIMBER",
 "BHR" => "HANDRAIL",
 #"BPA" => "PARAPET",
 "BPC" => "LOCATION ONLY",
 "BPR" => "PIER CAP",
 "BPT" => "ELEV ONLY",
 "BSC" => "SCUPPER",
 "BSS" => "STRUCTURAL STEEL",
 "BUC" => "Commercial", #H
 "BWC" => "SIDEWALK CONC",
 "BWL" => "BACKWALL",
 "CDE" => "Conduit" #H
 "CNA" => "AGG",
 "CNB" => "HMA",
 "CNC" => "CONC",
 "CNR" => "BRICK",
 "CRW" => "White", #H
 "CUP" => "Culvert", #H
 "DRA" => "AGG",
 "DRB" => "HMA",
 "DRC" => "CONC",
 "DRG" => "FIELD ENTRANCE",
 "DRR" => "BRICK",
 "DCA" => "AGG",           
 "DCB" => "HMA",           
 "DCC" => "CONC",          
 "DCG" => "FIELD ENTRANCE",
 "DCR" => "BRICK",         
 "DFA" => "AGG",           
 "DFB" => "HMA",           
 "DFC" => "CONC",          
 "DFG" => "FIELD ENTRANCE",
 "DFR" => "BRICK",         
 "DPA" => "AGG",           
 "DPB" => "HMA",           
 "DPC" => "CONC",          
 "DPG" => "FIELD ENTRANCE",
 "DPR" => "BRICK",         
 "DSP" => "DOWNSPOUT",
 "EOA" => "AGG",
 "EOB" => "HMA",
 "EOC" => "CONC",
 "EOR" => "BRICK",
 "ERB" => "BIT W/ BIT SHLD",
 "ERC" => "CONC W/ BIT SHLD",
 "ESC" => "CONC W/ CONC SHLD",
 "ETB" => "BIT W/ BIT SHLD & CURB",
 "ETC" => "CONC W/ BIT SHLD & CURB",
 "EUB" => "BIT W/ CURB",
 "EUC" => "CONC W/ CURB",
 "EWC" => "CONC W/ CONC SHLD & CURB",
 "FFL" => "FINISH FLOOR",
 "HHE" => "ELECTRIC",
 "HHF" => "FIBER OPTIC",
 "HHR" => "TRAFFIC SIGNAL",
 "HHT" => "TELEPHONE",
 "HHV" => "CABLE TV",
 "JUF" => "Fiber", #H
 "JUN" => "SANITARY QL-B",
 "JUT" => "COMM QL-B",
 "JUS" => "FIBER OPTIC QL-B",
 "JUV" => "TV QL-B", 
 "JUW" => "WATER QL-B",
 "LNB" => "HMA",
 "LNC" => "CONC",
 "LNM" => "White", #H
 "MHM" => "STORM",
 "MHT" => "COMM",
 "MHE" => "ELEC",
 "MHF" => "FIBER",
 "MHG" => "GAS",
 "MHN" => "SANITARY",
 "MHV" => "CABLE TV",
 "MHS" => "TRAFFIC FIBER OPTIC",
 "MHW" => "H2O",
 "MTE" => "ELEC",
 "MTW" => "H2O",
 "NPS" => "Yellow", #H
 "PBB" => "HMA",
 "PBC" => "CONC",
 "PDE" => "ELEC",
 "PDF" => "FIBER OPTIC",
 "PMA" => "AGG",
 "PMB" => "HMA",
 "PMC" => "CONC",
 "PMR" => "BRICK",
 "RCK" => "BOULDER",
 "RWL" => "Retaining Wall", #H
 "SBT" => "TELEPHONE",
 "SBW" => "SPRINKLER SYSTEM",
 "SHA" => "AGG",
 "SHB" => "HMA",
 "SHC" => "CONC",
 "SNE" => "ELEC",
 "SNF" => "FIBER",
 "SNG" => "GAS",
 "SNN" => "SANITARY",
 "SNP" => "PETRL", 
 "SNT" => "COMM",
 "SNV" => "TV",
 "SNW" => "WATER",
 "SWA" => "AGG",
 "SWB" => "HMA",
 "SWC" => "CONC",
 "SWR" => "BRICK",
 "TIL" => "TILE",
 "VLB" => "VALVE BOX",
 "VLN" => "VALVE SANITARY",
 "VNG" => "GAS VALVE",
 "VLW" => "WATER VALVE",
 "WTR" => "TOP ELEV", 
);
@flagCodes = (
 "RANDOM",
 "CKH",
 "CKV",
 "TMP",
);
%IDOTmiscCodes = ( 
 "701" => "Traverse Survey Point", 
 "702" => "X-Section Survey Point",
 "703" => "Topo Survey Point", 
 "707" => "Cut Square", 
 "711" => "Close Figure",
 "741" => "Broken",
 "742" => "Tubeco", 
 "743" => "App. Line of Poss.",
 "744" => "Possible", 
 "745" => "On-Skew",
 "746" => "Bent", 
 "748" => "Aboveground", 
 "749" => "Underground",
 "750" => "Abandoned", 
 "751" => "Aerial",
 "752" => "AGG", 
 "753" => "Aluminum",
 "754" => "Axle", 
 "755" => "Back",
 "756" => "Barb", 
 "757" => "BL",
 "758" => "Beginning", 
 "759" => "BIT",
 "760" => "Bolt", 
 "761" => "Bottom",
 "762" => "BRK", 
 "763" => "Buried",
 "764" => "Cable", 
 "765" => "Cable TV",
 "766" => "Cast Iron", 
 "767" => "Center",
 "768" => "CL", 
 "769" => "Chain Link",
 "770" => "Chiseled X", 
 "771" => "Clay",
 "772" => "CMP", 
 "773" => "CMPA",
 "774" => "CONC", 
 "775" => "Concrete Block",
 "776" => "Corner", 
 "777" => "Cross Cut",
 "778" => "Crushed Stone", 
 "779" => "CS",
 "780" => "Dirt", 
 "781" => "Disk",
 "782" => "Door Sill", 
 "783" => "Drill Hole",
 "784" => "Duct. Iron Pipe", 
 "785" => "Edge",
 "786" => "Edge of Water", 
 "787" => "Electrical",
 "788" => "End", 
 "789" => "Face",
 "790" => "Field", 
 "791" => "Flag",
 "792" => "Floor", 
 "793" => "FL",
 "794" => "Found", 
 "795" => "Foundation",
 "796" => "Front", 
 "797" => "Garage",
 "798" => "Gas", 
 "799" => "Gasoline",
 "800" => "Gravel", 
 "801" => "HSE",
 "802" => "Inside", 
 "803" => "Intersection",
 "804" => "Iron", 
 "805" => "Meanderline",
 "806" => "Metal", 
 "807" => "Midpoint",
 "808" => "Multiple Use", 
 "809" => "Nail",
 "810" => "Oiled Earth", 
 "811" => "Oil & Chips",
 "812" => "Ornamental", 
 "813" => "Outside",
 "814" => "Overhang", 
 "815" => "Painted",
 "816" => "PC", 
 "817" => "PCC",
 "818" => "Perm. Survey Marker", 
 "819" => "Petro",
 "820" => "PI", 
 "821" => "Pin",
 "822" => "Pinch Pipe", 
 "823" => "Pipe",
 "824" => "PK Nail", 
 "825" => "Plate",
 "826" => "Plug", 
 "827" => "POBTE",
 "828" => "Rebar", 
 "829" => "POC",
 "830" => "POFT", 
 "831" => "POFTE",
 "832" => "POT", 
 "833" => "PRC",
 "834" => "Private", 
 "835" => "PT",
 "836" => "PVC", 
 "837" => "PVC Pipe",
 "838" => "Rail Road Spike", 
 "839" => "Ramp",
 "840" => "RCP", 
 "841" => "RCPA",
 "842" => "Roof Bolt", 
 "843" => "Rubber",
 "844" => "Transitline", 
 "845" => "Sanitary",
 "846" => "SC", 
 "847" => "Set",
 "848" => "Shed", 
 "849" => "Square Rod",
 "850" => "ST", 
 "851" => "Steel",
 "852" => "Step", 
 "853" => "Stone",
 "854" => "Storm", 
 "855" => "Structure Entrance",
 "856" => "Survey", 
 "857" => "Telephone",
 "858" => "Thalweg", 
 "859" => "Timber",
 "860" => "Toe", 
 "861" => "Top",
 "862" => "Top of Bank", 
 "863" => "TS",
 "864" => "Vegetation Line", 
 "865" => "Vitrified Clay",
 "866" => "Vit. Clay Encased", 
 "867" => "Water",
 "868" => "Wood Stake", 
 "869" => "Wood",
 "870" => "Woven Wire", 
) ;
$cflag = "XXXcontrolXXX";
$aflag = "XXXalphaXXX";
$oflag = "XXXoutlierXXX";
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
$globalcomment="";
undef @ssplit;
##### added lv to make comment $fsplit[1] available to processpoint()
#####################





sub generateNextPtNum {
 return $_nextAutogenPtNum++;
}
##########
####################################### Start of Main Program
if ($#ARGV<0) {
 die "Syntax:\nperl fbk.pl <input file name> <start ptnum for new pts>\n";
}
$fname=$ARGV[0];
$fname =~ s/\.[^.]*$//;
open(IN,$ARGV[0]);
open(OUT,">${fname}.csv");
if ($#ARGV>0) {
 $_nextAutogenPtNum=$ARGV[1];
}
else {
 $_nextAutogenPtNum=100000;
}
while (<IN>) {
 $curIsString=0;
 @in = split(/,/, substr(uc, 0, -1), 5); #note: forces text to be uppercase
 my @fsplit = split(/\s+/,$in[4],2); #added lv - this separates the code from the comments
     #using the first? whitespace as the separator so $fplit[0] is the full code and $fsplit[1] = the comment
        my @ssplit = ($fsplit[0] =~ /(\w+)*(\W+)/); 
#    print OUT "ssplit[0] = $ssplit[0]\n";
#    print OUT "ssplit[1] = $ssplit[1]\n"; 
    if ($ssplit[1]) {
 } else {
  $ssplit[0] = $fsplit[0];
  $ssplit[1] = "";       
 }
# print OUT "ssplit[0] = $ssplit[0]\n";    
# print OUT "ssplit[1] = $ssplit[1]\n"; 
    #added lv - this separates the 3 letter and 
    # line number from the line coding symbol; \w is alpha
    # or numeric - \W is non alpha or numeric
    # $ssplit[0] is the code and line number; ssplit[1] is the line code 
 $tok[0] = $ssplit[1]; #added lv - this is the line code
 $tok[1] = "$ssplit[0] $fsplit[1]"; #added lv - this is the code and the comment, no line code
 # @tok = split(/\s+/, $in[4], 2);
 my @csplit = ($ssplit[0] =~ /(\w\w\w)(\d*)/);


########################test for comment
# if (length($fsplit[1])>0) {##############lv  test for comment
#  $fsplit[1]="\;$fsplit[1]";########lv
#  $globalcomment = $fsplit[1]; #### added lv to make comment $fsplit[1] available to processpoint()
# }
##### 1.A. cHANGES TO fIELD cOMMENT idot MISC CODES
# if ($fsplit[1] =~ /\d[3]/)  {
 if ($fsplit[1] =~ /\d\d\d/)  {
#  print OUT "fsplit[1] = $fsplit[1]\n";
#  print OUT "var1 = $&\n";
  $possibleMiscCode = $&;
  $description = $IDOTmiscCodes{$possibleMiscCode};
#  print OUT "possibleMiscCode = $possibleMiscCode\n";
#  print OUT "description = $description\n";
 }
 if ($description) {
  $fieldComment = $fsplit[1];
#  print OUT "fieldcomment1 = $fieldComment\n";
  $fieldComment =~ s/$possibleMiscCode/$description/;
#  print OUT "fieldcomment2 = $fieldComment\n";
 } else {
  $fieldComment = $fsplit[1];
#  print OUT "fieldcomment3 = $fieldComment\n";
 }
#####1.B sEARCH FOR DELETEABLE CODES
 if ($in[4] =~ /RANDOM|CKH|CKV/) {
  $commentFlag = $cflag;
 }
####2 SEARCH FOR REQUIRED COMMENTS
 $commentText = $requiredComments{$csplit[0]};
# if ($CommentText) {
  #print OUT "csplit[0] = $csplit[0]\n";
  #print OUT "variblec2 = $commentText\n";
  $mcomment = $commentText;
# }

####3.A. sEARCH FOR ALPHA POINT NUMBERS  
# if ($in[0] =~ /[^0-9]/) {
##  $commentFlag = $aflag;
# }

#### 3.B. sEARCH FOR OUTLIERS
 $C3 = $legalCodes{$csplit[0]};
# print OUT "varibleC3 = $C3\n";
 unless ($C3) {
  $commentFlag = $oflag;
 }


#### 4 lINECODEl
 if ($ssplit[1] =~ /\.\./) {   #END LINE
#  print OUT "a;lskdjfl\n";
#  print OUT "ssplit[1] = $ssplit[1]\n";
  $linecode = ")";
 }
 if ($ssplit[1] =~ /^\.$/) { #BEGIN LINE
  $linecode = "(";
 }
 if ($ssplit[1] =~ /-/) { #PC or PT (substitiute for OC);Graef Curve 20110610
  $linecode = "%";
 }
 if ($ssplit[1] =~ /@/) { #END LINE
  $linecode = ")";
 }
 #if ($ssplit[1] =~ /-/) { #PC CURVE
 # $linecode = "-";
 #}
 if ($ssplit[1] =~ /\+/) { #CLOSE FIGURE
  $linecode = "+";
 }
 $comment = " $mcomment $fieldComment $commentFlag";
 $checkInCode = "$ssplit[0]$linecode$comment";
 $checkInCode =~ s/  / /g;
 $checkInCode =~ s/  / /g;

########################### Print Section
 
 print OUT "$in[0],$in[1],$in[2],$in[3],$checkInCode\n";
 
####################### TEST SECTION
# print OUT "in[0] point number             = $in[0]\n";
# print OUT "in[1] northing                 = $in[1]\n";  
# print OUT "in[2] easting                  = $in[2]\n";  
# print OUT "in[3] elevation                = $in[3]\n";  
# print OUT "in[4] full code & comment      = $in[4]\n";  
# print OUT "fsplit[0] full code no comment = $fsplit[0]\n";  
# print OUT "fsplit[1] comment              = $fsplit[1]\n";  
# print OUT "ssplit[0] code and line no.    = $ssplit[0]\n";  
# print OUT "ssplit[1] line code            = $ssplit[1]\n";  
# print OUT "tok[0] line code               = $tok[0]\n";  
# print OUT "tok[1] code, line no., comment = $tok[1]\n";  
# print OUT "csplit[0] code                 = $csplit[0]\n";  
# print OUT "csplit[1] line number          = $csplit[1]\n";  
# print OUT "possibleMiscCode               = $possibleMiscCode\n";  
# print OUT "description                    = $description\n";  
# print OUT "field comment                  = $fieldComment\n";  
# print OUT "C1                             = $C1\n";  
# print OUT "commentFlag                    = $commentFlag\n";
# print OUT "cFlag  control                 = $cflag\n";
# print OUT "aFlag  alpha                   = $aflag\n";    
# print OUT "oFlag  outlier                 = $oflag\n";    
# print OUT "C2                             = $C2\n";  
# print OUT "mComment                       = $mComment\n";  
# print OUT "C3                             = $C3\n";  
# print OUT "C4                             = $C4\n";  
# print OUT "linecode                       = $linecode\n";  
# print OUT "comment                        = $comment\n";  
# print OUT "checkInCode                    = $checkInCode\n\n";  
  
 
 #prepare for next loop
 if ($curIsString) {
  $activeStrings{$figname}=1; #make sure the list contains an entry for this string
 }
 $lastWasString=$curIsString;
 $lastFigname=$figname;
 $lastPtNum=$in[0];
 $figname="";
 $comment="";  #### added lv 
 $globalcomment="";  #### added lv to make comment $fsplit[1] available to processpoint()
 $ssplit[0]="";
 $fsplit[0]=""; 
 $ssplit[1]=""; 
 $fsplit[1]="";
 $csplit[0]="";
 $csplit[1]="";
 $possibleMiscCode="";
 $description="";
 $fieldComment="";
 $C2="";
 $mComment="";
 $C3="";
 $C4="";
 $linecode="";
 $comment="";
 $checkInCode="";
 $commentFlag="";
 $commentText="";
}
close(IN);
close(OUT);
