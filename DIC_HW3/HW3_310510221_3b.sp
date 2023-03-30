****************************************************************************************************
** FILE NAME:    HW3_310510221_3b.sp
** VERSION:      1.0 
** DATE:         MAR 26, 2023
** AUTHOR:       KUAN-WEI, CHEN, NYCU IEE
** CODE TYPE:    HSPICE
** DESCRIPTION:  2023 Spring DIC / Homework3 / 3
** MODIFICATION: 
** Date          Description
** 03/26         Using 7 nm CMOS FiFFT devices with VDD= 0.75 V, FF process corner and 
**               medium Vt CMOS process
**
**                3. (50%) Design a dynamic D register as shown in Fig.1 with propose size of NMOS 
**                   and PMOS to have better tsetup, tpcq, tpdq and thold time. Both D and CLK 
**                   has rise time and fall time of 0.1ns ( 0V-0.75V).
****************************************************************************************************

********************************
**     Simulator setting      **
********************************
.option accurate
.option post           
.op
.TEMP 25.0

********************************
**      Library setting       **
********************************
.protect
.include '../7nm_TT_160803.pm'
.unprotect

********************************
**          Measure           **
********************************


********************************
**     Parameter setting      **
********************************
.param xvdd = 0.75
.param xvss = 0
.param simtime = 10ns
.param trise = 0.1n
.param tfall = 0.1n
.param period = 1ns

********************************
**     Circuit description    **
********************************

.subckt inv in out vdd vss
*m  D   G   S   B pmos/nmos nfin
m1 out in vdd vdd pmos_rvt nfin = 8
m2 out in vss vss nmos_rvt nfin = 8
.ends

.subckt dff clk d out vdd vss
*m   D   G   S    B   pmos/nmos nfin
*statge 1
m1  n5    d  vdd  vdd  pmos_rvt  nfin = 4
m2  n0  clk   n5  vdd  pmos_rvt  nfin = 4
m3  n0    d  vss  vss  nmos_rvt  nfin = 2

*statge 2
m4  n1  clk  vdd  vdd  pmos_rvt  nfin = 1
m5  n1   n0   n2  vss  nmos_rvt  nfin = 4
m6  n2  clk  vss  vss  nmos_rvt  nfin = 4

*statge 3
m7  n3   n1  vdd  vdd  pmos_rvt  nfin = 2
m8  n3  clk   n4  vss  nmos_rvt  nfin = 4
m9  n4   n1  vss  vss  nmos_rvt  nfin = 4

*stage 4
xinv  n3  out  vdd  vss  inv

.ends


xdff clk  d  out  vdd  vss  dff


********************************
**     Power declaration      **
********************************
vvdd       vdd       0    xvdd
vvss       vss       0    xvss

********************************
**     Input declaration      **
********************************
vclk      clk        0   pulse(0n  xvdd  0.3n  trise  tfall  0.47n  period)
vd         d         0   pulse(0  xvdd  0.1n  trise  tfall  0.97n  2n)
* vd         d         0   pwl(0n   xvss  2n   xvss  2.1n xvdd  5n   xvdd  5.1n xvss  6n   xvss  6.1n xvdd  7n   xvdd  7.1n xvss  8n   xvss  8.1n xvdd  8.5n xvdd  8.6n xvss  9n   xvss  10n  xvss)

********************************
**     Analysis setting       **
********************************
*initial condition
.tran 1p simtime

.end
