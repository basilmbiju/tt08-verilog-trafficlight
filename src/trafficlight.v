`timescale 1ns/1ps
module trafficlight_1(
    input wire clk,
    input wire reset,
    input wire sensor,
    output reg [1:0] light
);

// State definitions
parameter RED = 2'b01;
parameter YELLOW = 2'b10;
parameter GREEN = 2'b11;

// Timer settings
parameter RED_TIME = 50;  
parameter YELLOW_TIME = 5;  
parameter GREEN_TIME = 50; 

// Registers to hold state, next state, and timer
reg [1:0] state, next_state;
reg [31:0] timer;

// State transition and timer logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= RED;       
        timer <= RED_TIME; 
    end else begin
        if (timer == 0) begin
            state <= next_state; 
            
            case (next_state)
                RED: timer <= RED_TIME;
                YELLOW: timer <= YELLOW_TIME;
                GREEN: timer <= GREEN_TIME;
                default: timer <= RED_TIME; 
            endcase
        end else begin
            timer <= timer - 1; // Decrement timer
        end
    end
end

// Next state logic
always @(*) begin
    case (state)
        RED: begin
            if (timer == 0) begin
                next_state = GREEN; 
            end else begin
                next_state = RED;   
            end
        end
        
        GREEN: begin
            if (!sensor && timer >= 2) begin
                next_state = YELLOW; 
            end else if (timer == 0) begin
                next_state = YELLOW;
            end else begin
                next_state = GREEN;
            end
        end
        
        YELLOW: begin
            if (timer == 0) begin
                next_state = RED; 
            end else begin
                next_state = YELLOW;
            end
        end
        
        default: next_state = RED;
    endcase
end

// Output logic
always @(posedge clk) begin
    case (state)
        RED: light <= 2'b01;    // Red light
        YELLOW: light <= 2'b10; // Yellow light
        GREEN: light <= 2'b11;  // Green light
        default: light <= 2'b00; // Off (shouldn't happen)
    endcase
end

endmodule
