// *********************************************************************************
// Project Name : ov7725_ball
// Email        : 2972880695@qq.com
// Website      : https://home.cnblogs.com/u/hqz68/
// Create Time  : 2018/4/10 
// File Name    : Boundary_extraction.v
// Module Name  : Boundary_extraction
// Abstract     :
// editor		: sublime text 3
// *********************************************************************************
// Modification History:
// Date         By              Version                 Change Description
// -----------------------------------------------------------------------
// 2018/4/10    宏强�?           1.0                     Original
//  
// *********************************************************************************
`timescale      1ns/1ns
module Boundary_extraction (
	//system signals
	input					sclk			, 
	input					s_rst_n			,
	//图像数据输入
	input					vsync_i			,
	input					hsync_i			,
	input					data_en_i		,
	input					bound_data_i	,
	//坐标数据
	output wire [15:0] valid_num,
	output	wire	[31:0]	x_coor			,
	output	wire	[31:0]	y_coor			,
	output	wire			coor_valid_flag	
);
//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/

reg 						data_en_i_pos	;
reg 						data_en_i_r1	;

reg 						vsync_i_pos		;
reg 						vsync_i_neg		;
reg 						vsync_i_r1		;

reg 			[15:0]		valid_num_cnt	;
reg 						valid_flag		;
reg				[31:0]		x_coor_all		;
reg				[31:0]		y_coor_all		;
reg 			[9:0]		row_cnt			;
reg 			[9:0]		col_cnt			;

// reg 			[9:0]		y_coor_up		;
// reg 			[9:0]		y_coor_down		;
// reg 						y_flag			;

//=============================================================================
//****************************     Main Code    *******************************
//=============================================================================



//行有效下降沿
always @ (posedge sclk) begin	
	data_en_i_r1 <= data_en_i;
end

always @ (posedge sclk or negedge s_rst_n) begin
	if(s_rst_n == 1'b0)
		data_en_i_pos <= 1'b0;
	else if (~data_en_i_r1 && data_en_i)
	    data_en_i_pos <= 1'b1;    
	else	
        data_en_i_pos <= 1'b0;
end

always @ (posedge sclk) begin	
	vsync_i_r1 <= vsync_i;
end

//场有效上降沿
always @ (posedge sclk or negedge s_rst_n) begin
	if(s_rst_n == 1'b0)
		vsync_i_pos <= 1'b0;
	else if (~vsync_i_r1 && vsync_i)
	    vsync_i_pos <= 1'b1;    
	else	
        vsync_i_pos <= 1'b0;
end

//场有效下降沿
always @ (posedge sclk or negedge s_rst_n) begin
	if(s_rst_n == 1'b0)
		vsync_i_neg <= 1'b0;
	else if (vsync_i_r1 && ~vsync_i)
	    vsync_i_neg <= 1'b1;    
	else	
        vsync_i_neg <= 1'b0;
end

//行计�?
always @ (posedge sclk or negedge s_rst_n) begin
	if(s_rst_n == 1'b0)
		row_cnt <= 10'd0;
	else if (vsync_i_neg == 1'b1)        	
		row_cnt <= 10'd0; 	
	else if (data_en_i_pos == 1'b1 )
		row_cnt <= row_cnt + 1'b1;   
end

//列计�?
 always @ (posedge sclk or negedge s_rst_n) begin
 	if(s_rst_n == 1'b0)
 		col_cnt <= 10'd0;
 	else if (data_en_i == 1'b1)
 		col_cnt <= col_cnt + 1'b1;
 	else	
         col_cnt <= 10'd0;
 end

//目标数据计数
always @ (posedge sclk or negedge s_rst_n) begin
	if(s_rst_n == 1'b0)
		valid_num_cnt <= 16'd0;
	else if (vsync_i_neg == 1'b1)
		valid_num_cnt <= 16'd0;   
	else if (data_en_i == 1'b1 && bound_data_i == 1'b1)
		valid_num_cnt <= valid_num_cnt + 1'b1;   
end


//目标有效标志
always @ (posedge sclk or negedge s_rst_n) begin
	if(s_rst_n == 1'b0)
		valid_flag <= 1'b0;
	else if (vsync_i_neg == 1'b1)
		valid_flag <= 1'b0;	        
	else if (valid_num_cnt >= 16'd1500)
		valid_flag <= 1'b1;      
end

//x坐标求和
always @ (posedge sclk or negedge s_rst_n) begin
	if(s_rst_n == 1'b0)
		x_coor_all <= 32'd0;
	else if (data_en_i == 1'b1 && bound_data_i == 1'b1)
	    x_coor_all <=  x_coor_all +  col_cnt;  
	else if (vsync_i_neg == 1'b1)
	    x_coor_all <= 32'd0;    	   
end


//y坐标求和
always @ (posedge sclk or negedge s_rst_n) begin
	if(s_rst_n == 1'b0)
		y_coor_all <= 32'd0;
	else if (data_en_i == 1'b1 && bound_data_i == 1'b1)
	    y_coor_all <=  y_coor_all +  row_cnt;  
	else if (vsync_i_neg == 1'b1)
	    y_coor_all <= 32'd0;    	   
end

assign x_coor =  (vsync_i == 1'b1 ) ? x_coor_all : 32'd0;
assign y_coor =  (vsync_i == 1'b1 ) ? y_coor_all : 32'd0;
assign valid_num =  (vsync_i == 1'b1 ) ? valid_num_cnt : 16'd0;

assign coor_valid_flag = vsync_i && valid_flag;
// //==================================================

// //y方向上边界坐�?
// always @ (posedge sclk or negedge s_rst_n) begin
// 	if(s_rst_n == 1'b0) begin
// 		y_coor_up <= 10'd0;
// 		y_flag <= 1'b0;
// 	end
// 	else if (vsync_i == 1'b0)begin
// 		y_coor_up <= 10'd0;
// 		y_flag <= 1'b0;
// 	end      
// 	else if (valid_num_cnt == 10'd3 & hsync_i_neg == 1'b1 & y_flag == 1'b0) begin
//         y_coor_up <= row_cnt;
//         y_flag <= 1'b1;
//     end       
// end


// //y方向下边界坐�?
// always @ (posedge sclk or negedge s_rst_n) begin
// 	if(s_rst_n == 1'b0) begin
// 		y_coor_down <= 10'd0;
// 		y_flag <= 1'b0;
// 	end
// 	else if (vsync_i == 1'b0)begin
// 		y_coor_down <= 10'd0;
// 		y_flag <= 1'b0;
// 	end      
// 	else if (valid_num_cnt == 10'd3 & hsync_i_neg == 1'b1 & y_flag == 1'b1) begin
//         y_coor_down <= row_cnt;
//         y_flag <= 1'b0;
//     end       
// end

// //=======================================================================

// //x方向左边界坐�?
// always @ (posedge sclk or negedge s_rst_n) begin
// 	if(s_rst_n == 1'b0)
// 		x_coor_l <= 10'd640;
// 	else if (valid_num_cnt == 10'd3 & x_coor_l > col_cnt)
// 		x_coor_l <= col_cnt;             
// end

// //x方向右边界坐�?
// always @ (posedge sclk or negedge s_rst_n) begin
// 	if(s_rst_n == 1'b0)
// 		x_coor_r <= 10'd0;
// 	else if (hsync_i_neg == 1'b1 & x_coor_r < col_cnt)
// 		x_coor_r <= col_cnt;        
// end

endmodule