#all: ips pulpino

all : pulpino_zcu102



.PHONY: pulpino_zcu102
pulpino_zcu102:

	make -C pulpino_zcu102 clean all


.PHONY: program_FPGA
program_FPGA:
	make -C pulpino_zcu102 program_FPGA



.PHONY: clean
clean:

	make -C pulpino_zcu102 clean
