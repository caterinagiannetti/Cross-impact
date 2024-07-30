
cd "/Users/caterinagiannnetti/Dropbox (Salvati)/validation_bubbles_experimental_markets/laboratory/statistical_analysis/OFI_and_cross_impact_analysis/DATA/"
global TABLE_FOLDER="/Users/caterinagiannnetti/Dropbox (Salvati)/validation_bubbles_experimental_markets/laboratory/statistical_analysis/OFI_and_cross_impact_analysis/TABLE/"




use DATA_merged.dta, clear


gen macro=1 if period>=1 & period<=5
replace macro=2 if period>=6 & period<=10
replace macro=3 if period>=11 & period<=15
replace macro=4 if period>=16 & period<=20
replace macro=5 if period>=21 & period<=25
replace macro=6 if period>=26 & period<=30
replace macro=7 if period>=31 & period<=35
replace macro=8 if period>=36 & period<=40
replace macro=9 if period>=41 & period<=45
replace macro=10 if period>=46 & period<=50
replace macro=11 if period>=51 & period<=55
replace macro=12 if period>=56 & period<=60
replace macro=13 if period>=61 & period<=65
replace macro=14 if period>=66 & period<=70
replace macro=15 if period>=71 & period<=75


gen confusion=1 if macro>=5 & macro<=10
replace confusion=0 if confusion==.

*****TAB 4

estimates clear


regress ret1 c.ofi1#i.dummy_t1 c.ofi2#i.dummy_t1,  
eststo
test  _b[1.dummy_t1#c.ofi2]=_b[0b.dummy_t1#c.ofi2]

regress ret2 c.ofi1#i.dummy_t1 c.ofi2#i.dummy_t1, 
eststo
test _b[1.dummy_t1#c.ofi1]=_b[0b.dummy_t1#c.ofi1]

*** TAB 5

regress ret1 c.ofi1#i.dummy_t1#i.confusion c.ofi2#i.dummy_t1#i.confusion, 
eststo
test _b[1.dummy_t1#1.confusion#c.ofi2]=_b[0b.dummy_t1#1.confusion#c.ofi2]
test  _b[1.dummy_t1#0b.confusion#c.ofi2]= _b[0b.dummy_t1#0b.confusion#c.ofi2]

regress ret2 c.ofi1#i.dummy_t1#i.confusion c.ofi2#i.dummy_t1#i.confusion,  
eststo
test _b[1.dummy_t1#1.confusion#c.ofi1]=_b[0b.dummy_t1#1.confusion#c.ofi1]
test _b[1.dummy_t1#0b.confusion#c.ofi1]=_b[0b.dummy_t1#0b.confusion#c.ofi1]



***************************
* DATA HUMAN VS NOISE	  *
***************************


use DATA_Human_Noise_OFI.dta, clear

gen macro=1 if period>=1 & period<=5
replace macro=2 if period>=6 & period<=10
replace macro=3 if period>=11 & period<=15
replace macro=4 if period>=16 & period<=20
replace macro=5 if period>=21 & period<=25
replace macro=6 if period>=26 & period<=30
replace macro=7 if period>=31 & period<=35
replace macro=8 if period>=36 & period<=40
replace macro=9 if period>=41 & period<=45
replace macro=10 if period>=46 & period<=50
replace macro=11 if period>=51 & period<=55
replace macro=12 if period>=56 & period<=60
replace macro=13 if period>=61 & period<=65
replace macro=14 if period>=66 & period<=70
replace macro=15 if period>=71 & period<=75


rename dummy_sep dummy_t1

gen ofi1=ofi1_hum+ofi1_noise
gen ofi2=ofi2_hum+ofi2_noise
* TAB 11 in the Appendix
*sutex2 ret1 ret2  ofi1 ofi2 ofi1_hum ofi1_noise ofi2_hum ofi2_noise if dummy_t1==1, min  saving(summary.tex)  digits(3)  replace
*sutex2 ret1 ret2  ofi1 ofi2 ofi1_hum ofi1_noise ofi2_hum ofi2_noise if dummy_t1==0, min   saving(summary.tex)  digits(3)  append


**** TAB 12 IN THE APPENDIX
pwcorr ofi1_hum ofi2_hum ofi1_noise ofi2_noise if dummy_t1==1, star(.01) bonferroni
pwcorr ofi1_hum ofi2_hum ofi1_noise ofi2_noise if dummy_t1==1, star(.05) bonferroni


gen confusion=1 if macro>=5 & macro<=10
replace confusion=0 if confusion==.

*TAB 6

estimates clear
regress ret1 c.ofi1_hum#i.dummy_t1 c.ofi1_noise#i.dummy_t1 c.ofi2_hum#i.dummy_t1  c.ofi2_noise#i.dummy_t1,  coeflegend
eststo

*cross impact
test  _b[1.dummy_t1#c.ofi2_hum]=_b[0b.dummy_t1#c.ofi2_hum]
test  _b[1.dummy_t1#c.ofi2_noise]=_b[0b.dummy_t1#c.ofi2_noise]
*human vs noise
test  _b[1.dummy_t1#c.ofi2_hum]=_b[1.dummy_t1#c.ofi2_noise]
test  _b[0b.dummy_t1#c.ofi2_hum]=_b[0b.dummy_t1#c.ofi2_noise]
*diff in diff
test  (_b[1.dummy_t1#c.ofi2_noise]-_b[0b.dummy_t1#c.ofi2_noise])=(_b[1.dummy_t1#c.ofi2_hum]-_b[0b.dummy_t1#c.ofi2_hum])


*self impact
test  _b[1.dummy_t1#c.ofi1_hum]=_b[0b.dummy_t1#c.ofi1_hum]
test  _b[1.dummy_t1#c.ofi1_noise]=_b[0b.dummy_t1#c.ofi1_noise]
*human vs noise
test  _b[0b.dummy_t1#c.ofi1_hum]=_b[0b.dummy_t1#c.ofi1_noise]
test  _b[1.dummy_t1#c.ofi1_hum]=_b[0b.dummy_t1#c.ofi1_noise]

*diff in diff
test  (_b[1.dummy_t1#c.ofi1_noise]-_b[0b.dummy_t1#c.ofi1_noise])=(_b[1.dummy_t1#c.ofi1_hum]-_b[0b.dummy_t1#c.ofi1_hum])




****ret2
regress ret2 c.ofi1_hum#i.dummy_t1 c.ofi1_noise#i.dummy_t1 c.ofi2_hum#i.dummy_t1  c.ofi2_noise#i.dummy_t1,  coeflegend
eststo

*cross-impact
test  _b[1.dummy_t1#c.ofi1_hum]=_b[0b.dummy_t1#c.ofi1_hum]
test  _b[1.dummy_t1#c.ofi1_noise]=_b[0b.dummy_t1#c.ofi1_noise]
*human vs noise
test  _b[1.dummy_t1#c.ofi1_hum]=_b[1.dummy_t1#c.ofi1_noise]
test  _b[0b.dummy_t1#c.ofi1_hum]=_b[0b.dummy_t1#c.ofi1_noise]

*diff in diff
test  (_b[1.dummy_t1#c.ofi1_noise]-_b[0b.dummy_t1#c.ofi1_noise])=(_b[1.dummy_t1#c.ofi1_hum]-_b[0b.dummy_t1#c.ofi1_hum])


*self impact
test  _b[1.dummy_t1#c.ofi2_hum]=_b[0b.dummy_t1#c.ofi2_hum]
test  _b[1.dummy_t1#c.ofi2_noise]=_b[0b.dummy_t1#c.ofi2_noise]
*human vs noise
test  _b[0b.dummy_t1#c.ofi2_hum]=_b[0b.dummy_t1#c.ofi2_noise]
test  _b[1.dummy_t1#c.ofi2_hum]=_b[0b.dummy_t1#c.ofi2_noise]

*diff in diff
test  (_b[1.dummy_t1#c.ofi2_noise]-_b[0b.dummy_t1#c.ofi2_noise])=(_b[1.dummy_t1#c.ofi2_hum]-_b[0b.dummy_t1#c.ofi2_hum])




***TAB 7
* RET1

regress ret1 c.ofi1_hum#i.dummy_t1#i.confusion c.ofi1_noise#i.dummy_t1#i.confusion c.ofi2_hum#i.dummy_t1#i.confusion  c.ofi2_noise#i.dummy_t1#i.confusion,  coeflegend
eststo

***cross-impact
test _b[1.dummy_t1#1.confusion#c.ofi2_hum]=_b[0b.dummy_t1#1.confusion#c.ofi2_hum]
test _b[1.dummy_t1#1.confusion#c.ofi2_noise]=_b[0b.dummy_t1#1.confusion#c.ofi2_noise]

test  _b[1.dummy_t1#0b.confusion#c.ofi2_hum]= _b[0b.dummy_t1#0b.confusion#c.ofi2_hum]
test  _b[1.dummy_t1#0b.confusion#c.ofi2_noise]= _b[0b.dummy_t1#0b.confusion#c.ofi2_noise]
*human vs noise
test _b[1.dummy_t1#1.confusion#c.ofi2_noise]=_b[1.dummy_t1#1.confusion#c.ofi2_hum]
test _b[1.dummy_t1#0b.confusion#c.ofi2_noise]=_b[1.dummy_t1#0b.confusion#c.ofi2_hum]

test  _b[0b.dummy_t1#1.confusion#c.ofi2_noise]= _b[0b.dummy_t1#1.confusion#c.ofi2_hum]
test  _b[0b.dummy_t1#0b.confusion#c.ofi2_noise]= _b[0b.dummy_t1#0b.confusion#c.ofi2_hum]

*diff in diff
test  (_b[1.dummy_t1#1.confusion#c.ofi2_noise]-_b[0b.dummy_t1#1.confusion#c.ofi2_noise])=(_b[1.dummy_t1#1.confusion#c.ofi2_hum]-_b[0b.dummy_t1#1.confusion#c.ofi2_hum])

test  (_b[1.dummy_t1#0b.confusion#c.ofi2_noise]-_b[0b.dummy_t1#0b.confusion#c.ofi2_noise])=(_b[1.dummy_t1#0b.confusion#c.ofi2_hum]-_b[0b.dummy_t1#0b.confusion#c.ofi2_hum])

***self-impact
test _b[1.dummy_t1#1.confusion#c.ofi1_hum]=_b[0b.dummy_t1#1.confusion#c.ofi1_hum]
test _b[1.dummy_t1#1.confusion#c.ofi1_noise]=_b[0b.dummy_t1#1.confusion#c.ofi1_noise]

test  _b[1.dummy_t1#0b.confusion#c.ofi1_hum]= _b[0b.dummy_t1#0b.confusion#c.ofi1_hum]
test  _b[1.dummy_t1#0b.confusion#c.ofi1_noise]= _b[0b.dummy_t1#0b.confusion#c.ofi1_noise]

*human vs noise
test _b[1.dummy_t1#1.confusion#c.ofi1_noise]=_b[1.dummy_t1#1.confusion#c.ofi1_hum]
test _b[1.dummy_t1#0b.confusion#c.ofi1_noise]=_b[1.dummy_t1#0b.confusion#c.ofi1_hum]

test  _b[0b.dummy_t1#1.confusion#c.ofi1_noise]= _b[0b.dummy_t1#1.confusion#c.ofi1_hum]
test  _b[0b.dummy_t1#0b.confusion#c.ofi2_noise]= _b[0b.dummy_t1#0b.confusion#c.ofi1_hum]

*diff in diff
test  (_b[1.dummy_t1#1.confusion#c.ofi1_noise]-_b[0b.dummy_t1#1.confusion#c.ofi1_noise])=(_b[1.dummy_t1#1.confusion#c.ofi1_hum]-_b[0b.dummy_t1#1.confusion#c.ofi1_hum])

test  (_b[1.dummy_t1#0b.confusion#c.ofi2_noise]-_b[0b.dummy_t1#0b.confusion#c.ofi2_noise])=(_b[1.dummy_t1#0b.confusion#c.ofi2_hum]-_b[0b.dummy_t1#0b.confusion#c.ofi2_hum])




**RET2

regress ret2 c.ofi1_hum#i.dummy_t1#i.confusion c.ofi1_noise#i.dummy_t1#i.confusion c.ofi2_hum#i.dummy_t1#i.confusion  c.ofi2_noise#i.dummy_t1#i.confusion,  coeflegend

*cross-impact
eststo
test _b[1.dummy_t1#1.confusion#c.ofi1_hum]=_b[0b.dummy_t1#1.confusion#c.ofi1_hum]
test _b[1.dummy_t1#1.confusion#c.ofi1_noise]=_b[0b.dummy_t1#1.confusion#c.ofi1_noise]

test  _b[1.dummy_t1#0b.confusion#c.ofi1_hum]= _b[0b.dummy_t1#0b.confusion#c.ofi1_hum]
test  _b[1.dummy_t1#0b.confusion#c.ofi1_noise]= _b[0b.dummy_t1#0b.confusion#c.ofi1_noise]

*human vs noise
test _b[1.dummy_t1#1.confusion#c.ofi1_noise]=_b[1.dummy_t1#1.confusion#c.ofi1_hum]
test  _b[1.dummy_t1#0b.confusion#c.ofi1_noise]= _b[1.dummy_t1#0b.confusion#c.ofi1_hum]


test  _b[0b.dummy_t1#1.confusion#c.ofi1_noise]= _b[0b.dummy_t1#1.confusion#c.ofi1_hum]
test  _b[0b.dummy_t1#0b.confusion#c.ofi1_noise]= _b[0b.dummy_t1#0b.confusion#c.ofi1_hum]


*diff in diff
test  (_b[1.dummy_t1#1.confusion#c.ofi1_noise]-_b[0b.dummy_t1#1.confusion#c.ofi1_noise])=(_b[1.dummy_t1#1.confusion#c.ofi1_hum]-_b[0b.dummy_t1#1.confusion#c.ofi2_hum])

test  (_b[1.dummy_t1#0b.confusion#c.ofi1_noise]-_b[0b.dummy_t1#0b.confusion#c.ofi1_noise])=(_b[1.dummy_t1#0b.confusion#c.ofi1_hum]-_b[0b.dummy_t1#0b.confusion#c.ofi2_hum])


***self-impact
test _b[1.dummy_t1#1.confusion#c.ofi2_hum]=_b[0b.dummy_t1#1.confusion#c.ofi2_hum]
test _b[1.dummy_t1#1.confusion#c.ofi2_noise]=_b[0b.dummy_t1#1.confusion#c.ofi2_noise]

test  _b[1.dummy_t1#0b.confusion#c.ofi2_hum]= _b[0b.dummy_t1#0b.confusion#c.ofi2_hum]
test  _b[1.dummy_t1#0b.confusion#c.ofi2_noise]= _b[0b.dummy_t1#0b.confusion#c.ofi2_noise]

*human vs noise
test _b[1.dummy_t1#1.confusion#c.ofi2_noise]=_b[1.dummy_t1#1.confusion#c.ofi2_hum]
test _b[1.dummy_t1#0b.confusion#c.ofi2_noise]=_b[1.dummy_t1#0b.confusion#c.ofi2_hum]

test  _b[0b.dummy_t1#1.confusion#c.ofi2_noise]= _b[0b.dummy_t1#1.confusion#c.ofi2_hum]
test  _b[0b.dummy_t1#0b.confusion#c.ofi2_noise]= _b[0b.dummy_t1#0b.confusion#c.ofi2_hum]

*diff in diff
test  (_b[1.dummy_t1#1.confusion#c.ofi2_noise]-_b[0b.dummy_t1#1.confusion#c.ofi2_noise])=(_b[1.dummy_t1#1.confusion#c.ofi2_hum]-_b[0b.dummy_t1#1.confusion#c.ofi2_hum])

test  (_b[1.dummy_t1#0b.confusion#c.ofi2_noise]-_b[0b.dummy_t1#0b.confusion#c.ofi2_noise])=(_b[1.dummy_t1#0b.confusion#c.ofi2_hum]-_b[0b.dummy_t1#0b.confusion#c.ofi2_hum])


*********************
* DATA SIMULATION   *
*********************
*********************************
* together simulated + observed *
*********************************

use DATA_Human_Noise_OFI.dta, clear

rename dummy_sep dummy_t1
gen simulation=0

append using DATA_merged_sim_30nt.dta
replace simulation=1 if simulation==.

gen macro=1 if period>=1 & period<=5
replace macro=2 if period>=6 & period<=10
replace macro=3 if period>=11 & period<=15
replace macro=4 if period>=16 & period<=20
replace macro=5 if period>=21 & period<=25
replace macro=6 if period>=26 & period<=30
replace macro=7 if period>=31 & period<=35
replace macro=8 if period>=36 & period<=40
replace macro=9 if period>=41 & period<=45
replace macro=10 if period>=46 & period<=50
replace macro=11 if period>=51 & period<=55
replace macro=12 if period>=56 & period<=60
replace macro=13 if period>=61 & period<=65
replace macro=14 if period>=66 & period<=70
replace macro=15 if period>=71 & period<=75


gen confusion=1 if macro>=5 & macro<=10
replace confusion=0 if confusion==.


replace ofi1_noise= ofi1 if ofi1_noise==.
replace ofi2_noise= ofi2 if ofi2_noise==.

*sutex2 ret1 ret2  ofi1 ofi2 ofi1_hum ofi1_noise ofi2_hum ofi2_noise if dummy_t1==1 & simulation==1, min  saving(summary_synthetic.tex)  digits(3)  replace
*sutex2 ret1 ret2  ofi1 ofi2 ofi1_hum ofi1_noise ofi2_hum ofi2_noise if dummy_t1==0 & simulation==1, min   saving(summary_synthetic.tex)  digits(3)  append


**TAB 9
estimates clear
regress ret1  c.ofi1_noise#i.dummy_t1#i.simulation  c.ofi2_noise#i.dummy_t1#i.simulation,  coeflegend
eststo


test _b[0b.dummy_t1#1.simulation#c.ofi2_noise]=_b[1.dummy_t1#1.simulation#c.ofi2_noise]
test  _b[0b.dummy_t1#0b.simulation#c.ofi2_noise]= _b[1.dummy_t1#0b.simulation#c.ofi2_noise]


test _b[0b.dummy_t1#0b.simulation#c.ofi2_noise]=_b[0b.dummy_t1#1.simulation#c.ofi2_noise]
test  _b[1.dummy_t1#0b.simulation#c.ofi2_noise]= _b[1.dummy_t1#1.simulation#c.ofi2_noise]

regress ret1  c.ofi1_noise#i.dummy_t1#i.simulation#i.confusion  c.ofi2_noise#i.dummy_t1#i.simulation#i.confusion,  coeflegend
eststo


test _b[0b.dummy_t1#1.simulation#0b.confusion#c.ofi2_noise]=_b[1.dummy_t1#1.simulation#0b.confusion#c.ofi2_noise]
test _b[0b.dummy_t1#1.simulation#1.confusion#c.ofi2_noise]=_b[1.dummy_t1#1.simulation#1.confusion#c.ofi2_noise]

test _b[0b.dummy_t1#0b.simulation#0b.confusion#c.ofi2_noise]=_b[1.dummy_t1#0b.simulation#0b.confusion#c.ofi2_noise]
test _b[0b.dummy_t1#0b.simulation#1.confusion#c.ofi2_noise]=_b[1.dummy_t1#0b.simulation#1.confusion#c.ofi2_noise]



test _b[0b.dummy_t1#0b.simulation#0b.confusion#c.ofi2_noise]=_b[0b.dummy_t1#1.simulation#0b.confusion#c.ofi2_noise]
test _b[0b.dummy_t1#0b.simulation#1.confusion#c.ofi2_noise]=_b[0b.dummy_t1#1.simulation#1.confusion#c.ofi2_noise]
test _b[1.dummy_t1#0b.simulation#0b.confusion#c.ofi2_noise]=_b[1.dummy_t1#1.simulation#0b.confusion#c.ofi2_noise]
test  _b[1.dummy_t1#0b.simulation#1.confusion#c.ofi2_noise]=_b[1.dummy_t1#1.simulation#1.confusion#c.ofi2_noise]


regress ret2  c.ofi1_noise#i.dummy_t1#i.simulation  c.ofi2_noise#i.dummy_t1#i.simulation,  coeflegend
eststo
test _b[0b.dummy_t1#1.simulation#c.ofi2_noise]=_b[1.dummy_t1#1.simulation#c.ofi2_noise]
test  _b[0b.dummy_t1#0b.simulation#c.ofi2_noise]= _b[1.dummy_t1#0b.simulation#c.ofi2_noise]


test _b[0b.dummy_t1#0b.simulation#c.ofi1_noise]=_b[0b.dummy_t1#1.simulation#c.ofi1_noise]
test  _b[1.dummy_t1#0b.simulation#c.ofi1_noise]= _b[1.dummy_t1#1.simulation#c.ofi1_noise]

regress ret2  c.ofi1_noise#i.dummy_t1#i.simulation#i.confusion  c.ofi2_noise#i.dummy_t1#i.simulation#i.confusion,  coeflegend
eststo

test _b[0b.dummy_t1#1.simulation#0b.confusion#c.ofi2_noise]=_b[1.dummy_t1#1.simulation#0b.confusion#c.ofi2_noise]
test _b[0b.dummy_t1#1.simulation#1.confusion#c.ofi2_noise]=_b[1.dummy_t1#1.simulation#1.confusion#c.ofi2_noise]

test _b[0b.dummy_t1#0b.simulation#0b.confusion#c.ofi2_noise]=_b[1.dummy_t1#0b.simulation#0b.confusion#c.ofi2_noise]
test _b[0b.dummy_t1#0b.simulation#1.confusion#c.ofi2_noise]=_b[1.dummy_t1#0b.simulation#1.confusion#c.ofi2_noise]



test _b[0b.dummy_t1#0b.simulation#0b.confusion#c.ofi1_noise]=_b[0b.dummy_t1#1.simulation#0b.confusion#c.ofi1_noise]
test _b[0b.dummy_t1#0b.simulation#1.confusion#c.ofi1_noise]=_b[0b.dummy_t1#1.simulation#1.confusion#c.ofi1_noise]
test _b[1.dummy_t1#0b.simulation#0b.confusion#c.ofi1_noise]=_b[1.dummy_t1#1.simulation#0b.confusion#c.ofi1_noise]
test  _b[1.dummy_t1#0b.simulation#1.confusion#c.ofi1_noise]=_b[1.dummy_t1#1.simulation#1.confusion#c.ofi1_noise]


