module Elevator_Controller (
    input clk, rst, emer_stop,
    input [3:0] floor_req,
    output reg move_up, move_down, motor_stop,
    output reg [1:0] current_floor
);

    parameter IDLE = 2'b00;
    parameter M_U = 2'b01;
    parameter M_D = 2'b10;

    reg [1:0] PS, NS, Target_floor;

    always @(*)
        begin
            Target_floor = current_floor;
            if (floor_req[0]) begin
                Target_floor = 2'd0;
            end
            else if (floor_req[1]) begin
                Target_floor = 2'd1;
            end
            else if (floor_req[2]) begin
                Target_floor = 2'd2;
            end
            else if (floor_req[3]) begin
                Target_floor = 2'd3;
            end
        end

    always @(posedge clk)
        begin
            if (rst) begin
                PS <= IDLE;        
            end
            else
                PS <= NS;
        end

    always @(posedge clk or posedge rst) 
        begin
            if (rst) begin
                current_floor <= 2'b00;
            end
            else if(PS == M_U && (current_floor < 3)) begin
                current_floor <= current_floor + 2'b01;
            end    
            else if(PS == M_D && (current_floor > 0)) begin
                current_floor <= current_floor - 2'b01;
            end
        end

    always @(*) begin
        
        if (emer_stop)
            NS = IDLE;
        
        else begin
            case (PS)
                IDLE:begin
                    if (Target_floor > current_floor) begin
                        NS = M_U;
                    end
                    else if (Target_floor < current_floor) begin
                        NS = M_D;
                    end
                end
                M_U: begin
                    if (current_floor == Target_floor) begin
                        NS = IDLE;
                        Target_floor =0;
                    end
                    else if (Target_floor > current_floor) begin
                        NS = M_U;
                    end
                end
                M_D: begin
                    if (current_floor == Target_floor) begin
                        NS = IDLE;
                        Target_floor =0;
                    end
                    else if (Target_floor < current_floor) begin
                        NS = M_D;
                    end
                end
                default: NS = IDLE;
            endcase
        end
    end

    always @(*) begin
        {move_down, move_up, motor_stop} = 0;
        case (PS)
            M_U: move_up = 1'b1;
            M_D: move_down = 1'b1;
            IDLE: motor_stop = 1'b1; 
        endcase
    end

endmodule
