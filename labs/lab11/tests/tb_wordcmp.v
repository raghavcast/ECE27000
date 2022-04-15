/******************************************************************************
YOU ARE NOT PERMITTED TO USE ANYTHING FROM THIS FILE IN YOUR OWN CODE.
ANY ATTEMPT TO DO SO WILL BE CONSIDERED AN INSTANCE OF ACADEMIC DISHONESTY.
******************************************************************************/

`timescale 1ms/10ps
module tb_wordcmp();
  logic [5:0] in_place, in_word;
  logic [47:0] guessed, selected;

  wordcmp wcmp (.in_place(in_place), .in_word(in_word), 
                .guessed(guessed), .selected(selected));

  // send errors to stderr, not stdout :P
  integer STDERR = 32'h8000_0002;
  // keep track of time for labeling
  integer rltime;
  initial rltime = 0;
  always #1 rltime = rltime + 1;

  assign selected = "design";
  logic [5:0] corrinp, corrinw;
  assign corrinp = { guessed[47:40] == selected[47:40],
                     guessed[39:32] == selected[39:32],
                     guessed[31:24] == selected[31:24],
                     guessed[23:16] == selected[23:16],
                     guessed[15:8] == selected[15:8],
                     guessed[7:0] == selected[7:0] 
                   };
  assign corrinw = { guessed[47:40] == selected[39:32] || guessed[47:40] == selected[31:24] || guessed[47:40] == selected[23:16] || guessed[47:40] == selected[15:8] || guessed[47:40] == selected[7:0],
                     guessed[39:32] == selected[47:40] || guessed[39:32] == selected[31:24] || guessed[39:32] == selected[23:16] || guessed[39:32] == selected[15:8] || guessed[39:32] == selected[7:0],
                     guessed[31:24] == selected[47:40] || guessed[31:24] == selected[39:32] || guessed[31:24] == selected[23:16] || guessed[31:24] == selected[15:8] || guessed[31:24] == selected[7:0],
                     guessed[23:16] == selected[47:40] || guessed[23:16] == selected[31:24] || guessed[23:16] == selected[39:32] || guessed[23:16] == selected[15:8] || guessed[23:16] == selected[7:0],
                     guessed[15:8] == selected[47:40] || guessed[15:8] == selected[31:24] || guessed[15:8] == selected[23:16] || guessed[15:8] == selected[39:32] || guessed[15:8] == selected[7:0],
                     guessed[7:0] == selected[47:40] || guessed[7:0] == selected[31:24] || guessed[7:0] == selected[23:16] || guessed[7:0] == selected[15:8] || guessed[39:32] == selected[7:0]
                   };

  integer errored;

  initial begin
    $dumpfile("build/wordcmp.vcd");
    $dumpvars(0, tb_wordcmp);
    errored = 0; 
    guessed = "      ";
    #1;
    if (in_place != corrinp || in_word != corrinw) begin
      $fdisplay(STDERR, "%d ns | ERROR: all mismatch character test | Expected in_place=%8b, in_word=%8b, but got in_place=%8b and in_word=%8b",
                corrinp, corrinw, in_place, in_word);
      errored = 1;
    end
    guessed = "desert";
    #1;
    if (in_place != corrinp || in_word != corrinw) begin
      $fdisplay(STDERR, "%d ns | ERROR: some match character test | Expected in_place=%8b, in_word=%8b, but got in_place=%8b and in_word=%8b with guessed=%s and selected=%s",
                corrinp, corrinw, in_place, in_word, guessed, selected);
      errored = 1;
    end
    guessed = "dampen";
    #1;
    if (in_place != corrinp || in_word != corrinw) begin
      $fdisplay(STDERR, "%d ns | ERROR: some match character test | Expected in_place=%8b, in_word=%8b, but got in_place=%8b and in_word=%8b with guessed=%s and selected=%s",
                corrinp, corrinw, in_place, in_word, guessed, selected);
      errored = 1;
    end
    guessed = "abacus";
    #1;
    if (in_place != corrinp || in_word != corrinw) begin
      $fdisplay(STDERR, "%d ns | ERROR: all mismatch character test | Expected in_place=%8b, in_word=%8b, but got in_place=%8b and in_word=%8b with guessed=%s and selected=%s",
                corrinp, corrinw, in_place, in_word, guessed, selected);
      errored = 1;
    end
    guessed = "useful";
    #1;
    if (in_place != corrinp || in_word != corrinw) begin
      $fdisplay(STDERR, "%d ns | ERROR: some match character test | Expected in_place=%8b, in_word=%8b, but got in_place=%8b and in_word=%8b with guessed=%s and selected=%s",
                corrinp, corrinw, in_place, in_word, guessed, selected);
      errored = 1;
    end
    guessed = "design";
    #1;
    if (in_place != corrinp || in_word != corrinw) begin
      $fdisplay(STDERR, "%d ns | ERROR: all matched character test | Expected in_place=%8b, in_word=%8b, but got in_place=%8b and in_word=%8b with guessed=%s and selected=%s",
                corrinp, corrinw, in_place, in_word, guessed, selected);
      errored = 1;
    end
    if (errored == 0) $display("All tests passed!");
    $finish_and_return(errored);
  end

endmodule