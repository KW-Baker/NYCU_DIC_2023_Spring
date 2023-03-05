****************************************************************************************************
** FILE NAME:    HW1_310510221_1a.sp
** VERSION:      1.0 
** DATE:         MAR 01, 2023
** AUTHOR:       KUAN-WEI, CHEN, NYCU IEE
** CODE TYPE:    SPICE
** DESCRIPTION:  2023 Spring DIC / Homework1 / (1) Inverter a) 
** MODIFICATION: 
** Date          Description
** 03/01         Using 32 nm CMOS devices with VDD= 0.9 V, Wmin=64 nm, Lmin=32nm with 
**               resolution of 1nm; there are three kinds of Vt: High Vt, medium Vt and 
**               low Vt CMOS.
**
**               Keep L equal Lmin, design the W of each device (in table form) using medium 
**               Vt and high Vt (two cases) such that the logic threshold of the inverter is at 0.5 
**               VDD. Discuss your design procedures and the way you choose your MOS 
**               dimension.
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

* medium vt 
.param wp = 114n 

* high vt
*.param wp = 137n  

.param wn = 64n
.param cycle = 1n
.param simtime = 5n



********************************
**     Circuit description    **
********************************
* medium vt
m1 out in vdd vdd pmos_svt w=wp l=32n
m2 out in vss vss nmos_svt w=wn l=32n

* high vt
* m1 out in vdd vdd pmos_hvt w=wp l=32n
* m2 out in vss vss nmos_hvt w=wn l=32n

vin in vss 0v

********************************
**     Power declaration      **
********************************
vvdd       vdd       0    xvdd
vvss       vss       0    xvss
********************************
**     Analysis setting       **
********************************
.dc vin 0v 0.9v 0.01v

*** for dc sweep ***
* .dc vin 0v 0.9v 0.01v wp 64n 229n 1n
* .op 

.end   


