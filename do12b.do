
// To generate wealth
use "${MY_IN_PATH}pwealth.dta", clear

// Because we only care about 2012
keep if svyyear==2012

// Generate wealth variables - Market Value
gen phw = p0101e if svyyear==2012
gen propw = e0101e if svyyear==2012
gen faw = f0101e if svyyear==2012
gen insw = i0100e if svyyear==2012
gen baw = b0100e if svyyear==2012
gen taw = t0100e if svyyear==2012

// Generate wealth variables - Associated Debt (Total: Consumer Credit..)
gen phd = p0011e if svyyear==2012
gen propd = e0011e if svyyear==2012
gen dw = c0100e if svyyear==2012

//Overal Wealth - Diference
gen wealth= w0111e if svyyear==2012
egen sum_mv = rowtotal(phw propw faw insw baw taw)
egen sum_debts= rowtotal(phd propd dw)
gen sum_wealth= sum_mv - sum_debts

// Now get ready to merge
keep sum_mv sum_debts sum_wealth wealth persnr phw propw faw insw baw taw phd propd dw

// Drop first and last percentiles of wealth (to remove outliers)
quietly summarize wealth, detail
keep if inrange(wealth, r(p1), r(p99))

// Merge!
save "${MY_TEMP_PATH}wealth.dta", replace
use "${MY_OUT_PATH}data2012.dta"
merge 1:1 persnr using "${MY_TEMP_PATH}wealth.dta"
keep if _merge==3
drop _merge
label var wealth "Net imputed wealth in 2012"
label var phw "Wealth from primary residence"
label var propw "Wealth from other property investments"
label var faw "Wealth from financial assets"
label var insw "Wealth from insurance/private pension"
label var baw "Wealth from business assets"
label var taw "Wealth from tangible assets"
label var dw "Wealth from consumer debt (negative)"
label var sum_mv "Sum of market value wealth sources"
label var sum_debts "Sum of debts wealth sources"
save "${MY_OUT_PATH}data2012.dta", replace
erase "${MY_TEMP_PATH}wealth.dta"


// To generate number of marriages
use "${MY_IN_PATH}biomarsm.dta", clear
// Number of marriages code
*Replace numeric values to missing values*
mvdecode _all, mv(-1=. \ -2=. \ -3=.)

// check other &%set thingies
// and get rid of negative valueses
xtset persnr spellnr

// Drop spells after 2012
bysort persnr: replace spelltyp = . if begin >360
drop if spelltyp ==.

// Change var is changes from not married or separated to married
bysort persnr: gen change = 1 if spelltyp==2 & (L.spelltyp!=6)
bysort persnr: gen div = 1 if spellnr == 1 & spelltyp == 3
bysort persnr: gen widow = 1 if spellnr == 1 & spelltyp == 4
bysort persnr: gen sep = 1 if spellnr == 1 & spelltyp == 6

// Add total of changes to married (new marriages)
bysort persnr: egen married = total(change)
bysort persnr: egen sumwidow = total(widow)
bysort persnr: egen sumdiv = total(div)
bysort persnr: egen sumsep = total(sep)

// Bring it all together
egen nrmarriage = rowtotal (married sumwidow sumdiv sumsep)

// At the end, to get ready to merge
bysort persnr: egen maxnr=max(spellnr)
drop if spellnr != maxnr
keep persnr nrmarriage
save "${MY_TEMP_PATH}nrmarriage.dta"

// Merge!
use "${MY_OUT_PATH}data2012.dta"
merge 1:1 persnr using "${MY_TEMP_PATH}nrmarriage.dta"
drop if _merge==2
drop _merge
lab var nrmarriage "Number of marriages"
save "${MY_OUT_PATH}data2012.dta", replace
erase "${MY_TEMP_PATH}nrmarriage.dta"



// To generate length of marriage
use "${MY_IN_PATH}biomarsy.dta", clear
*Replace numeric values to missing values*
mvdecode _all, mv(-1=. \ -2=. \ -3=.)
xtset persnr spellnr


//Assuming "Length of marriage" variable is last/current marriage
gen lmar=0   
keep if beginy<=2012
bysort persnr: egen maxnr=max(spellnr)
replace endy= 2012 if maxnr==spellnr & spelltyp==2 & endy>2012

*If person was only married once and need to calculate end - begin of last spellnr
bysort persnr: replace lmar =endy-beginy if censor==5 & spelltyp==2 & (l.spelltyp!=3 |l.spelltyp!=4) 

*If person's last spelltyp isn't married:

*Widowed/Divorced
bysort persnr: replace lmar = beginy-l.beginy if ((spelltyp==3 | spelltyp==4 & l.spelltyp==2) & l.spelltyp!=6)
bysort persnr: replace lmar= beginy - l2.beginy if (((spelltyp==3 | spelltyp==4) & l2.spelltyp==2) & l.spelltyp==6)

bysort persnr: replace lmar =endy-beginy if spelltyp==2 & spellnr==maxnr
bysort persnr: replace lmar =endy-l.beginy if l.spelltyp==2 & spellnr==maxnr & spelltyp==6

gen married=1 if maxnr==spellnr & spelltyp==2 | spelltyp==6
replace married=0 if married==.
gen divorced=1 if maxnr==spellnr & spelltyp==3
replace divorced=0 if divorced==.
gen widowed=1 if maxnr==spellnr & spelltyp==4
replace widowed=0 if widowed==.
gen unmarried=1 if maxnr==spellnr & spelltyp==1
replace unmarried=0 if unmarried==.

keep if spellnr==maxnr & endy==2012

// Get ready to merge
drop if persnr == L.persnr
keep persnr lmar
save "${MY_TEMP_PATH}lengthmarriage.dta"

// Merge!
use "${MY_OUT_PATH}data2012.dta"
merge 1:1 persnr using "${MY_TEMP_PATH}lengthmarriage.dta"
drop if _merge==2
drop _merge
replace lmar = 0 if lmar==.
lab var lmar "Length of marriage"
save "${MY_OUT_PATH}data2012.dta", replace
erase "${MY_TEMP_PATH}lengthmarriage.dta"
