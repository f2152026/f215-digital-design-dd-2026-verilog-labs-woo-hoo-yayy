// and_beh_intra.v
// 2-input AND gate, BEHAVIORAL style, INTRA-assignment delay.
// a & b is evaluated immediately; only the write into y is delayed.
// Change DELAY to 1, 2, 3 for parts (a), (b), (c).

module and_beh_intra #(
  parameter DELAY = 1
) (
  input      a,
  input      b,
  output reg y
);

  always @(*) begin
    y = #(DELAY) a & b;
  end 

endmodule