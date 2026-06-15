# You may modify the PERIOD variable
set PERIOD 100.00
set IO_DELAY [expr $PERIOD/5.0]
# Constraint clock
create_clock -period $PERIOD -name clk -waveform [list 0 $IO_DELAY] -add [get_ports clk]
# Constraint I/O delay
set_input_delay -clock [get_clocks *] -add_delay $IO_DELAY [get_ports -filter { NAME !=  "clk" && DIRECTION == "IN" }]
set_output_delay -clock [get_clocks *] -add_delay $IO_DELAY [get_ports -filter { NAME =~  "*" && DIRECTION == "OUT" }]