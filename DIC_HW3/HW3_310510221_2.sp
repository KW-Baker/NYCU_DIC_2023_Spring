****************************************************************************************************
** FILE NAME:    HW3_310510221_2.sp
** VERSION:      1.0 
** DATE:         MAR 26, 2023
** AUTHOR:       KUAN-WEI, CHEN, NYCU IEE
** CODE TYPE:    HSPICE
** DESCRIPTION:  2023 Spring DIC / Homework3 / 2
** MODIFICATION: 
** Date          Description
** 03/26         Using 7 nm CMOS FiFFT devices with VDD= 0.75 V, FF process corner and 
**               medium Vt CMOS process
**
**               2. Ring oscillator
**               According to the results of 1(b), design a 3-stage inverter-based ring oscillator 
**               with unit size inverter with better logic threshold voltage.
**               Set the initial voltage of each node so that it can oscillate.
**               Show in table form, the SPICE simulation results of oscillation frequency and power consumption.
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
.meas pavg AVG POWER
.meas pmax MAX POWER
.meas TRAN PERIOD TRIG V(input) VAL=0.386 RISE=1
+                 TARG V(input) VAL=0.386 RISE=2

********************************
**     Parameter setting      **
********************************
.param xvdd = 0.75
.param xvss = 0
.param simtime = 100p

********************************
**     Circuit description    **
********************************
.subckt inverter in out vdd vss
m1 out in vdd vdd pmos_rvt nfin = 1
m2 out in vss vss nmos_rvt nfin = 1
.ends

xinv1 input out1  vdd vss inverter
xinv2 out1  out2  vdd vss inverter
xinv3 out2  input vdd vss inverter

********************************
**     Power declaration      **
********************************
vvdd       vdd       0    xvdd
vvss       vss       0    xvss

********************************
**     Analysis setting       **
********************************
*initial condition
.ic v(input) = 0

.tran 1p simtime

.print FREQ = 1/PERIOD

.end
