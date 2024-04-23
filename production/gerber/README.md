# Gerbers

You should include the Gerber files for HAUSRACK in this
section. These files are used for PCB fabrication.

## Required  Files

Ensure that the following Gerber files are included for manufacturing:

- Copper Layers: `HAUSRACK-F_Cu`, 
  `HAUSRACK-B_Cu` (top and bottom copper layers). There
  may be others if you have more than 2 copper layers.
- Silkscreen Layers: `HAUSRACK-F_SilkS`, 
  `HAUSRACK-B_SilkS` (top and bottom silkscreen layers).
- Solder Paste Layers: `HAUSRACK-F_Paste`, 
  `HAUSRACK-B_Paste` (top and bottom solder paste 
  layers).
- Solder Mask Layers: `HAUSRACK-F_Mask`, 
  `HAUSRACK-B_Mask` (top and bottom solder mask layers).
- Drill Files: `HAUSRACK-PTH` or 
  `HAUSRACK-NPTH` (NC drill file).
- Board Outline: `HAUSRACK-Edge_Cuts`(board outline 
  or edge cuts).

Please generate Gerber files with the correct extensions for your PCB 
fabricator. These files are necessary for accurate manufacturing of the PCB. 
You can find them for 
[JLCPCB](https://jlcpcb.com/help/article/362-how-to-generate-gerber-and-drill-files-in-kicad-7)
[OSHPark](https://docs.oshpark.com/design-tools/kicad/)
[PCBWay](https://www.pcbway.com/blog/help_center/Generate_Gerber_file_from_Kicad.html).