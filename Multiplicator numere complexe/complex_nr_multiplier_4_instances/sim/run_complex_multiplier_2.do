vlog -work work -L mtiAvm -L mtiOvm -L mtiUPF {../src/rtl/uint8_mult.v}
vlog -work work -L mtiAvm -L mtiOvm -L mtiUPF {../src/rtl/control_logic.v}
vlog -work work -L mtiAvm -L mtiOvm -L mtiUPF {../src/rtl/complex_nr_mult_2.v}
vlog -work work -L mtiAvm -L mtiOvm -L mtiUPF {../src/tb/clock_rst_gen.v}
vlog -work work -L mtiAvm -L mtiOvm -L mtiUPF {../src/tb/complex_nr_mult_tb.v}
vlog -work work -L mtiAvm -L mtiOvm -L mtiUPF {../src/tb/monitor_complex_multiplier.v}
vlog -work work -L mtiAvm -L mtiOvm -L mtiUPF {../src/tb/test_environment.v}

vsim -novopt work.test_environment

add wave test_environment/DUT/*
add wave test_environment/DUT/CONTROL_LOGIC/*
add wave test_environment/TESTBENCH/*
add wave test_environment/MONITOR/*

do wave.do

run -all