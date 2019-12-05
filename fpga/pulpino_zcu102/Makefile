PROJECT:=pulpino_zcu102

all: synth

synth:
	vivado -mode batch -source tcl/pulpino_zcu102.tcl


program_FPGA:
	vivado -mode batch -source tcl/program_fpga.tcl


gui-synth:
	vivado -mode gui -source tcl/run.tcl &


clean:

	rm -rf reports
	rm -rf ${PROJECT}
	rm -rf vivado*
	rm -rf .Xil

