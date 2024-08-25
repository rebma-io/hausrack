---
date: 2024-08-25
categories: 
  - Hardware
authors:
  - petrilli 
draft: true
---
# Creepage, Clearance, and Spacing ... Oh my!

https://www.protoexpress.com/blog/importance-pcb-line-spacing-creepage-clearance/
http://www.creepage.com

Since I intend to switch US mains voltage, that means I need to be able
to safely handle 120V~rms~ AC, which converts to approximately 170V~p~
(peak) and 340V~pp~ (peak-to-peak). This isn't a trivial amount of
voltage to work with, and deserves constant respect. 

Trace width 15A on 1oz copper for an external layer in air (25C) with a
maximum temperature rise of 10C is is just under 500mil (12.7mm). 

_Clearance_ is the distance, in air, between two conductors. _Creepage_
is the distance measured along the surface of insulating meterial
between two conductors.

 IEC-60112

 Comparative Tracking Index (CTI) defines the electrical voltage
 breakdown of the insulation material in a PCB caused by environmental
 conditions, such as moisture and dirt. FR3 typically has a CTI of 175,
 which makes it a category IIIa material.

 IEC-62368-1 

 Working voltage (IEC 355) Working voltage denotes the maximum voltage to which the part under consideration can be subjected when the appliance is operating at its rated voltage and under normal conditions of use.

Table 12 in section 5.4 specifies the following: 120 VAC
power supplies will need to withstand 1500 Vpk; 240 VAC
power supplies need to withstand 2500 Vpk

Common Mode protection = MOV + GDT (Littlefuse V10E300P + CG3 3.3)
Differential mode protection = TMOV (Littlefuse TMOV14RP300E)
Fuse 215016 (16a 250V) 20x5.2mm cartridge

3M Thermavolt paper?
Kapton Polyimide film, 1mil, 7,700V/mil

Wire AWG14/16 https://www.engineeringtoolbox.com/wire-gauges-d_419.html
