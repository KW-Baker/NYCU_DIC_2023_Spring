****************************************************************************************************
** FILE NAME:    HW3_310510221_1a.sp
** VERSION:      1.0 
** DATE:         MAR 26, 2023
** AUTHOR:       KUAN-WEI, CHEN, NYCU IEE
** CODE TYPE:    HSPICE
** DESCRIPTION:  2023 Spring DIC / Homework3 / 1
** MODIFICATION: 
** Date          Description
** 03/26         Using 7 nm CMOS FiFFT devices with VDD= 0.75 V, FF process corner and 
**               medium Vt CMOS process
**
**               1. MOS and Inverter
**               a) Run SPICE to draw the I-V DC curves (like the one in Fig.2.7 of page A2-
**                  2 with Vgs of 0.75, 0.55, 0.35) for PMOS and NMOS with Fin n=1. In 
**                  table form, mark Ids_max (Vgs=Vds= Vdd). Discuss the results.
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
.include '../7nm_TT_160803.pm'
.unprotect

********************************
**     Parameter setting      **
********************************
.param xvdd = 0.75
.param xvss = 0

********************************
**     Circuit description    **
********************************
*m Drain Gate Source Bulk pmos/nmos nfin
m1 vdsp vgsp vdd vdd pmos_rvt nfin = 1
m2 vdsn vgsn vss vss nmos_rvt nfin = 1

********************************
**     Power declaration      **
********************************
vvdd       vdd       0    xvdd
vvss       vss       0    xvss

********************************
**     Input declaration      **
********************************
vdsp      vdsp      vdd      0
vdsn      vdsn      vss      0
vgsp      vgsp      vdd      0
vgsn      vgsn      vss      0

********************************
**     Analysis setting       **
********************************
* test pmos and nmos respectively
.dc vdsp 0 -0.75 -0.01   sweep vgsp -0.35 -0.75 -0.2
.dc vdsn 0  0.75  0.01   sweep vgsn 0.35 0.75 0.2
.probe i(*)
.print i(*)


.end   
