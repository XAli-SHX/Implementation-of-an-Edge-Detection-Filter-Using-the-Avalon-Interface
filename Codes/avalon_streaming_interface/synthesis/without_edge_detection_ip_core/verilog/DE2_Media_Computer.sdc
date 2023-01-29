## Generated SDC file "DE2_Media_Computer.sdc"

## Copyright (C) 1991-2012 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 12.1 Build 175 10/24/2012 SJ Full Version"

## DATE    "Fri May 24 13:13:11 2013"

##
## DEVICE  "EP2C35F672C6"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {CLOCK_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {CLOCK_50}]
create_clock -name {CLOCK_27} -period 37.037 -waveform { 0.000 18.518 } [get_ports {CLOCK_27}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {NiosII|external_clocks|DE_Clock_Generator_System|pll|clk[0]} -source [get_pins {NiosII|external_clocks|DE_Clock_Generator_System|pll|inclk[0]}] -duty_cycle 50.000 -multiply_by 1 -master_clock {CLOCK_50} [get_pins {NiosII|external_clocks|DE_Clock_Generator_System|pll|clk[0]}] 
create_generated_clock -name {NiosII|external_clocks|DE_Clock_Generator_System|pll|clk[1]} -source [get_pins {NiosII|external_clocks|DE_Clock_Generator_System|pll|inclk[0]}] -duty_cycle 50.000 -multiply_by 1 -phase -54.000 -master_clock {CLOCK_50} [get_pins {NiosII|external_clocks|DE_Clock_Generator_System|pll|clk[1]}] 
create_generated_clock -name {NiosII|external_clocks|DE_Clock_Generator_System|pll|clk[2]} -source [get_pins {NiosII|external_clocks|DE_Clock_Generator_System|pll|inclk[0]}] -duty_cycle 50.000 -multiply_by 1 -divide_by 2 -phase 180.000 -master_clock {CLOCK_50} [get_pins {NiosII|external_clocks|DE_Clock_Generator_System|pll|clk[2]}] 
create_generated_clock -name {NiosII|external_clocks|DE_Clock_Generator_Audio|pll|clk[1]} -source [get_pins {NiosII|external_clocks|DE_Clock_Generator_Audio|pll|inclk[0]}] -duty_cycle 50.000 -multiply_by 14 -divide_by 31 -master_clock {CLOCK_27} [get_pins {NiosII|external_clocks|DE_Clock_Generator_Audio|pll|clk[1]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

