dump: top_t.lxt
	gtkwave top_t.lxt

runsim: top_t.lxt

top_t.lxt: top_t.vvp
	vvp $< -lxt2

top_t.vvp: top_t.v top.v serialtx.v yes.v
	iverilog -o $@ $^
