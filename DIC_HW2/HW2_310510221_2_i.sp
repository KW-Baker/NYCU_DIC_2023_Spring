****************************************************************************************************
** FILE NAME:    HW2_310510221_2_i.sp
** VERSION:      1.0 
** DATE:         MAR 14, 2023
** AUTHOR:       KUAN-WEI, CHEN, NYCU IEE
** CODE TYPE:    SPICE
** DESCRIPTION:  2023 Spring DIC / Homework2 / 2-i
** MODIFICATION: 
** Date          Description
** 03/14         (i) (10%)Run SPICE to get the input and output capacitance of the Schmitt trigger
**               when input and output are in 0/1 and 1/0 respectively (Be careful to indicate the Ad, 
**               AS, PD, PS)
****************************************************************************************************


********************************
**     Simulator setting      **
********************************
.option accurate
.option post 
.option captab            
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
.param wp = 64n 
.param wn = 64n
.param lp = 32n
.param ln = 32n
.param cycle = 1n
.param simtime = 5n

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



********************************
**     Power declaration      **
********************************
vvdd       vdd       0    xvdd
vvss       vss       0    xvss

* ********************************
* **     Input declaration      **
* ********************************
* input = 0.9 v
Vin        vin    vss    0.9
.option captab
.alter

* input = 0.0 v
Vin        vin    vss    0.0


********************************
**     Analysis setting       **
********************************
* .dc vin   0v   0.9v   0.01v 
* .dc vin 0.9v     0v  -0.01v
