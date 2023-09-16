	alias clc ".main clear"
	
	clc
	exec vlib work
	vmap work work
	
	set TB					"TB"
	set hdl_path			"../src/hdl"
	set inc_path			"../src/inc"
	
	# set run_time			"1 s"
	set run_time			"-all"

#============================ Add verilog files  ===============================
# Pleas add other module here	
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/*.v
		
	vlog 	+acc -incr -source  +incdir+$inc_path +define+SIM 	./tb/$TB.v
	onerror {break}

#================================ simulation ====================================

	vsim	-voptargs=+acc -debugDB $TB


#======================= adding signals to wave window ==========================

	# add wave -hex sim:/TB/uut/controller/ps
	# add wave -hex sim:/TB/uut/controller/ns
	# add wave -hex sim:/TB/uut/controller/last_neuron_batch
	# add wave -hex sim:/TB/uut/controller/N_P_itr1
	# add wave -hex sim:/TB/uut/controller/N_P_co1
	# add wave -hex sim:/TB/uut/controller/B_N_itr1
	# add wave -hex sim:/TB/uut/controller/B_N_co1
	# add wave -hex sim:/TB/uut/controller/layer_sel
	# add wave -hex sim:/TB/uut/controller/B_N_itr2
	# add wave -hex sim:/TB/uut/controller/B_N_co2
	# add wave -hex sim:/TB/uut/controller/N_P_itr2
	# add wave -hex sim:/TB/uut/controller/N_P_co2
	# add wave -hex sim:/TB/uut/datapath/dataProvider/pu_inputs2
	# add wave -hex sim:/TB/uut/datapath/dataProvider/pu_inputs
	# add wave -hex sim:/TB/uut/datapath/dataProvider/final_result
	# add wave -hex sim:/TB/uut/datapath/dataProvider/pu_res_en2
	# add wave -hex sim:/TB/uut/datapath/dataProvider/pu_res_w_addr
	# add wave -hex sim:/TB/uut/datapath/dataProvider/pu_results
	# add wave -hex sim:/TB/uut/datapath/results_ready
	# add wave -hex sim:/TB/uut/datapath/pu1/acc_reg_out
	# add wave -hex sim:/TB/uut/datapath/pu1/result
	# add wave -hex sim:/TB/uut/datapath/pu2/acc_reg_out
	# add wave -hex sim:/TB/uut/datapath/pu2/result
	# add wave -hex sim:/TB/uut/datapath/pu3/acc_reg_out
	# add wave -hex sim:/TB/uut/datapath/pu3/result
	# add wave -hex sim:/TB/uut/datapath/pu4/acc_reg_out
	# add wave -hex sim:/TB/uut/datapath/pu4/result
	# add wave -hex sim:/TB/uut/datapath/pu5/acc_reg_out
	# add wave -hex sim:/TB/uut/datapath/pu5/result
	# add wave -hex sim:/TB/uut/datapath/pu6/acc_reg_out
	# add wave -hex sim:/TB/uut/datapath/pu6/result
	# add wave -hex sim:/TB/uut/datapath/pu7/acc_reg_out
	# add wave -hex sim:/TB/uut/datapath/pu7/result
	# add wave -hex sim:/TB/uut/datapath/pu8/acc_reg_out
	# add wave -hex sim:/TB/uut/datapath/pu8/result
	add wave -hex -group 	 	{TB}				sim:/$TB/*
	add wave -hex -group 	 	{top}				sim:/$TB/uut/*	
	# add wave -hex -group -r		{all}				sim:/$TB/*
	# add wave -position end  sim:/TB/uut/datapath/dataProvider/w1mem/w1_mem/concat_outputs

#=========================== Configure wave signals =============================
	
	configure wave -signalnamewidth 2
    

#====================================== run =====================================

	run $run_time 