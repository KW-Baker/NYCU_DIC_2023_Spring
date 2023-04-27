****************************************************************************************************
** FILE NAME:    HW3_310510221_1b.sp
** VERSION:      1.0 
** DATE:         APR 24, 2023
** AUTHOR:       KUAN-WEI, CHEN, NYCU IEE
** CODE TYPE:    HSPICE
** DESCRIPTION:  2023 Spring DIC / Homework4 / 1
** MODIFICATION: 
** Date          Description
** 04/24         Using 7 nm CMOS FiFFT devices with VDD= 0.75 V, FF process corner and 
**               medium Vt CMOS process
**
**               /* Using 32 nm CMOS devices with VDD= 1.0 V, Wmin=64 nm, Lmin=32nm; using standard Vt CMOS */
**               /* Rise time and fall time of input signals are 0.04ns */
**               /* Do not forget to include reasonable AD, AS, PD and PS in your simulation */
**                Based on the design of (1), run SPICE to find the the propagation delay time (with pattern from 
**                000011110 to 000011111 (A[3:0]@B[3:0]@Cin). Determine the maximum propagation of a 
**                clock with the delay time estimated by SPICE for VDD=1.0 V. (20%)
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
.lib '../bulk_32nm.l'TT
.unprotect

********************************
**     Parameter setting      **
********************************
.global vdd gnd

.param xvdd = 1.0
.param xgnd = 0

* .param period = 2n
* .param period = 200p
* .param period = 300p
.param period = 250p

.param tr = 0.04n

********************************
**     Power declaration      **
********************************
vvdd vdd 0 xvdd
vvss gnd 0 xgnd

* ********************************
* **     Input declaration      **
* ********************************
VA1  A1  gnd pulse(0 xvdd 0.01n tr tr "(1*period-2*tr)/2" 'period')
VA2  A2  gnd pulse(0 xvdd 0.01n tr tr "(1*period-2*tr)/2" 'period')
VA3  A3  gnd pulse(0 xvdd 0.01n tr tr "(1*period-2*tr)/2" 'period')
VA4  A4  gnd pulse(0 xvdd 0.01n tr tr "(1*period-2*tr)/2" 'period')
VB1  B1  gnd pulse(xvdd 0 0.01n tr tr "(1*period-2*tr)/2" 'period')
VB2  B2  gnd pulse(xvdd 0 0.01n tr tr "(1*period-2*tr)/2" 'period')
VB3  B3  gnd pulse(xvdd 0 0.01n tr tr "(1*period-2*tr)/2" 'period')
VB4  B4  gnd pulse(xvdd 0 0.01n tr tr "(1*period-2*tr)/2" 'period')
VCIN Cin gnd pulse(0 xvdd 0.01n tr tr "(1*period-2*tr)/2" 'period')
**VCIN CIN gnd pulse(VL VH delay trise tfall pulse_width period)

********************************
**     Circuit description    **
********************************
* Inverter *
.subckt INV in out wp=128n wn=64n l=32n
	m1 out in vdd vdd pmos_svt w='wp' l='l' ad='wp*78.77n' as='wp*78.77n' pd='2*(wp+78.77n)' ps='2*(wp+78.77n)'
	m2 out in gnd gnd nmos_svt w='wn' l='l' ad='wn*78.77n' as='wn*78.77n' pd='2*(wn+78.77n)' ps='2*(wn+78.77n)'
.ends

* FO4 *
.subckt FO4 in
	X1 in fo1 INV
	X2 in fo2 INV
	X3 in fo3 INV
	X4 in fo4 INV
.ends

* Full Adder Bar *
.subckt FA_1 A B C CB SB wp1=690n wp2=256n wp3=384n  wn1=345n wn2=128n wn3=192n l=32n   
	** CARRY_BAR **
	mp1   n1  A  vdd vdd pmos_svt w='wp1' l='l' ad='wp1*78.77n' as='wp1*78.77n' pd='2*(wp1+78.77n)' ps='2*(wp1+78.77n)'
	mp2   n1  B  vdd vdd pmos_svt w='wp1' l='l' ad='wp1*78.77n' as='wp1*78.77n' pd='2*(wp1+78.77n)' ps='2*(wp1+78.77n)'
	mp3   n3  A  vdd vdd pmos_svt w='wp1' l='l' ad='wp1*78.77n' as='wp1*78.77n' pd='2*(wp1+78.77n)' ps='2*(wp1+78.77n)'
	mp4   CB  C   n1 vdd pmos_svt w='wp1' l='l' ad='wp1*78.77n' as='wp1*78.77n' pd='2*(wp1+78.77n)' ps='2*(wp1+78.77n)'
	mp5   CB  B   n3 vdd pmos_svt w='wp1' l='l' ad='wp1*78.77n' as='wp1*78.77n' pd='2*(wp1+78.77n)' ps='2*(wp1+78.77n)'
 
	mn1   CB  C   n2 gnd nmos_svt w='wn1' l='l' ad='wn1*78.77n' as='wn1*78.77n' pd='2*(wn1+78.77n)' ps='2*(wn1+78.77n)'
	mn2   CB  B   n4 gnd nmos_svt w='wn1' l='l' ad='wn1*78.77n' as='wn1*78.77n' pd='2*(wn1+78.77n)' ps='2*(wn1+78.77n)'
	mn3   n2  A  gnd gnd nmos_svt w='wn1' l='l' ad='wn1*78.77n' as='wn1*78.77n' pd='2*(wn1+78.77n)' ps='2*(wn1+78.77n)'
	mn4   n2  B  gnd gnd nmos_svt w='wn1' l='l' ad='wn1*78.77n' as='wn1*78.77n' pd='2*(wn1+78.77n)' ps='2*(wn1+78.77n)'
	mn5   n4  A  gnd gnd nmos_svt w='wn1' l='l' ad='wn1*78.77n' as='wn1*78.77n' pd='2*(wn1+78.77n)' ps='2*(wn1+78.77n)'
	** SUM_BAR **
	mp6   n5  A  vdd vdd pmos_svt w='wp2' l='l' ad='wp2*78.77n' as='wp2*78.77n' pd='2*(wp2+78.77n)' ps='2*(wp2+78.77n)'
	mp7   n5  B  vdd vdd pmos_svt w='wp2' l='l' ad='wp2*78.77n' as='wp2*78.77n' pd='2*(wp2+78.77n)' ps='2*(wp2+78.77n)'
	mp8   n5  C  vdd vdd pmos_svt w='wp2' l='l' ad='wp2*78.77n' as='wp2*78.77n' pd='2*(wp2+78.77n)' ps='2*(wp2+78.77n)'
	mp9   SB CB   n5 vdd pmos_svt w='wp2' l='l' ad='wp2*78.77n' as='wp2*78.77n' pd='2*(wp2+78.77n)' ps='2*(wp2+78.77n)'

	mp10  n7  A  vdd vdd pmos_svt w='wp3' l='l' ad='wp3*78.77n' as='wp3*78.77n' pd='2*(wp3+78.77n)' ps='2*(wp3+78.77n)'
	mp11  n8  B   n7 vdd pmos_svt w='wp3' l='l' ad='wp3*78.77n' as='wp3*78.77n' pd='2*(wp3+78.77n)' ps='2*(wp3+78.77n)'
	mp12  SB  C   n8 vdd pmos_svt w='wp3' l='l' ad='wp3*78.77n' as='wp3*78.77n' pd='2*(wp3+78.77n)' ps='2*(wp3+78.77n)'

	mn6   SB CB   n6 gnd nmos_svt w='wn2' l='l' ad='wn2*78.77n' as='wn2*78.77n' pd='2*(wn2+78.77n)' ps='2*(wn2+78.77n)'
	mn7   n6  A  gnd gnd nmos_svt w='wn2' l='l' ad='wn2*78.77n' as='wn2*78.77n' pd='2*(wn2+78.77n)' ps='2*(wn2+78.77n)'
	mn8   n6  B  gnd gnd nmos_svt w='wn2' l='l' ad='wn2*78.77n' as='wn2*78.77n' pd='2*(wn2+78.77n)' ps='2*(wn2+78.77n)'
	mn9   n6  C  gnd gnd nmos_svt w='wn2' l='l' ad='wn2*78.77n' as='wn2*78.77n' pd='2*(wn2+78.77n)' ps='2*(wn2+78.77n)'

	mn10  SB  C   n9 gnd nmos_svt w='wn3' l='l' ad='wn3*78.77n' as='wn3*78.77n' pd='2*(wn3+78.77n)' ps='2*(wn3+78.77n)'
	mn11  n9  B  n10 gnd nmos_svt w='wn3' l='l' ad='wn3*78.77n' as='wn3*78.77n' pd='2*(wn3+78.77n)' ps='2*(wn3+78.77n)'
	mn12 n10  A  gnd gnd nmos_svt w='wn3' l='l' ad='wn3*78.77n' as='wn3*78.77n' pd='2*(wn3+78.77n)' ps='2*(wn3+78.77n)'
.ends

.subckt FA_2 A B C CB SB wp1=366n wp2=256n wp3=384n  wn1=183n wn2=128n wn3=192n l=32n   
	** CARRY_BAR **
	mp1   n1  A  vdd vdd pmos_svt w='wp1' l='l' ad='wp1*78.77n' as='wp1*78.77n' pd='2*(wp1+78.77n)' ps='2*(wp1+78.77n)'
	mp2   n1  B  vdd vdd pmos_svt w='wp1' l='l' ad='wp1*78.77n' as='wp1*78.77n' pd='2*(wp1+78.77n)' ps='2*(wp1+78.77n)'
	mp3   n3  A  vdd vdd pmos_svt w='wp1' l='l' ad='wp1*78.77n' as='wp1*78.77n' pd='2*(wp1+78.77n)' ps='2*(wp1+78.77n)'
	mp4   CB  C   n1 vdd pmos_svt w='wp1' l='l' ad='wp1*78.77n' as='wp1*78.77n' pd='2*(wp1+78.77n)' ps='2*(wp1+78.77n)'
	mp5   CB  B   n3 vdd pmos_svt w='wp1' l='l' ad='wp1*78.77n' as='wp1*78.77n' pd='2*(wp1+78.77n)' ps='2*(wp1+78.77n)'
 
	mn1   CB  C   n2 gnd nmos_svt w='wn1' l='l' ad='wn1*78.77n' as='wn1*78.77n' pd='2*(wn1+78.77n)' ps='2*(wn1+78.77n)'
	mn2   CB  B   n4 gnd nmos_svt w='wn1' l='l' ad='wn1*78.77n' as='wn1*78.77n' pd='2*(wn1+78.77n)' ps='2*(wn1+78.77n)'
	mn3   n2  A  gnd gnd nmos_svt w='wn1' l='l' ad='wn1*78.77n' as='wn1*78.77n' pd='2*(wn1+78.77n)' ps='2*(wn1+78.77n)'
	mn4   n2  B  gnd gnd nmos_svt w='wn1' l='l' ad='wn1*78.77n' as='wn1*78.77n' pd='2*(wn1+78.77n)' ps='2*(wn1+78.77n)'
	mn5   n4  A  gnd gnd nmos_svt w='wn1' l='l' ad='wn1*78.77n' as='wn1*78.77n' pd='2*(wn1+78.77n)' ps='2*(wn1+78.77n)'
	** SUM_BAR **
	mp6   n5  A  vdd vdd pmos_svt w='wp2' l='l' ad='wp2*78.77n' as='wp2*78.77n' pd='2*(wp2+78.77n)' ps='2*(wp2+78.77n)'
	mp7   n5  B  vdd vdd pmos_svt w='wp2' l='l' ad='wp2*78.77n' as='wp2*78.77n' pd='2*(wp2+78.77n)' ps='2*(wp2+78.77n)'
	mp8   n5  C  vdd vdd pmos_svt w='wp2' l='l' ad='wp2*78.77n' as='wp2*78.77n' pd='2*(wp2+78.77n)' ps='2*(wp2+78.77n)'
	mp9   SB CB   n5 vdd pmos_svt w='wp2' l='l' ad='wp2*78.77n' as='wp2*78.77n' pd='2*(wp2+78.77n)' ps='2*(wp2+78.77n)'

	mp10  n7  A  vdd vdd pmos_svt w='wp3' l='l' ad='wp3*78.77n' as='wp3*78.77n' pd='2*(wp3+78.77n)' ps='2*(wp3+78.77n)'
	mp11  n8  B   n7 vdd pmos_svt w='wp3' l='l' ad='wp3*78.77n' as='wp3*78.77n' pd='2*(wp3+78.77n)' ps='2*(wp3+78.77n)'
	mp12  SB  C   n8 vdd pmos_svt w='wp3' l='l' ad='wp3*78.77n' as='wp3*78.77n' pd='2*(wp3+78.77n)' ps='2*(wp3+78.77n)'

	mn6   SB CB   n6 gnd nmos_svt w='wn2' l='l' ad='wn2*78.77n' as='wn2*78.77n' pd='2*(wn2+78.77n)' ps='2*(wn2+78.77n)'
	mn7   n6  A  gnd gnd nmos_svt w='wn2' l='l' ad='wn2*78.77n' as='wn2*78.77n' pd='2*(wn2+78.77n)' ps='2*(wn2+78.77n)'
	mn8   n6  B  gnd gnd nmos_svt w='wn2' l='l' ad='wn2*78.77n' as='wn2*78.77n' pd='2*(wn2+78.77n)' ps='2*(wn2+78.77n)'
	mn9   n6  C  gnd gnd nmos_svt w='wn2' l='l' ad='wn2*78.77n' as='wn2*78.77n' pd='2*(wn2+78.77n)' ps='2*(wn2+78.77n)'

	mn10  SB  C   n9 gnd nmos_svt w='wn3' l='l' ad='wn3*78.77n' as='wn3*78.77n' pd='2*(wn3+78.77n)' ps='2*(wn3+78.77n)'
	mn11  n9  B  n10 gnd nmos_svt w='wn3' l='l' ad='wn3*78.77n' as='wn3*78.77n' pd='2*(wn3+78.77n)' ps='2*(wn3+78.77n)'
	mn12 n10  A  gnd gnd nmos_svt w='wn3' l='l' ad='wn3*78.77n' as='wn3*78.77n' pd='2*(wn3+78.77n)' ps='2*(wn3+78.77n)'
.ends

.subckt FA_3 A B C CB SB wp1=394n wp2=256n wp3=384n  wn1=197n wn2=128n wn3=192n l=32n   
	** CARRY_BAR **
	mp1   n1  A  vdd vdd pmos_svt w='wp1' l='l' ad='wp1*78.77n' as='wp1*78.77n' pd='2*(wp1+78.77n)' ps='2*(wp1+78.77n)'
	mp2   n1  B  vdd vdd pmos_svt w='wp1' l='l' ad='wp1*78.77n' as='wp1*78.77n' pd='2*(wp1+78.77n)' ps='2*(wp1+78.77n)'
	mp3   n3  A  vdd vdd pmos_svt w='wp1' l='l' ad='wp1*78.77n' as='wp1*78.77n' pd='2*(wp1+78.77n)' ps='2*(wp1+78.77n)'
	mp4   CB  C   n1 vdd pmos_svt w='wp1' l='l' ad='wp1*78.77n' as='wp1*78.77n' pd='2*(wp1+78.77n)' ps='2*(wp1+78.77n)'
	mp5   CB  B   n3 vdd pmos_svt w='wp1' l='l' ad='wp1*78.77n' as='wp1*78.77n' pd='2*(wp1+78.77n)' ps='2*(wp1+78.77n)'
 
	mn1   CB  C   n2 gnd nmos_svt w='wn1' l='l' ad='wn1*78.77n' as='wn1*78.77n' pd='2*(wn1+78.77n)' ps='2*(wn1+78.77n)'
	mn2   CB  B   n4 gnd nmos_svt w='wn1' l='l' ad='wn1*78.77n' as='wn1*78.77n' pd='2*(wn1+78.77n)' ps='2*(wn1+78.77n)'
	mn3   n2  A  gnd gnd nmos_svt w='wn1' l='l' ad='wn1*78.77n' as='wn1*78.77n' pd='2*(wn1+78.77n)' ps='2*(wn1+78.77n)'
	mn4   n2  B  gnd gnd nmos_svt w='wn1' l='l' ad='wn1*78.77n' as='wn1*78.77n' pd='2*(wn1+78.77n)' ps='2*(wn1+78.77n)'
	mn5   n4  A  gnd gnd nmos_svt w='wn1' l='l' ad='wn1*78.77n' as='wn1*78.77n' pd='2*(wn1+78.77n)' ps='2*(wn1+78.77n)'
	** SUM_BAR **
	mp6   n5  A  vdd vdd pmos_svt w='wp2' l='l' ad='wp2*78.77n' as='wp2*78.77n' pd='2*(wp2+78.77n)' ps='2*(wp2+78.77n)'
	mp7   n5  B  vdd vdd pmos_svt w='wp2' l='l' ad='wp2*78.77n' as='wp2*78.77n' pd='2*(wp2+78.77n)' ps='2*(wp2+78.77n)'
	mp8   n5  C  vdd vdd pmos_svt w='wp2' l='l' ad='wp2*78.77n' as='wp2*78.77n' pd='2*(wp2+78.77n)' ps='2*(wp2+78.77n)'
	mp9   SB CB   n5 vdd pmos_svt w='wp2' l='l' ad='wp2*78.77n' as='wp2*78.77n' pd='2*(wp2+78.77n)' ps='2*(wp2+78.77n)'

	mp10  n7  A  vdd vdd pmos_svt w='wp3' l='l' ad='wp3*78.77n' as='wp3*78.77n' pd='2*(wp3+78.77n)' ps='2*(wp3+78.77n)'
	mp11  n8  B   n7 vdd pmos_svt w='wp3' l='l' ad='wp3*78.77n' as='wp3*78.77n' pd='2*(wp3+78.77n)' ps='2*(wp3+78.77n)'
	mp12  SB  C   n8 vdd pmos_svt w='wp3' l='l' ad='wp3*78.77n' as='wp3*78.77n' pd='2*(wp3+78.77n)' ps='2*(wp3+78.77n)'

	mn6   SB CB   n6 gnd nmos_svt w='wn2' l='l' ad='wn2*78.77n' as='wn2*78.77n' pd='2*(wn2+78.77n)' ps='2*(wn2+78.77n)'
	mn7   n6  A  gnd gnd nmos_svt w='wn2' l='l' ad='wn2*78.77n' as='wn2*78.77n' pd='2*(wn2+78.77n)' ps='2*(wn2+78.77n)'
	mn8   n6  B  gnd gnd nmos_svt w='wn2' l='l' ad='wn2*78.77n' as='wn2*78.77n' pd='2*(wn2+78.77n)' ps='2*(wn2+78.77n)'
	mn9   n6  C  gnd gnd nmos_svt w='wn2' l='l' ad='wn2*78.77n' as='wn2*78.77n' pd='2*(wn2+78.77n)' ps='2*(wn2+78.77n)'

	mn10  SB  C   n9 gnd nmos_svt w='wn3' l='l' ad='wn3*78.77n' as='wn3*78.77n' pd='2*(wn3+78.77n)' ps='2*(wn3+78.77n)'
	mn11  n9  B  n10 gnd nmos_svt w='wn3' l='l' ad='wn3*78.77n' as='wn3*78.77n' pd='2*(wn3+78.77n)' ps='2*(wn3+78.77n)'
	mn12 n10  A  gnd gnd nmos_svt w='wn3' l='l' ad='wn3*78.77n' as='wn3*78.77n' pd='2*(wn3+78.77n)' ps='2*(wn3+78.77n)'
.ends

.subckt FA_4 A B C CB SB wp1=448n wp2=280n wp3=430n  wn1=224n wn2=140n wn3=215n l=32n   
	** CARRY_BAR **
	mp1   n1  A  vdd vdd pmos_svt w='wp1' l='l' ad='wp1*78.77n' as='wp1*78.77n' pd='2*(wp1+78.77n)' ps='2*(wp1+78.77n)'
	mp2   n1  B  vdd vdd pmos_svt w='wp1' l='l' ad='wp1*78.77n' as='wp1*78.77n' pd='2*(wp1+78.77n)' ps='2*(wp1+78.77n)'
	mp3   n3  A  vdd vdd pmos_svt w='wp1' l='l' ad='wp1*78.77n' as='wp1*78.77n' pd='2*(wp1+78.77n)' ps='2*(wp1+78.77n)'
	mp4   CB  C   n1 vdd pmos_svt w='wp1' l='l' ad='wp1*78.77n' as='wp1*78.77n' pd='2*(wp1+78.77n)' ps='2*(wp1+78.77n)'
	mp5   CB  B   n3 vdd pmos_svt w='wp1' l='l' ad='wp1*78.77n' as='wp1*78.77n' pd='2*(wp1+78.77n)' ps='2*(wp1+78.77n)'
 
	mn1   CB  C   n2 gnd nmos_svt w='wn1' l='l' ad='wn1*78.77n' as='wn1*78.77n' pd='2*(wn1+78.77n)' ps='2*(wn1+78.77n)'
	mn2   CB  B   n4 gnd nmos_svt w='wn1' l='l' ad='wn1*78.77n' as='wn1*78.77n' pd='2*(wn1+78.77n)' ps='2*(wn1+78.77n)'
	mn3   n2  A  gnd gnd nmos_svt w='wn1' l='l' ad='wn1*78.77n' as='wn1*78.77n' pd='2*(wn1+78.77n)' ps='2*(wn1+78.77n)'
	mn4   n2  B  gnd gnd nmos_svt w='wn1' l='l' ad='wn1*78.77n' as='wn1*78.77n' pd='2*(wn1+78.77n)' ps='2*(wn1+78.77n)'
	mn5   n4  A  gnd gnd nmos_svt w='wn1' l='l' ad='wn1*78.77n' as='wn1*78.77n' pd='2*(wn1+78.77n)' ps='2*(wn1+78.77n)'
	** SUM_BAR **
	mp6   n5  A  vdd vdd pmos_svt w='wp2' l='l' ad='wp2*78.77n' as='wp2*78.77n' pd='2*(wp2+78.77n)' ps='2*(wp2+78.77n)'
	mp7   n5  B  vdd vdd pmos_svt w='wp2' l='l' ad='wp2*78.77n' as='wp2*78.77n' pd='2*(wp2+78.77n)' ps='2*(wp2+78.77n)'
	mp8   n5  C  vdd vdd pmos_svt w='wp2' l='l' ad='wp2*78.77n' as='wp2*78.77n' pd='2*(wp2+78.77n)' ps='2*(wp2+78.77n)'
	mp9   SB CB   n5 vdd pmos_svt w='wp2' l='l' ad='wp2*78.77n' as='wp2*78.77n' pd='2*(wp2+78.77n)' ps='2*(wp2+78.77n)'

	mp10  n7  A  vdd vdd pmos_svt w='wp3' l='l' ad='wp3*78.77n' as='wp3*78.77n' pd='2*(wp3+78.77n)' ps='2*(wp3+78.77n)'
	mp11  n8  B   n7 vdd pmos_svt w='wp3' l='l' ad='wp3*78.77n' as='wp3*78.77n' pd='2*(wp3+78.77n)' ps='2*(wp3+78.77n)'
	mp12  SB  C   n8 vdd pmos_svt w='wp3' l='l' ad='wp3*78.77n' as='wp3*78.77n' pd='2*(wp3+78.77n)' ps='2*(wp3+78.77n)'

	mn6   SB CB   n6 gnd nmos_svt w='wn2' l='l' ad='wn2*78.77n' as='wn2*78.77n' pd='2*(wn2+78.77n)' ps='2*(wn2+78.77n)'
	mn7   n6  A  gnd gnd nmos_svt w='wn2' l='l' ad='wn2*78.77n' as='wn2*78.77n' pd='2*(wn2+78.77n)' ps='2*(wn2+78.77n)'
	mn8   n6  B  gnd gnd nmos_svt w='wn2' l='l' ad='wn2*78.77n' as='wn2*78.77n' pd='2*(wn2+78.77n)' ps='2*(wn2+78.77n)'
	mn9   n6  C  gnd gnd nmos_svt w='wn2' l='l' ad='wn2*78.77n' as='wn2*78.77n' pd='2*(wn2+78.77n)' ps='2*(wn2+78.77n)'

	mn10  SB  C   n9 gnd nmos_svt w='wn3' l='l' ad='wn3*78.77n' as='wn3*78.77n' pd='2*(wn3+78.77n)' ps='2*(wn3+78.77n)'
	mn11  n9  B  n10 gnd nmos_svt w='wn3' l='l' ad='wn3*78.77n' as='wn3*78.77n' pd='2*(wn3+78.77n)' ps='2*(wn3+78.77n)'
	mn12 n10  A  gnd gnd nmos_svt w='wn3' l='l' ad='wn3*78.77n' as='wn3*78.77n' pd='2*(wn3+78.77n)' ps='2*(wn3+78.77n)'
.ends


* 4-bit Ripple Adder *
.subckt RA4 A1 A2 A3 A4 B1 B2 B3 B4 Cin S1 S2 S3 S4 Cout
	XINV1  A1    A1_   INV
	XINV2  A1_   A1__  INV 
	XINV3  A2    A2_   INV
	XINV4  A3    A3_   INV
	XINV5  A3_   A3__  INV
	XINV6  A4    A4_   INV

	XINV7  B1    B1_   INV
	XINV8  B1_   B1__  INV 
	XINV9  B2    B2_   INV
	XINV10 B3    B3_   INV
	XINV11 B3_   B3__  INV
	XINV12 B4    B4_   INV

	XINV13 Cin   Cin_  INV
	XINV14 Cin_  Cin__ INV
	
	XINV15 S1_ S1  INV
	XINV16 S3_ S3  INV

	XFA1   A1__  B1__  Cin__ C1_  S1_ FA_1
	XFA2   A2_   B2_   C1_   C2   S2  FA_2
	XFA3   A3__  B3__  C2    C3_  S3_ FA_3
	XFA4   A4_   B4_   C3_   Cout S4  FA_4
.ends

XRA4   A1 A2 A3 A4 B1 B2 B3 B4 Cin S1 S2 S3 S4 Cout RA4
XLOAD1 S1   FO4
XLOAD2 S2   FO4
XLOAD3 S3   FO4
XLOAD4 S4   FO4
XLOAD5 Cout FO4

********************************
**     Analysis setting       **
********************************
.tran 0.1p '3*period' 


********************************
**          Measure           **
********************************

.meas tran AvgPower  avg  power
.meas tran PeakPower MAX  power
* .meas tran LeakagePower AVG  power

.end   

