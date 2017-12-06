module PWM_core ( 				//Declaring inputs and outputs
 input reset, clk,
 input [7:0] switch_in,
 input [8:0] pulse_period,
 input [3:0] byteenable,
 output reg out
);


reg [7:0] duty_cycle, counter;	//Declaring helper variables


always@(posedge clk or negedge reset)
begin
	
	
   if(~reset) 						//Checking for reset since KEY is normally high
   begin
		counter <= 32'b1; 		//Filling counter with 1
		duty_cycle <= 32'b0;		//Clearing Duty Cycle
	end
	
	
	else if(counter == pulse_period)
	begin
		counter <= 32'b1;			//Filling counter with 1
	end
	

	else 
	begin
		counter <= counter + 1'b1;										//Incrementing counter and reading in duty cycle
		if(byteenable[0]) duty_cycle[7:0] <= switch_in[7:0];
	end
	
end 


always@(posedge clk)
begin
	
	if(counter <= duty_cycle)	//Writing a 1 to the LED when counter iw less than the duty cycle
	begin
		out = 1'b1;
	end

	else 
	begin								//Writing a 0 if the counter is outside the duty cycle
		out = 1'b0;
	end
		
end
endmodule