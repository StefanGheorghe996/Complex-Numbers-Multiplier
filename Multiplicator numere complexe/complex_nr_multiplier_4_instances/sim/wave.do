onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /test_environment/DUT/clk
add wave -noupdate /test_environment/DUT/rstn
add wave -noupdate /test_environment/DUT/sw_rst
add wave -noupdate -divider {Op Interface}
add wave -noupdate /test_environment/DUT/op_val
add wave -noupdate /test_environment/DUT/op_ready
add wave -noupdate /test_environment/DUT/op_data
add wave -noupdate -divider {Res Interface}
add wave -noupdate /test_environment/DUT/res_ready
add wave -noupdate /test_environment/DUT/res_val
add wave -noupdate -radix binary -subitemconfig {{/test_environment/DUT/res_data[35]} {-radix binary} {/test_environment/DUT/res_data[34]} {-radix binary} {/test_environment/DUT/res_data[33]} {-radix binary} {/test_environment/DUT/res_data[32]} {-radix binary} {/test_environment/DUT/res_data[31]} {-radix binary} {/test_environment/DUT/res_data[30]} {-radix binary} {/test_environment/DUT/res_data[29]} {-radix binary} {/test_environment/DUT/res_data[28]} {-radix binary} {/test_environment/DUT/res_data[27]} {-radix binary} {/test_environment/DUT/res_data[26]} {-radix binary} {/test_environment/DUT/res_data[25]} {-radix binary} {/test_environment/DUT/res_data[24]} {-radix binary} {/test_environment/DUT/res_data[23]} {-radix binary} {/test_environment/DUT/res_data[22]} {-radix binary} {/test_environment/DUT/res_data[21]} {-radix binary} {/test_environment/DUT/res_data[20]} {-radix binary} {/test_environment/DUT/res_data[19]} {-radix binary} {/test_environment/DUT/res_data[18]} {-radix binary} {/test_environment/DUT/res_data[17]} {-radix binary} {/test_environment/DUT/res_data[16]} {-radix binary} {/test_environment/DUT/res_data[15]} {-radix binary} {/test_environment/DUT/res_data[14]} {-radix binary} {/test_environment/DUT/res_data[13]} {-radix binary} {/test_environment/DUT/res_data[12]} {-radix binary} {/test_environment/DUT/res_data[11]} {-radix binary} {/test_environment/DUT/res_data[10]} {-radix binary} {/test_environment/DUT/res_data[9]} {-radix binary} {/test_environment/DUT/res_data[8]} {-radix binary} {/test_environment/DUT/res_data[7]} {-radix binary} {/test_environment/DUT/res_data[6]} {-radix binary} {/test_environment/DUT/res_data[5]} {-radix binary} {/test_environment/DUT/res_data[4]} {-radix binary} {/test_environment/DUT/res_data[3]} {-radix binary} {/test_environment/DUT/res_data[2]} {-radix binary} {/test_environment/DUT/res_data[1]} {-radix binary} {/test_environment/DUT/res_data[0]} {-radix binary}} /test_environment/DUT/res_data
add wave -noupdate -divider MONITOR
add wave -noupdate -radix decimal /test_environment/MONITOR/predicted_result_re
add wave -noupdate -radix decimal /test_environment/MONITOR/predicted_result_im
add wave -noupdate -radix decimal /test_environment/MONITOR/result_re
add wave -noupdate -radix decimal /test_environment/MONITOR/result_im
add wave -noupdate -divider {Intermediary results}
add wave -noupdate -radix decimal /test_environment/DUT/result_re
add wave -noupdate -radix decimal /test_environment/DUT/result_im
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {566 ns} 0}
configure wave -namecolwidth 309
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
