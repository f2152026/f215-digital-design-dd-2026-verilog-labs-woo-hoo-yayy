module tb;

  reg  [1:0] t_a, t_b;
  wire       t_gt, t_lt, t_eq;

  reg     exp_gt, exp_lt, exp_eq;
  integer i, ia, ib;
  integer errors;

  // Instance is named DUT so $dumpvars(0, DUT) below resolves.
  comp2 DUT (
    .A  (t_a),
    .B  (t_b),
    .GT (t_gt),
    .LT (t_lt),
    .EQ (t_eq)
  );

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    errors = 0;
    for (i = 0; i < 16; i = i + 1) begin
      // Apply every {A,B} pair, 00_00 through 11_11
      ia = i / 4;
      ib = i % 4;
      t_a = ia;
      t_b = ib;
      #5;

      // Expected values come from the integer copies of the operands,
      // not from anything in comp2.v
      exp_gt = (ia >  ib);
      exp_lt = (ia <  ib);
      exp_eq = (ia == ib);

      if ({t_gt, t_lt, t_eq} !== {exp_gt, exp_lt, exp_eq}) begin
        $display("FAIL at time %0t: A=%b B=%b  got GT=%b LT=%b EQ=%b  expected GT=%b LT=%b EQ=%b",
                 $time, t_a, t_b, t_gt, t_lt, t_eq, exp_gt, exp_lt, exp_eq);
        errors = errors + 1;
      end
    end

    // Summary line built piece by piece with $write
    $write("%0d of %0d combinations passed", 16 - errors, 16);
    if (errors == 0) $write(" -- ALL PASS");
    $write("\n");
    $finish;
  end

  initial
    $monitor($time, " A=%b B=%b | GT=%b LT=%b EQ=%b", t_a, t_b, t_gt, t_lt, t_eq);

endmodule