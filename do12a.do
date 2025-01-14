#delimit;
clear;
global MY_OUT_FILE  ${MY_OUT_PATH}data2012.dta;

set more off;

/* ----------------[ automatically pull PPFAD ]----------------- */;

use    hhnr    persnr  sex     gebjahr psample loc1989
       bahhnr  bbhhnr  bchhnr  yhhnr   zhhnr
	   bcnetto bchhnr bcnetold bccasemat bcsampreg bcpop
       migback miginfo banetto bbnetto ynetto znetto
using  "${MY_IN_PATH}ppfad.dta";

/* --------------[ balanced / unbalanced design ]--------------- */;

keep if ( ( banetto >= 10 & banetto < 20 ) | ( bbnetto >= 10 & bbnetto < 20 ) | 
          ( bcnetto >= 10 & bcnetto < 20 ) | ( ynetto >= 10 & ynetto < 20 ) | 
          ( znetto >= 10 & znetto < 20 ) );

/* -----------------[ private housholds only.]------------------ */;

/* -- start comment
keep if ( ( bapop == 1 | bapop == 2 ) | ( bbpop == 1 | bbpop == 2 ) |
          ( bcpop == 1 | bcpop == 2 ) | ( ypop == 1 | ypop == 2 ) |
          ( zpop == 1 | zpop == 2 ) );
*/;
/* -----------------------[ sort ppfad ]------------------------ */;

sort persnr;
save "${MY_TEMP_PATH}ppfad.dta", replace;
clear;

/* -----------------[ automatically pull PHRF ]----------------- */;

use    hhnr    persnr  prgroup 
       baphrf  bbphrf  bcphrf  yphrf   zphrf   
       hhnr    persnr  prgroup ypbleib zpbleib bapbleib bbpbleib bcpbleib yphrf
	 zphrf	 baphrf  bbphrf  bcphrf  baphrfah baphrfl1 baphrfl2 bbphrfal2
       bbphrfl3 bbphrfj bcphrfaj bcphrfk
using  "${MY_IN_PATH}phrf.dta";

sort  persnr;
save  "${MY_TEMP_PATH}phrf.dta", replace;
clear;

/* --------------[ automatically create pmaster ]--------------- */;

use    "${MY_TEMP_PATH}ppfad.dta";
merge  persnr
using  "${MY_TEMP_PATH}phrf.dta";

drop   if _merge == 2;
drop   _merge;
erase  "${MY_TEMP_PATH}ppfad.dta";
erase  "${MY_TEMP_PATH}phrf.dta";
sort   persnr;
save   "${MY_TEMP_PATH}pmaster.dta", replace;

/* ----------------------( pull bioparen )---------------------- */;

use    hhnr    persnr  vbbil  mbbil  vsinfo  msinfo  vbinfo  
       mbinfo  vsbil   msbil 
              
using "${MY_IN_PATH}bioparen.dta";

sort persnr;
save "${MY_TEMP_PATH}bioparen.dta", replace;
clear;

/* -----------------------( pull ypgen )------------------------ */;

use    hhnr    yhhnr   persnr  
       labnet08
using "${MY_IN_PATH}ypgen.dta";

sort persnr;
save "${MY_TEMP_PATH}ypgen.dta", replace;
clear;

/* ----------------------( pull ypequiv )----------------------- */;

use    hhnr    yhhnr   persnr  
       hhnrakt x11101ll d11102ll x11104ll x1110508 d1110108 d1110408
       d1110808 d1110908 e1110108 e1110208 e1110308 e1110408 e1110508 e1110608
       e1110708 i1111008 w1110108 h1110308 h1110408 ijob108 ijob208 iself08
       ioldy08 iwidy08 iunby08 iunay08 isuby08 ieret08 imaty08 istuy08 imilt08
       ialim08 ielse08 icomp08 iprvp08 i13ly08 i14ly08 ixmas08 iholy08 igray08
       iothy08 igrv108 igrv208 renty08 opery08 divdy08 chspt08 house08 nursh08
       subst08 sphlp08 hsup08  ismp108 iciv108 iwar108 iagr108 iguv108 ivbl108
       icom108 iprv108 ison108 ismp208 iciv208 iwar208 iagr208 iguv208 ivbl208
       icom208 ison208 iprv208 d11112ll lossr08 lossc08 alg208
using "${MY_IN_PATH}ypequiv.dta";

sort persnr;
save "${MY_TEMP_PATH}ypequiv.dta", replace;
clear;

/* ----------------------( pull zpequiv )----------------------- */;

use    hhnr    zhhnr   persnr  
       hhnrakt x11101ll d11102ll x11104ll d1110109 d1110409 e1110109
       e1110209 e1110309 e1110409 e1110509 e1110609 e1110709 i1111009 w1110909
       w1111009 w1111109 h1110309 h1110409 l1110109 l1110209 ijob109 ijob209
       iself09 ioldy09 iwidy09 iunby09 iunay09 isuby09 ieret09 imaty09 istuy09
       imilt09 ialim09 ielse09 icomp09 iprvp09 i13ly09 i14ly09 ixmas09 iholy09
       igray09 iothy09 igrv109 igrv209 renty09 opery09 divdy09 chspt09 house09
       nursh09 subst09 sphlp09 hsup09  ismp109 iciv109 iwar109 iagr109 iguv109
       ivbl109 icom109 iprv109 ison109 ismp209 iciv209 iwar209 iagr209 iguv209
       ivbl209 icom209 ison209 iprv209 d11112ll ssold09 lossr09 lossc09 
using "${MY_IN_PATH}zpequiv.dta";

sort persnr;
save "${MY_TEMP_PATH}zpequiv.dta", replace;
clear;

/* -----------------------( pull zpgen )------------------------ */;

use    hhnr    zhhnr   persnr  
       labnet09
using "${MY_IN_PATH}zpgen.dta";

sort persnr;
save "${MY_TEMP_PATH}zpgen.dta", replace;
clear;

/* ----------------------( pull bapequiv )---------------------- */;

use    hhnr    bahhnr  persnr  
       hhnrakt x11101ll d11102ll x11104ll d1110110 d1110410 d1110810
       d1110910 e1110110 e1110210 e1110310 e1110410 e1110510 e1110610 e1110710
       i1111010 w1110910 w1111010 w1111110 h1110310 h1110410 h1111210 l1110110
       l1110210 w1110410 e1120110 ijob110 ijob210 iself10 ioldy10 iwidy10
       iunby10 iunay10 isuby10 ieret10 imaty10 istuy10 imilt10 ialim10 ielse10
       icomp10 iprvp10 i13ly10 i14ly10 ixmas10 iholy10 igray10 iothy10 igrv110
       igrv210 renty10 opery10 divdy10 chspt10 house10 nursh10 subst10 sphlp10
       hsup10  ismp110 iciv110 iwar110 iagr110 iguv110 ivbl110 icom110 iprv110
       ison110 ismp210 iciv210 iwar210 iagr210 iguv210 ivbl210 icom210 ison210
       iprv210 d11112ll ssold10 lossr10 lossc10 alg210
using "${MY_IN_PATH}bapequiv.dta";

sort persnr;
save "${MY_TEMP_PATH}bapequiv.dta", replace;
clear;

/* -----------------------( pull bapgen )----------------------- */;

use    hhnr    bahhnr  persnr  
       labnet10
using "${MY_IN_PATH}bapgen.dta";

sort persnr;
save "${MY_TEMP_PATH}bapgen.dta", replace;
clear;

/* ----------------------( pull bbpequiv )---------------------- */;

use    hhnr    bbhhnr  persnr  
       hhnrakt x11101ll d11102ll x11104ll x1110511 d1110111  d1110411
       d1110811 d1110911 e1110111 e1110211 e1110311 e1110411 e1110511 e1110611
       e1110711 i1111011 w1110111 w1110911 w1111011 w1111111 h1110311 h1110411
       h1111211 l1110111 l1110211 w1110411 e1120111 ijob111 ijob211 iself11
       ioldy11 iwidy11 iunby11 iunay11 isuby11 ieret11 imaty11 istuy11 imilt11
       ialim11 ielse11 icomp11 iprvp11 i13ly11 i14ly11 ixmas11 iholy11 igray11
       iothy11 igrv111 igrv211 renty11 opery11 divdy11 chspt11 house11 nursh11
       subst11 sphlp11 hsup11  ismp111 iciv111 iwar111 iagr111 iguv111 ivbl111
       icom111 iprv111 ison111 ismp211 iciv211 iwar211 iagr211 iguv211 ivbl211
       icom211 ison211 iprv211 d11112ll ssold11 lossr11 lossc11 alg211 
using "${MY_IN_PATH}bbpequiv.dta";

sort persnr;
save "${MY_TEMP_PATH}bbpequiv.dta", replace;
clear;

/* -----------------------( pull bbpgen )----------------------- */;

use    hhnr    bbhhnr  persnr  
       labnet11
using "${MY_IN_PATH}bbpgen.dta";

sort persnr;
save "${MY_TEMP_PATH}bbpgen.dta", replace;
clear;

/* ----------------------( pull bcpequiv )---------------------- */;

use    hhnr    bchhnr  persnr  
       hhnrakt x11101ll d11102ll x11104ll x1110312 x1110512 d1110112 d1110312
       d1110412 d1110812 d1110912 e1110112 e1110212 e1110312 e1110412 e1110512
       e1110612 e1110712 i1111012 w1110112 w1110912 w1111012 w1111112 h1110312
       h1110412 h1111212 w1110412 e1120112 ijob112 ijob212 iself12 ioldy12
       iwidy12 iunby12 iunay12 isuby12 ieret12 imaty12 istuy12 imilt12 ialim12
       ielse12 icomp12 iprvp12 i13ly12 i14ly12 ixmas12 iholy12 igray12 iothy12
       igrv112 igrv212 renty12 opery12 divdy12 chspt12 house12 nursh12 subst12
       sphlp12 hsup12  ismp112 iciv112 iwar112 iagr112 iguv112 ivbl112 icom112
       iprv112 ison112 ismp212 iciv212 iwar212 iagr212 iguv212 ivbl212 icom212
       ison212 iprv212 d11112ll ssold12 lossr12 lossc12 falg212 adchb12 chsub12
using "${MY_IN_PATH}bcpequiv.dta";

sort persnr;
save "${MY_TEMP_PATH}bcpequiv.dta", replace;
clear;

/* ------------------------( pull bcp )------------------------- */;

use    hhnr    bchhnr  persnr  
       welle   bcpnr   bcp0401 bcp0402 bcp0403 bcp0404 bcp0405 bcp0406 bcp0407
       bcp0408 bcp0409 bcp05   bcp06   bcp07   bcp08   bcp11   bcp12   bcp13  
       bcp14   bcp15   bcp1601 bcp2401 bcp2402 bcp2403 bcp2404 bcp25   bcp26  
       bcp2701 bcp29   bcp30   bcp44   bcp4501 bcp4502 bcp46   bcp4701 bcp4702
       bcp4801 bcp4802 bcp51   bcp53   bcp6001 bcp6101 bcp6102 bcp6103 bcp6104
       bcp6105 bcp6106 bcp6107 bcp6201 bcp70   bcp71   bcp7201 bcp7202 bcp7206
       bcp11001 bcp11002 bcp11003 bcp12801 bcp129  bcp13001 bcp13002 bcp13003
       bcp131  bcp132  bcp134  bcp135  bcp136  bcp137  bcp138  bcp139  bcp14001
       bcp14002 bcp141	bcp142	bcp143	bcp144	bcp145	bcp146	bcp147 
       bcp14903 bcp14904 bcp14905 bcp14906 bcp14907 bcp14908 bcp14909 bcp14910
       bcp14911 bcp14912 bcp15004 bcp15005 bcp15006 bcp15007 f12p003a2
       f12p003b2 f12p003c2 f12p003d2 f12p003e2 f12p003f2 f12p003g2 f12p003h2
       f12p003i2 f12p003j2 f12p003a3 f12p003b3 f12p003c3 f12p003d3 f12p003e3
       f12p003f3 f12p003g3 f12p003h3 f12p003i3 f12p003j3 f12p014f f12p015a
       f12p015b f12p015c f12p015d f12p015e f12p015f f12p015g f12p043a f12p043b
       f12p043c f12p043d f12p043e f12p043f f12p043g f12p043h f12p122
using "${MY_IN_PATH}bcp.dta";

sort persnr;
save "${MY_TEMP_PATH}bcp.dta", replace;
clear;

/* -----------------------( pull bcpgen )----------------------- */;

use    hhnr bchhnr persnr 
       hhnrakt sample1 nation12 bcfamstd labnet12 stib12  emplst12 lfs12  
       jobch12 autono12 erljob12 ausb12  bcerwzeit bctatzeit
       bcvebzeit bcuebstd oeffd12 nace12  betr12  allbet12 jobend12 expft12
       exppt12 expue12 isced97_12 isced11_12 casmin12 bcbilzeit bcpsbil
       bcpbbil01 bcpbbil02 bcpbbil03 bcpsbilo bcpbbilo bcpsbila bcpbbila
       field12 degree12 traina12 trainb12 trainc12 traind12

using "${MY_IN_PATH}bcpgen.dta";

sort persnr;
save "${MY_TEMP_PATH}bcpgen.dta", replace;
clear;

/* -----------------------( pull rp )----------------------- */;

use    persnr rp108a01 rp108b01 rp108c01 

using "${MY_IN_PATH}rp.dta";

sort persnr;
save "${MY_TEMP_PATH}rp.dta", replace;
clear;

/* -----------------( Now merge all together )------------------ */;

use   "${MY_TEMP_PATH}pmaster.dta";
erase "${MY_TEMP_PATH}pmaster.dta";

/* -----------( merge together by person: ALL Waves )----------- */;

/* ---------------------( merge BIOPAREN )---------------------- */;

          
sort  persnr;
merge persnr
using "${MY_TEMP_PATH}bioparen.dta";
drop   if _merge == 2;
drop   _merge;
erase "${MY_TEMP_PATH}bioparen.dta";

/* -----------------------( merge YPGEN )----------------------- */;

          
sort  persnr;
merge persnr
using "${MY_TEMP_PATH}ypgen.dta";
drop   if _merge == 2;
drop   _merge;
erase "${MY_TEMP_PATH}ypgen.dta";

/* ----------------------( merge YPEQUIV )---------------------- */;

          
sort  persnr;
merge persnr
using "${MY_TEMP_PATH}ypequiv.dta";
drop   if _merge == 2;
drop   _merge;
erase "${MY_TEMP_PATH}ypequiv.dta";

/* ----------------------( merge ZPEQUIV )---------------------- */;

          
sort  persnr;
merge persnr
using "${MY_TEMP_PATH}zpequiv.dta";
drop   if _merge == 2;
drop   _merge;
erase "${MY_TEMP_PATH}zpequiv.dta";

/* -----------------------( merge ZPGEN )----------------------- */;

          
sort  persnr;
merge persnr
using "${MY_TEMP_PATH}zpgen.dta";
drop   if _merge == 2;
drop   _merge;
erase "${MY_TEMP_PATH}zpgen.dta";

/* ---------------------( merge BAPEQUIV )---------------------- */;

          
sort  persnr;
merge persnr
using "${MY_TEMP_PATH}bapequiv.dta";
drop   if _merge == 2;
drop   _merge;
erase "${MY_TEMP_PATH}bapequiv.dta";

/* ----------------------( merge BAPGEN )----------------------- */;

          
sort  persnr;
merge persnr
using "${MY_TEMP_PATH}bapgen.dta";
drop   if _merge == 2;
drop   _merge;
erase "${MY_TEMP_PATH}bapgen.dta";

/* ---------------------( merge BBPEQUIV )---------------------- */;

          
sort  persnr;
merge persnr
using "${MY_TEMP_PATH}bbpequiv.dta";
drop   if _merge == 2;
drop   _merge;
erase "${MY_TEMP_PATH}bbpequiv.dta";

/* ----------------------( merge BBPGEN )----------------------- */;

          
sort  persnr;
merge persnr
using "${MY_TEMP_PATH}bbpgen.dta";
drop   if _merge == 2;
drop   _merge;
erase "${MY_TEMP_PATH}bbpgen.dta";

/* ---------------------( merge BCPEQUIV )---------------------- */;

          
sort  persnr;
merge persnr
using "${MY_TEMP_PATH}bcpequiv.dta";
drop   if _merge == 2;
drop   _merge;
erase "${MY_TEMP_PATH}bcpequiv.dta";

/* ------------------------( merge BCP )------------------------ */;

          
sort  persnr;
merge persnr
using "${MY_TEMP_PATH}bcp.dta";
drop   if _merge == 2;
drop   _merge;
erase "${MY_TEMP_PATH}bcp.dta";

/* ----------------------( merge BCPGEN )----------------------- */;

          
sort  persnr;
merge persnr
using "${MY_TEMP_PATH}bcpgen.dta";
drop   if _merge == 2;
drop   _merge;
erase "${MY_TEMP_PATH}bcpgen.dta";

/* ----------------------( merge RP )----------------------- */;

          
sort  persnr;
merge persnr
using "${MY_TEMP_PATH}rp.dta";
drop   if _merge == 2;
drop   _merge;
erase "${MY_TEMP_PATH}rp.dta";

/* --------------------------( done! )-------------------------- */;

label data "SOEPINFO: Magic at Work! Pris, Paola, and James!!";
save  "${MY_OUT_FILE}", replace;
