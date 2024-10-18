// *********************************************************************************
// Project Name : Corrosion
// Email        : 2972880695@qq.com
// Website      : https://home.cnblogs.com/u/hqz68/
// Create Time  : 2018/10/30 
// File Name    : Cor_alg.v
// Module Name  : Cor_alg
// Called By    : 
// Abstract     :
// editor		: sublime text 3
// *********************************************************************************
// Modification History:
// Date         By              Version                 Change Description
// -----------------------------------------------------------------------
// 2018/1030/30    宏强子           1.0                     Original
//  
// *********************************************************************************
`timescale      1ns/1ns
module Cor_alg (
	//system signals
	input						sclk		, 
	input						s_rst_n		,
	//输入
	input						vsync_i		,
	input						hsync_i		,
	input						data_en_i	,
	input			[15:0]		Cor_data_i	,
	//输出
	output	reg					vsync_o		,
	output	reg					hsync_o		,
	output	reg					data_en_o	,
	output	wire	[15:0]		Cor_data_o

);
 

reg							line1_1			;
reg							line1_2			;
reg							line1_3			;

reg							line2_1			; 
reg							line2_2			;
reg							line2_3			;

reg							line3_1			; 
reg							line3_2			;
reg							line3_3			;

reg							data_flag		;

reg							data_en_r0		;
reg							data_en_r1		;
reg							data_en_r2		;
	
reg                     	vsync_i_r0      ;
reg                     	vsync_i_r1      ;
reg                     	vsync_i_r2      ;

reg                     	hsync_i_r0      ;
reg                     	hsync_i_r1      ;
reg                     	hsync_i_r2      ;

wire						line1			;
wire						line2			;
wire						line3			;



line_buffer	cor_buffer_inst (
	.clock 			( sclk 			),
	.clken			( data_en_i		),
	.shiftin 		( Cor_data_i[0]	),
	.shiftout 		( 		 		),
	.taps0x 		( line1 		),
	.taps1x 		( line2 		),
	.taps2x 		( line3 		)
	);



//line1
always @ (posedge sclk ) begin
		line1_1	<= line1;
		line1_2 <= line1_1;
		line1_3 <= line1_2;
end


//line2
always @ (posedge sclk ) begin
		line2_1	<= line2;
		line2_2 <= line2_1;
		line2_3 <= line2_2;
end


//line3
always @ (posedge sclk ) begin
		line3_1	<= line3;
		line3_2 <= line3_1;
		line3_3 <= line3_2;
end


//腐蚀
always @ (posedge sclk or negedge s_rst_n) begin
	if(s_rst_n == 1'b0)
		data_flag <= 1'b0;	
	else if((line1_1 ==1'b1 || line1_2 ==1'b1 || line1_3 ==1'b1  ||
			 line2_1 ==1'b1 || line2_2 ==1'b1 || line2_3 ==1'b1  ||
			 line3_1 ==1'b1 || line3_2 ==1'b1 || line3_3 ==1'b1 ) && data_en_r2) 
		data_flag <= 1'b1;
	else 
	    data_flag <= 1'b0;   
end


//data_en_o
always @ (posedge sclk ) begin	
        data_en_r0 <= data_en_i;
		data_en_r1 <= data_en_r0;
		data_en_r2 <= data_en_r1;
		data_en_o <= data_en_r2;
end

//hsync_o
always  @(posedge sclk ) begin
        hsync_i_r0 <= hsync_i;
        hsync_i_r1 <= hsync_i_r0;
        hsync_i_r2 <= hsync_i_r1;
        hsync_o <= hsync_i_r2;
                
end


//vsync_o
always  @(posedge sclk ) begin
        vsync_i_r0 <= vsync_i;
        vsync_i_r1 <= vsync_i_r0;
        vsync_i_r2 <= vsync_i_r1;
        vsync_o <= vsync_i_r2;
end

assign Cor_data_o = data_flag == 1'b1 ? 16'hffff : 16'd0;
endmodule