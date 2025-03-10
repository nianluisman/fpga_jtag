transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/nilu171/source/fpga_repos/fpga_jtag {C:/Users/nilu171/source/fpga_repos/fpga_jtag/jtag.sv}
vlog -sv -work work +incdir+C:/Users/nilu171/source/fpga_repos/fpga_jtag {C:/Users/nilu171/source/fpga_repos/fpga_jtag/tab_defines.sv}
vlog -sv -work work +incdir+C:/Users/nilu171/source/fpga_repos/fpga_jtag {C:/Users/nilu171/source/fpga_repos/fpga_jtag/boundray_scan.sv}
vlog -sv -work work +incdir+C:/Users/nilu171/source/fpga_repos/fpga_jtag {C:/Users/nilu171/source/fpga_repos/fpga_jtag/digital_core.sv}
vlog -sv -work work +incdir+C:/Users/nilu171/source/fpga_repos/fpga_jtag {C:/Users/nilu171/source/fpga_repos/fpga_jtag/tab_controller.sv}
vlog -sv -work work +incdir+C:/Users/nilu171/source/fpga_repos/fpga_jtag {C:/Users/nilu171/source/fpga_repos/fpga_jtag/clock_sync.sv}
vlog -sv -work work +incdir+C:/Users/nilu171/source/fpga_repos/fpga_jtag {C:/Users/nilu171/source/fpga_repos/fpga_jtag/data_register.sv}

vlog -sv -work work +incdir+C:/Users/nilu171/source/fpga_repos/fpga_jtag/output_files {C:/Users/nilu171/source/fpga_repos/fpga_jtag/output_files/tb_top.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb_top

add wave *
view structure
view signals
run -all
