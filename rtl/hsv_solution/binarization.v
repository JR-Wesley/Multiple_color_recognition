module binarization(
    input[8:0] h_thre_u,
	input[8:0] h_thre_l,
	input[7:0] s_thre_u,
	input[7:0] s_thre_l,
	input[7:0] v_thre_u,
	input[7:0] v_thre_l,
	input[8:0] h,
	input[7:0] s,
	input[7:0] v,
	output bin
);
assign bin=(h<h_thre_u && h>h_thre_l && s<s_thre_u && s>s_thre_l && v<v_thre_u && v>v_thre_l)?1:0;
endmodule