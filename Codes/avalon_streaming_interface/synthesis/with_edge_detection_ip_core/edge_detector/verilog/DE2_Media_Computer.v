
module DE2_Media_Computer (
	// Inputs
	CLOCK_50,
	CLOCK_27,
	EXT_CLOCK,
	KEY,
	SW,

	//  Communication
	UART_RXD,
	
	// Audio
	AUD_ADCDAT,
	
	//IrDA
	IRDA_RXD,

	// Video In
	TD_CLK27,
	TD_DATA,
	TD_HS,
	TD_VS,
	
	// Ethernet
	ENET_INT,
	
	// USB
	OTG_INT0,
	OTG_INT1,

/*****************************************************************************/
	// Bidirectionals
	GPIO_0,
	GPIO_1,

	// Memory (SRAM)
	SRAM_DQ,
	
	// Memory (SDRAM)
	DRAM_DQ,

	// PS2 Port
	PS2_CLK,
	PS2_DAT,
	
	// Audio
	AUD_BCLK,
	AUD_ADCLRCK,
	AUD_DACLRCK,
	
	// Char LCD 16x2
	LCD_DATA,

	// AV Config
	I2C_SDAT,
	
	//SD Card
	SD_CMD,
	SD_DAT,
	SD_DAT3,
	
	//Flash
	FL_DQ,
	
	// Ethernet
	ENET_DATA,
	
	//USB
	OTG_DATA,
	
/*****************************************************************************/
	// Outputs
	
	// 	Simple
	LEDG,
	LEDR,

	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5,
	HEX6,
	HEX7,
	
	// 	Memory (SRAM)
	SRAM_ADDR,

	SRAM_CE_N,
	SRAM_WE_N,
	SRAM_OE_N,
	SRAM_UB_N,
	SRAM_LB_N,
	
	//  Communication
	UART_TXD,
	
	// Memory (SDRAM)
	DRAM_ADDR,
	
	DRAM_BA_1,
	DRAM_BA_0,
	DRAM_CAS_N,
	DRAM_RAS_N,
	DRAM_CLK,
	DRAM_CKE,
	DRAM_CS_N,
	DRAM_WE_N,
	DRAM_UDQM,
	DRAM_LDQM,
	
	// Audio
	AUD_XCK,
	AUD_DACDAT,
	
	// VGA
	VGA_CLK,
	VGA_HS,
	VGA_VS,
	VGA_BLANK,
	VGA_SYNC,
	VGA_R,
	VGA_G,
	VGA_B,

	// Char LCD 16x2
	LCD_ON,
	LCD_BLON,
	LCD_EN,
	LCD_RS,
	LCD_RW,
	
	// AV Config
	I2C_SCLK,
	
	//SD Card
	SD_CLK,
	
	//Flash
	FL_ADDR,
   FL_CE_N,
	FL_OE_N,
	FL_RST_N,
	FL_WE_N,
	
	//IrDA
	IRDA_TXD,
	
	//Video In
	TD_RESET,
	
	// Ethernet
	ENET_CMD,
	ENET_CS_N,
	ENET_RD_N,
	ENET_RST_N,
	ENET_WR_N,
	ENET_CLK,
	
	// USB
	OTG_ADDR,
	OTG_CS_N,
	OTG_RD_N,
	OTG_RST_N,
	OTG_WR_N,
);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/


/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/
// Inputs
input				CLOCK_50;
input				CLOCK_27;
input				EXT_CLOCK;
input		[3:0]	KEY;
input		[17:0]	SW;


//  Communication
input				UART_RXD;

//  Audio
input				AUD_ADCDAT;

//  IrDA
input				IRDA_RXD;

// Video In
input 	[7:0]	TD_DATA;
input   			TD_HS;
input  			TD_VS;
input 			TD_CLK27;

// Enternet
input				ENET_INT;

// USB
input          OTG_INT0;
input          OTG_INT1;

// Bidirectionals
inout		[35:0]	GPIO_0;
inout		[35:0]	GPIO_1;

// 	Memory (SRAM)
inout		[15:0]	SRAM_DQ;

//  Memory (SDRAM)
inout		[15:0]	DRAM_DQ;

//  PS2 Port
inout				PS2_CLK;
inout				PS2_DAT;

//  Audio
inout				AUD_BCLK;
inout				AUD_ADCLRCK;
inout				AUD_DACLRCK;

//  AV Config
inout				I2C_SDAT;

//  Char LCD 16x2
inout		[ 7: 0]	LCD_DATA;

// SD Card
inout 			SD_CMD;
inout 			SD_DAT;
inout 			SD_DAT3;

// Flash
inout 	[ 7: 0]  FL_DQ; 

// Ethernet
inout 	[15: 0]  ENET_DATA;

// USB
inout    [15: 0]  OTG_DATA;

// Outputs

// 	Simple
output		[8:0]	LEDG;
output		[17:0]	LEDR;

output		[6:0]	HEX0;
output		[6:0]	HEX1;
output		[6:0]	HEX2;
output		[6:0]	HEX3;
output		[6:0]	HEX4;
output		[6:0]	HEX5;
output		[6:0]	HEX6;
output		[6:0]	HEX7;

// 	Memory (SRAM)
output		[17:0]	SRAM_ADDR;

output				SRAM_CE_N;
output				SRAM_WE_N;
output				SRAM_OE_N;
output				SRAM_UB_N;
output				SRAM_LB_N;

//  Communication
output				UART_TXD;

//  Memory (SDRAM)
output		[11:0]	DRAM_ADDR;

output				DRAM_BA_1;
output				DRAM_BA_0;
output				DRAM_CAS_N;
output				DRAM_RAS_N;
output				DRAM_CLK;
output				DRAM_CKE;
output				DRAM_CS_N;
output				DRAM_WE_N;
output				DRAM_UDQM;
output				DRAM_LDQM;

//  Audio
output				AUD_XCK;
output				AUD_DACDAT;

//  VGA
output				VGA_CLK;
output				VGA_HS;
output				VGA_VS;
output				VGA_BLANK;
output				VGA_SYNC;
output		[ 9: 0]	VGA_R;
output		[ 9: 0]	VGA_G;
output		[ 9: 0]	VGA_B;

//  Char LCD 16x2
output				LCD_ON;
output				LCD_BLON;
output				LCD_EN;
output				LCD_RS;
output				LCD_RW;

//  AV Config
output				I2C_SCLK;

//  SD Card
output 				SD_CLK;

//  Flash
output 		[21: 0]	FL_ADDR;
output 				FL_CE_N;
output				FL_OE_N;
output				FL_RST_N;
output				FL_WE_N;
   
//  IrDA
output				IRDA_TXD;
   
//  Video In
output   			TD_RESET;

// Ethernet
output				ENET_CMD;
output				ENET_CS_N;
output				ENET_RD_N;
output				ENET_RST_N;
output				ENET_WR_N;
output				ENET_CLK;

//USB
output      [ 1: 0]  OTG_ADDR;
output				OTG_CS_N;
output				OTG_RD_N;
output				OTG_RST_N;
output				OTG_WR_N;



/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
// Internal Wires

wire clk_25;

// Internal Registers

// State Machine Registers

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/


/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/


/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

// Output Assignments
assign GPIO_0[ 0]	= 1'bZ;
assign GPIO_0[ 2]	= 1'bZ;
assign GPIO_0[16]	= 1'bZ;
assign GPIO_0[18]	= 1'bZ;
assign GPIO_1[ 0]	= 1'bZ;
assign GPIO_1[ 2]	= 1'bZ;
assign GPIO_1[16]	= 1'bZ;
assign GPIO_1[18]	= 1'bZ;

assign ENET_CLK = clk_25;

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/
nios_system NiosII (
	// 1) global signals:
	.clk									(CLOCK_50),
	.clk_27									(CLOCK_27),
	.reset_n								(KEY[0]),
	.sys_clk								(),
	.vga_clk								(clk_25),
	.sdram_clk								(DRAM_CLK),
	.audio_clk								(AUD_XCK),

	// the_AV_Config
	.I2C_SDAT_to_and_from_the_AV_Config		(I2C_SDAT),
	.I2C_SCLK_from_the_AV_Config			(I2C_SCLK),
	
	// the_Audio
	.AUD_ADCDAT_to_the_Audio				(AUD_ADCDAT),
	.AUD_BCLK_to_the_Audio		      	(AUD_BCLK),
	.AUD_ADCLRCK_to_the_Audio		         (AUD_ADCLRCK),
	.AUD_DACLRCK_to_the_Audio		      (AUD_DACLRCK),
	.AUD_DACDAT_from_the_Audio				(AUD_DACDAT),

	// the_Char_LCD_16x2
	.LCD_DATA_to_and_from_the_Char_LCD_16x2	(LCD_DATA),
	.LCD_ON_from_the_Char_LCD_16x2			(LCD_ON),
	.LCD_BLON_from_the_Char_LCD_16x2		(LCD_BLON),
	.LCD_EN_from_the_Char_LCD_16x2			(LCD_EN),
	.LCD_RS_from_the_Char_LCD_16x2			(LCD_RS),
	.LCD_RW_from_the_Char_LCD_16x2			(LCD_RW),

	// the_Expansion_JP1
	.GPIO_0_to_and_from_the_Expansion_JP1	({GPIO_0[35:19], GPIO_0[17], GPIO_0[15:3], GPIO_0[1]}),

	// the_Expansion_JP2
	.GPIO_1_to_and_from_the_Expansion_JP2	({GPIO_1[35:19], GPIO_1[17], GPIO_1[15:3], GPIO_1[1]}),

	// the_Green_LEDs
	.LEDG_from_the_Green_LEDs				(LEDG),

	// the_HEX3_HEX0
	.HEX0_from_the_HEX3_HEX0				(HEX0),
	.HEX1_from_the_HEX3_HEX0				(HEX1),
	.HEX2_from_the_HEX3_HEX0				(HEX2),
	.HEX3_from_the_HEX3_HEX0				(HEX3),
	
	// the_HEX7_HEX4
	.HEX4_from_the_HEX7_HEX4				(HEX4),
	.HEX5_from_the_HEX7_HEX4				(HEX5),
	.HEX6_from_the_HEX7_HEX4				(HEX6),
	.HEX7_from_the_HEX7_HEX4				(HEX7),

	// the_PS2_Port
	.PS2_CLK_to_and_from_the_PS2_Port		(PS2_CLK),
	.PS2_DAT_to_and_from_the_PS2_Port		(PS2_DAT),
	
	// the_Pushbuttons
	.KEY_to_the_Pushbuttons					({KEY[3:1], 1'b1}),

	// the_Red_LEDs
	.LEDR_from_the_Red_LEDs					(LEDR),
	
	// the_SDRAM
	.zs_addr_from_the_SDRAM					(DRAM_ADDR),
	.zs_ba_from_the_SDRAM					({DRAM_BA_1, DRAM_BA_0}),
	.zs_cas_n_from_the_SDRAM				(DRAM_CAS_N),
	.zs_cke_from_the_SDRAM					(DRAM_CKE),
	.zs_cs_n_from_the_SDRAM					(DRAM_CS_N),
	.zs_dq_to_and_from_the_SDRAM			(DRAM_DQ),
	.zs_dqm_from_the_SDRAM					({DRAM_UDQM, DRAM_LDQM}),
	.zs_ras_n_from_the_SDRAM				(DRAM_RAS_N),
	.zs_we_n_from_the_SDRAM					(DRAM_WE_N),
	
	// the_SRAM
	.SRAM_DQ_to_and_from_the_SRAM			(SRAM_DQ),
	.SRAM_ADDR_from_the_SRAM				(SRAM_ADDR),
	.SRAM_LB_N_from_the_SRAM				(SRAM_LB_N),
	.SRAM_UB_N_from_the_SRAM				(SRAM_UB_N),
	.SRAM_CE_N_from_the_SRAM				(SRAM_CE_N),
	.SRAM_OE_N_from_the_SRAM				(SRAM_OE_N),
	.SRAM_WE_N_from_the_SRAM				(SRAM_WE_N),

	// the_Serial_port
	.UART_RXD_to_the_Serial_Port			(UART_RXD),
	.UART_TXD_from_the_Serial_Port			(UART_TXD),
	
	// the_Slider_switches
	.SW_to_the_Slider_Switches				(SW),

	// the_VGA_Controller
	.VGA_CLK_from_the_VGA_Controller		(VGA_CLK),
	.VGA_HS_from_the_VGA_Controller			(VGA_HS),
	.VGA_VS_from_the_VGA_Controller			(VGA_VS),
	.VGA_BLANK_from_the_VGA_Controller		(VGA_BLANK),
	.VGA_SYNC_from_the_VGA_Controller		(VGA_SYNC),
	.VGA_R_from_the_VGA_Controller			(VGA_R),
	.VGA_G_from_the_VGA_Controller			(VGA_G),
	.VGA_B_from_the_VGA_Controller			(VGA_B),
	
	// the Flash
	.flash_ADDR                             (FL_ADDR),
   .flash_CE_N                             (FL_CE_N),
   .flash_OE_N                             (FL_OE_N),
   .flash_WE_N                             (FL_WE_N),
   .flash_RST_N                            (FL_RST_N),
   .flash_DQ                               (FL_DQ),
   
	// the SD Card
	.sd_card_b_SD_cmd                       (SD_CMD),
   .sd_card_b_SD_dat                       (SD_DAT),
   .sd_card_b_SD_dat3                      (SD_DAT3),
   .sd_card_o_SD_clock                     (SD_CLK),
   
	// the IrDA
	.irda_TXD                               (IRDA_TXD),
   .irda_RXD                               (IRDA_RXD),
   
	// the Video In
	.video_in_TD_CLK27                      (TD_CLK27),
   .video_in_TD_DATA                       (TD_DATA),
   .video_in_TD_HS                         (TD_HS),
   .video_in_TD_VS                         (TD_VS),
   .video_in_TD_RESET                      (TD_RESET),
	.video_in_clk27_reset						(!KEY[0]),
   //.video_in_overflow_flag                 ()
	
	// the Ethernet
	.ethernet_INT                           (ENET_INT),
   .ethernet_DATA                          (ENET_DATA),
   .ethernet_RST_N                         (ENET_RST_N),
   .ethernet_CS_N                          (ENET_CS_N),
   .ethernet_CMD                           (ENET_CMD),
   .ethernet_RD_N                          (ENET_RD_N),
   .ethernet_WR_N                          (ENET_WR_N),
	
	// the USB             
   .usb_INT1                               (OTG_INT1),
   .usb_DATA                               (OTG_DATA),
   .usb_RST_N                              (OTG_RST_N),
   .usb_ADDR                               (OTG_ADDR),
   .usb_CS_N                               (OTG_CS_N),
   .usb_RD_N                               (OTG_RD_N),
   .usb_WR_N                               (OTG_WR_N),
   .usb_INT0                               (OTG_INT0),
);

endmodule

