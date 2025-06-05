
cd "/Users/caterinagiannnetti/Dropbox/validation_bubbles_experimental_markets/Paper/submission/JBEE/revisions/DATA"



***use main dataset - market returns
use DATA_main.dta, clear


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
sum ret1 ret2  ofi1 ofi2 ofi1_hum ofi1_noise ofi2_hum ofi2_noise if dummy_t1==1
sum ret1 ret2  ofi1 ofi2 ofi1_hum ofi1_noise ofi2_hum ofi2_noise if dummy_t1==0

**** TAB 12 IN THE APPENDIX
pwcorr ofi1_hum ofi2_hum ofi1_noise ofi2_noise if dummy_t1==0, star(.01) bonferroni
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

append using DATA_simulated.dta
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

sum ret1 ret2  ofi1 ofi2 ofi1_hum ofi1_noise ofi2_hum ofi2_noise if dummy_t1==1 & simulation==1 
sum ret1 ret2  ofi1 ofi2 ofi1_hum ofi1_noise ofi2_hum ofi2_noise if dummy_t1==0 & simulation==1

**TAB 8
estimates clear
regress ret1  c.ofi1_noise#i.dummy_t1#i.simulation  c.ofi2_noise#i.dummy_t1#i.simulation,  coeflegend
eststo


test _b[0b.dummy_t1#1.simulation#c.ofi2_noise]=_b[1.dummy_t1#1.simulation#c.ofi2_noise]
test  _b[0b.dummy_t1#0b.simulation#c.ofi2_noise]= _b[1.dummy_t1#0b.simulation#c.ofi2_noise]


test _b[0b.dummy_t1#0b.simulation#c.ofi2_noise]=_b[0b.dummy_t1#1.simulation#c.ofi2_noise]
test  _b[1.dummy_t1#0b.simulation#c.ofi2_noise]= _b[1.dummy_t1#1.simulation#c.ofi2_noise]



regress ret2  c.ofi1_noise#i.dummy_t1#i.simulation  c.ofi2_noise#i.dummy_t1#i.simulation,  coeflegend
eststo
test _b[0b.dummy_t1#1.simulation#c.ofi2_noise]=_b[1.dummy_t1#1.simulation#c.ofi2_noise]
test  _b[0b.dummy_t1#0b.simulation#c.ofi2_noise]= _b[1.dummy_t1#0b.simulation#c.ofi2_noise]


test _b[0b.dummy_t1#0b.simulation#c.ofi1_noise]=_b[0b.dummy_t1#1.simulation#c.ofi1_noise]
test  _b[1.dummy_t1#0b.simulation#c.ofi1_noise]= _b[1.dummy_t1#1.simulation#c.ofi1_noise]



***TAB 9
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




drop if simulation==1

egen ofi1_average_t1=mean(ofi1_hum), by(macro session dummy_t1)
egen ofi2_average_t1=mean(ofi2_hum), by(macro session dummy_t1)


gen directionalist=1 if (ofi1_average_t1>0 & ofi2_average_t1>0) |(ofi1_average_t1<0 & ofi2_average_t1<0)
replace directionalist=1 if  (ofi1_average_t1==0 & ofi2_average_t1==0) 
replace directionalist=0 if  directionalist==.

gen neutral=1 if (ofi1_average_t1>0 & ofi2_average_t1<0) |(ofi1_average_t1<0 & ofi2_average_t1>0)
replace neutral=0 if  neutral==.

gen others=1 if neutral==0 | directionalist==0
replace others=0 if neutral==1 | directionalist==1

egen directionalist_t1=mean(directionalist), by(macro dummy_t1)

egen neutral_t1=mean(neutral), by(macro dummy_t1)
egen others_t1=mean(others), by(macro dummy_t1)



****figure 3
twoway   (connected neutral_t1 macro if dummy_t1==1, sort  lpattern(dash) color(edkblue) msymbol(circle)) (connected neutral_t1 macro if dummy_t1==0, sort  lpattern(dash) msymbol(circle) color(maroon)) ,  title("Trading strategies - Market Neutral") 

***figure 4
twoway (connected directionalist_t1 macro if dummy_t1==1, sort  lpattern(shortdash) color(edkblue) msymbol(circle)) (connected directionalist_t1 macro if dummy_t1==0, sort  lpattern(dash) msymbol(triangle) color(maroon)),  title("Trading strategies")


****
**use the dataset on total transactions for generate figure and descriptive
use MEX_T1&T2.dta, clear


egen agent_type=group(virtual marketmaker)

egen tot_type=sum(1), by(sessioncode  round event_type dummy_t1)
egen tot_type_player=sum(1), by(sessioncode round event_type agent_type dummy_t1)



gen share= tot_type_player/tot_type 

gen Cancellation=1 if event_type=="Cancellation"
replace Cancellation=0 if Cancellation==.


gen Submission=1 if event_type=="Submission"
replace Submission=0 if Submission==.

gen Execution=1 if event_type=="Execution"
replace Execution=0 if Execution==.

****TAB 1 T1-SEPARETED

preserve
bys sessioncode event_type round agent_type dummy_t1: keep if _n==1
regress share Cancellation  Execution Submission if agent_type==1 & dummy_t1==1, noconstant
regress share Cancellation  Execution Submission if agent_type==2 & dummy_t1==1, noconstant
regress share Cancellation  Execution Submission if agent_type==3 & dummy_t1==1, noconstant
****TAB 1 T2-UNIQUE
regress share Cancellation  Execution Submission if agent_type==1 & dummy_t1==0, noconstant
regress share Cancellation  Execution Submission if agent_type==2 & dummy_t1==0, noconstant
regress share Cancellation  Execution Submission if agent_type==3 & dummy_t1==0, noconstant

restore


keep if event_type=="Execution"



egen average_price_virtual=mean(price), by(round market virtual dummy_t1)
egen average_price=mean(price), by(round market session dummy_t1)
egen average_price_session=mean(price), by(round market session dummy_t1)

egen session_id=group(sessioncode)

generate FV_A=(15-round+1)*0.12 + 1.80
generate FV_B=(15-round+1)*0 + 2.80

bys sessioncode  groupid round market  dummy_t1: keep if _n==1



***figure 1

twoway (connected average_price_virtual  round if market=="A" & virtual==0 & dummy_t1==1, sort lpattern(shortdash) color(edkblue) msymbol(circle)) (connected average_price_virtual round if market=="A" & virtual==0 & dummy_t1==0, sort lpattern(dash) color(edkblue) msymbol(triangle))   (connected average_price_virtual  round if market=="B" & virtual==0 & dummy_t1==1, sort lpattern(shortdash) msymbol(circle) color(maroon)) (connected average_price_virtual round  if market=="B" & virtual==0 & dummy_t1==0, sort lpattern(dash) msymbol(triangle) color(maroon)) (connected  FV_A round if market=="A" & virtual==0, sort lpattern(dot) color( black) msymbol(point))  (connected  FV_B round if market=="B" & virtual==0 & dummy_t1==1, sort lpattern(dot) msymbol(point) color(black)), ylabel(0(1)5) title("Human players")

***figure 2
twoway (connected average_price_virtual  round if market=="A" & virtual==1 & dummy_t1==1, sort lpattern(shortdash) color(edkblue) msymbol(circle)) (connected average_price_virtual round if market=="A" & virtual==1 & dummy_t1==0, sort lpattern(dash) color(edkblue) msymbol(triangle))   (connected average_price_virtual  round if market=="B" & virtual==1 & dummy_t1==1, sort lpattern(shortdash) msymbol(circle) color(maroon)) (connected average_price_virtual round  if market=="B" & virtual==1 & dummy_t1==0, sort lpattern(dash) msymbol(triangle) color(maroon)) (connected  FV_A round if market=="A" & virtual==1, sort lpattern(dot) color( black) msymbol(point))  (connected  FV_B round if market=="B" & virtual==1 & dummy_t1==1, sort lpattern(dot) msymbol(point) color(black)), ylabel(0(1)5) 


**TAB 3 upper part (bottom part syntethic below)
gen RAD_A=abs(price-FV_A)/FV_A
gen RAD_B=abs(price-FV_B)/FV_B


sum RAD_A if market=="A" & dummy_t1==1
sum RAD_A if market=="A" & dummy_t1==0
sum RAD_B if market=="B" & dummy_t1==1
sum RAD_B if market=="B" & dummy_t1==0

****
**use the  dataset on simulated total transactions for generate  descriptive
use MEX_T1&T2_simulated.dta, clear


keep if event_type=="Execution"



egen average_price_virtual=mean(price), by(round market virtual dummy_t1)
egen average_price=mean(price), by(round market session dummy_t1)
egen average_price_session=mean(price), by(round market session dummy_t1)

egen session_id=group(sessioncode)

generate FV_A=(15-round+1)*0.12 + 1.80
generate FV_B=(15-round+1)*0 + 2.80

bys sessioncode  groupid round market  dummy_t1: keep if _n==1


**TAB 3 bottom part syntethic below)
gen RAD_A=abs(price-FV_A)/FV_A
gen RAD_B=abs(price-FV_B)/FV_B


sum RAD_A if market=="A" & dummy_t1==1
sum RAD_A if market=="A" & dummy_t1==0
sum RAD_B if market=="B" & dummy_t1==1
sum RAD_B if market=="B" & dummy_t1==0
