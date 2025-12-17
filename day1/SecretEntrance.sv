module SecretEntrance(
    input logic clk,
    input logic rst_n,

    input logic in_valid,
    input logic neg,
    input logic [9:0] rotation,
    output logic [9:0] zeroCount
);

    logic signed [8:0] currRotation;
    logic signed [7:0] rot;
    logic signed [8:0] nextRotation;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            currRotation = 9'sd50;
            zeroCount = 10'd0;
        end

        else if (in_valid) begin
            rot = rotation % 100;
            if (neg) begin
                rot = ~rot + 1;
            end
            
            nextRotation = (currRotation + rot) % 100;
            if (nextRotation == 0) begin
                zeroCount <= zeroCount + 10'd1;
            end

            currRotation <= nextRotation;
        end 

    end
endmodule