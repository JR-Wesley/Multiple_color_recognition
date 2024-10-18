// *********************************************************************************
// Project Name : OV7725_VGA_FaceTracking
// Email        : 2972880695@qq.com
// Website      : https://home.cnblogs.com/u/hqz68/
// Create Time  : 2018/10/6 11:17:26
// File Name    : RGB2Ycbcr.v
// Module Name  : RGB2Ycbcr
// Called By    : 
// Abstract     :
//
// *********************************************************************************
// Modification History:
// Date         By              Version                 Change Description
// -----------------------------------------------------------------------
// 2018/10/6    宏强�?           1.0                     Original
//  
// *********************************************************************************
`timescale      1ns/1ns
module  RGB2Ycbcr(
        //system signals
        input                   s_rst_n                 ,       
        input                   sclk                    ,       
        //输入
        input           [7:0]   rgb_r                   ,
        input           [7:0]   rgb_g                   ,
        input           [7:0]   rgb_b                   ,
        input                   vsync_i                 ,
        input                   hsync_i                 ,
        //数据调试接口
        input           [7:0]   data_1_up               ,
        input           [7:0]   data_1_down             ,
        input           [7:0]   data_2_up               ,
        input           [7:0]   data_2_down             ,
        //输出
        output  reg             vsync_o                 ,       
        output  reg             hsync_o                 ,       
        output  wire    [7:0]   data_o                  

);


//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/

// blue
localparam              cb_up   =       8'd255   ;
localparam              cb_down =       8'd180   ;
localparam              cr_up   =       8'd128   ;
localparam              cr_down =       8'd80    ;
/*
// red
localparam              cb_up   =       8'd128   ;
localparam              cb_down =       8'd48   ;
localparam              cr_up   =       8'd255   ;
localparam              cr_down =       8'd200   ;
*/
reg             [15:0]          Y_sum           ;
reg             [15:0]          Cb_sum          ;
reg             [15:0]          Cr_sum          ;

reg             [7:0]           Y_data          ;
reg             [7:0]           Cb_data         ;
reg             [7:0]           Cr_data         ;

reg                             vsync_i_r0      ;
reg                             hsync_i_r0      ;
reg             [7:0]           state           ;


//=============================================================================
//**************    Main Code   **************
//=============================================================================

//Y_sum
always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                Y_sum <= 16'd0;
        else
                Y_sum <= 8'd77 * rgb_r + 8'd150 * rgb_g + 8'd29 * rgb_b; 
end

//Cb_sum
always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                Cb_sum <= 16'd0;
        else
                Cb_sum <= -8'd43 * rgb_r - 8'd85 * rgb_g + 8'd128 * rgb_b; 
end


//Cr_sum
always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                Cr_sum <= 16'd0;
        else
                Cr_sum <= 8'd128 * rgb_r - 8'd107 * rgb_g - 8'd21 * rgb_b; 
end

//Y_data
always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                Y_data <= 8'd0;
        else
                Y_data <=  Y_sum[15:8];
end


//Cb_data
always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                Cb_data <= 8'd0;
        else
                Cb_data <=  Cb_sum[15:8] + 8'd128;
end

//Cr_data
always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                Cr_data <= 8'd0;
        else
                Cr_data <=  Cr_sum[15:8] +8'd128;
end


//hsync_o
always  @(posedge sclk ) begin
        hsync_i_r0 <= hsync_i;
        hsync_o <= hsync_i_r0;
                
end


//vsync_o
always  @(posedge sclk ) begin
        vsync_i_r0 <= vsync_i;
        vsync_o <= vsync_i_r0;
end



 assign  data_o = (Cb_data > cb_down && Cb_data < cb_up 
 		&& Cr_data > cr_down && Cr_data < cr_up) ? 8'hff : 8'h00 ;  //红色


//assign  data_o = (Cb_data > data_1_down && Cb_data < data_1_up 
//		&& Cr_data > data_2_down && Cr_data < data_2_up) ? 8'hff : 8'h00 ;  //肤色
//assign  data_o = (Cb_data <8'd110 
//						&& Cr_data >8'd50 && Cr_data < 8'd100) ? 8'hff : 8'h00 ;  
endmodule
