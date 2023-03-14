****************************************************************************************************
** FILE NAME:    HW2_310510221_2_ii.sp
** VERSION:      1.0 
** DATE:         MAR 14, 2023
** AUTHOR:       KUAN-WEI, CHEN, NYCU IEE
** CODE TYPE:    SPICE
** DESCRIPTION:  2023 Spring DIC / Homework2 / 2-ii
** MODIFICATION: 
** Date          Description
** 03/14         2. Do the power and timing analysis of the schmitt trigger 
**               which has two fanouts of the same Schmitt trigger.
****************************************************************************************************


********************************
**     Simulator setting      **
********************************
.option accurate
.option post           
.op
.TEMP 25.0

********************************
**     Library setting        **
********************************
.protect
.lib '../../bulk_32nm.l'TT
.unprotect

********************************
**     Parameter setting      **
********************************
.param xvdd = 0.9  
.param xvss = 0    
.global vdd gnd

********************************
**     Circuit description    **
********************************
** Schmitt trigger
.subckt schmitt in out 
m1 n12  in  gnd gnd nmos_svt w=560n l=32n ad=60.6536f as=44.1112f pd=1336.6n ps=1277.5n
m2 out  in  n12 gnd nmos_svt w=64n  l=32n ad=6.93184f as=5.04128f pd=344.62n ps=285.54n
m3 vdd  out n12 gnd nmos_svt w=64n  l=32n ad=6.93184f as=5.04128f pd=344.62n ps=285.54n
m4 n45  in  vdd vdd pmos_svt w=240n l=32n ad=25.9944f as=18.9048f pd=696.62n ps=637.54n
m5 out  in  n45 vdd pmos_svt w=64n  l=32n ad=6.93184f as=5.04128f pd=344.62n ps=285.54n
m6 vss  out n45 vdd pmos_svt w=64n  l=32n ad=6.93184f as=5.04128f pd=344.62n ps=285.54n
.ends

* * 2 fanouts of the same Schmitt trigger
Xsch1 vin   fnode schmitt
Xsch2 fnode out2  schmitt
Xsch3 fnode out3  schmitt


* pulse
* Vinn vin gnd pulse(0 xvdd 0ns 0.4ns 0.4ns 0.6ns 2ns)

* duration = 10 ns
Vinn vin gnd pwl(0n xvss 5n xvdd 10n xvss 15n xvdd 20n xvss)

* duration = 2 ns
* Vinn vin gnd pwl(0n xvss 1n xvdd 2n xvss 3n xvdd 4n xvss)


********************************
**     Power declaration      **
********************************
vvdd    vdd 0   xvdd
vvss    gnd 0   xvss


********************************
**     Analysis setting       **
********************************

* duration = 10 ns
.tran 0.01n 20n 

* duration = 2 ns
* .tran 0.01n 4n 

* * (a)
.meas tran tdr trig v(vin) val='0.5*xvdd' fall=2 targ v(fnode) val='0.5*xvdd' rise=2
.meas tran tdf trig v(vin) val='0.5*xvdd' rise=2 targ v(fnode) val='0.5*xvdd' fall=2


* * (b)
.probe power=par('-p(vvdd)')

* * duration = 10 ns
.meas tran AvgPower AVG power from=0.01n to=5n
.meas tran PeakPower MAX power from=0.01n to=5n

* * duration = 2 ns
* .meas tran AvgPower AVG power from=0.01n to=4n
* .meas tran PeakPower MAX power from=0.01n to=4n


* * (c) Get the leakage power
* .alter
* Vinn vin gnd 0.0
* .meas tran leakagepwr0 AVG power from=0.01n to=5n
* .meas tran leakagepwr0 AVG power from=0.01n to=4n

* .alter
* Vinn vin gnd 0.9
* .meas tran leakagepwr1 AVG power from=0.01n to=5n
* .meas tran leakagepwr1 AVG power from=0.01n to=4n

.end



