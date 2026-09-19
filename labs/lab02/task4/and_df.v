// and_df.v
// 2-input AND gate, DATAFLOW style, with a continuous-assignment delay.
// Change DELAY to 1, 2, 3 for parts (a), (b), (c).

module and_df #(
  parameter DELAY = 1
) (
  input  a,
  input  b,
  output y
);

  assign #(DELAY) y = a & b;

endmodule