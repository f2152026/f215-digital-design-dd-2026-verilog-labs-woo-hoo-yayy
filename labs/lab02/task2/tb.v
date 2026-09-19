module tb;

  // Test configuration: change these to test other sizes
  localparam W = 8;
  localparam D = 8;

  reg  [$clog2(D)-1:0] t_sel;
  wire [W-1:0]         t_dout;

  reg  [W-1:0] exp;
  integer      i;
  integer      errors;

  // Instance is named DUT so $dumpvars(0, DUT) below resolves.
  lut #(.WIDTH(W), .DEPTH(D)) DUT (
    .sel  (t_sel),
    .dout (t_dout)
  );

  // Waveform dump configuration (DO NOT CHANGE)
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    errors = 0;
    for (i = 0; i < D; i = i + 1) begin
      t_sel = i;
      #5;
      exp = i * i;
      if (t_dout !== exp) begin
        $display("FAIL at time %0t: sel=%0d got %0d expected %0d",
                 $time, t_sel, t_dout, exp);
        errors = errors + 1;
      end
    end
    $display("%0d of %0d addresses passed", D - errors, D);
    $finish;
  end

  initial
    $monitor($time, " sel=%0d | dout=%0d", t_sel, t_dout);

endmodule