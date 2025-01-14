/*****************************************************************************/
/* This is the Stata .do file for the replication by Priscila Robinson, Paola
Perez, and James Donahue regarding the gender wealth cap. Before running, please
take a moment to set the global macros to fit your own settings, being sure to
set "MY_IN_PATH" as the folder containing your SOEP data files.

Additionally, please run ensure that the user-written function "decompose2.ado"
is in the in path folder. It produces a function necessary for this analysis. */
/*****************************************************************************/
#delimit;
set more off;
clear;
/* -----   Here you can customize the paths and options:   ----- */;

global MY_IN_PATH   "C:\Users\lnwgr\Downloads\data\";
global MY_OUT_PATH  "C:\Users\lnwgr\Google Drive\_Hamburg WISO stuff\SOEP\Final Paper\";
global MY_TEMP_PATH "C:\Users\lnwgr\Downloads\temp\";

global MY_OUT_FILE  ${MY_OUT_PATH}data2002.dta;
global MY_LOG_FILE  ${MY_OUT_PATH}SOEP Donahue Perez Robinson.log;

log using "${MY_LOG_FILE}", text replace;
set more off;

/* ----------------[ automatically pull PPFAD ]----------------- */;

use    hhnr    persnr  sex     gebjahr psample 
       ohhnr   phhnr   qhhnr   rhhnr   shhnr   
       onetto  pnetto  qnetto  rnetto  snetto  
       opop    ppop    qpop    rpop    spop    
       loc1989 migback
using  "${MY_IN_PATH}ppfad.dta";

/* --------------[ balanced / unbalanced design ]--------------- */;

keep if ( ( onetto >= 10 & onetto < 20 ) | ( pnetto >= 10 & pnetto < 20 ) | 
          ( qnetto >= 10 & qnetto < 20 ) | ( rnetto >= 10 & rnetto < 20 ) | 
          ( snetto >= 10 & snetto < 20 ) );

/* -----------------[ private housholds only.]------------------ */;

keep if ( ( opop == 1 | opop == 2 ) | ( ppop == 1 | ppop == 2 ) |
          ( qpop == 1 | qpop == 2 ) | ( rpop == 1 | rpop == 2 ) |
          ( spop == 1 | spop == 2 ) );

/* -----------------------[ sort ppfad ]------------------------ */;

sort persnr;
save "${MY_TEMP_PATH}ppfad.dta", replace;
clear;

/* -----------------[ automatically pull PHRF ]----------------- */;

use    hhnr    persnr  prgroup 
       ophrf   pphrf   qphrf   rphrf   sphrf   
       ppbleib qpbleib rpbleib spbleib
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

use    hhnr    persnr  
       vsbil   msbil
using "${MY_IN_PATH}bioparen.dta";

sort persnr;
save "${MY_TEMP_PATH}bioparen.dta", replace;
clear;

/* ----------------------( pull opequiv )----------------------- */;

use    hhnr    ohhnr   persnr  
       i1111098 ijob198 ijob298 iself98 ioldy98 iwidy98 iunby98 iunay98 isuby98
       ieret98 imaty98 istuy98 imilt98 ialim98 ielse98 icomp98 iprvp98 i13ly98
       i14ly98 ixmas98 iholy98 igray98 iothy98 igrv198 igrv298 renty98 opery98
       divdy98 chspt98 house98 nursh98 subst98 sphlp98 hsup98  ismp198 iciv198
       iwar198 iagr198 iguv198 ivbl198 icom198 iprv198 ison198 ismp298 iciv298
       iwar298 iagr298 iguv298 ivbl298 icom298 ison298 iprv298 ssold98 lossr98
       lossc98 itray98 idemy98 alg298  adchb98 iachm98 i1110298
using "${MY_IN_PATH}opequiv.dta";

sort persnr;
save "${MY_TEMP_PATH}opequiv.dta", replace;
clear;

/* ----------------------( pull ppequiv )----------------------- */;

use    hhnr    phhnr   persnr  
       i1111099 ijob199 ijob299 iself99 ioldy99 iwidy99 iunby99 iunay99 isuby99
       ieret99 imaty99 istuy99 imilt99 ialim99 ielse99 icomp99 iprvp99 i13ly99
       i14ly99 ixmas99 iholy99 igray99 iothy99 igrv199 igrv299 renty99 opery99
       divdy99 chspt99 house99 nursh99 subst99 sphlp99 hsup99  ismp199 iciv199
       iwar199 iagr199 iguv199 ivbl199 icom199 iprv199 ison199 ismp299 iciv299
       iwar299 iagr299 iguv299 ivbl299 icom299 ison299 iprv299 ssold99 lossr99
       lossc99 itray99 idemy99 alg299  adchb99 iachm99 i1110299
using "${MY_IN_PATH}ppequiv.dta";

sort persnr;
save "${MY_TEMP_PATH}ppequiv.dta", replace;
clear;

/* ----------------------( pull qpequiv )----------------------- */;

use    hhnr    qhhnr   persnr  
       i1111000 ijob100 ijob200 iself00 ioldy00 iwidy00 iunby00 iunay00 isuby00
       ieret00 imaty00 istuy00 imilt00 ialim00 ielse00 icomp00 iprvp00 i13ly00
       i14ly00 ixmas00 iholy00 igray00 iothy00 igrv100 igrv200 renty00 opery00
       divdy00 chspt00 house00 nursh00 subst00 sphlp00 hsup00  ismp100 iciv100
       iwar100 iagr100 iguv100 ivbl100 icom100 iprv100 ison100 ismp200 iciv200
       iwar200 iagr200 iguv200 ivbl200 icom200 ison200 iprv200 ssold00 lossr00
       lossc00 itray00 idemy00 alg200  adchb00 iachm00 i1110200
using "${MY_IN_PATH}qpequiv.dta";

sort persnr;
save "${MY_TEMP_PATH}qpequiv.dta", replace;
clear;

/* -------------------------( pull rp )------------------------- */;

use    hhnr    rhhnr   persnr  
       rp108a01 rp108b01 rp108c01
using "${MY_IN_PATH}rp.dta";

sort persnr;
save "${MY_TEMP_PATH}rp.dta", replace;
clear;

/* ----------------------( pull rpequiv )----------------------- */;

use    hhnr    rhhnr   persnr  
       i1111001 ijob101 ijob201 iself01 ioldy01 iwidy01 iunby01 iunay01 isuby01
       ieret01 imaty01 istuy01 imilt01 ialim01 ielse01 icomp01 iprvp01 i13ly01
       i14ly01 ixmas01 iholy01 igray01 iothy01 igrv101 igrv201 renty01 opery01
       divdy01 chspt01 house01 nursh01 subst01 sphlp01 hsup01  ismp101 iciv101
       iwar101 iagr101 iguv101 ivbl101 icom101 iprv101 ison101 ismp201 iciv201
       iwar201 iagr201 iguv201 ivbl201 icom201 ison201 iprv201 ssold01 lossr01
       lossc01 itray01 idemy01 alg201  adchb01 iachm01 i1110201
using "${MY_IN_PATH}rpequiv.dta";

sort persnr;
save "${MY_TEMP_PATH}rpequiv.dta", replace;
clear;

/* -------------------------( pull sp )------------------------- */;

use    hhnr    shhnr   persnr  sp13201
       sp1102  sp1103  sp1104  sp1105  sp1107  sp8002  sp8003 sp13202
using "${MY_IN_PATH}sp.dta";

sort persnr;
save "${MY_TEMP_PATH}sp.dta", replace;
clear;

/* -----------------------( pull opgen )------------------------ */;

use    labnet98 persnr
using "${MY_IN_PATH}opgen.dta";

sort persnr;
save "${MY_TEMP_PATH}opgen.dta", replace;
clear;

/* -----------------------( pull ppgen )------------------------ */;

use    labnet99 persnr
using "${MY_IN_PATH}ppgen.dta";

sort persnr;
save "${MY_TEMP_PATH}ppgen.dta", replace;
clear;

/* -----------------------( pull qpgen )------------------------ */;

use    labnet00 persnr
using "${MY_IN_PATH}qpgen.dta";

sort persnr;
save "${MY_TEMP_PATH}qpgen.dta", replace;
clear;

/* -----------------------( pull rpgen )------------------------ */;

use    labnet01 persnr
using "${MY_IN_PATH}rpgen.dta";

sort persnr;
save "${MY_TEMP_PATH}rpgen.dta", replace;
clear;

/* -----------------------( pull spgen )------------------------ */;

use    hhnr    shhnr   persnr  labnet02
       erwtyp02 erljob02 oeffd02 partz02 partnr02 nation02 spsbil  spbbil01
       spbbil02 sbilzeit serwzeit statzeit autono02 expft02 exppt02 expue02
	   spsbila spbbila sfamstd lfs02 emplst02 jobch02 degree02 isced97_02
using "${MY_IN_PATH}spgen.dta";

sort persnr;
save "${MY_TEMP_PATH}spgen.dta", replace;
clear;

/* ----------------------( pull spequiv )----------------------- */;

use    hhnr    shhnr   persnr  i1110202
       i1111002 h1110302 h1110402 ijob102 ijob202 iself02 ioldy02 iwidy02
       iunby02 iunay02 isuby02 ieret02 imaty02 istuy02 imilt02 ialim02 ielse02
       icomp02 iprvp02 i13ly02 i14ly02 ixmas02 iholy02 igray02 iothy02 igrv102
       igrv202 renty02 opery02 divdy02 chspt02 house02 nursh02 subst02 sphlp02
       hsup02  ismp102 iciv102 iwar102 iagr102 iguv102 ivbl102 icom102 iprv102
       ison102 ismp202 iciv202 iwar202 iagr202 iguv202 ivbl202 icom202 ison202
       iprv202 ssold02 lossr02 lossc02 itray02 idemy02 alg202  adchb02 iachm02
using "${MY_IN_PATH}spequiv.dta";

sort persnr;
save "${MY_TEMP_PATH}spequiv.dta", replace;
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

/* ----------------------( merge OPEQUIV )---------------------- */;

          
sort  persnr;
merge persnr
using "${MY_TEMP_PATH}opequiv.dta";
drop   if _merge == 2;
drop   _merge;
erase "${MY_TEMP_PATH}opequiv.dta";

/* ----------------------( merge PPEQUIV )---------------------- */;

          
sort  persnr;
merge persnr
using "${MY_TEMP_PATH}ppequiv.dta";
drop   if _merge == 2;
drop   _merge;
erase "${MY_TEMP_PATH}ppequiv.dta";

/* ----------------------( merge QPEQUIV )---------------------- */;

          
sort  persnr;
merge persnr
using "${MY_TEMP_PATH}qpequiv.dta";
drop   if _merge == 2;
drop   _merge;
erase "${MY_TEMP_PATH}qpequiv.dta";

/* ------------------------( merge RP )------------------------- */;

          
sort  persnr;
merge persnr
using "${MY_TEMP_PATH}rp.dta";
drop   if _merge == 2;
drop   _merge;
erase "${MY_TEMP_PATH}rp.dta";

/* ----------------------( merge RPEQUIV )---------------------- */;

          
sort  persnr;
merge persnr
using "${MY_TEMP_PATH}rpequiv.dta";
drop   if _merge == 2;
drop   _merge;
erase "${MY_TEMP_PATH}rpequiv.dta";

/* ------------------------( merge SP )------------------------- */;

          
sort  persnr;
merge persnr
using "${MY_TEMP_PATH}sp.dta";
drop   if _merge == 2;
drop   _merge;
erase "${MY_TEMP_PATH}sp.dta";

/* -----------------------( merge SPGEN )----------------------- */;

          
sort  persnr;
merge persnr
using "${MY_TEMP_PATH}spgen.dta";
drop   if _merge == 2;
drop   _merge;
erase "${MY_TEMP_PATH}spgen.dta";


/* -----------------------( merge RPGEN )----------------------- */;

          
sort  persnr;
merge persnr
using "${MY_TEMP_PATH}rpgen.dta";
drop   if _merge == 2;
drop   _merge;
erase "${MY_TEMP_PATH}rpgen.dta";

/* -----------------------( merge QPGEN )----------------------- */;

          
sort  persnr;
merge persnr
using "${MY_TEMP_PATH}qpgen.dta";
drop   if _merge == 2;
drop   _merge;
erase "${MY_TEMP_PATH}qpgen.dta";

/* -----------------------( merge OPGEN )----------------------- */;

          
sort  persnr;
merge persnr
using "${MY_TEMP_PATH}opgen.dta";
drop   if _merge == 2;
drop   _merge;
erase "${MY_TEMP_PATH}opgen.dta";

/* -----------------------( merge PPGEN )----------------------- */;

          
sort  persnr;
merge persnr
using "${MY_TEMP_PATH}ppgen.dta";
drop   if _merge == 2;
drop   _merge;
erase "${MY_TEMP_PATH}ppgen.dta";

/* ----------------------( merge SPEQUIV )---------------------- */;

          
sort  persnr;
merge persnr
using "${MY_TEMP_PATH}spequiv.dta";
drop   if _merge == 2;
drop   _merge;
erase "${MY_TEMP_PATH}spequiv.dta";

/* --------------------------( done! )-------------------------- */;

label data "Magic at Work! Pris, Paola, and James!!";
save  "${MY_OUT_FILE}", replace;
do "${MY_OUT_PATH}do02b.do";
do "${MY_OUT_PATH}do02c.do";
do "${MY_OUT_PATH}do12a.do";
do "${MY_OUT_PATH}do12b.do";
do "${MY_OUT_PATH}do12c.do";
log close;
