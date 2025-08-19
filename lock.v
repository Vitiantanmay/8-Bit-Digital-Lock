module digital_lock #(
    parameter [7:0] PASSWORD = 8'hA5,
    parameter integer MAX_ATTEMPTS = 3
)(
    input  wire       clk,
    input  wire       rst,
    input  wire [7:0] key_in,
    input  wire       enter,
    output reg        access,
    output reg        alarm,
    output reg        lockout
);

    reg [31:0] attempts;

    always @(posedge clk) begin
        if (rst) begin
            access  <= 1'b0;
            alarm   <= 1'b0;
            lockout <= 1'b0;
            attempts<= 0;
        end else begin
            alarm <= 1'b0;
            if (!access && !lockout && enter) begin
                if (key_in == PASSWORD) begin
                    access <= 1'b1;
                    attempts <= 0;
                end else begin
                    alarm <= 1'b1;
                    if (attempts < MAX_ATTEMPTS)
                        attempts <= attempts + 1;
                    if ((attempts + 1) >= MAX_ATTEMPTS)
                        lockout <= 1'b1;
                end
            end
        end
    end

endmodule
