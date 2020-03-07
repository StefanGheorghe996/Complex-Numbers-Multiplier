onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /test_environment/DUT/clk
add wave -noupdate /test_environment/DUT/rstn
add wave -noupdate /test_environment/DUT/sw_rst
add wave -noupdate /test_environment/DUT/op_val
add wave -noupdate /test_environment/DUT/res_ready
add wave -noupdate -color Gold -radix decimal /test_environment/DUT/op_1_re
add wave -noupdate -color Gold -radix decimal /test_environment/DUT/op_1_im
add wave -noupdate -color Gold -radix decimal /test_environment/DUT/op_2_re
add wave -noupdate -color Gold -radix decimal /test_environment/DUT/op_2_im
add wave -noupdate /test_environment/DUT/op_ready
add wave -noupdate /test_environment/DUT/res_val
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
add wave -noupdate /test_environment/DUT/CONTROL_LOGIC/clk
add wave -noupdate /test_environment/DUT/CONTROL_LOGIC/rstn
add wave -noupdate /test_environment/DUT/CONTROL_LOGIC/sw_rst
add wave -noupdate /test_environment/DUT/CONTROL_LOGIC/op_val
add wave -noupdate /test_environment/DUT/CONTROL_LOGIC/res_ready
add wave -noupdate /test_environment/DUT/CONTROL_LOGIC/op_ready
add wave -noupdate /test_environment/DUT/CONTROL_LOGIC/res_val
add wave -noupdate /test_environment/DUT/CONTROL_LOGIC/op_1_sel
add wave -noupdate /test_environment/DUT/CONTROL_LOGIC/op_2_sel
add wave -noupdate /test_environment/DUT/CONTROL_LOGIC/compute_enable
add wave -noupdate /test_environment/DUT/CONTROL_LOGIC/result_reg_sel
add wave -noupdate /test_environment/DUT/CONTROL_LOGIC/state
add wave -noupdate /test_environment/DUT/CONTROL_LOGIC/next_state
add wave -noupdate /test_environment/TESTBENCH/clk
add wave -noupdate /test_environment/TESTBENCH/rstn
add wave -noupdate /test_environment/TESTBENCH/op_ready
add wave -noupdate /test_environment/TESTBENCH/res_val
add wave -noupdate /test_environment/TESTBENCH/sw_rst
add wave -noupdate /test_environment/TESTBENCH/op_val
add wave -noupdate /test_environment/TESTBENCH/res_ready
add wave -noupdate /test_environment/TESTBENCH/op_1_re
add wave -noupdate /test_environment/TESTBENCH/op_1_im
add wave -noupdate /test_environment/TESTBENCH/op_2_re
add wave -noupdate /test_environment/TESTBENCH/op_2_im
add wave -noupdate /test_environment/TESTBENCH/op_1_re_reg
add wave -noupdate /test_environment/TESTBENCH/op_1_im_reg
add wave -noupdate /test_environment/TESTBENCH/op_2_re_reg
add wave -noupdate /test_environment/TESTBENCH/op_2_im_reg
add wave -noupdate /test_environment/MONITOR/clk
add wave -noupdate /test_environment/MONITOR/rstn
add wave -noupdate /test_environment/MONITOR/sw_rst
add wave -noupdate /test_environment/MONITOR/op_val
add wave -noupdate /test_environment/MONITOR/res_ready
add wave -noupdate /test_environment/MONITOR/op_1_re
add wave -noupdate /test_environment/MONITOR/op_1_im
add wave -noupdate /test_environment/MONITOR/op_2_re
add wave -noupdate /test_environment/MONITOR/op_2_im
add wave -noupdate /test_environment/MONITOR/op_ready
add wave -noupdate /test_environment/MONITOR/res_val
add wave -noupdate -color Gold -radix decimal /test_environment/MONITOR/result_re
add wave -noupdate -color Gold -radix decimal /test_environment/MONITOR/result_im
add wave -noupdate -color Gold -radix decimal /test_environment/MONITOR/predicted_result_re
add wave -noupdate -color Gold -radix decimal /test_environment/MONITOR/predicted_result_im
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
configure wave -namecolwidth 258
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
WaveRestoreZoom {0 ns} {9429 ns}
