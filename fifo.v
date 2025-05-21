module fifo (
    input wire clk,
    input wire rstn,
    input wire wr_en,
    input wire rd_en,
    input wire [7:0] data_in,         // Corrigido para bater com o tb.v

    output reg [7:0] data_out,        // Corrigido para bater com o tb.v
    output wire empty,
    output wire full
);

    reg [7:0] mem [3:0];      // Memória com 4 posições
    reg [1:0] w_ptr;          // Ponteiro de escrita
    reg [1:0] r_ptr;          // Ponteiro de leitura
    reg [2:0] count;          // Contador (0 a 4)

    assign empty = (count == 0);
    assign full  = (count == 4);

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            w_ptr <= 0;
            r_ptr <= 0;
            count <= 0;
            data_out <= 8'b0;
        end else begin
            // Escrita
            if (wr_en && !full) begin
                mem[w_ptr] <= data_in;
                w_ptr <= w_ptr + 1;
                count <= count + 1;
            end

            // Leitura
            if (rd_en && !empty) begin
                data_out <= mem[r_ptr];
                r_ptr <= r_ptr + 1;
                count <= count - 1;
            end
        end
    end
endmodule
