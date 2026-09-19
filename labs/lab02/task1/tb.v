module tb;

  reg  t_i0, t_i1, t_s;
  wire t_y;

  // Instance is named DUT so that $dumpvars(0, DUT) below resolves.
  DUT DUT (
    .I0 (t_i0),
    .I1 (t_i1),
    .S  (t_s),
    .Y  (t_y)
  );

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  integer i;
  initial begin
    for (i = 0; i < 8; i = i + 1) begin
      {t_i0, t_i1, t_s} = i[2:0];
      #5;
    end
    $finish;
  end

  initial
    $monitor($time, " I0=%b I1=%b S=%b | Y=%b", t_i0, t_i1, t_s, t_y);

endmodule