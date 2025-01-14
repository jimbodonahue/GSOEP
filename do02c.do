**VARIABLE GENERATION**
*Replace numeric values to missing values*
quietly mvdecode _all, mv(-1=. \ -2=. \ -3=.)
set more off

*Over65 variable*
gen over65=0
replace over65=1 if 2002-gebjahr>=65
label var over65 "Over 65 years old"

*Sum of all sources of income for each year*
egen sumpi1998=rowtotal(i1111098 ioldy98 iwidy98 icomp98 iprvp98 iunby98 iunay98 imaty98 istuy98 imilt98 ialim98 ielse98)
egen sumpi1999= rowtotal( i1111099 ioldy99 iwidy99 icomp99 iprvp99 iunby99 iunay99 imaty99 istuy99 imilt99 ialim99 ielse99)
egen sumpi2000= rowtotal(i1111000 ioldy00 iwidy00 icomp00 iprvp00 iunby00 iunay00 imaty00 istuy00 imilt00 ialim00 ielse00)
egen sumpi2001= rowtotal(i1111001 ioldy01 iwidy01 icomp01 iprvp01 iunby01 iunay01 imaty01 istuy01 imilt01 ialim01 ielse01)
egen sumpi2002= rowtotal(i1111002 ioldy02 iwidy02 icomp02 iprvp02 iunby02 iunay02 imaty02 istuy02 imilt02 ialim02 ielse02)
// To eliminate zero values (only keep if labor income exists)
replace sumpi1998 =. if i1111098==.
replace sumpi1999 =. if i1111099==.
replace sumpi2000 =. if i1111000==.
replace sumpi2001 =. if i1111001==.

egen perminc=rmean(sumpi1998 sumpi1999 sumpi2000 sumpi2001 sumpi2002)
lab var perminc "Permanent Income"

// Higher order terms
gen inc2 = perminc^2
gen inc3 = perminc^3
lab var inc2 "Income squared"
lab var inc3 "Income cubed"

 // Kids under 5 years old (0-4)
 egen kidsbelow5 = rowtotal ( h1110302 h1110402)
 lab var kidsbelow5 "Number of children below 5"

 // Education level
 gen edu_1 =1 if isced97_02<3
 gen edu_2 =1 if isced97_02==3
 gen edu_3 =1 if isced97_02==4 | isced97_02==5
 gen edu_4 =1 if isced97_02==6
 replace edu_1 =0 if edu_1==.
 replace edu_2 =0 if edu_2==.
 replace edu_3 =0 if edu_3==.
 replace edu_4 =0 if edu_4==.
 lab var edu_1 "No education"
 lab var edu_2 "Lower vocational education"
 lab var edu_3 "Upper vocational education"
 lab var edu_4 "University degree" 
 
 // Parent with higher education
 // Generate mother's education
gen hiedu_m = 0
replace hiedu_m = 1 if msbil == 4
// Generate father's education
gen hiedu_f = 0
replace hiedu_f = 1 if vsbil == 4
// Generate parent's education
egen hiedu_p = rowtotal(hiedu_m hiedu_f)
replace hiedu_p = 1 if hiedu_p == 2
lab var hiedu_m "Mother with higher education"
lab var hiedu_f "Father with higher education"
lab var hiedu_p "Parent with higher education"
 
// Generate inheritance dummies
gen inheri1 = 1 if rp108a01 < 1992
replace inheri1 =1 if rp108b01 < 1992 & rp108a01 != .
replace inheri1 =1 if rp108c01 < 1992 & rp108b01 != .
replace inheri1 = 0 if inheri1==.

gen inheri2 =1 if rp108a01 >= 1992 & rp108a01 != .
replace inheri2 =1 if rp108b01 >= 1992 & rp108a01 != .
replace inheri2 =1 if rp108c01 >= 1992 & rp108b01 != .
replace inheri2 =0 if inheri2 ==.

label var inheri1 "Old inheritance (1949-1002)"
label var inheri2 "Recent inheritence (1992)-2001"

// We need a binary gender variable (sex is a string var)
gen gender = 1 if sex==1
replace gender = 0 if sex==2
lab var gender "Gender (1=male 0=female)"
lab define g 0 "Female" 1 "Male"
lab values gender g

// Variable for if they lived in East Germany
gen ddr = 1 if loc1989 == 1
replace ddr = 0 if ddr ==.
lab var ddr "Lived in East Germany (incl E Berlin)"

// Variable for coming from abroad
gen abroad = 0
replace abroad = 1 if migback ==2
lab var abroad "Coming from abroad"

// No labor market experience
egen nolabexp = rowtotal( expft02 exppt02 expue02)
replace nolabexp = . if nolabexp!=0 
replace nolabexp = 1 if nolabexp==0 // to make interpretation more intuitive
replace nolabexp = 0 if nolabexp==.
lab var nolabexp "No labor market experience"

// Workforce participation
gen notworkforce = 1 if lfs02<6
replace notworkforce =0 if notworkforce ==.
lab var notworkforce "Not in workforce"

// Job autonomy
gen hiautono = 1 if autono02 ==4 | autono02 ==5
replace hiautono = 0 if hiautono ==.
lab var hiautono "High job autonomy"

// Self employment
gen self_empl = 1 if iself02 >0
replace self_empl = 0 if self_empl ==.
lab var self_empl "Self-employed in 2002"

// Create dummies for marital status
gen divorced =0
replace divorced=1 if sfamstd==4 
replace divorced=0 if sp13202==1

//Widowed
gen widowed=0
replace widowed=1 if sfamstd==5 
replace widowed=0 if sp13202==1

//Cohabitating 
gen cohabitating=1 if sp13202==1 
replace cohabitating=0 if divorced==1
replace cohabitating=0 if widowed==1

//Married
gen married=0
replace married=1 if sfamstd==1 | sfamstd==2

//Single-Never Married
gen singlenm=1 if sp13202==2 & sfamstd==3
replace singlenm=1 if married==0 & divorced==0 & widowed==0 & cohabitating==0
replace singlenm=0 if singlenm==.

replace sp13202=2 if sp13202==.
replace cohabitating=0 if sp13202==2
replace cohabitating=0 if married==1
replace singlenm=1 if married==0 & divorced==0 & widowed==0 & cohabitating==0

//Generate m = marital status for males
gen m=1 if gender==1 & married==1
replace m=2 if gender==1 & cohabitating==1
replace m=3 if gender==1 & divorced==1
replace m=4 if gender==1 & widowed==1
replace m=5 if gender==1 & singlenm==1
// Generate f = marital status for females
gen f=1 if gender==0 & married==1
replace f=2 if gender==0 & cohabitating==1
replace f=3 if gender==0 & divorced==1
replace f=4 if gender==0 & widowed==1
replace f=5 if gender==0 & singlenm==1
// Generate s = marital status dummy (both genders included)
gen s=1 if married==1
replace s=2 if cohabitating==1
replace s=3 if divorced==1
replace s=4 if widowed==1
replace s=5 if singlenm==1
lab define s 1 "Married" 2 "Cohabitating" 3 "Divorced" 4 "Widowed" 5 "Single"
lab values s s
// Generate t = marital status by gender
gen t=1 if gender==1 & married==1
replace t=2 if gender==1 & cohabitating==1
replace t=3 if gender==1 & divorced==1
replace t=4 if gender==1 & widowed==1
replace t=5 if gender==1 & singlenm==1
replace t=6 if gender==0 & married==1
replace t=7 if gender==0 & cohabitating==1
replace t=8 if gender==0 & divorced==1
replace t=9 if gender==0 & widowed==1
replace t=10 if gender==0 & singlenm==1
label var t "Marital status"
label define t 1 "Married man" 2 "Cohabitating man" 3 "Divorced man" 4 "Widowed man" 5 "Single man" /*
*/ 6 "Married woman" 7 "Cohabitating woman" 8 "Divorced woman" 9 "Widowed woman" 10 "Single woman"
label values t t
// Partner
gen partner = 0
replace partner = 1 if cohabitating ==1
label var partner "Has a partner"
// Age
gen age = 2002-gebjahr
label var age "Age"

**************************  BEGIN TABLE MAKING!!  *****************************
// For Table 1
//Means of variables by marital status
egen ale=rmean(i1111098 i1111099 i1111000 i1111001 i1111002)
*Full time
gen ftemp=1 if emplst02==1
replace ftemp=0 if ftemp==.
replace ftemp=0 if self_emp==1
*Part time
gen ptemp=1 if emplst02==2
replace ptemp=0 if ptemp==.
replace ptemp=0 if self_emp==1
*Vocational 
gen vocemp=1 if emplst02==3
replace vocemp=0 if vocemp==.
replace vocemp=0 if self_emp==1
*Irregular
gen irremp=1 if emplst02==4
replace irremp=0 if irremp==.
replace irremp=0 if self_emp==1
*Not employed
gen notemp=1 if emplst02==5
replace notemp=0 if notemp==.
replace notemp=0 if self_emp==1
replace notemp=0 if lfs02==6
*Unemployed
gen unempl=1 if lfs02==6
replace unempl=0 if unempl==.
**Low education

local varlist "age abroad perminc ale edu_1 edu_2 edu_3 edu_4 ftemp ptemp self_emp notemp unempl vocemp irremp ddr wealth"

//Generate mean of amounts: Demographics, Income, Education, Labor Market Status, Regional Characteristics, Net Worth
foreach var of  varlist age abroad perminc ale edu_1 edu_2 edu_3 edu_4 ftemp ptemp self_emp notemp unempl vocemp irremp ddr wealth{
		dis "`var'"
		table t gender [aw=sphrf], c(mean `var') sc col row
}
// Median wealth
foreach t in 1 2 3 4 5 6 7 8 9 10 {
	quietly sum wealth if t==`t' [aweight=sphrf], detail
	disp r(p50)
	}
// Total female, male
foreach t in 0 1 {
	quietly sum wealth if gender==`t' [aweight=sphrf], detail
	disp r(p50)
	}
//************** Table 2 
// Table 2, row 1-2
table s gender [aw=sphrf], c(mean wealth) row
table s gender [aw=sphrf], c(med wealth) row
// Relative Wealth Position
quietly sum wealth
gen avwealth = r(mean)
// For row 3,
foreach t in 1 2 3 4 5 6 7 8 9 10 {
	quietly sum wealth if t==`t' [aweight=sphrf], detail
	local label : label (t) `t'
	disp r(mean)/avwealth*100 " for `label'"
	}
// Total female, male
foreach t in 0 1 {
	quietly sum wealth if gender==`t' [aweight=sphrf], detail
	disp r(mean)/avwealth *100
	}
// Table 2, rows on shared wealth- get number and divide by total
table s gender [aw=sphrf] if wealth==0, row
table s gender [aw=sphrf] if wealth<0, row

// Quintile shares
// for this, pshare can also be added via https://ideas.repec.org/c/boc/bocode/s458036.html
cap ssc install pshare
pshare wealth [pweight=sphrf], n(5) gini over(t)
pshare wealth [pweight=sphrf], n(5) gini over(gender)
	
// Inequality
// P90/P50
foreach t in 1 2 3 4 5 6 7 8 9 10 {
	quietly sum wealth if t==`t' [aweight=sphrf], detail
	local label : label (t) `t'
	disp r(p90)/r(p50) " for `label'"
	}
	foreach t in 0 1 {
	quietly sum wealth if gender==`t' [aweight=sphrf], detail
	disp r(p90)/r(p50)
	}
// P75-P50
foreach t in 1 2 3 4 5 6 7 8 9 10 {
	quietly sum wealth if t==`t' [aweight=sphrf], detail
	local label : label (t) `t'
	disp r(p75)/r(p50) " for `label'"
	}
foreach t in 0 1 {
	quietly sum wealth if gender==`t' [aweight=sphrf], detail
	disp r(p75)/r(p50)
	}
//

// ************** For Table 3:
foreach w in phw propw faw insw baw taw sum_debts wealth {
	table s gender [aw=sphrf], c(mean `w' sem `w') row
	disp "Wealth from `w'"
	}
	//	
// *********** OLS regression (Table 4)
reg wealth lmar nrmarriage abroad partner ddr kidsbelow5 over65 edu_2 edu_3 edu_4 hiautono perminc expft02 exppt02 expue02 notworkforce nolabexp hiedu_f hiedu_m hiedu_p inheri2 inheri1 inc2 inc3 if gender==1 [aweight=sphrf], robust
estimates store men
reg wealth lmar nrmarriage abroad partner ddr kidsbelow5 over65 edu_2 edu_3 edu_4 hiautono perminc expft02 exppt02 expue02 notworkforce nolabexp hiedu_f hiedu_m hiedu_p inheri2 inheri1 inc2 inc3 if gender==0 [aweight=sphrf], robust
estimates store women
estimates tab women men, star stat(N) varl title (OLS Coefficients 2002)

// DFL Decomposition
/* Define vectors of characteristics as globals */
/* Vector of labor experience variables */
  global l  " expft02 exppt02 expue02 nolabexp over65 hiautono perminc"
/* Vector of Education variables */ 
  global e "edu_1 edu_2 edu_3 edu_4"
/* Vector of intergenerational attributes*/
  global i "hiedu_m hiedu_f hiedu_p inheri1 inheri2"
/* Vector of d demographics */
 global d "ddr kidsbelow5 abroad lmar nrmarriage partner"
 // For weights
 gen hhwtrp =  sphrf
// Run decompose2.ado to load DFL decomposition
cap do"${MY_OUT_PATH}decompose2.ado"
set matsize 3000
decompose2 wealth gender group($l) group($e) group($i) group($d), logit boot
return list
matrix list r(table)
matrix DFL2002=r(table)
save  "${MY_OUT_FILE}", replace
