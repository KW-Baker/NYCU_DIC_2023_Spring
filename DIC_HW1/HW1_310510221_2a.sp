****************************************************************************************************
** FILE NAME:    HW1_310510221_2a.sp
** VERSION:      1.0 
** DATE:         MAR 01, 2023
** AUTHOR:       KUAN-WEI, CHEN, NYCU IEE
** CODE TYPE:    SPICE
** DESCRIPTION:  2023 Spring DIC / Homework1 / (2) CMOS Schmitt trigger a) 
** MODIFICATION: 
** Date          Description
** 03/01         Using 32 nm CMOS devices with VDD= 0.9 V, Wmin=64 nm, Lmin=32nm with 
**               resolution of 1nm; there are three kinds of Vt: High Vt, medium Vt and 
**               low Vt CMOS.
**              
**               Design a CMOS Schmitt trigger shown at Fig.1 using medium Vt such that 
**               Vout=0.5 VDD when V+ = 0.46-0.49 VDD, V- = 0.44~0.41 and both rising and 
**               falling △V are the same. Using medium Vt in your design .     
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
.param wp = 64n 
.param wn = 64n
.param lp = 32n
.param ln = 32n
.param cycle = 1n
.param simtime = 5n

********************************
**     Circuit description    **
********************************
*m? D   G    S   B  pmos/nmos  w  l
* 1st design 
* m1 n12  in  vss vss nmos_svt w=18894n l=ln
* m2 out  in  n12 vss nmos_svt w=64n    l=ln
* m3 vdd  out n12 vss nmos_svt w=64n    l=ln
* m4 n45  in  vdd vdd pmos_svt w=678n   l=lp
* m5 out  in  n45 vdd pmos_svt w=64n    l=lp
* m6 vss  out n45 vdd pmos_svt w=64n    l=lp

* 2nd design
* m1 n12  in  vss vss nmos_svt w=544n l=ln
* m2 out  in  n12 vss nmos_svt w=64n  l=ln
* m3 vdd  out n12 vss nmos_svt w=64n  l=ln
* m4 n45  in  vdd vdd pmos_svt w=192n l=lp
* m5 out  in  n45 vdd pmos_svt w=64n  l=lp
* m6 vss  out n45 vdd pmos_svt w=64n  l=lp

* 3rd design 
m1 n12  in  vss vss nmos_svt w=560n l=ln
m2 out  in  n12 vss nmos_svt w=64n  l=ln
m3 vdd  out n12 vss nmos_svt w=64n  l=ln
m4 n45  in  vdd vdd pmos_svt w=240n l=lp
m5 out  in  n45 vdd pmos_svt w=64n  l=lp
m6 vss  out n45 vdd pmos_svt w=64n  l=lp
vin in vss 0v

********************************
**     Power declaration      **
********************************
vvdd       vdd       0    xvdd
vvss       vss       0    xvss

********************************
**     Analysis setting       **
********************************
.dc vin   0v   0.9v   0.01v 
.dc vin 0.9v     0v  -0.01v
* .op 

.end   


