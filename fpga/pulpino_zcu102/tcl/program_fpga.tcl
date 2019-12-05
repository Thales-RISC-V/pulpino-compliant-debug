open_hw
connect_hw_server
open_hw_target
set_property PROGRAM.FILE {pulpino_zcu102/pulpino_zcu102.runs/impl_1/Base_Zynq_MPSoC_wrapper.bit} [get_hw_devices xczu9_0]
current_hw_device [get_hw_devices xczu9_0]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices xczu9_0] 0]
current_hw_device [get_hw_devices arm_dap_1]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices arm_dap_1] 0]
current_hw_device [get_hw_devices xczu9_0]
set_property PROBES.FILE {} [get_hw_devices xczu9_0]
set_property FULL_PROBES.FILE {} [get_hw_devices xczu9_0]
set_property PROGRAM.FILE {pulpino_zcu102/pulpino_zcu102.runs/impl_1/Base_Zynq_MPSoC_wrapper.bit} [get_hw_devices xczu9_0]
program_hw_devices [get_hw_devices xczu9_0]
refresh_hw_device [lindex [get_hw_devices xczu9_0] 0]

