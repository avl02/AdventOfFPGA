`timescale 1ns/1ps
module SecretEntrance_tb;
    logic clk = 0;
    always #5 clk = ~clk;

    logic rst_n;

    logic in_valid;
    logic neg;
    logic [9:0] rotation;
    logic [9:0] zeroCount;

    SecretEntrance passcode (
        .clk(clk),
        .rst_n(rst_n),
        .in_valid(in_valid),
        .neg(neg),
        .rotation(rotation),
        .zeroCount(zeroCount)
    ); 


    int f;
    reg [8*6-1:0] line;
    byte negChar;
    int rotationNum;

    initial begin
        rst_n = 1'b0;
        in_valid = 1'b0;
        neg = 1'b0;
        rotation = 10'd0;  

        repeat (5) @(posedge clk);
        rst_n = 1'b1; 
        
        f = $fopen("input.txt", "r");

        while (!$feof(f)) begin
            line = "";
            void'($fgets(line, f));
            void'($sscanf(line, "%c%d", negChar, rotationNum));

            @(posedge clk) begin
                in_valid <= 1;
                neg <= (negChar == "L");
                rotation <= rotationNum[9:0];
            end

            @(posedge clk) begin
                in_valid <= 0;
            end
        end
        $fclose(f);
        repeat (5) @(posedge clk);
        $display("Number of times pointed at 0: %d", zeroCount);
        $finish;

    end

endmodule