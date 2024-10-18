// *********************************************************************************
// Project Name : OSXXXX
// Email        : 2972880695@qq.com
// Website      : https://home.cnblogs.com/u/hqz68/
// Create Time  : 2018/10/6 14:45:08
// File Name    : algo_top.v
// Module Name  : algo_top
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
module  algo_top(
        //system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,   
        //输入
        input                   vsync_i                 ,       
        input                   hsync_i                 ,       
	    input	[15 : 0]		data_i		            ,	
        input                   [1 : 0]sel              ,
        input                   data_en                 ,       
        //输出
        output  reg             vsync_o                 ,       
        output  reg             hsync_o                 ,       
        output  [15 : 0] rgb565 ,
        //输出坐标
	    output  wire    [15 : 0]   valid_num            ,
        output  wire    [31 : 0]   x_coor               ,
        output  wire    [31 : 0]   y_coor               ,
        output  wire            coor_valid_flag        
);
reg     [17:0] rgb_data_o;
assign rgb565 ={rgb_data_o[17 : 13], rgb_data_o[11 : 6], rgb_data_o[5 : 1]};
//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/
localparam              RGB             = 2'b00         ;
localparam              YCBCR           = 2'b01         ;
localparam              CORRO           = 2'b10         ;
localparam              EXP             = 2'b11         ;

reg             [1:0]           state                   ;
reg             [17:0]          rgb_data_i0             ;
wire            [7:0]           rgb_r                   ;
wire            [7:0]           rgb_g                   ;
wire            [7:0]           rgb_b                   ;
wire		[7:0]           Ycbcr_data_o            ;
wire            [15:0]          Cor_data_o              ;
wire            [15:0]          Exp_data_o              ;
wire                            cor_vsync_o             ;
wire                            cor_hsync_o             ;
wire                            exp_vsync_o             ;
wire                            exp_hsync_o             ;
wire                            ycbcr_vsync_o           ;
wire                            ycbcr_hsync_o           ;
wire            [7:0]           data_1_up               ;
wire            [7:0]           data_1_down             ;
wire            [7:0]           data_2_up               ;
wire            [7:0]           data_2_down             ;
wire                            cor_data_en_o           ;
wire                            exp_data_en_o           ;
//=============================================================================
//**************    Main Code   **************
//=============================================================================

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                state <= RGB;
        else state <= sel;
end

always  @(posedge sclk ) begin
          rgb_data_i0 <= {data_i[15 : 11], 1'b0, data_i[10 : 5], data_i[4 : 0], 1'b0};              
end


always  @(posedge sclk ) begin
        if(state == RGB) begin
                rgb_data_o <= rgb_data_i0;
                vsync_o <= vsync_i; 
                hsync_o <= hsync_i; 
                end
        else if(state == YCBCR) begin
                rgb_data_o <= {Ycbcr_data_o,Ycbcr_data_o,Ycbcr_data_o[1:0]};
                vsync_o <= ycbcr_vsync_o;
                hsync_o <= ycbcr_hsync_o;
                end
        else if(state == CORRO) begin
                rgb_data_o <= {Cor_data_o,Cor_data_o[1:0]}; 
                vsync_o <= cor_vsync_o;
                hsync_o <= cor_hsync_o;
                end
        else if(state == EXP) begin
                rgb_data_o <= {Exp_data_o,Exp_data_o[1:0]}; 
                vsync_o <= exp_vsync_o;
                hsync_o <= exp_hsync_o;
                end                
end

//rgb565转rgb888
assign  rgb_r = {data_i[15 : 11], 3'b0};
assign  rgb_g = {data_i[10 : 5] , 2'b0};
assign  rgb_b = {data_i[4 : 0]  , 3'b0};


RGB2Ycbcr       RGB2Ycbcr_inst(
        //system signals
        .s_rst_n                (s_rst_n                ),
        .sclk                   (sclk                   ),

        .rgb_r                  (rgb_r                  ),
        .rgb_g                  (rgb_g                  ),
        .rgb_b                  (rgb_b                  ),
        .vsync_i                (vsync_i                ),
        .hsync_i                (hsync_i                ),

//        .data_1_up              (data_1_up              ),
//        .data_1_down            (data_1_down            ),
//        .data_2_up              (data_2_up              ),
//        .data_2_down            (data_2_down            ),
        .data_1_up              (8'b0              ),
        .data_1_down            (8'b0            ),
        .data_2_up              (8'b0              ),
        .data_2_down            (8'b0            ),

        .vsync_o                (ycbcr_vsync_o          ),
        .hsync_o                (ycbcr_hsync_o          ),
        .data_o                 (Ycbcr_data_o           )

);

Cor_alg 			Cor_alg_inst(
        //system signals
        .sclk                   (sclk                   ), 
        .s_rst_n                (s_rst_n                ),

        .vsync_i                (ycbcr_vsync_o          ),
        .hsync_i                (ycbcr_hsync_o          ),
        .data_en_i              (data_en                ),
        .Cor_data_i             ({Ycbcr_data_o,Ycbcr_data_o}  ),

        .vsync_o                (cor_vsync_o            ),
        .hsync_o                (cor_hsync_o            ),
        .data_en_o              (cor_data_en_o          ),
        .Cor_data_o             (Cor_data_o             )

);

Exp_alg                         Exp_alg_inst(
        //system signals
        .sclk                   (sclk                   ), 
        .s_rst_n                (s_rst_n                ),
        // input cor data
        .vsync_i                (cor_vsync_o            ),
        .hsync_i                (cor_hsync_o            ),
        .data_en_i              (cor_data_en_o          ),
        .Exp_data_i             (Cor_data_o             ),
        // output exp data
        .vsync_o                (exp_vsync_o            ),
        .hsync_o                (exp_hsync_o            ),
        .data_en_o              (exp_data_en_o          ),
        .Exp_data_o             (Exp_data_o             )
);

Boundary_extraction             Boundary_extraction_inst(
        //system signals
        .sclk                   (sclk                   ), 
        .s_rst_n                (s_rst_n                ),

        .vsync_i                (cor_vsync_o            ),
        .hsync_i                (cor_hsync_o            ),
        .data_en_i              (cor_data_en_o          ),
        .bound_data_i           (Cor_data_o[0:0]        ),
    // output data co
        .valid_num              (valid_num              ),
        .x_coor                 (x_coor                 ),
        .y_coor                 (y_coor                 ),
        .coor_valid_flag        (coor_valid_flag        )
);
endmodule