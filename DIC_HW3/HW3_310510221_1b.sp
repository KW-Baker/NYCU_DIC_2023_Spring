****************************************************************************************************
** FILE NAME:    HW3_310510221_1b.sp
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
**               b) Keep a unit size inverter with NMOS n=1and choose the n of PMOS for 
**                  n=1 and 2 to show the logic threshold voltage. Run SPICE to verify your 
**                  results by showing simulated waveforms.
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
.param cycle = 1n
.param simtime = 5n

********************************
**     Circuit description    **
********************************
.subckt inverter in out vdd vss
m1 out in vdd vdd pmos_rvt nfin = 1
* m1 out in vdd vdd pmos_rvt nfin = 2

m2 out in vss vss nmos_rvt nfin = 1
.ends

xinv in out vdd vss inverter

********************************
**     Power declaration      **
********************************
vvdd       vdd       0    xvdd
vvss       vss       0    xvss

********************************
**     Input declaration      **
********************************
vin        in      vss     0

********************************
**     Analysis setting       **
********************************
.dc vin    0v  0.75v   0.01v
.dc vin 0.75v     0v   -0.01v

.end   


