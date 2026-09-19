// and_beh_before.v
// 2-input AND gate, BEHAVIORAL style, delay BEFORE the assignment.
// The process waits DELAY units, THEN evaluates a & b with the values
// at that later moment.
// Change DELAY to 1, 2, 3 for parts (a), (b), (c).

module and_beh_before #(
  parameter DELAY = 1
) (
  input      a,
  input      b,
  output reg y
);

  always @(*) begin
    #(DELAY) y = a & b;
  end 

endmodule