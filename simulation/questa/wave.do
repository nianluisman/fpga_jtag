onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_top/internal_clk
add wave -noupdate /tb_top/half_time
add wave -noupdate /tb_top/tck
add wave -noupdate /tb_top/digital_core_clk
add wave -noupdate /tb_top/ex_data_out
add wave -noupdate /tb_top/digital_output
add wave -noupdate /tb_top/iter
add wave -noupdate /tb_top/trst_n
add wave -noupdate /tb_top/tdi
add wave -noupdate /tb_top/mode
add wave -noupdate /tb_top/ex_data_in
add wave -noupdate /tb_top/instr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10207524 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {131072 ns}
