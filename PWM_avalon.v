module PWM_avalon(	
	input csi_clk,
	input rsi_rst_n,
	input avs_s0_read,
	input avs_s0_write,
	input avs_s0_chip_select,
	input wire [3:0] avs_s0_byteenable,
	input wire [31:0] avs_s0_writedata,
	input wire [1:0] avs_s0_address,
	output wire [31:0] avs_s0_readdata,
	output coe_pwm_out);

reg [31:0] pulse_width;
wire load_pulse_width;
wire [3:0] load_pulse_width_lanes;
reg [31:0] period;
wire load_period;
wire [3:0] load_period_lanes;
reg enable;
wire load_enable;
wire read_pulse_width;
wire read_period;
wire read_enable;
reg [31:0] read_data;
wire pwm_out;


PWM_core PWM_core0(
	.clk (csi_clk), 
	.reset (rsi_rst_n),
	.period (period),
	.dutyc_switch (pulse_width), 
	.out (pwm_out)
	);

assign coe_pwm_out = pwm_out & enable;

assign load_pulse_width = avs_s0_chip_select & avs_s0_write & (avs_s0_address == 0);
assign load_period = avs_s0_chip_select & avs_s0_write & (avs_s0_address == 1);
assign load_enable = avs_s0_chip_select & avs_s0_write & (avs_s0_address == 2);

assign read_pulse_width = avs_s0_chip_select & avs_s0_read & (avs_s0_address == 0);
assign read_period = avs_s0_chip_select & avs_s0_read & (avs_s0_address == 1);
assign read_enable = avs_s0_chip_select & avs_s0_read & (avs_s0_address == 2);

always @(posedge csi_clk or negedge rsi_rst_n)
begin

if (rsi_rst_n == 0)
	begin
		pulse_width <= 250000;
	end
	else
	begin
		if (load_pulse_width == 1)
		begin
			if (load_pulse_width_lanes[0] == 1)
				begin
				pulse_width[7:0] <= avs_s0_writedata[7:0];
				end
			if (load_pulse_width_lanes[1] == 1)
				begin
				pulse_width[15:8] <= avs_s0_writedata[15:8];
				end
			if (load_pulse_width_lanes[2] == 1)
				begin
				pulse_width[23:16] <= avs_s0_writedata[23:16];
				end
			if (load_pulse_width_lanes[3] == 1)
				begin
				pulse_width[31:24] <= avs_s0_writedata[31:24];
				end
		end
		
		if (read_pulse_width == 1)
			read_data <= pulse_width;

	end
end

always @(posedge csi_clk or negedge rsi_rst_n)
begin

if (rsi_rst_n == 0)
	begin
		period <= 500000;
	end
	else
	begin
	if (load_period == 1)
		begin
			if (load_period_lanes[0] == 1)
				begin
				period[7:0] <= avs_s0_writedata[7:0];
				end
			if (load_period_lanes[1] == 1)
				begin
				period[15:8] <= avs_s0_writedata[15:8];
				end
			if (load_period_lanes[2] == 1)
				begin
				period[23:16] <= avs_s0_writedata[23:16];
				end
			if (load_period_lanes[3] == 1)
				begin
				period[31:24] <= avs_s0_writedata[31:24];
				end
		end
		
		if (read_period == 1)
			read_data <= period;

	end
end

always @(posedge csi_clk or negedge rsi_rst_n)
begin

if (rsi_rst_n == 0)
	begin
		enable <= 1;
	end
	else
	begin
	if (load_enable == 1)
		begin
			if(avs_s0_byteenable[0] == 1)
			begin
				enable <= avs_s0_writedata[0];
			end
		end
		if (read_enable == 1)
			read_data <= {31'b0, enable};
	end
end

assign avs_s0_readdata = read_data;
endmodule
