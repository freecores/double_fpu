/////////////////////////////////////////////////////////////////////
////                                                             ////
////  FPU                                                        ////
////  Floating Point Unit (Double precision)                     ////
////                                                             ////
////  Author: David Lundgren                                     ////
////          davidklun@gmail.com                                ////
////                                                             ////
/////////////////////////////////////////////////////////////////////
////                                                             ////
//// Copyright (C) 2009 David Lundgren                           ////
////                  davidklun@gmail.com                        ////
////                                                             ////
//// This source file may be used and distributed without        ////
//// restriction provided that this copyright statement is not   ////
//// removed from the file and that any derivative work contains ////
//// the original copyright notice and the associated disclaimer.////
////                                                             ////
////     THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY     ////
//// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   ////
//// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   ////
//// FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      ////
//// OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         ////
//// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    ////
//// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   ////
//// GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        ////
//// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  ////
//// LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  ////
//// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  ////
//// OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         ////
//// POSSIBILITY OF SUCH DAMAGE.                                 ////
////                                                             ////
/////////////////////////////////////////////////////////////////////

// fpu_op, add = 0, subtract = 1

`timescale 1ns / 100ps

module fpu( clk, rst, enable, fpu_op, opa, opb, out, ready );
input		clk;
input		rst;
input		enable;
input		fpu_op;
input		[63:0]	opa, opb;
output		[63:0]	out;
output		ready;


reg 	[63:0]	outfp, outfp_2, out;
reg   	sign, sign_a, sign_b, fpu_op_1, fpu_op_2, fpu_op_3, fpu_op_4, fpu_op_final;
reg		fpuf_2, fpuf_3, fpuf_4, fpuf_5, fpuf_6, fpuf_7, fpuf_8, fpuf_9, fpuf_10;
reg		fpuf_11, fpuf_12, fpuf_13, fpuf_14, fpuf_15;
reg		sign_a2, sign_a3, sign_b2, sign_b3, sign_2, sign_3, sign_4, sign_5, sign_6; 
reg		sign_7, sign_8, sign_9, sign_10, sign_11, sign_12; 
reg   	[10:0] exponent_a, exponent_b, expa_2, expb_2, expa_3, expb_3;
reg   	[51:0] mantissa_a, mantissa_b, mana_2, mana_3, manb_2, manb_3;
reg		expa_et_inf, expb_et_inf, input_is_inf, in_inf2, in_inf3, in_inf4, in_inf5;
reg		in_inf6, in_inf7, in_inf8, in_inf9, in_inf10, in_inf11, in_inf12, in_inf13;
reg   	in_inf14, in_inf15, expa_gt_expb, expa_et_expb, mana_gtet_manb, a_gtet_b;
reg   	[10:0] exponent_small, exponent_large, expl_1, expl_2, expl_3, expl_4;
reg   	[10:0] expl_5, expl_6, expl_7, expl_8, expl_9, expl_10, expl_11;
reg   	[51:0] mantissa_small, mantissa_large;
reg   	[51:0] mantissa_small_2, mantissa_large_2;
reg   	[51:0] mantissa_small_3, mantissa_large_3;
reg		exp_small_et0, exp_large_et0, exp_small_et0_2, exp_large_et0_2;
reg 	[10:0] exponent_diff, exponent_diff_2, exponent_diff_3, exponent_diff_4;
reg  	[53:0] large_add, large_add_2, large_add_3, small_add;
reg		[53:0] small_shift, small_shift_2, small_shift_3, small_shift_4;
reg  	[53:0] large_add_4, large_add_5;
reg   	small_shift_nonzero;
reg		small_is_nonzero, small_is_nonzero_2, small_is_nonzero_3; 
reg   	small_fraction_enable;
wire    [53:0] small_shift_LSB = { 53'b0, 1'b1 };
reg   	[53:0] sum, sum_2, sum_3, sum_4;
reg   	sum_overflow; 
reg   	[10:0] exponent_add, exp_add2, exponent_sub, exponent_sub_2;
reg		[52:0] minuend, minuend_2, minuend_3, minuend_4, minuend_5, subtrahend;  
reg		[52:0] subtra_shift, subtra_shift_2, subtra_shift_3, subtra_shift_4;
reg   	subtra_shift_nonzero;
reg   	subtra_fraction_enable;
wire    [52:0] subtra_shift_LSB = { 52'b0, 1'b1 };
reg 	[5:0] 	diff_shift, diff_shift_2;
reg		[52:0] diff, diff_2, diff_3, diff_4, diff_5;
reg		diffshift_gt_exponent, diffshift_et_53;
reg 	ready, count_ready, count_ready_0;
reg		[4:0] count;

always @(posedge clk) 
	begin
		if (rst) begin
			sign <= 0; fpu_op_1 <= 0; fpu_op_final <= 0; fpu_op_2 <= 0;
			fpu_op_3 <= 0; fpu_op_4 <= 0; fpuf_2 <= 0; fpuf_3 <= 0; fpuf_4 <= 0;
			fpuf_5 <= 0; fpuf_6 <= 0; fpuf_7 <= 0; fpuf_8 <= 0; fpuf_9 <= 0; 
			fpuf_10 <= 0; fpuf_11 <= 0; fpuf_12 <= 0; fpuf_13 <= 0; fpuf_14 <= 0;  
			fpuf_15 <= 0; sign_a <= 0; sign_b <= 0; 
			sign_a2 <= 0; sign_b2 <= 0; sign_a3 <= 0; sign_b3 <= 0; 
			exponent_a <= 0; exponent_b <= 0; expa_2 <= 0; expa_3 <= 0;
			expb_2 <= 0; expb_3 <= 0; mantissa_a <= 0; mantissa_b <= 0; mana_2 <= 0; mana_3 <= 0;
			manb_2 <= 0; manb_3 <= 0; expa_et_inf <= 0; expb_et_inf <= 0;
			input_is_inf <= 0; in_inf2 <= 0; in_inf3 <= 0; in_inf4 <= 0; in_inf5 <= 0; 
			in_inf6 <= 0; in_inf7 <= 0; in_inf8 <= 0; in_inf9 <= 0; in_inf10 <= 0;
			in_inf11 <= 0; in_inf12 <= 0; in_inf13 <= 0; in_inf14 <= 0; in_inf15 <= 0;
			expa_gt_expb <= 0; expa_et_expb <= 0; mana_gtet_manb <= 0;
   			a_gtet_b <= 0; sign <= 0; sign_2 <= 0; sign_3 <= 0; sign_4 <= 0; sign_5 <= 0;
   			sign_6 <= 0; sign_7 <= 0; sign_8 <= 0; sign_9 <= 0;
   			sign_10 <= 0; sign_11 <= 0; sign_12 <= 0;
			exponent_small  <= 0; exponent_large  <= 0; expl_1 <= 0; expl_2 <= 0;
			expl_3 <= 0; expl_4 <= 0; expl_5 <= 0; expl_6 <= 0; expl_7 <= 0;
			expl_8 <= 0; expl_9 <= 0; expl_10 <= 0; expl_11 <= 0;
			exp_small_et0 <= 0; exp_large_et0 <= 0;
   			exp_small_et0_2 <= 0; exp_large_et0_2 <= 0;
			mantissa_small  <= 0; mantissa_large  <= 0;
			mantissa_small_2 <= 0; mantissa_large_2 <= 0;
			mantissa_small_3 <= 0; mantissa_large_3 <= 0;
			exponent_diff <= 0; exponent_diff_2 <= 0; exponent_diff_3 <= 0;
			exponent_diff_4 <= 0; large_add <= 0; large_add_2 <= 0;
			large_add_3 <= 0; large_add_4 <= 0; large_add_5 <= 0; small_add <= 0;
			small_shift <= 0; small_shift_2 <= 0; small_shift_3 <= 0; 
			small_shift_4 <= 0; small_shift_nonzero <= 0;
			small_is_nonzero <= 0; small_is_nonzero_2 <= 0; small_is_nonzero_3 <= 0;
			small_fraction_enable <= 0;
			sum <= 0; sum_2 <= 0; sum_overflow <= 0; sum_3 <= 0; sum_4 <= 0;
			exponent_add <= 0; exp_add2 <= 0; 
			minuend <= 0; minuend_2 <= 0; minuend_3 <= 0; 
			minuend_4 <= 0; minuend_5 <= 0; subtrahend <= 0;
			subtra_shift <= 0; subtra_shift_2 <= 0; subtra_shift_3 <= 0; 
			subtra_shift_4 <= 0; subtra_shift_nonzero <= 0;
			subtra_fraction_enable <= 0; diff_shift_2 <= 0; diff <= 0;
			diffshift_gt_exponent <= 0; diffshift_et_53 <= 0; diff_2 <= 0;
			diff_3 <= 0; diff_4 <= 0; diff_5 <= 0; exponent_sub <= 0; 
			exponent_sub_2 <= 0; outfp <= 0; outfp_2 <= 0;  out <= 0;
		end
		else if (enable) begin
			fpu_op_1 <= fpu_op; fpu_op_final <= fpu_op_1 ^ (sign_a ^ sign_b);
			fpuf_2 <= fpu_op_final; fpuf_3 <= fpuf_2; fpuf_4 <= fpuf_3;
			fpuf_5 <= fpuf_4; fpuf_6 <= fpuf_5; fpuf_7 <= fpuf_6; fpuf_8 <= fpuf_7; 
			fpuf_9 <= fpuf_8; fpuf_10 <= fpuf_9; fpuf_11 <= fpuf_10; fpuf_12 <= fpuf_11; 
			fpuf_13 <= fpuf_12; fpuf_14 <= fpuf_13; fpuf_15 <= fpuf_14; 
			fpu_op_2 <= fpu_op_1; fpu_op_3 <= fpu_op_2; fpu_op_4 <= fpu_op_3;
			sign_a <= opa[63]; sign_b <= opb[63]; sign_a2 <= sign_a;
			sign_b2 <= sign_b; sign_a3 <= sign_a2; sign_b3 <= sign_b2;
			exponent_a <= opa[62:52]; expa_2 <= exponent_a; expa_3 <= expa_2;
			exponent_b <= opb[62:52]; expb_2 <= exponent_b; expb_3 <= expb_2;
			mantissa_a <= opa[51:0]; mana_2 <= mantissa_a; mana_3 <= mana_2;
			mantissa_b <= opb[51:0]; manb_2 <= mantissa_b; manb_3 <= manb_2;
			expa_et_inf <= exponent_a == 2047;
			expb_et_inf <= exponent_b == 2047;
			input_is_inf <= expa_et_inf | expb_et_inf; in_inf2 <= input_is_inf;
			in_inf3 <= in_inf2; in_inf4 <= in_inf3; in_inf5 <= in_inf4; in_inf6 <= in_inf5;
			in_inf7 <= in_inf6; in_inf8 <= in_inf7; in_inf9 <= in_inf8; in_inf10 <= in_inf9;
			in_inf11 <= in_inf10; in_inf12 <= in_inf11; in_inf13 <= in_inf12; 
			in_inf14 <= in_inf13; in_inf15 <= in_inf14;
			expa_gt_expb <= exponent_a > exponent_b;
			expa_et_expb <= exponent_a == exponent_b;
			mana_gtet_manb <= mantissa_a >= mantissa_b;
   			a_gtet_b <= expa_gt_expb | (expa_et_expb & mana_gtet_manb);
   			sign <= a_gtet_b ? sign_a3 :!sign_b3 ^ (fpu_op_3 == 0);
   			sign_2 <= sign; sign_3 <= sign_2; sign_4 <= sign_3; sign_5 <= sign_4;
   			sign_6 <= sign_5; sign_7 <= sign_6; sign_8 <= sign_7; sign_9 <= sign_8;
   			sign_10 <= sign_9; sign_11 <= sign_10; sign_12 <= sign_11;
   			exponent_small  <= a_gtet_b ? expb_3 : expa_3;
   			exponent_large  <= a_gtet_b ? expa_3 : expb_3; 
   			expl_2 <= exponent_large; expl_3 <= expl_2; expl_4 <= expl_3;
   			expl_5 <= expl_4; expl_6 <= expl_5; expl_7 <= expl_6; expl_8 <= expl_7;
   			expl_9 <= expl_8; expl_10 <= expl_9; expl_11 <= expl_10;
   			exp_small_et0 <= exponent_small == 0;
   			exp_large_et0 <= exponent_large == 0;
   			exp_small_et0_2 <= exp_small_et0;
   			exp_large_et0_2 <= exp_large_et0;
  			mantissa_small  <= a_gtet_b ? manb_3 : mana_3;
   			mantissa_large  <= a_gtet_b ? mana_3 : manb_3;
   			mantissa_small_2 <= mantissa_small;
   			mantissa_large_2 <= mantissa_large;
   			mantissa_small_3 <= exp_small_et0 ? 0 : mantissa_small_2;
   			mantissa_large_3 <= exp_large_et0 ? 0 : mantissa_large_2;
			exponent_diff <= exponent_large - exponent_small;
			exponent_diff_2 <= exponent_diff;
			exponent_diff_3 <= exponent_diff_2;
			exponent_diff_4 <= exponent_diff_3;
			large_add <= { 1'b0, !exp_large_et0_2, mantissa_large_3};
			large_add_2 <= large_add; large_add_3 <= large_add_2;
			large_add_4 <= large_add_3; large_add_5 <= large_add_4;
			small_add <= { 1'b0, !exp_small_et0_2, mantissa_small_3};
			small_shift <= small_add >> exponent_diff_3; 
			small_shift_2 <= small_shift; small_shift_3 <= small_shift_2; 
			small_fraction_enable <= small_is_nonzero_3 & !small_shift_nonzero;
			small_shift_4 <= small_fraction_enable ? small_shift_LSB : small_shift_3;
			small_shift_nonzero <= |small_shift[53:0];
			small_is_nonzero <= !exp_small_et0_2;
			small_is_nonzero_2 <= small_is_nonzero; small_is_nonzero_3 <= small_is_nonzero_2;
			sum <= large_add_5 + small_shift_4;
			sum_overflow <= sum[53];
			sum_2 <= sum;
			sum_3 <= sum_overflow ? sum_2 >> 1 : sum_2;
			sum_4 <= sum_3;
			exponent_add <= sum_overflow ? expl_10 + 1: expl_10;
			exp_add2 <= exponent_add; 
			minuend <= { !exp_large_et0_2, mantissa_large_3};
			minuend_2 <= minuend; minuend_3 <= minuend_2; 
			minuend_4 <= minuend_3; minuend_5 <= minuend_4;
			subtrahend <= { !exp_small_et0_2, mantissa_small_3};
			subtra_shift <= subtrahend >> exponent_diff_3;
			subtra_shift_2 <= subtra_shift;
			subtra_shift_3 <= subtra_shift_2;
			subtra_shift_nonzero <= |subtra_shift[52:0];
			subtra_fraction_enable <= small_is_nonzero_3 & !subtra_shift_nonzero;
			subtra_shift_4 <= subtra_fraction_enable ? subtra_shift_LSB : subtra_shift_3;
			diff_shift_2 <= diff_shift;
			diff <= minuend_5 - subtra_shift_4; diff_2 <= diff; diff_3 <= diff_2;
			diffshift_gt_exponent <= diff_shift > expl_10;
			diffshift_et_53 <= diff_shift_2 == 53; 
			diff_4 <= diffshift_gt_exponent ? diff_3 << expl_11 : diff_3 << diff_shift_2;
			diff_5 <= diff_4;
			exponent_sub <= diffshift_gt_exponent ? 0 : (expl_11 - diff_shift_2);
			exponent_sub_2 <= diffshift_et_53 ? 0 : exponent_sub;
			outfp <= {sign_12, exp_add2, sum_4[51:0]};
			outfp_2 <= fpuf_15 ? {outfp[63], exponent_sub_2, diff_5[51:0]} : outfp;
			out <= in_inf15 ? { outfp_2[63], 11'b11111111111, 52'b0 } : outfp_2;
		end
	end


		
always @(posedge clk)
   casex(diff)	
    53'b1????????????????????????????????????????????????????: diff_shift <=  0;
	53'b01???????????????????????????????????????????????????: diff_shift <=  1;
	53'b001??????????????????????????????????????????????????: diff_shift <=  2;
	53'b0001?????????????????????????????????????????????????: diff_shift <=  3;
	53'b00001????????????????????????????????????????????????: diff_shift <=  4;
	53'b000001???????????????????????????????????????????????: diff_shift <=  5;
	53'b0000001??????????????????????????????????????????????: diff_shift <=  6;
	53'b00000001?????????????????????????????????????????????: diff_shift <=  7;
	53'b000000001????????????????????????????????????????????: diff_shift <=  8;
	53'b0000000001???????????????????????????????????????????: diff_shift <=  9;
	53'b00000000001??????????????????????????????????????????: diff_shift <=  10;
	53'b000000000001?????????????????????????????????????????: diff_shift <=  11;
	53'b0000000000001????????????????????????????????????????: diff_shift <=  12;
	53'b00000000000001???????????????????????????????????????: diff_shift <=  13;
	53'b000000000000001??????????????????????????????????????: diff_shift <=  14;
	53'b0000000000000001?????????????????????????????????????: diff_shift <=  15;
	53'b00000000000000001????????????????????????????????????: diff_shift <=  16;
	53'b000000000000000001???????????????????????????????????: diff_shift <=  17;
	53'b0000000000000000001??????????????????????????????????: diff_shift <=  18;
	53'b00000000000000000001?????????????????????????????????: diff_shift <=  19;
	53'b000000000000000000001????????????????????????????????: diff_shift <=  20;
	53'b0000000000000000000001???????????????????????????????: diff_shift <=  21;
	53'b00000000000000000000001??????????????????????????????: diff_shift <=  22;
	53'b000000000000000000000001?????????????????????????????: diff_shift <=  23;
	53'b0000000000000000000000001????????????????????????????: diff_shift <=  24;
	53'b00000000000000000000000001???????????????????????????: diff_shift <=  25;
	53'b000000000000000000000000001??????????????????????????: diff_shift <=  26;
	53'b0000000000000000000000000001?????????????????????????: diff_shift <=  27;
	53'b00000000000000000000000000001????????????????????????: diff_shift <=  28;
	53'b000000000000000000000000000001???????????????????????: diff_shift <=  29;
	53'b0000000000000000000000000000001??????????????????????: diff_shift <=  30;
	53'b00000000000000000000000000000001?????????????????????: diff_shift <=  31;
	53'b000000000000000000000000000000001????????????????????: diff_shift <=  32;
	53'b0000000000000000000000000000000001???????????????????: diff_shift <=  33;
	53'b00000000000000000000000000000000001??????????????????: diff_shift <=  34;
	53'b000000000000000000000000000000000001?????????????????: diff_shift <=  35;
	53'b0000000000000000000000000000000000001????????????????: diff_shift <=  36;
	53'b00000000000000000000000000000000000001???????????????: diff_shift <=  37;
	53'b000000000000000000000000000000000000001??????????????: diff_shift <=  38;
	53'b0000000000000000000000000000000000000001?????????????: diff_shift <=  39;
	53'b00000000000000000000000000000000000000001????????????: diff_shift <=  40;
	53'b000000000000000000000000000000000000000001???????????: diff_shift <=  41;
	53'b0000000000000000000000000000000000000000001??????????: diff_shift <=  42;
	53'b00000000000000000000000000000000000000000001?????????: diff_shift <=  43;
	53'b000000000000000000000000000000000000000000001????????: diff_shift <=  44;
	53'b0000000000000000000000000000000000000000000001???????: diff_shift <=  45;
	53'b00000000000000000000000000000000000000000000001??????: diff_shift <=  46;
	53'b000000000000000000000000000000000000000000000001?????: diff_shift <=  47;
	53'b0000000000000000000000000000000000000000000000001????: diff_shift <=  48;
    53'b00000000000000000000000000000000000000000000000001???: diff_shift <=  49;
	53'b000000000000000000000000000000000000000000000000001??: diff_shift <=  50;
	53'b0000000000000000000000000000000000000000000000000001?: diff_shift <=  51;
	53'b00000000000000000000000000000000000000000000000000001: diff_shift <=  52;
	53'b00000000000000000000000000000000000000000000000000000: diff_shift <=  53;
	endcase	

	
always @(posedge clk) 
begin
	if (rst) begin
		ready <= 0;
		count_ready_0 <= 0;
		count_ready  <= 0;
	end
	else if (enable) begin
		ready <= count_ready;
		count_ready_0 <= count == 15;
		count_ready <= count == 16;
	end
end

always @(posedge clk) 
begin
	if (rst) 
		count <= 0;
	else if (enable & !count_ready_0 & !count_ready) 
		count <= count + 1;
end

endmodule
