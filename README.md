# cdp1802
Reverse engineered CDP1802 microprocessor in VHDL

# Description
This repository contains the VHDL description of the CDP1802 microprocessor.
All pins (except the pin XTAL) are included according to the datasheet
https://wiki.techinc.nl/images/5/5f/Cdp1802.pdf

See also: http://bitsavers.trailing-edge.com/components/rca/cosmac/MPM-201A_User_Manual_for_the_CDP1802_COSMAC_Microprocessor_1976.pdf

See also: http://www.cosmacelf.com/

The CPU timing is close to the real CDP1802 with a few small exceptions.

# Toplevel
The name of the toplevel is CDP18 which includes the Microcontroller and RAM.
The testbenches in the directory tb/vhdl can be used in simulation

# License
MIT

# Simulation instructions
Bash:

`modelsim_config unb2c -v1`

`run_modelsim unb2c`

Modelsim:

`lp cdp1802`

`mk clean`

`mk all`

double click testbence `tb_cdp18.vhd`

`as 10`

`run 600us`

exit:
`quit -sim`
