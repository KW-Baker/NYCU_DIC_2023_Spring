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
.param period = 150p

.param tr = 0.04n

********************************
**     Power declaration      **
********************************
vvdd vdd 0 xvdd
vvss gnd 0 xgnd

* ********************************
* **     Input declaration      **
* ********************************
VA1  A1  gnd xvdd
VA2  A2  gnd xvdd
VA3  A3  gnd xvdd
VA4  A4  gnd xvdd
VB1  B1  gnd xgnd
VB2  B2  gnd xgnd
VB3  B3  gnd xgnd
VB4  B4  gnd xgnd
* VCIN Cin gnd pulse(0 xvdd 50p 0.05n 0.05n 25p 150p)
* VCLK CLK gnd pulse(0 xvdd 50p  0.0n  0.0n  5p  10p)
VCIN Cin gnd pulse(0 xvdd 'period*2' tr tr "(1*period*4-2*tr)/2" 'period*4')
VCLK CLK gnd pulse(0 xvdd 0.0n   tr tr "(1*period-2*tr)/2"   'period')


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

* Inverter *
.subckt INV2 in out wp=1024n wn=1024n l=32n
	m1 out in vdd vdd pmos_svt w='wp' l='l' ad='wp*78.77n' as='wp*78.77n' pd='2*(wp+78.77n)' ps='2*(wp+78.77n)'
	m2 out in gnd gnd nmos_svt w='wn' l='l' ad='wn*78.77n' as='wn*78.77n' pd='2*(wn+78.77n)' ps='2*(wn+78.77n)'
.ends

* * DFF*
.subckt DFF clk d out w=64n l=32n
*m   D   G   S    B   pmos/nmos w l
*stage 1
m1  n5    d  vdd  vdd  pmos_svt  w='w*4' l='l' ad='w*4*78.77n' as='w*4*78.77n' pd='2*(w*4+78.77n)' ps='2*(w*4+78.77n)'
m2  n0  clk   n5  vdd  pmos_svt  w='w*4' l='l' ad='w*4*78.77n' as='w*4*78.77n' pd='2*(w*4+78.77n)' ps='2*(w*4+78.77n)'
m3  n0    d  gnd  gnd  nmos_svt  w='w*4' l='l' ad='w*4*78.77n' as='w*4*78.77n' pd='2*(w*4+78.77n)' ps='2*(w*4+78.77n)'

*stage 2
m4  n1  clk  vdd  vdd  pmos_svt  w='w*1' l='l' ad='w*1*78.77n' as='w*1*78.77n' pd='2*(w*1+78.77n)' ps='2*(w*1+78.77n)'
m5  n1   n0   n2  gnd  nmos_svt  w='w*2' l='l' ad='w*2*78.77n' as='w*2*78.77n' pd='2*(w*2+78.77n)' ps='2*(w*2+78.77n)'
m6  n2  clk  gnd  gnd  nmos_svt  w='w*2' l='l' ad='w*2*78.77n' as='w*2*78.77n' pd='2*(w*2+78.77n)' ps='2*(w*2+78.77n)'

*stage 3
m7  n3   n1  vdd  vdd  pmos_svt  w='w*3' l='l' ad='w*3*78.77n' as='w*3*78.77n' pd='2*(w*3+78.77n)' ps='2*(w*3+78.77n)'
m8  n3  clk   n4  gnd  nmos_svt  w='w*2' l='l' ad='w*2*78.77n' as='w*2*78.77n' pd='2*(w*2+78.77n)' ps='2*(w*2+78.77n)'
m9  n4   n1  gnd  gnd  nmos_svt  w='w*2' l='l' ad='w*2*78.77n' as='w*2*78.77n' pd='2*(w*2+78.77n)' ps='2*(w*2+78.77n)'

*stage 4
XINV  n3  out  INV2
.ends


* 4-bit Ripple Adder *
.subckt RA4 A1 A2 A3 A4 B1 B2 B3 B4 Cin S1_ff S2_ff S3_ff S4_ff Cout_ff CLK 
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

	* Pipelining Register*
	XDFF1   CLK A1__  A1_ff DFF
	XDFF2   CLK A2_   A2_ff DFF
	XDFF3   CLK A3__  A3_ff DFF
	XDFF4   CLK A4_   A4_ff DFF

	XDFF5   CLK B1__  B1_ff DFF
	XDFF6   CLK B2_   B2_ff DFF
	XDFF7   CLK B3__  B3_ff DFF
	XDFF8   CLK B4_   B4_ff DFF

	XDFF9   CLK Cin__ Cin_ff DFF

	XDFF10  CLK S1    S1_ff DFF
	XDFF11  CLK S2    S2_ff DFF
	XDFF12  CLK S3    S3_ff DFF
	XDFF13  CLK S4    S4_ff DFF

	XDFF14  CLK Cout  Cout_ff DFF

	* FA BAR * 
	XFA1   A1_ff  B1_ff  Cin_ff C1_  S1_ FA_1
	XFA2   A2_ff  B2_ff  C1_    C2   S2  FA_2
	XFA3   A3_ff  B3_ff  C2     C3_  S3_ FA_3
	XFA4   A4_ff  B4_ff  C3_    Cout S4  FA_4
.ends




XRA4   A1 A2 A3 A4 B1 B2 B3 B4 Cin S1 S2 S3 S4 Cout CLK RA4 
XLOAD1 S1   FO4
XLOAD2 S2   FO4
XLOAD3 S3   FO4
XLOAD4 S4   FO4
XLOAD5 Cout FO4

********************************
**     Analysis setting       **
********************************
.tran 0.1p '12*period' 


********************************
**          Measure           **
********************************

.meas tran AvgPower  avg  power
.meas tran PeakPower MAX  power
* .meas tran LeakagePower AVG  power

.end   

