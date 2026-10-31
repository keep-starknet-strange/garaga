module

public import DivideAndPair.Generated
public import DivideAndPair.LowOrder

-- Generated per-gate certificates. Every exponent is checked by Lean.
@[expose] public section
namespace DivideAndPair
set_option maxRecDepth 8192
set_option maxHeartbeats 1000000
theorem cairo_sqrt_eq (value : Fp) :
    cairo_sqrt value = [value^(2^252-2), value^(2^253-4)-value, value^(2^253-4)+value] := by
  unfold cairo_sqrt
  extract_lets v4 v8 v12 v16 v20 v24 v28 v32 v36 v40 v44 v48 v52 v56 v60 v64 v68 v72 v76 v80 v84 v88 v92 v96 v100 v104 v108 v112 v116 v120 v124 v128 v132 v136 v140 v144 v148 v152 v156 v160 v164 v168 v172 v176 v180 v184 v188 v192 v196 v200 v204 v208 v212 v216 v220 v224 v228 v232 v236 v240 v244 v248 v252 v256 v260 v264 v268 v272 v276 v280 v284 v288 v292 v296 v300 v304 v308 v312 v316 v320 v324 v328 v332 v336 v340 v344 v348 v352 v356 v360 v364 v368 v372 v376 v380 v384 v388 v392 v396 v400 v404 v408 v412 v416 v420 v424 v428 v432 v436 v440 v444 v448 v452 v456 v460 v464 v468 v472 v476 v480 v484 v488 v492 v496 v500 v504 v508 v512 v516 v520 v524 v528 v532 v536 v540 v544 v548 v552 v556 v560 v564 v568 v572 v576 v580 v584 v588 v592 v596 v600 v604 v608 v612 v616 v620 v624 v628 v632 v636 v640 v644 v648 v652 v656 v660 v664 v668 v672 v676 v680 v684 v688 v692 v696 v700 v704 v708 v712 v716 v720 v724 v728 v732 v736 v740 v744 v748 v752 v756 v760 v764 v768 v772 v776 v780 v784 v788 v792 v796 v800 v804 v808 v812 v816 v820 v824 v828 v832 v836 v840 v844 v848 v852 v856 v860 v864 v868 v872 v876 v880 v884 v888 v892 v896 v900 v904 v908 v912 v916 v920 v924 v928 v932 v936 v940 v944 v948 v952 v956 v960 v964 v968 v972 v976 v980 v984 v988 v992 v996 v1000 v1004 v1008 v1012 v1016 v1020 v1024 v1028 v1032 v1036 v1040 v1044 v1048 v1052 v1056 v1060 v1064
  have h4 : v4 = value^2 := by
    change value*value = _
    ring
  have h8 : v8 = value^4 := by
    change v4*v4 = _
    rw [h4]
    ring
  have h12 : v12 = value^8 := by
    change v8*v8 = _
    rw [h8]
    ring
  have h16 : v16 = value^9 := by
    change v12*value = _
    rw [h12]
    ring
  have h20 : v20 = value^11 := by
    change v16*v4 = _
    rw [h16, h4]
    ring
  have h24 : v24 = value^22 := by
    change v20*v20 = _
    rw [h20]
    ring
  have h28 : v28 = value^31 := by
    change v24*v16 = _
    rw [h24, h16]
    ring
  have h32 : v32 = value^62 := by
    change v28*v28 = _
    rw [h28]
    ring
  have h36 : v36 = value^124 := by
    change v32*v32 = _
    rw [h32]
    ring
  have h40 : v40 = value^248 := by
    change v36*v36 = _
    rw [h36]
    ring
  have h44 : v44 = value^496 := by
    change v40*v40 = _
    rw [h40]
    ring
  have h48 : v48 = value^992 := by
    change v44*v44 = _
    rw [h44]
    ring
  have h52 : v52 = value^1023 := by
    change v48*v28 = _
    rw [h48, h28]
    ring
  have h56 : v56 = value^2046 := by
    change v52*v52 = _
    rw [h52]
    ring
  have h60 : v60 = value^4092 := by
    change v56*v56 = _
    rw [h56]
    ring
  have h64 : v64 = value^8184 := by
    change v60*v60 = _
    rw [h60]
    ring
  have h68 : v68 = value^16368 := by
    change v64*v64 = _
    rw [h64]
    ring
  have h72 : v72 = value^32736 := by
    change v68*v68 = _
    rw [h68]
    ring
  have h76 : v76 = value^65472 := by
    change v72*v72 = _
    rw [h72]
    ring
  have h80 : v80 = value^130944 := by
    change v76*v76 = _
    rw [h76]
    ring
  have h84 : v84 = value^261888 := by
    change v80*v80 = _
    rw [h80]
    ring
  have h88 : v88 = value^523776 := by
    change v84*v84 = _
    rw [h84]
    ring
  have h92 : v92 = value^1047552 := by
    change v88*v88 = _
    rw [h88]
    ring
  have h96 : v96 = value^1048575 := by
    change v92*v52 = _
    rw [h92, h52]
    ring
  have h100 : v100 = value^2097150 := by
    change v96*v96 = _
    rw [h96]
    ring
  have h104 : v104 = value^4194300 := by
    change v100*v100 = _
    rw [h100]
    ring
  have h108 : v108 = value^8388600 := by
    change v104*v104 = _
    rw [h104]
    ring
  have h112 : v112 = value^16777200 := by
    change v108*v108 = _
    rw [h108]
    ring
  have h116 : v116 = value^33554400 := by
    change v112*v112 = _
    rw [h112]
    ring
  have h120 : v120 = value^67108800 := by
    change v116*v116 = _
    rw [h116]
    ring
  have h124 : v124 = value^134217600 := by
    change v120*v120 = _
    rw [h120]
    ring
  have h128 : v128 = value^268435200 := by
    change v124*v124 = _
    rw [h124]
    ring
  have h132 : v132 = value^536870400 := by
    change v128*v128 = _
    rw [h128]
    ring
  have h136 : v136 = value^1073740800 := by
    change v132*v132 = _
    rw [h132]
    ring
  have h140 : v140 = value^2147481600 := by
    change v136*v136 = _
    rw [h136]
    ring
  have h144 : v144 = value^4294963200 := by
    change v140*v140 = _
    rw [h140]
    ring
  have h148 : v148 = value^8589926400 := by
    change v144*v144 = _
    rw [h144]
    ring
  have h152 : v152 = value^17179852800 := by
    change v148*v148 = _
    rw [h148]
    ring
  have h156 : v156 = value^34359705600 := by
    change v152*v152 = _
    rw [h152]
    ring
  have h160 : v160 = value^68719411200 := by
    change v156*v156 = _
    rw [h156]
    ring
  have h164 : v164 = value^137438822400 := by
    change v160*v160 = _
    rw [h160]
    ring
  have h168 : v168 = value^274877644800 := by
    change v164*v164 = _
    rw [h164]
    ring
  have h172 : v172 = value^549755289600 := by
    change v168*v168 = _
    rw [h168]
    ring
  have h176 : v176 = value^1099510579200 := by
    change v172*v172 = _
    rw [h172]
    ring
  have h180 : v180 = value^1099511627775 := by
    change v176*v96 = _
    rw [h176, h96]
    ring
  have h184 : v184 = value^2199023255550 := by
    change v180*v180 = _
    rw [h180]
    ring
  have h188 : v188 = value^4398046511100 := by
    change v184*v184 = _
    rw [h184]
    ring
  have h192 : v192 = value^8796093022200 := by
    change v188*v188 = _
    rw [h188]
    ring
  have h196 : v196 = value^17592186044400 := by
    change v192*v192 = _
    rw [h192]
    ring
  have h200 : v200 = value^35184372088800 := by
    change v196*v196 = _
    rw [h196]
    ring
  have h204 : v204 = value^70368744177600 := by
    change v200*v200 = _
    rw [h200]
    ring
  have h208 : v208 = value^140737488355200 := by
    change v204*v204 = _
    rw [h204]
    ring
  have h212 : v212 = value^281474976710400 := by
    change v208*v208 = _
    rw [h208]
    ring
  have h216 : v216 = value^562949953420800 := by
    change v212*v212 = _
    rw [h212]
    ring
  have h220 : v220 = value^1125899906841600 := by
    change v216*v216 = _
    rw [h216]
    ring
  have h224 : v224 = value^1125899906842623 := by
    change v220*v52 = _
    rw [h220, h52]
    ring
  have h228 : v228 = value^2251799813685246 := by
    change v224*v224 = _
    rw [h224]
    ring
  have h232 : v232 = value^4503599627370492 := by
    change v228*v228 = _
    rw [h228]
    ring
  have h236 : v236 = value^9007199254740984 := by
    change v232*v232 = _
    rw [h232]
    ring
  have h240 : v240 = value^18014398509481968 := by
    change v236*v236 = _
    rw [h236]
    ring
  have h244 : v244 = value^36028797018963936 := by
    change v240*v240 = _
    rw [h240]
    ring
  have h248 : v248 = value^72057594037927872 := by
    change v244*v244 = _
    rw [h244]
    ring
  have h252 : v252 = value^144115188075855744 := by
    change v248*v248 = _
    rw [h248]
    ring
  have h256 : v256 = value^288230376151711488 := by
    change v252*v252 = _
    rw [h252]
    ring
  have h260 : v260 = value^576460752303422976 := by
    change v256*v256 = _
    rw [h256]
    ring
  have h264 : v264 = value^1152921504606845952 := by
    change v260*v260 = _
    rw [h260]
    ring
  have h268 : v268 = value^2305843009213691904 := by
    change v264*v264 = _
    rw [h264]
    ring
  have h272 : v272 = value^4611686018427383808 := by
    change v268*v268 = _
    rw [h268]
    ring
  have h276 : v276 = value^9223372036854767616 := by
    change v272*v272 = _
    rw [h272]
    ring
  have h280 : v280 = value^18446744073709535232 := by
    change v276*v276 = _
    rw [h276]
    ring
  have h284 : v284 = value^36893488147419070464 := by
    change v280*v280 = _
    rw [h280]
    ring
  have h288 : v288 = value^73786976294838140928 := by
    change v284*v284 = _
    rw [h284]
    ring
  have h292 : v292 = value^147573952589676281856 := by
    change v288*v288 = _
    rw [h288]
    ring
  have h296 : v296 = value^295147905179352563712 := by
    change v292*v292 = _
    rw [h292]
    ring
  have h300 : v300 = value^590295810358705127424 := by
    change v296*v296 = _
    rw [h296]
    ring
  have h304 : v304 = value^1180591620717410254848 := by
    change v300*v300 = _
    rw [h300]
    ring
  have h308 : v308 = value^2361183241434820509696 := by
    change v304*v304 = _
    rw [h304]
    ring
  have h312 : v312 = value^4722366482869641019392 := by
    change v308*v308 = _
    rw [h308]
    ring
  have h316 : v316 = value^9444732965739282038784 := by
    change v312*v312 = _
    rw [h312]
    ring
  have h320 : v320 = value^18889465931478564077568 := by
    change v316*v316 = _
    rw [h316]
    ring
  have h324 : v324 = value^37778931862957128155136 := by
    change v320*v320 = _
    rw [h320]
    ring
  have h328 : v328 = value^75557863725914256310272 := by
    change v324*v324 = _
    rw [h324]
    ring
  have h332 : v332 = value^151115727451828512620544 := by
    change v328*v328 = _
    rw [h328]
    ring
  have h336 : v336 = value^302231454903657025241088 := by
    change v332*v332 = _
    rw [h332]
    ring
  have h340 : v340 = value^604462909807314050482176 := by
    change v336*v336 = _
    rw [h336]
    ring
  have h344 : v344 = value^1208925819614628100964352 := by
    change v340*v340 = _
    rw [h340]
    ring
  have h348 : v348 = value^2417851639229256201928704 := by
    change v344*v344 = _
    rw [h344]
    ring
  have h352 : v352 = value^4835703278458512403857408 := by
    change v348*v348 = _
    rw [h348]
    ring
  have h356 : v356 = value^9671406556917024807714816 := by
    change v352*v352 = _
    rw [h352]
    ring
  have h360 : v360 = value^19342813113834049615429632 := by
    change v356*v356 = _
    rw [h356]
    ring
  have h364 : v364 = value^38685626227668099230859264 := by
    change v360*v360 = _
    rw [h360]
    ring
  have h368 : v368 = value^77371252455336198461718528 := by
    change v364*v364 = _
    rw [h364]
    ring
  have h372 : v372 = value^154742504910672396923437056 := by
    change v368*v368 = _
    rw [h368]
    ring
  have h376 : v376 = value^309485009821344793846874112 := by
    change v372*v372 = _
    rw [h372]
    ring
  have h380 : v380 = value^618970019642689587693748224 := by
    change v376*v376 = _
    rw [h376]
    ring
  have h384 : v384 = value^1237940039285379175387496448 := by
    change v380*v380 = _
    rw [h380]
    ring
  have h388 : v388 = value^2475880078570758350774992896 := by
    change v384*v384 = _
    rw [h384]
    ring
  have h392 : v392 = value^4951760157141516701549985792 := by
    change v388*v388 = _
    rw [h388]
    ring
  have h396 : v396 = value^9903520314283033403099971584 := by
    change v392*v392 = _
    rw [h392]
    ring
  have h400 : v400 = value^19807040628566066806199943168 := by
    change v396*v396 = _
    rw [h396]
    ring
  have h404 : v404 = value^39614081257132133612399886336 := by
    change v400*v400 = _
    rw [h400]
    ring
  have h408 : v408 = value^79228162514264267224799772672 := by
    change v404*v404 = _
    rw [h404]
    ring
  have h412 : v412 = value^158456325028528534449599545344 := by
    change v408*v408 = _
    rw [h408]
    ring
  have h416 : v416 = value^316912650057057068899199090688 := by
    change v412*v412 = _
    rw [h412]
    ring
  have h420 : v420 = value^633825300114114137798398181376 := by
    change v416*v416 = _
    rw [h416]
    ring
  have h424 : v424 = value^1267650600228228275596796362752 := by
    change v420*v420 = _
    rw [h420]
    ring
  have h428 : v428 = value^1267650600228229401496703205375 := by
    change v424*v224 = _
    rw [h424, h224]
    ring
  have h432 : v432 = value^2535301200456458802993406410750 := by
    change v428*v428 = _
    rw [h428]
    ring
  have h436 : v436 = value^5070602400912917605986812821500 := by
    change v432*v432 = _
    rw [h432]
    ring
  have h440 : v440 = value^10141204801825835211973625643000 := by
    change v436*v436 = _
    rw [h436]
    ring
  have h444 : v444 = value^20282409603651670423947251286000 := by
    change v440*v440 = _
    rw [h440]
    ring
  have h448 : v448 = value^40564819207303340847894502572000 := by
    change v444*v444 = _
    rw [h444]
    ring
  have h452 : v452 = value^81129638414606681695789005144000 := by
    change v448*v448 = _
    rw [h448]
    ring
  have h456 : v456 = value^162259276829213363391578010288000 := by
    change v452*v452 = _
    rw [h452]
    ring
  have h460 : v460 = value^324518553658426726783156020576000 := by
    change v456*v456 = _
    rw [h456]
    ring
  have h464 : v464 = value^649037107316853453566312041152000 := by
    change v460*v460 = _
    rw [h460]
    ring
  have h468 : v468 = value^1298074214633706907132624082304000 := by
    change v464*v464 = _
    rw [h464]
    ring
  have h472 : v472 = value^2596148429267413814265248164608000 := by
    change v468*v468 = _
    rw [h468]
    ring
  have h476 : v476 = value^5192296858534827628530496329216000 := by
    change v472*v472 = _
    rw [h472]
    ring
  have h480 : v480 = value^10384593717069655257060992658432000 := by
    change v476*v476 = _
    rw [h476]
    ring
  have h484 : v484 = value^20769187434139310514121985316864000 := by
    change v480*v480 = _
    rw [h480]
    ring
  have h488 : v488 = value^41538374868278621028243970633728000 := by
    change v484*v484 = _
    rw [h484]
    ring
  have h492 : v492 = value^83076749736557242056487941267456000 := by
    change v488*v488 = _
    rw [h488]
    ring
  have h496 : v496 = value^166153499473114484112975882534912000 := by
    change v492*v492 = _
    rw [h492]
    ring
  have h500 : v500 = value^332306998946228968225951765069824000 := by
    change v496*v496 = _
    rw [h496]
    ring
  have h504 : v504 = value^664613997892457936451903530139648000 := by
    change v500*v500 = _
    rw [h500]
    ring
  have h508 : v508 = value^1329227995784915872903807060279296000 := by
    change v504*v504 = _
    rw [h504]
    ring
  have h512 : v512 = value^2658455991569831745807614120558592000 := by
    change v508*v508 = _
    rw [h508]
    ring
  have h516 : v516 = value^5316911983139663491615228241117184000 := by
    change v512*v512 = _
    rw [h512]
    ring
  have h520 : v520 = value^10633823966279326983230456482234368000 := by
    change v516*v516 = _
    rw [h516]
    ring
  have h524 : v524 = value^21267647932558653966460912964468736000 := by
    change v520*v520 = _
    rw [h520]
    ring
  have h528 : v528 = value^42535295865117307932921825928937472000 := by
    change v524*v524 = _
    rw [h524]
    ring
  have h532 : v532 = value^85070591730234615865843651857874944000 := by
    change v528*v528 = _
    rw [h528]
    ring
  have h536 : v536 = value^170141183460469231731687303715749888000 := by
    change v532*v532 = _
    rw [h532]
    ring
  have h540 : v540 = value^340282366920938463463374607431499776000 := by
    change v536*v536 = _
    rw [h536]
    ring
  have h544 : v544 = value^680564733841876926926749214862999552000 := by
    change v540*v540 = _
    rw [h540]
    ring
  have h548 : v548 = value^1361129467683753853853498429725999104000 := by
    change v544*v544 = _
    rw [h544]
    ring
  have h552 : v552 = value^2722258935367507707706996859451998208000 := by
    change v548*v548 = _
    rw [h548]
    ring
  have h556 : v556 = value^5444517870735015415413993718903996416000 := by
    change v552*v552 = _
    rw [h552]
    ring
  have h560 : v560 = value^10889035741470030830827987437807992832000 := by
    change v556*v556 = _
    rw [h556]
    ring
  have h564 : v564 = value^21778071482940061661655974875615985664000 := by
    change v560*v560 = _
    rw [h560]
    ring
  have h568 : v568 = value^43556142965880123323311949751231971328000 := by
    change v564*v564 = _
    rw [h564]
    ring
  have h572 : v572 = value^87112285931760246646623899502463942656000 := by
    change v568*v568 = _
    rw [h568]
    ring
  have h576 : v576 = value^174224571863520493293247799004927885312000 := by
    change v572*v572 = _
    rw [h572]
    ring
  have h580 : v580 = value^348449143727040986586495598009855770624000 := by
    change v576*v576 = _
    rw [h576]
    ring
  have h584 : v584 = value^696898287454081973172991196019711541248000 := by
    change v580*v580 = _
    rw [h580]
    ring
  have h588 : v588 = value^1393796574908163946345982392039423082496000 := by
    change v584*v584 = _
    rw [h584]
    ring
  have h592 : v592 = value^2787593149816327892691964784078846164992000 := by
    change v588*v588 = _
    rw [h588]
    ring
  have h596 : v596 = value^5575186299632655785383929568157692329984000 := by
    change v592*v592 = _
    rw [h592]
    ring
  have h600 : v600 = value^11150372599265311570767859136315384659968000 := by
    change v596*v596 = _
    rw [h596]
    ring
  have h604 : v604 = value^22300745198530623141535718272630769319936000 := by
    change v600*v600 = _
    rw [h600]
    ring
  have h608 : v608 = value^44601490397061246283071436545261538639872000 := by
    change v604*v604 = _
    rw [h604]
    ring
  have h612 : v612 = value^89202980794122492566142873090523077279744000 := by
    change v608*v608 = _
    rw [h608]
    ring
  have h616 : v616 = value^178405961588244985132285746181046154559488000 := by
    change v612*v612 = _
    rw [h612]
    ring
  have h620 : v620 = value^356811923176489970264571492362092309118976000 := by
    change v616*v616 = _
    rw [h616]
    ring
  have h624 : v624 = value^713623846352979940529142984724184618237952000 := by
    change v620*v620 = _
    rw [h620]
    ring
  have h628 : v628 = value^1427247692705959881058285969448369236475904000 := by
    change v624*v624 = _
    rw [h624]
    ring
  have h632 : v632 = value^2854495385411919762116571938896738472951808000 := by
    change v628*v628 = _
    rw [h628]
    ring
  have h636 : v636 = value^5708990770823839524233143877793476945903616000 := by
    change v632*v632 = _
    rw [h632]
    ring
  have h640 : v640 = value^11417981541647679048466287755586953891807232000 := by
    change v636*v636 = _
    rw [h636]
    ring
  have h644 : v644 = value^22835963083295358096932575511173907783614464000 := by
    change v640*v640 = _
    rw [h640]
    ring
  have h648 : v648 = value^45671926166590716193865151022347815567228928000 := by
    change v644*v644 = _
    rw [h644]
    ring
  have h652 : v652 = value^91343852333181432387730302044695631134457856000 := by
    change v648*v648 = _
    rw [h648]
    ring
  have h656 : v656 = value^182687704666362864775460604089391262268915712000 := by
    change v652*v652 = _
    rw [h652]
    ring
  have h660 : v660 = value^365375409332725729550921208178782524537831424000 := by
    change v656*v656 = _
    rw [h656]
    ring
  have h664 : v664 = value^730750818665451459101842416357565049075662848000 := by
    change v660*v660 = _
    rw [h660]
    ring
  have h668 : v668 = value^1461501637330902918203684832715130098151325696000 := by
    change v664*v664 = _
    rw [h664]
    ring
  have h672 : v672 = value^2923003274661805836407369665430260196302651392000 := by
    change v668*v668 = _
    rw [h668]
    ring
  have h676 : v676 = value^5846006549323611672814739330860520392605302784000 := by
    change v672*v672 = _
    rw [h672]
    ring
  have h680 : v680 = value^11692013098647223345629478661721040785210605568000 := by
    change v676*v676 = _
    rw [h676]
    ring
  have h684 : v684 = value^23384026197294446691258957323442081570421211136000 := by
    change v680*v680 = _
    rw [h680]
    ring
  have h688 : v688 = value^46768052394588893382517914646884163140842422272000 := by
    change v684*v684 = _
    rw [h684]
    ring
  have h692 : v692 = value^93536104789177786765035829293768326281684844544000 := by
    change v688*v688 = _
    rw [h688]
    ring
  have h696 : v696 = value^187072209578355573530071658587536652563369689088000 := by
    change v692*v692 = _
    rw [h692]
    ring
  have h700 : v700 = value^374144419156711147060143317175073305126739378176000 := by
    change v696*v696 = _
    rw [h696]
    ring
  have h704 : v704 = value^748288838313422294120286634350146610253478756352000 := by
    change v700*v700 = _
    rw [h700]
    ring
  have h708 : v708 = value^1496577676626844588240573268700293220506957512704000 := by
    change v704*v704 = _
    rw [h704]
    ring
  have h712 : v712 = value^2993155353253689176481146537400586441013915025408000 := by
    change v708*v708 = _
    rw [h708]
    ring
  have h716 : v716 = value^5986310706507378352962293074801172882027830050816000 := by
    change v712*v712 = _
    rw [h712]
    ring
  have h720 : v720 = value^11972621413014756705924586149602345764055660101632000 := by
    change v716*v716 = _
    rw [h716]
    ring
  have h724 : v724 = value^23945242826029513411849172299204691528111320203264000 := by
    change v720*v720 = _
    rw [h720]
    ring
  have h728 : v728 = value^47890485652059026823698344598409383056222640406528000 := by
    change v724*v724 = _
    rw [h724]
    ring
  have h732 : v732 = value^95780971304118053647396689196818766112445280813056000 := by
    change v728*v728 = _
    rw [h728]
    ring
  have h736 : v736 = value^191561942608236107294793378393637532224890561626112000 := by
    change v732*v732 = _
    rw [h732]
    ring
  have h740 : v740 = value^383123885216472214589586756787275064449781123252224000 := by
    change v736*v736 = _
    rw [h736]
    ring
  have h744 : v744 = value^766247770432944429179173513574550128899562246504448000 := by
    change v740*v740 = _
    rw [h740]
    ring
  have h748 : v748 = value^1532495540865888858358347027149100257799124493008896000 := by
    change v744*v744 = _
    rw [h744]
    ring
  have h752 : v752 = value^3064991081731777716716694054298200515598248986017792000 := by
    change v748*v748 = _
    rw [h748]
    ring
  have h756 : v756 = value^6129982163463555433433388108596401031196497972035584000 := by
    change v752*v752 = _
    rw [h752]
    ring
  have h760 : v760 = value^12259964326927110866866776217192802062392995944071168000 := by
    change v756*v756 = _
    rw [h756]
    ring
  have h764 : v764 = value^24519928653854221733733552434385604124785991888142336000 := by
    change v760*v760 = _
    rw [h760]
    ring
  have h768 : v768 = value^49039857307708443467467104868771208249571983776284672000 := by
    change v764*v764 = _
    rw [h764]
    ring
  have h772 : v772 = value^98079714615416886934934209737542416499143967552569344000 := by
    change v768*v768 = _
    rw [h768]
    ring
  have h776 : v776 = value^196159429230833773869868419475084832998287935105138688000 := by
    change v772*v772 = _
    rw [h772]
    ring
  have h780 : v780 = value^392318858461667547739736838950169665996575870210277376000 := by
    change v776*v776 = _
    rw [h776]
    ring
  have h784 : v784 = value^784637716923335095479473677900339331993151740420554752000 := by
    change v780*v780 = _
    rw [h780]
    ring
  have h788 : v788 = value^1569275433846670190958947355800678663986303480841109504000 := by
    change v784*v784 = _
    rw [h784]
    ring
  have h792 : v792 = value^3138550867693340381917894711601357327972606961682219008000 := by
    change v788*v788 = _
    rw [h788]
    ring
  have h796 : v796 = value^6277101735386680763835789423202714655945213923364438016000 := by
    change v792*v792 = _
    rw [h792]
    ring
  have h800 : v800 = value^12554203470773361527671578846405429311890427846728876032000 := by
    change v796*v796 = _
    rw [h796]
    ring
  have h804 : v804 = value^25108406941546723055343157692810858623780855693457752064000 := by
    change v800*v800 = _
    rw [h800]
    ring
  have h808 : v808 = value^50216813883093446110686315385621717247561711386915504128000 := by
    change v804*v804 = _
    rw [h804]
    ring
  have h812 : v812 = value^100433627766186892221372630771243434495123422773831008256000 := by
    change v808*v808 = _
    rw [h808]
    ring
  have h816 : v816 = value^200867255532373784442745261542486868990246845547662016512000 := by
    change v812*v812 = _
    rw [h812]
    ring
  have h820 : v820 = value^401734511064747568885490523084973737980493691095324033024000 := by
    change v816*v816 = _
    rw [h816]
    ring
  have h824 : v824 = value^803469022129495137770981046169947475960987382190648066048000 := by
    change v820*v820 = _
    rw [h820]
    ring
  have h828 : v828 = value^1606938044258990275541962092339894951921974764381296132096000 := by
    change v824*v824 = _
    rw [h824]
    ring
  have h832 : v832 = value^1606938044258990275541962092341162602522202993782792835301375 := by
    change v828*v428 = _
    rw [h828, h428]
    ring
  have h836 : v836 = value^3213876088517980551083924184682325205044405987565585670602750 := by
    change v832*v832 = _
    rw [h832]
    ring
  have h840 : v840 = value^6427752177035961102167848369364650410088811975131171341205500 := by
    change v836*v836 = _
    rw [h836]
    ring
  have h844 : v844 = value^12855504354071922204335696738729300820177623950262342682411000 := by
    change v840*v840 = _
    rw [h840]
    ring
  have h848 : v848 = value^25711008708143844408671393477458601640355247900524685364822000 := by
    change v844*v844 = _
    rw [h844]
    ring
  have h852 : v852 = value^51422017416287688817342786954917203280710495801049370729644000 := by
    change v848*v848 = _
    rw [h848]
    ring
  have h856 : v856 = value^102844034832575377634685573909834406561420991602098741459288000 := by
    change v852*v852 = _
    rw [h852]
    ring
  have h860 : v860 = value^205688069665150755269371147819668813122841983204197482918576000 := by
    change v856*v856 = _
    rw [h856]
    ring
  have h864 : v864 = value^411376139330301510538742295639337626245683966408394965837152000 := by
    change v860*v860 = _
    rw [h860]
    ring
  have h868 : v868 = value^822752278660603021077484591278675252491367932816789931674304000 := by
    change v864*v864 = _
    rw [h864]
    ring
  have h872 : v872 = value^1645504557321206042154969182557350504982735865633579863348608000 := by
    change v868*v868 = _
    rw [h868]
    ring
  have h876 : v876 = value^3291009114642412084309938365114701009965471731267159726697216000 := by
    change v872*v872 = _
    rw [h872]
    ring
  have h880 : v880 = value^6582018229284824168619876730229402019930943462534319453394432000 := by
    change v876*v876 = _
    rw [h876]
    ring
  have h884 : v884 = value^13164036458569648337239753460458804039861886925068638906788864000 := by
    change v880*v880 = _
    rw [h880]
    ring
  have h888 : v888 = value^26328072917139296674479506920917608079723773850137277813577728000 := by
    change v884*v884 = _
    rw [h884]
    ring
  have h892 : v892 = value^52656145834278593348959013841835216159447547700274555627155456000 := by
    change v888*v888 = _
    rw [h888]
    ring
  have h896 : v896 = value^105312291668557186697918027683670432318895095400549111254310912000 := by
    change v892*v892 = _
    rw [h892]
    ring
  have h900 : v900 = value^210624583337114373395836055367340864637790190801098222508621824000 := by
    change v896*v896 = _
    rw [h896]
    ring
  have h904 : v904 = value^421249166674228746791672110734681729275580381602196445017243648000 := by
    change v900*v900 = _
    rw [h900]
    ring
  have h908 : v908 = value^842498333348457493583344221469363458551160763204392890034487296000 := by
    change v904*v904 = _
    rw [h904]
    ring
  have h912 : v912 = value^1684996666696914987166688442938726917102321526408785780068974592000 := by
    change v908*v908 = _
    rw [h908]
    ring
  have h916 : v916 = value^3369993333393829974333376885877453834204643052817571560137949184000 := by
    change v912*v912 = _
    rw [h912]
    ring
  have h920 : v920 = value^6739986666787659948666753771754907668409286105635143120275898368000 := by
    change v916*v916 = _
    rw [h916]
    ring
  have h924 : v924 = value^13479973333575319897333507543509815336818572211270286240551796736000 := by
    change v920*v920 = _
    rw [h920]
    ring
  have h928 : v928 = value^26959946667150639794667015087019630673637144422540572481103593472000 := by
    change v924*v924 = _
    rw [h924]
    ring
  have h932 : v932 = value^53919893334301279589334030174039261347274288845081144962207186944000 := by
    change v928*v928 = _
    rw [h928]
    ring
  have h936 : v936 = value^107839786668602559178668060348078522694548577690162289924414373888000 := by
    change v932*v932 = _
    rw [h932]
    ring
  have h940 : v940 = value^215679573337205118357336120696157045389097155380324579848828747776000 := by
    change v936*v936 = _
    rw [h936]
    ring
  have h944 : v944 = value^431359146674410236714672241392314090778194310760649159697657495552000 := by
    change v940*v940 = _
    rw [h940]
    ring
  have h948 : v948 = value^862718293348820473429344482784628181556388621521298319395314991104000 := by
    change v944*v944 = _
    rw [h944]
    ring
  have h952 : v952 = value^1725436586697640946858688965569256363112777243042596638790629982208000 := by
    change v948*v948 = _
    rw [h948]
    ring
  have h956 : v956 = value^3450873173395281893717377931138512726225554486085193277581259964416000 := by
    change v952*v952 = _
    rw [h952]
    ring
  have h960 : v960 = value^6901746346790563787434755862277025452451108972170386555162519928832000 := by
    change v956*v956 = _
    rw [h956]
    ring
  have h964 : v964 = value^13803492693581127574869511724554050904902217944340773110325039857664000 := by
    change v960*v960 = _
    rw [h960]
    ring
  have h968 : v968 = value^27606985387162255149739023449108101809804435888681546220650079715328000 := by
    change v964*v964 = _
    rw [h964]
    ring
  have h972 : v972 = value^55213970774324510299478046898216203619608871777363092441300159430656000 := by
    change v968*v968 = _
    rw [h968]
    ring
  have h976 : v976 = value^110427941548649020598956093796432407239217743554726184882600318861312000 := by
    change v972*v972 = _
    rw [h972]
    ring
  have h980 : v980 = value^220855883097298041197912187592864814478435487109452369765200637722624000 := by
    change v976*v976 = _
    rw [h976]
    ring
  have h984 : v984 = value^441711766194596082395824375185729628956870974218904739530401275445248000 := by
    change v980*v980 = _
    rw [h980]
    ring
  have h988 : v988 = value^883423532389192164791648750371459257913741948437809479060802550890496000 := by
    change v984*v984 = _
    rw [h984]
    ring
  have h992 : v992 = value^1766847064778384329583297500742918515827483896875618958121605101780992000 := by
    change v988*v988 = _
    rw [h988]
    ring
  have h996 : v996 = value^3533694129556768659166595001485837031654967793751237916243210203561984000 := by
    change v992*v992 = _
    rw [h992]
    ring
  have h1000 : v1000 = value^7067388259113537318333190002971674063309935587502475832486420407123968000 := by
    change v996*v996 = _
    rw [h996]
    ring
  have h1004 : v1004 = value^14134776518227074636666380005943348126619871175004951664972840814247936000 := by
    change v1000*v1000 = _
    rw [h1000]
    ring
  have h1008 : v1008 = value^28269553036454149273332760011886696253239742350009903329945681628495872000 := by
    change v1004*v1004 = _
    rw [h1004]
    ring
  have h1012 : v1012 = value^56539106072908298546665520023773392506479484700019806659891363256991744000 := by
    change v1008*v1008 = _
    rw [h1008]
    ring
  have h1016 : v1016 = value^113078212145816597093331040047546785012958969400039613319782726513983488000 := by
    change v1012*v1012 = _
    rw [h1012]
    ring
  have h1020 : v1020 = value^226156424291633194186662080095093570025917938800079226639565453027966976000 := by
    change v1016*v1016 = _
    rw [h1016]
    ring
  have h1024 : v1024 = value^452312848583266388373324160190187140051835877600158453279130906055933952000 := by
    change v1020*v1020 = _
    rw [h1020]
    ring
  have h1028 : v1028 = value^904625697166532776746648320380374280103671755200316906558261812111867904000 := by
    change v1024*v1024 = _
    rw [h1024]
    ring
  have h1032 : v1032 = value^1809251394333065553493296640760748560207343510400633813116523624223735808000 := by
    change v1028*v1028 = _
    rw [h1028]
    ring
  have h1036 : v1036 = value^1809251394333065553493296640760748560207343510400633813116524750123642650623 := by
    change v1032*v224 = _
    rw [h1032, h224]
    ring
  have h1040 : v1040 = value^3618502788666131106986593281521497120414687020801267626233049500247285301246 := by
    change v1036*v1036 = _
    rw [h1036]
    ring
  have h1044 : v1044 = value^7237005577332262213973186563042994240829374041602535252466099000494570602492 := by
    change v1040*v1040 = _
    rw [h1040]
    ring
  have h1048 : v1048 = value^7237005577332262213973186563042994240829374041602535252466099000494570602493 := by
    change v1044*value = _
    rw [h1044]
    ring
  have h1052 : v1052 = value^7237005577332262213973186563042994240829374041602535252466099000494570602494 := by
    change v1048*value = _
    rw [h1048]
    ring
  have h1056 : v1056 = value^14474011154664524427946373126085988481658748083205070504932198000989141204988 := by
    change v1052*v1052 = _
    rw [h1052]
    ring
  change [v1052, v1056-value, v1056+value] = _
  rw [h1052, h1056]
  rfl

theorem cairo_sqrt_or_twice_eq (value : Fp) :
    cairo_sqrt_or_twice value = [value^(2^252-2), value^(2^253-4)-value, value^(2^253-4)+value, value^(2^253-4)-(19681161376707505956807079304988542015446066515923890162744021073123829784752:Fp)*value, value^(2^253-4)+(19681161376707505956807079304988542015446066515923890162744021073123829784752:Fp)*value] := by
  unfold cairo_sqrt_or_twice
  extract_lets v4 v8 v12 v16 v20 v24 v28 v32 v36 v40 v44 v48 v52 v56 v60 v64 v68 v72 v76 v80 v84 v88 v92 v96 v100 v104 v108 v112 v116 v120 v124 v128 v132 v136 v140 v144 v148 v152 v156 v160 v164 v168 v172 v176 v180 v184 v188 v192 v196 v200 v204 v208 v212 v216 v220 v224 v228 v232 v236 v240 v244 v248 v252 v256 v260 v264 v268 v272 v276 v280 v284 v288 v292 v296 v300 v304 v308 v312 v316 v320 v324 v328 v332 v336 v340 v344 v348 v352 v356 v360 v364 v368 v372 v376 v380 v384 v388 v392 v396 v400 v404 v408 v412 v416 v420 v424 v428 v432 v436 v440 v444 v448 v452 v456 v460 v464 v468 v472 v476 v480 v484 v488 v492 v496 v500 v504 v508 v512 v516 v520 v524 v528 v532 v536 v540 v544 v548 v552 v556 v560 v564 v568 v572 v576 v580 v584 v588 v592 v596 v600 v604 v608 v612 v616 v620 v624 v628 v632 v636 v640 v644 v648 v652 v656 v660 v664 v668 v672 v676 v680 v684 v688 v692 v696 v700 v704 v708 v712 v716 v720 v724 v728 v732 v736 v740 v744 v748 v752 v756 v760 v764 v768 v772 v776 v780 v784 v788 v792 v796 v800 v804 v808 v812 v816 v820 v824 v828 v832 v836 v840 v844 v848 v852 v856 v860 v864 v868 v872 v876 v880 v884 v888 v892 v896 v900 v904 v908 v912 v916 v920 v924 v928 v932 v936 v940 v944 v948 v952 v956 v960 v964 v968 v972 v976 v980 v984 v988 v992 v996 v1000 v1004 v1008 v1012 v1016 v1020 v1024 v1028 v1032 v1036 v1040 v1044 v1048 v1052 v1056 v1060 v1064 v1068 v1072 v1076 v1080
  have h4 : v4 = value^2 := by
    change value*value = _
    ring
  have h8 : v8 = value^4 := by
    change v4*v4 = _
    rw [h4]
    ring
  have h12 : v12 = value^8 := by
    change v8*v8 = _
    rw [h8]
    ring
  have h16 : v16 = value^9 := by
    change v12*value = _
    rw [h12]
    ring
  have h20 : v20 = value^11 := by
    change v16*v4 = _
    rw [h16, h4]
    ring
  have h24 : v24 = value^22 := by
    change v20*v20 = _
    rw [h20]
    ring
  have h28 : v28 = value^31 := by
    change v24*v16 = _
    rw [h24, h16]
    ring
  have h32 : v32 = value^62 := by
    change v28*v28 = _
    rw [h28]
    ring
  have h36 : v36 = value^124 := by
    change v32*v32 = _
    rw [h32]
    ring
  have h40 : v40 = value^248 := by
    change v36*v36 = _
    rw [h36]
    ring
  have h44 : v44 = value^496 := by
    change v40*v40 = _
    rw [h40]
    ring
  have h48 : v48 = value^992 := by
    change v44*v44 = _
    rw [h44]
    ring
  have h52 : v52 = value^1023 := by
    change v48*v28 = _
    rw [h48, h28]
    ring
  have h56 : v56 = value^2046 := by
    change v52*v52 = _
    rw [h52]
    ring
  have h60 : v60 = value^4092 := by
    change v56*v56 = _
    rw [h56]
    ring
  have h64 : v64 = value^8184 := by
    change v60*v60 = _
    rw [h60]
    ring
  have h68 : v68 = value^16368 := by
    change v64*v64 = _
    rw [h64]
    ring
  have h72 : v72 = value^32736 := by
    change v68*v68 = _
    rw [h68]
    ring
  have h76 : v76 = value^65472 := by
    change v72*v72 = _
    rw [h72]
    ring
  have h80 : v80 = value^130944 := by
    change v76*v76 = _
    rw [h76]
    ring
  have h84 : v84 = value^261888 := by
    change v80*v80 = _
    rw [h80]
    ring
  have h88 : v88 = value^523776 := by
    change v84*v84 = _
    rw [h84]
    ring
  have h92 : v92 = value^1047552 := by
    change v88*v88 = _
    rw [h88]
    ring
  have h96 : v96 = value^1048575 := by
    change v92*v52 = _
    rw [h92, h52]
    ring
  have h100 : v100 = value^2097150 := by
    change v96*v96 = _
    rw [h96]
    ring
  have h104 : v104 = value^4194300 := by
    change v100*v100 = _
    rw [h100]
    ring
  have h108 : v108 = value^8388600 := by
    change v104*v104 = _
    rw [h104]
    ring
  have h112 : v112 = value^16777200 := by
    change v108*v108 = _
    rw [h108]
    ring
  have h116 : v116 = value^33554400 := by
    change v112*v112 = _
    rw [h112]
    ring
  have h120 : v120 = value^67108800 := by
    change v116*v116 = _
    rw [h116]
    ring
  have h124 : v124 = value^134217600 := by
    change v120*v120 = _
    rw [h120]
    ring
  have h128 : v128 = value^268435200 := by
    change v124*v124 = _
    rw [h124]
    ring
  have h132 : v132 = value^536870400 := by
    change v128*v128 = _
    rw [h128]
    ring
  have h136 : v136 = value^1073740800 := by
    change v132*v132 = _
    rw [h132]
    ring
  have h140 : v140 = value^2147481600 := by
    change v136*v136 = _
    rw [h136]
    ring
  have h144 : v144 = value^4294963200 := by
    change v140*v140 = _
    rw [h140]
    ring
  have h148 : v148 = value^8589926400 := by
    change v144*v144 = _
    rw [h144]
    ring
  have h152 : v152 = value^17179852800 := by
    change v148*v148 = _
    rw [h148]
    ring
  have h156 : v156 = value^34359705600 := by
    change v152*v152 = _
    rw [h152]
    ring
  have h160 : v160 = value^68719411200 := by
    change v156*v156 = _
    rw [h156]
    ring
  have h164 : v164 = value^137438822400 := by
    change v160*v160 = _
    rw [h160]
    ring
  have h168 : v168 = value^274877644800 := by
    change v164*v164 = _
    rw [h164]
    ring
  have h172 : v172 = value^549755289600 := by
    change v168*v168 = _
    rw [h168]
    ring
  have h176 : v176 = value^1099510579200 := by
    change v172*v172 = _
    rw [h172]
    ring
  have h180 : v180 = value^1099511627775 := by
    change v176*v96 = _
    rw [h176, h96]
    ring
  have h184 : v184 = value^2199023255550 := by
    change v180*v180 = _
    rw [h180]
    ring
  have h188 : v188 = value^4398046511100 := by
    change v184*v184 = _
    rw [h184]
    ring
  have h192 : v192 = value^8796093022200 := by
    change v188*v188 = _
    rw [h188]
    ring
  have h196 : v196 = value^17592186044400 := by
    change v192*v192 = _
    rw [h192]
    ring
  have h200 : v200 = value^35184372088800 := by
    change v196*v196 = _
    rw [h196]
    ring
  have h204 : v204 = value^70368744177600 := by
    change v200*v200 = _
    rw [h200]
    ring
  have h208 : v208 = value^140737488355200 := by
    change v204*v204 = _
    rw [h204]
    ring
  have h212 : v212 = value^281474976710400 := by
    change v208*v208 = _
    rw [h208]
    ring
  have h216 : v216 = value^562949953420800 := by
    change v212*v212 = _
    rw [h212]
    ring
  have h220 : v220 = value^1125899906841600 := by
    change v216*v216 = _
    rw [h216]
    ring
  have h224 : v224 = value^1125899906842623 := by
    change v220*v52 = _
    rw [h220, h52]
    ring
  have h228 : v228 = value^2251799813685246 := by
    change v224*v224 = _
    rw [h224]
    ring
  have h232 : v232 = value^4503599627370492 := by
    change v228*v228 = _
    rw [h228]
    ring
  have h236 : v236 = value^9007199254740984 := by
    change v232*v232 = _
    rw [h232]
    ring
  have h240 : v240 = value^18014398509481968 := by
    change v236*v236 = _
    rw [h236]
    ring
  have h244 : v244 = value^36028797018963936 := by
    change v240*v240 = _
    rw [h240]
    ring
  have h248 : v248 = value^72057594037927872 := by
    change v244*v244 = _
    rw [h244]
    ring
  have h252 : v252 = value^144115188075855744 := by
    change v248*v248 = _
    rw [h248]
    ring
  have h256 : v256 = value^288230376151711488 := by
    change v252*v252 = _
    rw [h252]
    ring
  have h260 : v260 = value^576460752303422976 := by
    change v256*v256 = _
    rw [h256]
    ring
  have h264 : v264 = value^1152921504606845952 := by
    change v260*v260 = _
    rw [h260]
    ring
  have h268 : v268 = value^2305843009213691904 := by
    change v264*v264 = _
    rw [h264]
    ring
  have h272 : v272 = value^4611686018427383808 := by
    change v268*v268 = _
    rw [h268]
    ring
  have h276 : v276 = value^9223372036854767616 := by
    change v272*v272 = _
    rw [h272]
    ring
  have h280 : v280 = value^18446744073709535232 := by
    change v276*v276 = _
    rw [h276]
    ring
  have h284 : v284 = value^36893488147419070464 := by
    change v280*v280 = _
    rw [h280]
    ring
  have h288 : v288 = value^73786976294838140928 := by
    change v284*v284 = _
    rw [h284]
    ring
  have h292 : v292 = value^147573952589676281856 := by
    change v288*v288 = _
    rw [h288]
    ring
  have h296 : v296 = value^295147905179352563712 := by
    change v292*v292 = _
    rw [h292]
    ring
  have h300 : v300 = value^590295810358705127424 := by
    change v296*v296 = _
    rw [h296]
    ring
  have h304 : v304 = value^1180591620717410254848 := by
    change v300*v300 = _
    rw [h300]
    ring
  have h308 : v308 = value^2361183241434820509696 := by
    change v304*v304 = _
    rw [h304]
    ring
  have h312 : v312 = value^4722366482869641019392 := by
    change v308*v308 = _
    rw [h308]
    ring
  have h316 : v316 = value^9444732965739282038784 := by
    change v312*v312 = _
    rw [h312]
    ring
  have h320 : v320 = value^18889465931478564077568 := by
    change v316*v316 = _
    rw [h316]
    ring
  have h324 : v324 = value^37778931862957128155136 := by
    change v320*v320 = _
    rw [h320]
    ring
  have h328 : v328 = value^75557863725914256310272 := by
    change v324*v324 = _
    rw [h324]
    ring
  have h332 : v332 = value^151115727451828512620544 := by
    change v328*v328 = _
    rw [h328]
    ring
  have h336 : v336 = value^302231454903657025241088 := by
    change v332*v332 = _
    rw [h332]
    ring
  have h340 : v340 = value^604462909807314050482176 := by
    change v336*v336 = _
    rw [h336]
    ring
  have h344 : v344 = value^1208925819614628100964352 := by
    change v340*v340 = _
    rw [h340]
    ring
  have h348 : v348 = value^2417851639229256201928704 := by
    change v344*v344 = _
    rw [h344]
    ring
  have h352 : v352 = value^4835703278458512403857408 := by
    change v348*v348 = _
    rw [h348]
    ring
  have h356 : v356 = value^9671406556917024807714816 := by
    change v352*v352 = _
    rw [h352]
    ring
  have h360 : v360 = value^19342813113834049615429632 := by
    change v356*v356 = _
    rw [h356]
    ring
  have h364 : v364 = value^38685626227668099230859264 := by
    change v360*v360 = _
    rw [h360]
    ring
  have h368 : v368 = value^77371252455336198461718528 := by
    change v364*v364 = _
    rw [h364]
    ring
  have h372 : v372 = value^154742504910672396923437056 := by
    change v368*v368 = _
    rw [h368]
    ring
  have h376 : v376 = value^309485009821344793846874112 := by
    change v372*v372 = _
    rw [h372]
    ring
  have h380 : v380 = value^618970019642689587693748224 := by
    change v376*v376 = _
    rw [h376]
    ring
  have h384 : v384 = value^1237940039285379175387496448 := by
    change v380*v380 = _
    rw [h380]
    ring
  have h388 : v388 = value^2475880078570758350774992896 := by
    change v384*v384 = _
    rw [h384]
    ring
  have h392 : v392 = value^4951760157141516701549985792 := by
    change v388*v388 = _
    rw [h388]
    ring
  have h396 : v396 = value^9903520314283033403099971584 := by
    change v392*v392 = _
    rw [h392]
    ring
  have h400 : v400 = value^19807040628566066806199943168 := by
    change v396*v396 = _
    rw [h396]
    ring
  have h404 : v404 = value^39614081257132133612399886336 := by
    change v400*v400 = _
    rw [h400]
    ring
  have h408 : v408 = value^79228162514264267224799772672 := by
    change v404*v404 = _
    rw [h404]
    ring
  have h412 : v412 = value^158456325028528534449599545344 := by
    change v408*v408 = _
    rw [h408]
    ring
  have h416 : v416 = value^316912650057057068899199090688 := by
    change v412*v412 = _
    rw [h412]
    ring
  have h420 : v420 = value^633825300114114137798398181376 := by
    change v416*v416 = _
    rw [h416]
    ring
  have h424 : v424 = value^1267650600228228275596796362752 := by
    change v420*v420 = _
    rw [h420]
    ring
  have h428 : v428 = value^1267650600228229401496703205375 := by
    change v424*v224 = _
    rw [h424, h224]
    ring
  have h432 : v432 = value^2535301200456458802993406410750 := by
    change v428*v428 = _
    rw [h428]
    ring
  have h436 : v436 = value^5070602400912917605986812821500 := by
    change v432*v432 = _
    rw [h432]
    ring
  have h440 : v440 = value^10141204801825835211973625643000 := by
    change v436*v436 = _
    rw [h436]
    ring
  have h444 : v444 = value^20282409603651670423947251286000 := by
    change v440*v440 = _
    rw [h440]
    ring
  have h448 : v448 = value^40564819207303340847894502572000 := by
    change v444*v444 = _
    rw [h444]
    ring
  have h452 : v452 = value^81129638414606681695789005144000 := by
    change v448*v448 = _
    rw [h448]
    ring
  have h456 : v456 = value^162259276829213363391578010288000 := by
    change v452*v452 = _
    rw [h452]
    ring
  have h460 : v460 = value^324518553658426726783156020576000 := by
    change v456*v456 = _
    rw [h456]
    ring
  have h464 : v464 = value^649037107316853453566312041152000 := by
    change v460*v460 = _
    rw [h460]
    ring
  have h468 : v468 = value^1298074214633706907132624082304000 := by
    change v464*v464 = _
    rw [h464]
    ring
  have h472 : v472 = value^2596148429267413814265248164608000 := by
    change v468*v468 = _
    rw [h468]
    ring
  have h476 : v476 = value^5192296858534827628530496329216000 := by
    change v472*v472 = _
    rw [h472]
    ring
  have h480 : v480 = value^10384593717069655257060992658432000 := by
    change v476*v476 = _
    rw [h476]
    ring
  have h484 : v484 = value^20769187434139310514121985316864000 := by
    change v480*v480 = _
    rw [h480]
    ring
  have h488 : v488 = value^41538374868278621028243970633728000 := by
    change v484*v484 = _
    rw [h484]
    ring
  have h492 : v492 = value^83076749736557242056487941267456000 := by
    change v488*v488 = _
    rw [h488]
    ring
  have h496 : v496 = value^166153499473114484112975882534912000 := by
    change v492*v492 = _
    rw [h492]
    ring
  have h500 : v500 = value^332306998946228968225951765069824000 := by
    change v496*v496 = _
    rw [h496]
    ring
  have h504 : v504 = value^664613997892457936451903530139648000 := by
    change v500*v500 = _
    rw [h500]
    ring
  have h508 : v508 = value^1329227995784915872903807060279296000 := by
    change v504*v504 = _
    rw [h504]
    ring
  have h512 : v512 = value^2658455991569831745807614120558592000 := by
    change v508*v508 = _
    rw [h508]
    ring
  have h516 : v516 = value^5316911983139663491615228241117184000 := by
    change v512*v512 = _
    rw [h512]
    ring
  have h520 : v520 = value^10633823966279326983230456482234368000 := by
    change v516*v516 = _
    rw [h516]
    ring
  have h524 : v524 = value^21267647932558653966460912964468736000 := by
    change v520*v520 = _
    rw [h520]
    ring
  have h528 : v528 = value^42535295865117307932921825928937472000 := by
    change v524*v524 = _
    rw [h524]
    ring
  have h532 : v532 = value^85070591730234615865843651857874944000 := by
    change v528*v528 = _
    rw [h528]
    ring
  have h536 : v536 = value^170141183460469231731687303715749888000 := by
    change v532*v532 = _
    rw [h532]
    ring
  have h540 : v540 = value^340282366920938463463374607431499776000 := by
    change v536*v536 = _
    rw [h536]
    ring
  have h544 : v544 = value^680564733841876926926749214862999552000 := by
    change v540*v540 = _
    rw [h540]
    ring
  have h548 : v548 = value^1361129467683753853853498429725999104000 := by
    change v544*v544 = _
    rw [h544]
    ring
  have h552 : v552 = value^2722258935367507707706996859451998208000 := by
    change v548*v548 = _
    rw [h548]
    ring
  have h556 : v556 = value^5444517870735015415413993718903996416000 := by
    change v552*v552 = _
    rw [h552]
    ring
  have h560 : v560 = value^10889035741470030830827987437807992832000 := by
    change v556*v556 = _
    rw [h556]
    ring
  have h564 : v564 = value^21778071482940061661655974875615985664000 := by
    change v560*v560 = _
    rw [h560]
    ring
  have h568 : v568 = value^43556142965880123323311949751231971328000 := by
    change v564*v564 = _
    rw [h564]
    ring
  have h572 : v572 = value^87112285931760246646623899502463942656000 := by
    change v568*v568 = _
    rw [h568]
    ring
  have h576 : v576 = value^174224571863520493293247799004927885312000 := by
    change v572*v572 = _
    rw [h572]
    ring
  have h580 : v580 = value^348449143727040986586495598009855770624000 := by
    change v576*v576 = _
    rw [h576]
    ring
  have h584 : v584 = value^696898287454081973172991196019711541248000 := by
    change v580*v580 = _
    rw [h580]
    ring
  have h588 : v588 = value^1393796574908163946345982392039423082496000 := by
    change v584*v584 = _
    rw [h584]
    ring
  have h592 : v592 = value^2787593149816327892691964784078846164992000 := by
    change v588*v588 = _
    rw [h588]
    ring
  have h596 : v596 = value^5575186299632655785383929568157692329984000 := by
    change v592*v592 = _
    rw [h592]
    ring
  have h600 : v600 = value^11150372599265311570767859136315384659968000 := by
    change v596*v596 = _
    rw [h596]
    ring
  have h604 : v604 = value^22300745198530623141535718272630769319936000 := by
    change v600*v600 = _
    rw [h600]
    ring
  have h608 : v608 = value^44601490397061246283071436545261538639872000 := by
    change v604*v604 = _
    rw [h604]
    ring
  have h612 : v612 = value^89202980794122492566142873090523077279744000 := by
    change v608*v608 = _
    rw [h608]
    ring
  have h616 : v616 = value^178405961588244985132285746181046154559488000 := by
    change v612*v612 = _
    rw [h612]
    ring
  have h620 : v620 = value^356811923176489970264571492362092309118976000 := by
    change v616*v616 = _
    rw [h616]
    ring
  have h624 : v624 = value^713623846352979940529142984724184618237952000 := by
    change v620*v620 = _
    rw [h620]
    ring
  have h628 : v628 = value^1427247692705959881058285969448369236475904000 := by
    change v624*v624 = _
    rw [h624]
    ring
  have h632 : v632 = value^2854495385411919762116571938896738472951808000 := by
    change v628*v628 = _
    rw [h628]
    ring
  have h636 : v636 = value^5708990770823839524233143877793476945903616000 := by
    change v632*v632 = _
    rw [h632]
    ring
  have h640 : v640 = value^11417981541647679048466287755586953891807232000 := by
    change v636*v636 = _
    rw [h636]
    ring
  have h644 : v644 = value^22835963083295358096932575511173907783614464000 := by
    change v640*v640 = _
    rw [h640]
    ring
  have h648 : v648 = value^45671926166590716193865151022347815567228928000 := by
    change v644*v644 = _
    rw [h644]
    ring
  have h652 : v652 = value^91343852333181432387730302044695631134457856000 := by
    change v648*v648 = _
    rw [h648]
    ring
  have h656 : v656 = value^182687704666362864775460604089391262268915712000 := by
    change v652*v652 = _
    rw [h652]
    ring
  have h660 : v660 = value^365375409332725729550921208178782524537831424000 := by
    change v656*v656 = _
    rw [h656]
    ring
  have h664 : v664 = value^730750818665451459101842416357565049075662848000 := by
    change v660*v660 = _
    rw [h660]
    ring
  have h668 : v668 = value^1461501637330902918203684832715130098151325696000 := by
    change v664*v664 = _
    rw [h664]
    ring
  have h672 : v672 = value^2923003274661805836407369665430260196302651392000 := by
    change v668*v668 = _
    rw [h668]
    ring
  have h676 : v676 = value^5846006549323611672814739330860520392605302784000 := by
    change v672*v672 = _
    rw [h672]
    ring
  have h680 : v680 = value^11692013098647223345629478661721040785210605568000 := by
    change v676*v676 = _
    rw [h676]
    ring
  have h684 : v684 = value^23384026197294446691258957323442081570421211136000 := by
    change v680*v680 = _
    rw [h680]
    ring
  have h688 : v688 = value^46768052394588893382517914646884163140842422272000 := by
    change v684*v684 = _
    rw [h684]
    ring
  have h692 : v692 = value^93536104789177786765035829293768326281684844544000 := by
    change v688*v688 = _
    rw [h688]
    ring
  have h696 : v696 = value^187072209578355573530071658587536652563369689088000 := by
    change v692*v692 = _
    rw [h692]
    ring
  have h700 : v700 = value^374144419156711147060143317175073305126739378176000 := by
    change v696*v696 = _
    rw [h696]
    ring
  have h704 : v704 = value^748288838313422294120286634350146610253478756352000 := by
    change v700*v700 = _
    rw [h700]
    ring
  have h708 : v708 = value^1496577676626844588240573268700293220506957512704000 := by
    change v704*v704 = _
    rw [h704]
    ring
  have h712 : v712 = value^2993155353253689176481146537400586441013915025408000 := by
    change v708*v708 = _
    rw [h708]
    ring
  have h716 : v716 = value^5986310706507378352962293074801172882027830050816000 := by
    change v712*v712 = _
    rw [h712]
    ring
  have h720 : v720 = value^11972621413014756705924586149602345764055660101632000 := by
    change v716*v716 = _
    rw [h716]
    ring
  have h724 : v724 = value^23945242826029513411849172299204691528111320203264000 := by
    change v720*v720 = _
    rw [h720]
    ring
  have h728 : v728 = value^47890485652059026823698344598409383056222640406528000 := by
    change v724*v724 = _
    rw [h724]
    ring
  have h732 : v732 = value^95780971304118053647396689196818766112445280813056000 := by
    change v728*v728 = _
    rw [h728]
    ring
  have h736 : v736 = value^191561942608236107294793378393637532224890561626112000 := by
    change v732*v732 = _
    rw [h732]
    ring
  have h740 : v740 = value^383123885216472214589586756787275064449781123252224000 := by
    change v736*v736 = _
    rw [h736]
    ring
  have h744 : v744 = value^766247770432944429179173513574550128899562246504448000 := by
    change v740*v740 = _
    rw [h740]
    ring
  have h748 : v748 = value^1532495540865888858358347027149100257799124493008896000 := by
    change v744*v744 = _
    rw [h744]
    ring
  have h752 : v752 = value^3064991081731777716716694054298200515598248986017792000 := by
    change v748*v748 = _
    rw [h748]
    ring
  have h756 : v756 = value^6129982163463555433433388108596401031196497972035584000 := by
    change v752*v752 = _
    rw [h752]
    ring
  have h760 : v760 = value^12259964326927110866866776217192802062392995944071168000 := by
    change v756*v756 = _
    rw [h756]
    ring
  have h764 : v764 = value^24519928653854221733733552434385604124785991888142336000 := by
    change v760*v760 = _
    rw [h760]
    ring
  have h768 : v768 = value^49039857307708443467467104868771208249571983776284672000 := by
    change v764*v764 = _
    rw [h764]
    ring
  have h772 : v772 = value^98079714615416886934934209737542416499143967552569344000 := by
    change v768*v768 = _
    rw [h768]
    ring
  have h776 : v776 = value^196159429230833773869868419475084832998287935105138688000 := by
    change v772*v772 = _
    rw [h772]
    ring
  have h780 : v780 = value^392318858461667547739736838950169665996575870210277376000 := by
    change v776*v776 = _
    rw [h776]
    ring
  have h784 : v784 = value^784637716923335095479473677900339331993151740420554752000 := by
    change v780*v780 = _
    rw [h780]
    ring
  have h788 : v788 = value^1569275433846670190958947355800678663986303480841109504000 := by
    change v784*v784 = _
    rw [h784]
    ring
  have h792 : v792 = value^3138550867693340381917894711601357327972606961682219008000 := by
    change v788*v788 = _
    rw [h788]
    ring
  have h796 : v796 = value^6277101735386680763835789423202714655945213923364438016000 := by
    change v792*v792 = _
    rw [h792]
    ring
  have h800 : v800 = value^12554203470773361527671578846405429311890427846728876032000 := by
    change v796*v796 = _
    rw [h796]
    ring
  have h804 : v804 = value^25108406941546723055343157692810858623780855693457752064000 := by
    change v800*v800 = _
    rw [h800]
    ring
  have h808 : v808 = value^50216813883093446110686315385621717247561711386915504128000 := by
    change v804*v804 = _
    rw [h804]
    ring
  have h812 : v812 = value^100433627766186892221372630771243434495123422773831008256000 := by
    change v808*v808 = _
    rw [h808]
    ring
  have h816 : v816 = value^200867255532373784442745261542486868990246845547662016512000 := by
    change v812*v812 = _
    rw [h812]
    ring
  have h820 : v820 = value^401734511064747568885490523084973737980493691095324033024000 := by
    change v816*v816 = _
    rw [h816]
    ring
  have h824 : v824 = value^803469022129495137770981046169947475960987382190648066048000 := by
    change v820*v820 = _
    rw [h820]
    ring
  have h828 : v828 = value^1606938044258990275541962092339894951921974764381296132096000 := by
    change v824*v824 = _
    rw [h824]
    ring
  have h832 : v832 = value^1606938044258990275541962092341162602522202993782792835301375 := by
    change v828*v428 = _
    rw [h828, h428]
    ring
  have h836 : v836 = value^3213876088517980551083924184682325205044405987565585670602750 := by
    change v832*v832 = _
    rw [h832]
    ring
  have h840 : v840 = value^6427752177035961102167848369364650410088811975131171341205500 := by
    change v836*v836 = _
    rw [h836]
    ring
  have h844 : v844 = value^12855504354071922204335696738729300820177623950262342682411000 := by
    change v840*v840 = _
    rw [h840]
    ring
  have h848 : v848 = value^25711008708143844408671393477458601640355247900524685364822000 := by
    change v844*v844 = _
    rw [h844]
    ring
  have h852 : v852 = value^51422017416287688817342786954917203280710495801049370729644000 := by
    change v848*v848 = _
    rw [h848]
    ring
  have h856 : v856 = value^102844034832575377634685573909834406561420991602098741459288000 := by
    change v852*v852 = _
    rw [h852]
    ring
  have h860 : v860 = value^205688069665150755269371147819668813122841983204197482918576000 := by
    change v856*v856 = _
    rw [h856]
    ring
  have h864 : v864 = value^411376139330301510538742295639337626245683966408394965837152000 := by
    change v860*v860 = _
    rw [h860]
    ring
  have h868 : v868 = value^822752278660603021077484591278675252491367932816789931674304000 := by
    change v864*v864 = _
    rw [h864]
    ring
  have h872 : v872 = value^1645504557321206042154969182557350504982735865633579863348608000 := by
    change v868*v868 = _
    rw [h868]
    ring
  have h876 : v876 = value^3291009114642412084309938365114701009965471731267159726697216000 := by
    change v872*v872 = _
    rw [h872]
    ring
  have h880 : v880 = value^6582018229284824168619876730229402019930943462534319453394432000 := by
    change v876*v876 = _
    rw [h876]
    ring
  have h884 : v884 = value^13164036458569648337239753460458804039861886925068638906788864000 := by
    change v880*v880 = _
    rw [h880]
    ring
  have h888 : v888 = value^26328072917139296674479506920917608079723773850137277813577728000 := by
    change v884*v884 = _
    rw [h884]
    ring
  have h892 : v892 = value^52656145834278593348959013841835216159447547700274555627155456000 := by
    change v888*v888 = _
    rw [h888]
    ring
  have h896 : v896 = value^105312291668557186697918027683670432318895095400549111254310912000 := by
    change v892*v892 = _
    rw [h892]
    ring
  have h900 : v900 = value^210624583337114373395836055367340864637790190801098222508621824000 := by
    change v896*v896 = _
    rw [h896]
    ring
  have h904 : v904 = value^421249166674228746791672110734681729275580381602196445017243648000 := by
    change v900*v900 = _
    rw [h900]
    ring
  have h908 : v908 = value^842498333348457493583344221469363458551160763204392890034487296000 := by
    change v904*v904 = _
    rw [h904]
    ring
  have h912 : v912 = value^1684996666696914987166688442938726917102321526408785780068974592000 := by
    change v908*v908 = _
    rw [h908]
    ring
  have h916 : v916 = value^3369993333393829974333376885877453834204643052817571560137949184000 := by
    change v912*v912 = _
    rw [h912]
    ring
  have h920 : v920 = value^6739986666787659948666753771754907668409286105635143120275898368000 := by
    change v916*v916 = _
    rw [h916]
    ring
  have h924 : v924 = value^13479973333575319897333507543509815336818572211270286240551796736000 := by
    change v920*v920 = _
    rw [h920]
    ring
  have h928 : v928 = value^26959946667150639794667015087019630673637144422540572481103593472000 := by
    change v924*v924 = _
    rw [h924]
    ring
  have h932 : v932 = value^53919893334301279589334030174039261347274288845081144962207186944000 := by
    change v928*v928 = _
    rw [h928]
    ring
  have h936 : v936 = value^107839786668602559178668060348078522694548577690162289924414373888000 := by
    change v932*v932 = _
    rw [h932]
    ring
  have h940 : v940 = value^215679573337205118357336120696157045389097155380324579848828747776000 := by
    change v936*v936 = _
    rw [h936]
    ring
  have h944 : v944 = value^431359146674410236714672241392314090778194310760649159697657495552000 := by
    change v940*v940 = _
    rw [h940]
    ring
  have h948 : v948 = value^862718293348820473429344482784628181556388621521298319395314991104000 := by
    change v944*v944 = _
    rw [h944]
    ring
  have h952 : v952 = value^1725436586697640946858688965569256363112777243042596638790629982208000 := by
    change v948*v948 = _
    rw [h948]
    ring
  have h956 : v956 = value^3450873173395281893717377931138512726225554486085193277581259964416000 := by
    change v952*v952 = _
    rw [h952]
    ring
  have h960 : v960 = value^6901746346790563787434755862277025452451108972170386555162519928832000 := by
    change v956*v956 = _
    rw [h956]
    ring
  have h964 : v964 = value^13803492693581127574869511724554050904902217944340773110325039857664000 := by
    change v960*v960 = _
    rw [h960]
    ring
  have h968 : v968 = value^27606985387162255149739023449108101809804435888681546220650079715328000 := by
    change v964*v964 = _
    rw [h964]
    ring
  have h972 : v972 = value^55213970774324510299478046898216203619608871777363092441300159430656000 := by
    change v968*v968 = _
    rw [h968]
    ring
  have h976 : v976 = value^110427941548649020598956093796432407239217743554726184882600318861312000 := by
    change v972*v972 = _
    rw [h972]
    ring
  have h980 : v980 = value^220855883097298041197912187592864814478435487109452369765200637722624000 := by
    change v976*v976 = _
    rw [h976]
    ring
  have h984 : v984 = value^441711766194596082395824375185729628956870974218904739530401275445248000 := by
    change v980*v980 = _
    rw [h980]
    ring
  have h988 : v988 = value^883423532389192164791648750371459257913741948437809479060802550890496000 := by
    change v984*v984 = _
    rw [h984]
    ring
  have h992 : v992 = value^1766847064778384329583297500742918515827483896875618958121605101780992000 := by
    change v988*v988 = _
    rw [h988]
    ring
  have h996 : v996 = value^3533694129556768659166595001485837031654967793751237916243210203561984000 := by
    change v992*v992 = _
    rw [h992]
    ring
  have h1000 : v1000 = value^7067388259113537318333190002971674063309935587502475832486420407123968000 := by
    change v996*v996 = _
    rw [h996]
    ring
  have h1004 : v1004 = value^14134776518227074636666380005943348126619871175004951664972840814247936000 := by
    change v1000*v1000 = _
    rw [h1000]
    ring
  have h1008 : v1008 = value^28269553036454149273332760011886696253239742350009903329945681628495872000 := by
    change v1004*v1004 = _
    rw [h1004]
    ring
  have h1012 : v1012 = value^56539106072908298546665520023773392506479484700019806659891363256991744000 := by
    change v1008*v1008 = _
    rw [h1008]
    ring
  have h1016 : v1016 = value^113078212145816597093331040047546785012958969400039613319782726513983488000 := by
    change v1012*v1012 = _
    rw [h1012]
    ring
  have h1020 : v1020 = value^226156424291633194186662080095093570025917938800079226639565453027966976000 := by
    change v1016*v1016 = _
    rw [h1016]
    ring
  have h1024 : v1024 = value^452312848583266388373324160190187140051835877600158453279130906055933952000 := by
    change v1020*v1020 = _
    rw [h1020]
    ring
  have h1028 : v1028 = value^904625697166532776746648320380374280103671755200316906558261812111867904000 := by
    change v1024*v1024 = _
    rw [h1024]
    ring
  have h1032 : v1032 = value^1809251394333065553493296640760748560207343510400633813116523624223735808000 := by
    change v1028*v1028 = _
    rw [h1028]
    ring
  have h1036 : v1036 = value^1809251394333065553493296640760748560207343510400633813116524750123642650623 := by
    change v1032*v224 = _
    rw [h1032, h224]
    ring
  have h1040 : v1040 = value^3618502788666131106986593281521497120414687020801267626233049500247285301246 := by
    change v1036*v1036 = _
    rw [h1036]
    ring
  have h1044 : v1044 = value^7237005577332262213973186563042994240829374041602535252466099000494570602492 := by
    change v1040*v1040 = _
    rw [h1040]
    ring
  have h1048 : v1048 = value^7237005577332262213973186563042994240829374041602535252466099000494570602493 := by
    change v1044*value = _
    rw [h1044]
    ring
  have h1052 : v1052 = value^7237005577332262213973186563042994240829374041602535252466099000494570602494 := by
    change v1048*value = _
    rw [h1048]
    ring
  have h1056 : v1056 = value^14474011154664524427946373126085988481658748083205070504932198000989141204988 := by
    change v1052*v1052 = _
    rw [h1052]
    ring
  change [v1052, v1056-value, v1056+value, v1056-(19681161376707505956807079304988542015446066515923890162744021073123829784752:Fp)*value, v1056+(19681161376707505956807079304988542015446066515923890162744021073123829784752:Fp)*value] = _
  rw [h1052, h1056]
  rfl

theorem cairo_finish_power (e wp w sign : Fp) :
    cairo_finish e wp w sign = [(cairo_miller_input e wp w sign)^(2^253-5)] := by
  unfold cairo_finish
  extract_lets v16 v20 v24 v28 v32 v36 v40 v44 v48 v52 v56 v60 v64 v68 v72 v76 v80 v84 v88 v92 v96 v100 v104 v108 v112 v116 v120 v124 v128 v132 v136 v140 v144 v148 v152 v156 v160 v164 v168 v172 v176 v180 v184 v188 v192 v196 v200 v204 v208 v212 v216 v220 v224 v228 v232 v236 v240 v244 v248 v252 v256 v260 v264 v268 v272 v276 v280 v284 v288 v292 v296 v300 v304 v308 v312 v316 v320 v324 v328 v332 v336 v340 v344 v348 v352 v356 v360 v364 v368 v372 v376 v380 v384 v388 v392 v396 v400 v404 v408 v412 v416 v420 v424 v428 v432 v436 v440 v444 v448 v452 v456 v460 v464 v468 v472 v476 v480 v484 v488 v492 v496 v500 v504 v508 v512 v516 v520 v524 v528 v532 v536 v540 v544 v548 v552 v556 v560 v564 v568 v572 v576 v580 v584 v588 v592 v596 v600 v604 v608 v612 v616 v620 v624 v628 v632 v636 v640 v644 v648 v652 v656 v660 v664 v668 v672 v676 v680 v684 v688 v692 v696 v700 v704 v708 v712 v716 v720 v724 v728 v732 v736 v740 v744 v748 v752 v756 v760 v764 v768 v772 v776 v780 v784 v788 v792 v796 v800 v804 v808 v812 v816 v820 v824 v828 v832 v836 v840 v844 v848 v852 v856 v860 v864 v868 v872 v876 v880 v884 v888 v892 v896 v900 v904 v908 v912 v916 v920 v924 v928 v932 v936 v940 v944 v948 v952 v956 v960 v964 v968 v972 v976 v980 v984 v988 v992 v996 v1000 v1004 v1008 v1012 v1016 v1020 v1024 v1028 v1032 v1036 v1040 v1044 v1048 v1052 v1056 v1060 v1064 v1068 v1072 v1076 v1080 v1084 v1088 v1092 v1096 v1100 v1104 v1108 v1112 v1116 v1120 v1124 v1128
  have miller_input : v72 = cairo_miller_input e wp w sign := rfl
  clear_value v72
  have h76 : v76 = v72^2 := by
    change v72*v72 = _
    ring
  have h80 : v80 = v72^4 := by
    change v76*v76 = _
    rw [h76]
    ring
  have h84 : v84 = v72^8 := by
    change v80*v80 = _
    rw [h80]
    ring
  have h88 : v88 = v72^9 := by
    change v84*v72 = _
    rw [h84]
    ring
  have h92 : v92 = v72^11 := by
    change v88*v76 = _
    rw [h88, h76]
    ring
  have h96 : v96 = v72^22 := by
    change v92*v92 = _
    rw [h92]
    ring
  have h100 : v100 = v72^31 := by
    change v96*v88 = _
    rw [h96, h88]
    ring
  have h104 : v104 = v72^62 := by
    change v100*v100 = _
    rw [h100]
    ring
  have h108 : v108 = v72^124 := by
    change v104*v104 = _
    rw [h104]
    ring
  have h112 : v112 = v72^248 := by
    change v108*v108 = _
    rw [h108]
    ring
  have h116 : v116 = v72^496 := by
    change v112*v112 = _
    rw [h112]
    ring
  have h120 : v120 = v72^992 := by
    change v116*v116 = _
    rw [h116]
    ring
  have h124 : v124 = v72^1023 := by
    change v120*v100 = _
    rw [h120, h100]
    ring
  have h128 : v128 = v72^2046 := by
    change v124*v124 = _
    rw [h124]
    ring
  have h132 : v132 = v72^4092 := by
    change v128*v128 = _
    rw [h128]
    ring
  have h136 : v136 = v72^8184 := by
    change v132*v132 = _
    rw [h132]
    ring
  have h140 : v140 = v72^16368 := by
    change v136*v136 = _
    rw [h136]
    ring
  have h144 : v144 = v72^32736 := by
    change v140*v140 = _
    rw [h140]
    ring
  have h148 : v148 = v72^65472 := by
    change v144*v144 = _
    rw [h144]
    ring
  have h152 : v152 = v72^130944 := by
    change v148*v148 = _
    rw [h148]
    ring
  have h156 : v156 = v72^261888 := by
    change v152*v152 = _
    rw [h152]
    ring
  have h160 : v160 = v72^523776 := by
    change v156*v156 = _
    rw [h156]
    ring
  have h164 : v164 = v72^1047552 := by
    change v160*v160 = _
    rw [h160]
    ring
  have h168 : v168 = v72^1048575 := by
    change v164*v124 = _
    rw [h164, h124]
    ring
  have h172 : v172 = v72^2097150 := by
    change v168*v168 = _
    rw [h168]
    ring
  have h176 : v176 = v72^4194300 := by
    change v172*v172 = _
    rw [h172]
    ring
  have h180 : v180 = v72^8388600 := by
    change v176*v176 = _
    rw [h176]
    ring
  have h184 : v184 = v72^16777200 := by
    change v180*v180 = _
    rw [h180]
    ring
  have h188 : v188 = v72^33554400 := by
    change v184*v184 = _
    rw [h184]
    ring
  have h192 : v192 = v72^67108800 := by
    change v188*v188 = _
    rw [h188]
    ring
  have h196 : v196 = v72^134217600 := by
    change v192*v192 = _
    rw [h192]
    ring
  have h200 : v200 = v72^268435200 := by
    change v196*v196 = _
    rw [h196]
    ring
  have h204 : v204 = v72^536870400 := by
    change v200*v200 = _
    rw [h200]
    ring
  have h208 : v208 = v72^1073740800 := by
    change v204*v204 = _
    rw [h204]
    ring
  have h212 : v212 = v72^2147481600 := by
    change v208*v208 = _
    rw [h208]
    ring
  have h216 : v216 = v72^4294963200 := by
    change v212*v212 = _
    rw [h212]
    ring
  have h220 : v220 = v72^8589926400 := by
    change v216*v216 = _
    rw [h216]
    ring
  have h224 : v224 = v72^17179852800 := by
    change v220*v220 = _
    rw [h220]
    ring
  have h228 : v228 = v72^34359705600 := by
    change v224*v224 = _
    rw [h224]
    ring
  have h232 : v232 = v72^68719411200 := by
    change v228*v228 = _
    rw [h228]
    ring
  have h236 : v236 = v72^137438822400 := by
    change v232*v232 = _
    rw [h232]
    ring
  have h240 : v240 = v72^274877644800 := by
    change v236*v236 = _
    rw [h236]
    ring
  have h244 : v244 = v72^549755289600 := by
    change v240*v240 = _
    rw [h240]
    ring
  have h248 : v248 = v72^1099510579200 := by
    change v244*v244 = _
    rw [h244]
    ring
  have h252 : v252 = v72^1099511627775 := by
    change v248*v168 = _
    rw [h248, h168]
    ring
  have h256 : v256 = v72^2199023255550 := by
    change v252*v252 = _
    rw [h252]
    ring
  have h260 : v260 = v72^4398046511100 := by
    change v256*v256 = _
    rw [h256]
    ring
  have h264 : v264 = v72^8796093022200 := by
    change v260*v260 = _
    rw [h260]
    ring
  have h268 : v268 = v72^17592186044400 := by
    change v264*v264 = _
    rw [h264]
    ring
  have h272 : v272 = v72^35184372088800 := by
    change v268*v268 = _
    rw [h268]
    ring
  have h276 : v276 = v72^70368744177600 := by
    change v272*v272 = _
    rw [h272]
    ring
  have h280 : v280 = v72^140737488355200 := by
    change v276*v276 = _
    rw [h276]
    ring
  have h284 : v284 = v72^281474976710400 := by
    change v280*v280 = _
    rw [h280]
    ring
  have h288 : v288 = v72^562949953420800 := by
    change v284*v284 = _
    rw [h284]
    ring
  have h292 : v292 = v72^1125899906841600 := by
    change v288*v288 = _
    rw [h288]
    ring
  have h296 : v296 = v72^1125899906842623 := by
    change v292*v124 = _
    rw [h292, h124]
    ring
  have h300 : v300 = v72^2251799813685246 := by
    change v296*v296 = _
    rw [h296]
    ring
  have h304 : v304 = v72^4503599627370492 := by
    change v300*v300 = _
    rw [h300]
    ring
  have h308 : v308 = v72^9007199254740984 := by
    change v304*v304 = _
    rw [h304]
    ring
  have h312 : v312 = v72^18014398509481968 := by
    change v308*v308 = _
    rw [h308]
    ring
  have h316 : v316 = v72^36028797018963936 := by
    change v312*v312 = _
    rw [h312]
    ring
  have h320 : v320 = v72^72057594037927872 := by
    change v316*v316 = _
    rw [h316]
    ring
  have h324 : v324 = v72^144115188075855744 := by
    change v320*v320 = _
    rw [h320]
    ring
  have h328 : v328 = v72^288230376151711488 := by
    change v324*v324 = _
    rw [h324]
    ring
  have h332 : v332 = v72^576460752303422976 := by
    change v328*v328 = _
    rw [h328]
    ring
  have h336 : v336 = v72^1152921504606845952 := by
    change v332*v332 = _
    rw [h332]
    ring
  have h340 : v340 = v72^2305843009213691904 := by
    change v336*v336 = _
    rw [h336]
    ring
  have h344 : v344 = v72^4611686018427383808 := by
    change v340*v340 = _
    rw [h340]
    ring
  have h348 : v348 = v72^9223372036854767616 := by
    change v344*v344 = _
    rw [h344]
    ring
  have h352 : v352 = v72^18446744073709535232 := by
    change v348*v348 = _
    rw [h348]
    ring
  have h356 : v356 = v72^36893488147419070464 := by
    change v352*v352 = _
    rw [h352]
    ring
  have h360 : v360 = v72^73786976294838140928 := by
    change v356*v356 = _
    rw [h356]
    ring
  have h364 : v364 = v72^147573952589676281856 := by
    change v360*v360 = _
    rw [h360]
    ring
  have h368 : v368 = v72^295147905179352563712 := by
    change v364*v364 = _
    rw [h364]
    ring
  have h372 : v372 = v72^590295810358705127424 := by
    change v368*v368 = _
    rw [h368]
    ring
  have h376 : v376 = v72^1180591620717410254848 := by
    change v372*v372 = _
    rw [h372]
    ring
  have h380 : v380 = v72^2361183241434820509696 := by
    change v376*v376 = _
    rw [h376]
    ring
  have h384 : v384 = v72^4722366482869641019392 := by
    change v380*v380 = _
    rw [h380]
    ring
  have h388 : v388 = v72^9444732965739282038784 := by
    change v384*v384 = _
    rw [h384]
    ring
  have h392 : v392 = v72^18889465931478564077568 := by
    change v388*v388 = _
    rw [h388]
    ring
  have h396 : v396 = v72^37778931862957128155136 := by
    change v392*v392 = _
    rw [h392]
    ring
  have h400 : v400 = v72^75557863725914256310272 := by
    change v396*v396 = _
    rw [h396]
    ring
  have h404 : v404 = v72^151115727451828512620544 := by
    change v400*v400 = _
    rw [h400]
    ring
  have h408 : v408 = v72^302231454903657025241088 := by
    change v404*v404 = _
    rw [h404]
    ring
  have h412 : v412 = v72^604462909807314050482176 := by
    change v408*v408 = _
    rw [h408]
    ring
  have h416 : v416 = v72^1208925819614628100964352 := by
    change v412*v412 = _
    rw [h412]
    ring
  have h420 : v420 = v72^2417851639229256201928704 := by
    change v416*v416 = _
    rw [h416]
    ring
  have h424 : v424 = v72^4835703278458512403857408 := by
    change v420*v420 = _
    rw [h420]
    ring
  have h428 : v428 = v72^9671406556917024807714816 := by
    change v424*v424 = _
    rw [h424]
    ring
  have h432 : v432 = v72^19342813113834049615429632 := by
    change v428*v428 = _
    rw [h428]
    ring
  have h436 : v436 = v72^38685626227668099230859264 := by
    change v432*v432 = _
    rw [h432]
    ring
  have h440 : v440 = v72^77371252455336198461718528 := by
    change v436*v436 = _
    rw [h436]
    ring
  have h444 : v444 = v72^154742504910672396923437056 := by
    change v440*v440 = _
    rw [h440]
    ring
  have h448 : v448 = v72^309485009821344793846874112 := by
    change v444*v444 = _
    rw [h444]
    ring
  have h452 : v452 = v72^618970019642689587693748224 := by
    change v448*v448 = _
    rw [h448]
    ring
  have h456 : v456 = v72^1237940039285379175387496448 := by
    change v452*v452 = _
    rw [h452]
    ring
  have h460 : v460 = v72^2475880078570758350774992896 := by
    change v456*v456 = _
    rw [h456]
    ring
  have h464 : v464 = v72^4951760157141516701549985792 := by
    change v460*v460 = _
    rw [h460]
    ring
  have h468 : v468 = v72^9903520314283033403099971584 := by
    change v464*v464 = _
    rw [h464]
    ring
  have h472 : v472 = v72^19807040628566066806199943168 := by
    change v468*v468 = _
    rw [h468]
    ring
  have h476 : v476 = v72^39614081257132133612399886336 := by
    change v472*v472 = _
    rw [h472]
    ring
  have h480 : v480 = v72^79228162514264267224799772672 := by
    change v476*v476 = _
    rw [h476]
    ring
  have h484 : v484 = v72^158456325028528534449599545344 := by
    change v480*v480 = _
    rw [h480]
    ring
  have h488 : v488 = v72^316912650057057068899199090688 := by
    change v484*v484 = _
    rw [h484]
    ring
  have h492 : v492 = v72^633825300114114137798398181376 := by
    change v488*v488 = _
    rw [h488]
    ring
  have h496 : v496 = v72^1267650600228228275596796362752 := by
    change v492*v492 = _
    rw [h492]
    ring
  have h500 : v500 = v72^1267650600228229401496703205375 := by
    change v496*v296 = _
    rw [h496, h296]
    ring
  have h504 : v504 = v72^2535301200456458802993406410750 := by
    change v500*v500 = _
    rw [h500]
    ring
  have h508 : v508 = v72^5070602400912917605986812821500 := by
    change v504*v504 = _
    rw [h504]
    ring
  have h512 : v512 = v72^10141204801825835211973625643000 := by
    change v508*v508 = _
    rw [h508]
    ring
  have h516 : v516 = v72^20282409603651670423947251286000 := by
    change v512*v512 = _
    rw [h512]
    ring
  have h520 : v520 = v72^40564819207303340847894502572000 := by
    change v516*v516 = _
    rw [h516]
    ring
  have h524 : v524 = v72^81129638414606681695789005144000 := by
    change v520*v520 = _
    rw [h520]
    ring
  have h528 : v528 = v72^162259276829213363391578010288000 := by
    change v524*v524 = _
    rw [h524]
    ring
  have h532 : v532 = v72^324518553658426726783156020576000 := by
    change v528*v528 = _
    rw [h528]
    ring
  have h536 : v536 = v72^649037107316853453566312041152000 := by
    change v532*v532 = _
    rw [h532]
    ring
  have h540 : v540 = v72^1298074214633706907132624082304000 := by
    change v536*v536 = _
    rw [h536]
    ring
  have h544 : v544 = v72^2596148429267413814265248164608000 := by
    change v540*v540 = _
    rw [h540]
    ring
  have h548 : v548 = v72^5192296858534827628530496329216000 := by
    change v544*v544 = _
    rw [h544]
    ring
  have h552 : v552 = v72^10384593717069655257060992658432000 := by
    change v548*v548 = _
    rw [h548]
    ring
  have h556 : v556 = v72^20769187434139310514121985316864000 := by
    change v552*v552 = _
    rw [h552]
    ring
  have h560 : v560 = v72^41538374868278621028243970633728000 := by
    change v556*v556 = _
    rw [h556]
    ring
  have h564 : v564 = v72^83076749736557242056487941267456000 := by
    change v560*v560 = _
    rw [h560]
    ring
  have h568 : v568 = v72^166153499473114484112975882534912000 := by
    change v564*v564 = _
    rw [h564]
    ring
  have h572 : v572 = v72^332306998946228968225951765069824000 := by
    change v568*v568 = _
    rw [h568]
    ring
  have h576 : v576 = v72^664613997892457936451903530139648000 := by
    change v572*v572 = _
    rw [h572]
    ring
  have h580 : v580 = v72^1329227995784915872903807060279296000 := by
    change v576*v576 = _
    rw [h576]
    ring
  have h584 : v584 = v72^2658455991569831745807614120558592000 := by
    change v580*v580 = _
    rw [h580]
    ring
  have h588 : v588 = v72^5316911983139663491615228241117184000 := by
    change v584*v584 = _
    rw [h584]
    ring
  have h592 : v592 = v72^10633823966279326983230456482234368000 := by
    change v588*v588 = _
    rw [h588]
    ring
  have h596 : v596 = v72^21267647932558653966460912964468736000 := by
    change v592*v592 = _
    rw [h592]
    ring
  have h600 : v600 = v72^42535295865117307932921825928937472000 := by
    change v596*v596 = _
    rw [h596]
    ring
  have h604 : v604 = v72^85070591730234615865843651857874944000 := by
    change v600*v600 = _
    rw [h600]
    ring
  have h608 : v608 = v72^170141183460469231731687303715749888000 := by
    change v604*v604 = _
    rw [h604]
    ring
  have h612 : v612 = v72^340282366920938463463374607431499776000 := by
    change v608*v608 = _
    rw [h608]
    ring
  have h616 : v616 = v72^680564733841876926926749214862999552000 := by
    change v612*v612 = _
    rw [h612]
    ring
  have h620 : v620 = v72^1361129467683753853853498429725999104000 := by
    change v616*v616 = _
    rw [h616]
    ring
  have h624 : v624 = v72^2722258935367507707706996859451998208000 := by
    change v620*v620 = _
    rw [h620]
    ring
  have h628 : v628 = v72^5444517870735015415413993718903996416000 := by
    change v624*v624 = _
    rw [h624]
    ring
  have h632 : v632 = v72^10889035741470030830827987437807992832000 := by
    change v628*v628 = _
    rw [h628]
    ring
  have h636 : v636 = v72^21778071482940061661655974875615985664000 := by
    change v632*v632 = _
    rw [h632]
    ring
  have h640 : v640 = v72^43556142965880123323311949751231971328000 := by
    change v636*v636 = _
    rw [h636]
    ring
  have h644 : v644 = v72^87112285931760246646623899502463942656000 := by
    change v640*v640 = _
    rw [h640]
    ring
  have h648 : v648 = v72^174224571863520493293247799004927885312000 := by
    change v644*v644 = _
    rw [h644]
    ring
  have h652 : v652 = v72^348449143727040986586495598009855770624000 := by
    change v648*v648 = _
    rw [h648]
    ring
  have h656 : v656 = v72^696898287454081973172991196019711541248000 := by
    change v652*v652 = _
    rw [h652]
    ring
  have h660 : v660 = v72^1393796574908163946345982392039423082496000 := by
    change v656*v656 = _
    rw [h656]
    ring
  have h664 : v664 = v72^2787593149816327892691964784078846164992000 := by
    change v660*v660 = _
    rw [h660]
    ring
  have h668 : v668 = v72^5575186299632655785383929568157692329984000 := by
    change v664*v664 = _
    rw [h664]
    ring
  have h672 : v672 = v72^11150372599265311570767859136315384659968000 := by
    change v668*v668 = _
    rw [h668]
    ring
  have h676 : v676 = v72^22300745198530623141535718272630769319936000 := by
    change v672*v672 = _
    rw [h672]
    ring
  have h680 : v680 = v72^44601490397061246283071436545261538639872000 := by
    change v676*v676 = _
    rw [h676]
    ring
  have h684 : v684 = v72^89202980794122492566142873090523077279744000 := by
    change v680*v680 = _
    rw [h680]
    ring
  have h688 : v688 = v72^178405961588244985132285746181046154559488000 := by
    change v684*v684 = _
    rw [h684]
    ring
  have h692 : v692 = v72^356811923176489970264571492362092309118976000 := by
    change v688*v688 = _
    rw [h688]
    ring
  have h696 : v696 = v72^713623846352979940529142984724184618237952000 := by
    change v692*v692 = _
    rw [h692]
    ring
  have h700 : v700 = v72^1427247692705959881058285969448369236475904000 := by
    change v696*v696 = _
    rw [h696]
    ring
  have h704 : v704 = v72^2854495385411919762116571938896738472951808000 := by
    change v700*v700 = _
    rw [h700]
    ring
  have h708 : v708 = v72^5708990770823839524233143877793476945903616000 := by
    change v704*v704 = _
    rw [h704]
    ring
  have h712 : v712 = v72^11417981541647679048466287755586953891807232000 := by
    change v708*v708 = _
    rw [h708]
    ring
  have h716 : v716 = v72^22835963083295358096932575511173907783614464000 := by
    change v712*v712 = _
    rw [h712]
    ring
  have h720 : v720 = v72^45671926166590716193865151022347815567228928000 := by
    change v716*v716 = _
    rw [h716]
    ring
  have h724 : v724 = v72^91343852333181432387730302044695631134457856000 := by
    change v720*v720 = _
    rw [h720]
    ring
  have h728 : v728 = v72^182687704666362864775460604089391262268915712000 := by
    change v724*v724 = _
    rw [h724]
    ring
  have h732 : v732 = v72^365375409332725729550921208178782524537831424000 := by
    change v728*v728 = _
    rw [h728]
    ring
  have h736 : v736 = v72^730750818665451459101842416357565049075662848000 := by
    change v732*v732 = _
    rw [h732]
    ring
  have h740 : v740 = v72^1461501637330902918203684832715130098151325696000 := by
    change v736*v736 = _
    rw [h736]
    ring
  have h744 : v744 = v72^2923003274661805836407369665430260196302651392000 := by
    change v740*v740 = _
    rw [h740]
    ring
  have h748 : v748 = v72^5846006549323611672814739330860520392605302784000 := by
    change v744*v744 = _
    rw [h744]
    ring
  have h752 : v752 = v72^11692013098647223345629478661721040785210605568000 := by
    change v748*v748 = _
    rw [h748]
    ring
  have h756 : v756 = v72^23384026197294446691258957323442081570421211136000 := by
    change v752*v752 = _
    rw [h752]
    ring
  have h760 : v760 = v72^46768052394588893382517914646884163140842422272000 := by
    change v756*v756 = _
    rw [h756]
    ring
  have h764 : v764 = v72^93536104789177786765035829293768326281684844544000 := by
    change v760*v760 = _
    rw [h760]
    ring
  have h768 : v768 = v72^187072209578355573530071658587536652563369689088000 := by
    change v764*v764 = _
    rw [h764]
    ring
  have h772 : v772 = v72^374144419156711147060143317175073305126739378176000 := by
    change v768*v768 = _
    rw [h768]
    ring
  have h776 : v776 = v72^748288838313422294120286634350146610253478756352000 := by
    change v772*v772 = _
    rw [h772]
    ring
  have h780 : v780 = v72^1496577676626844588240573268700293220506957512704000 := by
    change v776*v776 = _
    rw [h776]
    ring
  have h784 : v784 = v72^2993155353253689176481146537400586441013915025408000 := by
    change v780*v780 = _
    rw [h780]
    ring
  have h788 : v788 = v72^5986310706507378352962293074801172882027830050816000 := by
    change v784*v784 = _
    rw [h784]
    ring
  have h792 : v792 = v72^11972621413014756705924586149602345764055660101632000 := by
    change v788*v788 = _
    rw [h788]
    ring
  have h796 : v796 = v72^23945242826029513411849172299204691528111320203264000 := by
    change v792*v792 = _
    rw [h792]
    ring
  have h800 : v800 = v72^47890485652059026823698344598409383056222640406528000 := by
    change v796*v796 = _
    rw [h796]
    ring
  have h804 : v804 = v72^95780971304118053647396689196818766112445280813056000 := by
    change v800*v800 = _
    rw [h800]
    ring
  have h808 : v808 = v72^191561942608236107294793378393637532224890561626112000 := by
    change v804*v804 = _
    rw [h804]
    ring
  have h812 : v812 = v72^383123885216472214589586756787275064449781123252224000 := by
    change v808*v808 = _
    rw [h808]
    ring
  have h816 : v816 = v72^766247770432944429179173513574550128899562246504448000 := by
    change v812*v812 = _
    rw [h812]
    ring
  have h820 : v820 = v72^1532495540865888858358347027149100257799124493008896000 := by
    change v816*v816 = _
    rw [h816]
    ring
  have h824 : v824 = v72^3064991081731777716716694054298200515598248986017792000 := by
    change v820*v820 = _
    rw [h820]
    ring
  have h828 : v828 = v72^6129982163463555433433388108596401031196497972035584000 := by
    change v824*v824 = _
    rw [h824]
    ring
  have h832 : v832 = v72^12259964326927110866866776217192802062392995944071168000 := by
    change v828*v828 = _
    rw [h828]
    ring
  have h836 : v836 = v72^24519928653854221733733552434385604124785991888142336000 := by
    change v832*v832 = _
    rw [h832]
    ring
  have h840 : v840 = v72^49039857307708443467467104868771208249571983776284672000 := by
    change v836*v836 = _
    rw [h836]
    ring
  have h844 : v844 = v72^98079714615416886934934209737542416499143967552569344000 := by
    change v840*v840 = _
    rw [h840]
    ring
  have h848 : v848 = v72^196159429230833773869868419475084832998287935105138688000 := by
    change v844*v844 = _
    rw [h844]
    ring
  have h852 : v852 = v72^392318858461667547739736838950169665996575870210277376000 := by
    change v848*v848 = _
    rw [h848]
    ring
  have h856 : v856 = v72^784637716923335095479473677900339331993151740420554752000 := by
    change v852*v852 = _
    rw [h852]
    ring
  have h860 : v860 = v72^1569275433846670190958947355800678663986303480841109504000 := by
    change v856*v856 = _
    rw [h856]
    ring
  have h864 : v864 = v72^3138550867693340381917894711601357327972606961682219008000 := by
    change v860*v860 = _
    rw [h860]
    ring
  have h868 : v868 = v72^6277101735386680763835789423202714655945213923364438016000 := by
    change v864*v864 = _
    rw [h864]
    ring
  have h872 : v872 = v72^12554203470773361527671578846405429311890427846728876032000 := by
    change v868*v868 = _
    rw [h868]
    ring
  have h876 : v876 = v72^25108406941546723055343157692810858623780855693457752064000 := by
    change v872*v872 = _
    rw [h872]
    ring
  have h880 : v880 = v72^50216813883093446110686315385621717247561711386915504128000 := by
    change v876*v876 = _
    rw [h876]
    ring
  have h884 : v884 = v72^100433627766186892221372630771243434495123422773831008256000 := by
    change v880*v880 = _
    rw [h880]
    ring
  have h888 : v888 = v72^200867255532373784442745261542486868990246845547662016512000 := by
    change v884*v884 = _
    rw [h884]
    ring
  have h892 : v892 = v72^401734511064747568885490523084973737980493691095324033024000 := by
    change v888*v888 = _
    rw [h888]
    ring
  have h896 : v896 = v72^803469022129495137770981046169947475960987382190648066048000 := by
    change v892*v892 = _
    rw [h892]
    ring
  have h900 : v900 = v72^1606938044258990275541962092339894951921974764381296132096000 := by
    change v896*v896 = _
    rw [h896]
    ring
  have h904 : v904 = v72^1606938044258990275541962092341162602522202993782792835301375 := by
    change v900*v500 = _
    rw [h900, h500]
    ring
  have h908 : v908 = v72^3213876088517980551083924184682325205044405987565585670602750 := by
    change v904*v904 = _
    rw [h904]
    ring
  have h912 : v912 = v72^6427752177035961102167848369364650410088811975131171341205500 := by
    change v908*v908 = _
    rw [h908]
    ring
  have h916 : v916 = v72^12855504354071922204335696738729300820177623950262342682411000 := by
    change v912*v912 = _
    rw [h912]
    ring
  have h920 : v920 = v72^25711008708143844408671393477458601640355247900524685364822000 := by
    change v916*v916 = _
    rw [h916]
    ring
  have h924 : v924 = v72^51422017416287688817342786954917203280710495801049370729644000 := by
    change v920*v920 = _
    rw [h920]
    ring
  have h928 : v928 = v72^102844034832575377634685573909834406561420991602098741459288000 := by
    change v924*v924 = _
    rw [h924]
    ring
  have h932 : v932 = v72^205688069665150755269371147819668813122841983204197482918576000 := by
    change v928*v928 = _
    rw [h928]
    ring
  have h936 : v936 = v72^411376139330301510538742295639337626245683966408394965837152000 := by
    change v932*v932 = _
    rw [h932]
    ring
  have h940 : v940 = v72^822752278660603021077484591278675252491367932816789931674304000 := by
    change v936*v936 = _
    rw [h936]
    ring
  have h944 : v944 = v72^1645504557321206042154969182557350504982735865633579863348608000 := by
    change v940*v940 = _
    rw [h940]
    ring
  have h948 : v948 = v72^3291009114642412084309938365114701009965471731267159726697216000 := by
    change v944*v944 = _
    rw [h944]
    ring
  have h952 : v952 = v72^6582018229284824168619876730229402019930943462534319453394432000 := by
    change v948*v948 = _
    rw [h948]
    ring
  have h956 : v956 = v72^13164036458569648337239753460458804039861886925068638906788864000 := by
    change v952*v952 = _
    rw [h952]
    ring
  have h960 : v960 = v72^26328072917139296674479506920917608079723773850137277813577728000 := by
    change v956*v956 = _
    rw [h956]
    ring
  have h964 : v964 = v72^52656145834278593348959013841835216159447547700274555627155456000 := by
    change v960*v960 = _
    rw [h960]
    ring
  have h968 : v968 = v72^105312291668557186697918027683670432318895095400549111254310912000 := by
    change v964*v964 = _
    rw [h964]
    ring
  have h972 : v972 = v72^210624583337114373395836055367340864637790190801098222508621824000 := by
    change v968*v968 = _
    rw [h968]
    ring
  have h976 : v976 = v72^421249166674228746791672110734681729275580381602196445017243648000 := by
    change v972*v972 = _
    rw [h972]
    ring
  have h980 : v980 = v72^842498333348457493583344221469363458551160763204392890034487296000 := by
    change v976*v976 = _
    rw [h976]
    ring
  have h984 : v984 = v72^1684996666696914987166688442938726917102321526408785780068974592000 := by
    change v980*v980 = _
    rw [h980]
    ring
  have h988 : v988 = v72^3369993333393829974333376885877453834204643052817571560137949184000 := by
    change v984*v984 = _
    rw [h984]
    ring
  have h992 : v992 = v72^6739986666787659948666753771754907668409286105635143120275898368000 := by
    change v988*v988 = _
    rw [h988]
    ring
  have h996 : v996 = v72^13479973333575319897333507543509815336818572211270286240551796736000 := by
    change v992*v992 = _
    rw [h992]
    ring
  have h1000 : v1000 = v72^26959946667150639794667015087019630673637144422540572481103593472000 := by
    change v996*v996 = _
    rw [h996]
    ring
  have h1004 : v1004 = v72^53919893334301279589334030174039261347274288845081144962207186944000 := by
    change v1000*v1000 = _
    rw [h1000]
    ring
  have h1008 : v1008 = v72^107839786668602559178668060348078522694548577690162289924414373888000 := by
    change v1004*v1004 = _
    rw [h1004]
    ring
  have h1012 : v1012 = v72^215679573337205118357336120696157045389097155380324579848828747776000 := by
    change v1008*v1008 = _
    rw [h1008]
    ring
  have h1016 : v1016 = v72^431359146674410236714672241392314090778194310760649159697657495552000 := by
    change v1012*v1012 = _
    rw [h1012]
    ring
  have h1020 : v1020 = v72^862718293348820473429344482784628181556388621521298319395314991104000 := by
    change v1016*v1016 = _
    rw [h1016]
    ring
  have h1024 : v1024 = v72^1725436586697640946858688965569256363112777243042596638790629982208000 := by
    change v1020*v1020 = _
    rw [h1020]
    ring
  have h1028 : v1028 = v72^3450873173395281893717377931138512726225554486085193277581259964416000 := by
    change v1024*v1024 = _
    rw [h1024]
    ring
  have h1032 : v1032 = v72^6901746346790563787434755862277025452451108972170386555162519928832000 := by
    change v1028*v1028 = _
    rw [h1028]
    ring
  have h1036 : v1036 = v72^13803492693581127574869511724554050904902217944340773110325039857664000 := by
    change v1032*v1032 = _
    rw [h1032]
    ring
  have h1040 : v1040 = v72^27606985387162255149739023449108101809804435888681546220650079715328000 := by
    change v1036*v1036 = _
    rw [h1036]
    ring
  have h1044 : v1044 = v72^55213970774324510299478046898216203619608871777363092441300159430656000 := by
    change v1040*v1040 = _
    rw [h1040]
    ring
  have h1048 : v1048 = v72^110427941548649020598956093796432407239217743554726184882600318861312000 := by
    change v1044*v1044 = _
    rw [h1044]
    ring
  have h1052 : v1052 = v72^220855883097298041197912187592864814478435487109452369765200637722624000 := by
    change v1048*v1048 = _
    rw [h1048]
    ring
  have h1056 : v1056 = v72^441711766194596082395824375185729628956870974218904739530401275445248000 := by
    change v1052*v1052 = _
    rw [h1052]
    ring
  have h1060 : v1060 = v72^883423532389192164791648750371459257913741948437809479060802550890496000 := by
    change v1056*v1056 = _
    rw [h1056]
    ring
  have h1064 : v1064 = v72^1766847064778384329583297500742918515827483896875618958121605101780992000 := by
    change v1060*v1060 = _
    rw [h1060]
    ring
  have h1068 : v1068 = v72^3533694129556768659166595001485837031654967793751237916243210203561984000 := by
    change v1064*v1064 = _
    rw [h1064]
    ring
  have h1072 : v1072 = v72^7067388259113537318333190002971674063309935587502475832486420407123968000 := by
    change v1068*v1068 = _
    rw [h1068]
    ring
  have h1076 : v1076 = v72^14134776518227074636666380005943348126619871175004951664972840814247936000 := by
    change v1072*v1072 = _
    rw [h1072]
    ring
  have h1080 : v1080 = v72^28269553036454149273332760011886696253239742350009903329945681628495872000 := by
    change v1076*v1076 = _
    rw [h1076]
    ring
  have h1084 : v1084 = v72^56539106072908298546665520023773392506479484700019806659891363256991744000 := by
    change v1080*v1080 = _
    rw [h1080]
    ring
  have h1088 : v1088 = v72^113078212145816597093331040047546785012958969400039613319782726513983488000 := by
    change v1084*v1084 = _
    rw [h1084]
    ring
  have h1092 : v1092 = v72^226156424291633194186662080095093570025917938800079226639565453027966976000 := by
    change v1088*v1088 = _
    rw [h1088]
    ring
  have h1096 : v1096 = v72^452312848583266388373324160190187140051835877600158453279130906055933952000 := by
    change v1092*v1092 = _
    rw [h1092]
    ring
  have h1100 : v1100 = v72^904625697166532776746648320380374280103671755200316906558261812111867904000 := by
    change v1096*v1096 = _
    rw [h1096]
    ring
  have h1104 : v1104 = v72^1809251394333065553493296640760748560207343510400633813116523624223735808000 := by
    change v1100*v1100 = _
    rw [h1100]
    ring
  have h1108 : v1108 = v72^1809251394333065553493296640760748560207343510400633813116524750123642650623 := by
    change v1104*v296 = _
    rw [h1104, h296]
    ring
  have h1112 : v1112 = v72^3618502788666131106986593281521497120414687020801267626233049500247285301246 := by
    change v1108*v1108 = _
    rw [h1108]
    ring
  have h1116 : v1116 = v72^7237005577332262213973186563042994240829374041602535252466099000494570602492 := by
    change v1112*v1112 = _
    rw [h1112]
    ring
  have h1120 : v1120 = v72^7237005577332262213973186563042994240829374041602535252466099000494570602493 := by
    change v1116*v72 = _
    rw [h1116]
    ring
  have h1124 : v1124 = v72^14474011154664524427946373126085988481658748083205070504932198000989141204986 := by
    change v1120*v1120 = _
    rw [h1120]
    ring
  have h1128 : v1128 = v72^14474011154664524427946373126085988481658748083205070504932198000989141204987 := by
    change v1124*v72 = _
    rw [h1124]
    ring
  change [v1128] = _
  rw [h1128, miller_input]
  rfl

end DivideAndPair
