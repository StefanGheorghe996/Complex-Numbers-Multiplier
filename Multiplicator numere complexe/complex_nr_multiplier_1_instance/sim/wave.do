onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /test_environment/DUT/clk
add wave -noupdate /test_environment/DUT/rstn
add wave -noupdate /test_environment/DUT/sw_rst
add wave -noupdate -divider op
add wave -noupdate /test_environment/DUT/op_val
add wave -noupdate /test_environment/DUT/op_ready
add wave -noupdate -radix unsigned /test_environment/DUT/op_1_re
add wave -noupdate -radix unsigned /test_environment/DUT/op_1_im
add wave -noupdate -radix unsigned /test_environment/DUT/op_2_re
add wave -noupdate -radix unsigned /test_environment/DUT/op_2_im
add wave -noupdate -divider res
add wave -noupdate /test_environment/DUT/res_val
add wave -noupdate /test_environment/DUT/res_ready
add wave -noupdate /test_environment/DUT/result_re
add wave -noupdate /test_environment/DUT/result_im
add wave -noupdate /test_environment/DUT/op_1_sel
add wave -noupdate /test_environment/DUT/op_2_sel
add wave -noupdate /test_environment/DUT/compute_enable
add wave -noupdate /test_environment/DUT/result_reg_sel
add wave -noupdate /test_environment/DUT/re_x_re
add wave -noupdate /test_environment/DUT/im_x_im
add wave -noupdate /test_environment/DUT/re_x_im_1
add wave -noupdate /test_environment/DUT/re_x_im_2
add wave -noupdate /test_environment/DUT/op_1_re_register
add wave -noupdate /test_environment/DUT/op_1_im_register
add wave -noupdate /test_environment/DUT/op_2_re_register
add wave -noupdate /test_environment/DUT/op_2_im_register
add wave -noupdate /test_environment/DUT/multiplier_op_1
add wave -noupdate /test_environment/DUT/multiplier_op_2
add wave -noupdate /test_environment/DUT/multiplier_result
add wave -noupdate -divider control
add wave -noupdate /test_environment/DUT/CONTROL_LOGIC/op_1_sel
add wave -noupdate /test_environment/DUT/CONTROL_LOGIC/op_2_sel
add wave -noupdate /test_environment/DUT/CONTROL_LOGIC/compute_enable
add wave -noupdate /test_environment/DUT/CONTROL_LOGIC/result_reg_sel
add wave -noupdate /test_environment/DUT/CONTROL_LOGIC/state
add wave -noupdate /test_environment/DUT/CONTROL_LOGIC/next_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {545 ns} 0}
configure wave -namecolwidth 355
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
WaveRestoreZoom {189 ns} {949 ns}
