dump: serial_t.lxt
	gtkwave serial_t.lxt &

runsim: serial_t.lxt

serial_t.lxt: serial_t.vvp
	vvp $< -lxt2

serial_t.vvp: serial.v serial_t.v
	iverilog -o $@ $^
