module PWM_core( 
input reset, clk,
input [8:0] dutyc_switch,
input [8:0] period,
output reg out
);


reg [8:0] duty_cycle, counter;
reg [3:0] compare_result = 4'b1111;



always@(posedge clk or negedge reset) //Activating hardware at rising edge of clock or falling edge of reset
begin

   if(~reset) //checking for reset signal (reset driven low)
		begin
			counter <= 32'b1; 		//assigning 32 "ones" to the counter
			duty_cycle <= 32'b0;		//assigning 32 "zeros" to the duty_cycle
		end
	
	else if(counter == period) //checking for counter equal to period
		begin
			counter <= 32'b1;			//if equal, assigning 32 "ones" to the counter
		end
	
	else 
		begin
			counter <= counter + 1'b1;														//Incrementing counter, counting
			if(compare_result[0]) duty_cycle[7:0] <= dutyc_switch[7:0];

		end
	
end 


always@(posedge clk)				//Activating hardware at rising edge of clock
begin

	if(counter <= duty_cycle)	//checking if counter is less than or equal to duty_cycle
		begin
		out = 1'b1;					//if counter is less than or equal to duty_cycle, output 1
		end
	else 
		begin
		out = 1'b0;					//if counter is not less than or equal to duty_cycle, output 0
		end

end

endmodule
