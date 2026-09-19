// tb.v
// Self-checking testbench for alu.v (op=0: add, op=1: sub, 4-bit operands).
// Expected results are computed here with integer arithmetic, independent
// of the design's logic.

module tb;

  reg  [3:0] t_a, t_b;
  reg        t_op;
  wire [3:0] t_result;

  reg  [3:0] exp;
  integer    ia, ib, iop;
  integer    errors, total;

  // Instance is named DUT to match the other tasks.
  alu DUT (
    .a      (t_a),
    .b      (t_b),
    .op     (t_op),
    .result (t_result)
  );

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, tb);
    end
  end

  // Apply one test vector, wait for it to settle, then check it.
  task apply_and_check(input [3:0] a, input [3:0] b, input op);
    begin
      t_a  = a;
      t_b  = b;
      t_op = op;
      #5;
      exp = op ? (a - b) : (a + b);   // truncated to 4 bits on assignment
      total = total + 1;
      if (t_result !== exp) begin
        $display("FAIL at time %0t: op=%b a=%0d b=%0d  got %0d  expected %0d",
                 $time, op, a, b, t_result, exp);
        errors = errors + 1;
      end
    end
  endtask

  initial begin
    errors = 0;
    total  = 0;

    // Phase 1: same operands held fixed while op switches
    apply_and_check(4'd9, 4'd3, 1'b0);   // add
    apply_and_check(4'd9, 4'd3, 1'b1);   // sub (only op changed)
    apply_and_check(4'd9, 4'd3, 1'b0);   // back to add
    apply_and_check(4'd9, 4'd3, 1'b1);   // back to sub

    // Phase 2: operands changing, both operations
    apply_and_check(4'd7, 4'd2, 1'b0);
    apply_and_check(4'd8, 4'd5, 1'b1);
    apply_and_check(4'd3, 4'd6, 1'b1);   // negative result wraps
    apply_and_check(4'd15, 4'd1, 1'b0);  // add overflow wraps
    apply_and_check(4'd0, 4'd0, 1'b1);

    // Phase 3: exhaustive, all 512 combinations of a, b, op
    for (iop = 0; iop < 2; iop = iop + 1)
      for (ia = 0; ia < 16; ia = ia + 1)
        for (ib = 0; ib < 16; ib = ib + 1)
          apply_and_check(ia[3:0], ib[3:0], iop[0]);

    // Summary line
    $write("%0d of %0d tests passed", total - errors, total);
    if (errors == 0) $write(" -- ALL PASS");
    $write("\n");
    $finish;
  end

endmodule