onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /test_environment/DUT/clk
add wave -noupdate /test_environment/DUT/rstn
add wave -noupdate /test_environment/DUT/sw_rst
add wave -noupdate -divider {Op Interface}
add wave -noupdate /test_environment/DUT/op_val
add wave -noupdate /test_environment/DUT/op_ready
add wave -noupdate -radix decimal /test_environment/DUT/op_data
add wave -noupdate -divider {Res Interface}
add wave -noupdate /test_environment/DUT/res_ready
add wave -noupdate /test_environment/DUT/res_val
add wave -noupdate -radix decimal /test_environment/DUT/res_data
add wave -noupdate -divider MONITOR
add wave -noupdate -radix decimal /test_environment/MONITOR/predicted_result_re
add wave -noupdate -radix decimal /test_environment/MONITOR/predicted_result_im
add wave -noupdate -radix decimal /test_environment/MONITOR/result_re
add wave -noupdate -radix decimal /test_environment/MONITOR/result_im
add wave -noupdate -divider {Intermediary results}
add wave -noupdate -radix decimal /test_environment/DUT/result_re
add wave -noupdate -radix decimal /test_environment/DUT/result_im
add wave -noupdate -radix decimal /test_environment/DUT/re_x_re
add wave -noupdate -radix decimal /test_environment/DUT/im_x_im
add wave -noupdate -radix decimal /test_environment/DUT/re_x_im_1
add wave -noupdate -radix decimal /test_environment/DUT/re_x_im_2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {385 ns} 0}
configure wave -namecolwidth 309
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
WaveRestoreZoom {0 ns} {3610 ns}
