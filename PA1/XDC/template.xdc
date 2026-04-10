# You may modify the PERIOD variable
set PERIOD 10.000
set HALF_PERIOD [expr $PERIOD/2.0]
# Constraint clock
create_clock -period $PERIOD -name clk -waveform [list 0 $HALF_PERIOD] -add [get_ports clk]
# Constraint I/O delay
set_input_delay -clock [get_clocks *] -add_delay $HALF_PERIOD [get_ports -filter { NAME !=  "clk" && DIRECTION == "IN" }]
set_output_delay -clock [get_clocks *] -add_delay $HALF_PERIOD [get_ports -filter { NAME =~  "*" && DIRECTION == "OUT" }]