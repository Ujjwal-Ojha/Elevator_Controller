module Elevator_Controller_tb (
    );
    
    reg clk = 0;
    reg rst, emer_stop;
    reg [3:0] floor_req;

    wire [1:0] current_floor;
    wire move_down, move_up, motor_stop;

    Elevator_Controller dut(clk, rst, emer_stop, floor_req, move_up, move_down, motor_stop, current_floor);
    
    always #5 clk = ~clk;

    initial begin
        
        rst = 1;
        floor_req = 5'b0000;
        emer_stop = 0;

        #10;
        rst = 0;
        
        #10;
        floor_req = 4'b0001;

        #20;
        floor_req = 4'b0100;

        #20;
        floor_req = 4'b1000;

        #30;
        floor_req = 4'b0001;
        
        #20;
        floor_req = 4'b0000;

        #50 emer_stop =1;
        #30 emer_stop =0;

        #50;
        $finish;
    end

    initial begin
        $monitor("Time = %0t | Floor = %0d | Req = %b | UP = %b  DOWN = %b  STOP = %b  EMG = %b",
                $time, current_floor, floor_req, move_up, move_down, motor_stop, emer_stop
                );
    end

endmodule
