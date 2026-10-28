`timescale 1ns / 1ps

module sc_fifo #(
    parameter integer WIDTH = 16,
    parameter integer DEPTH = 32,
    parameter integer ALMOST_EMPTY_THRESHOLD = 1,
    parameter integer ALMOST_FULL_THRESHOLD = 31,
    parameter integer READ_LATENCY = 1
) (
    input  wire CLK,
    input  wire SRST,

    input  wire [WIDTH-1:0] DATA_IN,
    input  wire WRITE_ENABLE,
    input  wire READ_ENABLE,

    output wire [$clog2(DEPTH+1)-1:0] DATA_COUNT,
    output wire VALID,
    output wire [WIDTH-1:0] DATA_OUT,

    output wire ALMOST_FULL,
    output wire ALMOST_EMPTY,
    output wire FULL,
    output wire EMPTY
);

    localparam integer PTR_WIDTH =
        (DEPTH <= 1) ? 1 : $clog2(DEPTH);

    localparam integer COUNT_WIDTH = $clog2(DEPTH + 1);

    // Infer block RAM for FIFO storage.
    (* ram_style = "block" *)
    reg [WIDTH-1:0] memory [0:DEPTH-1];

    reg [PTR_WIDTH-1:0] write_pointer;
    reg [PTR_WIDTH-1:0] read_pointer;
    reg [COUNT_WIDTH-1:0] count_register;

    reg [WIDTH-1:0] data_pipeline [0:READ_LATENCY-1];
    reg [READ_LATENCY-1:0] valid_pipeline;

    wire write_accept;
    wire read_accept;

    integer i;

    assign DATA_COUNT = count_register;

    assign EMPTY = (count_register == 0);
    assign FULL  = (count_register == DEPTH);

    assign ALMOST_EMPTY =
        (count_register <= ALMOST_EMPTY_THRESHOLD);

    assign ALMOST_FULL =
        (count_register >= ALMOST_FULL_THRESHOLD);

    // Reject writes when full and reads when empty.
    assign write_accept = WRITE_ENABLE && !FULL;
    assign read_accept  = READ_ENABLE && !EMPTY;

    assign DATA_OUT = data_pipeline[READ_LATENCY-1];
    assign VALID    = valid_pipeline[READ_LATENCY-1];

    always @(posedge CLK) begin
        if (SRST) begin
            write_pointer <= 0;
            read_pointer  <= 0;
            count_register <= 0;

            valid_pipeline <= {READ_LATENCY{1'b0}};

            for (i = 0; i < READ_LATENCY; i = i + 1) begin
                data_pipeline[i] <= {WIDTH{1'b0}};
            end
        end else begin
            if (write_accept) begin
                memory[write_pointer] <= DATA_IN;

                if (write_pointer == DEPTH - 1)
                    write_pointer <= 0;
                else
                    write_pointer <= write_pointer + 1'b1;
            end

            if (read_accept) begin
                data_pipeline[0] <= memory[read_pointer];

                if (read_pointer == DEPTH - 1)
                    read_pointer <= 0;
                else
                    read_pointer <= read_pointer + 1'b1;
            end

            for (i = 1; i < READ_LATENCY; i = i + 1) begin
                data_pipeline[i] <= data_pipeline[i-1];
                valid_pipeline[i] <= valid_pipeline[i-1];
            end

            valid_pipeline[0] <= read_accept;

            case ({write_accept, read_accept})
                2'b10: count_register <= count_register + 1'b1;
                2'b01: count_register <= count_register - 1'b1;
                default: count_register <= count_register;
            endcase
        end
    end

endmodule