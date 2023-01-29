----------------------------------------------------------------------------------------------
-- This is a stand-alone Altera University Program IP Core that interfaces with a Flash Memory
-- device on DE1/DE2 board.
--
-- Author: Tomasz Czajkowski
-- Date: February 17th, 2009
-- NOTES/REVISIONS:
----------------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY Altera_UP_Flash_Memory_UP_Core_Standalone IS
	GENERIC (
		FLASH_MEMORY_ADDRESS_WIDTH 	: INTEGER := 22;
		FLASH_MEMORY_DATA_WIDTH 		: INTEGER := 8
	);
	PORT 
	(
		-- Signals to local circuit 
		i_clock 		: IN 		STD_LOGIC;
		i_reset_n 	: IN 		STD_LOGIC;
		i_address 	: IN 		STD_LOGIC_VECTOR(FLASH_MEMORY_ADDRESS_WIDTH - 1 DOWNTO 0);
		i_data 		: IN 		STD_LOGIC_VECTOR(FLASH_MEMORY_DATA_WIDTH - 1 DOWNTO 0);
		i_read,
		i_write,
		i_erase 		: IN 		STD_LOGIC;
		o_data 		: OUT 	STD_LOGIC_VECTOR(FLASH_MEMORY_DATA_WIDTH - 1 DOWNTO 0);
		o_done 		: OUT 	STD_LOGIC;
		
		-- Signals to be connected to Flash chip via proper I/O ports
		FL_ADDR 		: OUT 	STD_LOGIC_VECTOR(FLASH_MEMORY_ADDRESS_WIDTH - 1 DOWNTO 0);
		FL_DQ 		: INOUT 	STD_LOGIC_VECTOR(FLASH_MEMORY_DATA_WIDTH - 1 DOWNTO 0);
		FL_CE_N,
		FL_OE_N,
		FL_WE_N,
		FL_RST_N 	: OUT 	STD_LOGIC
	);

END ENTITY;


ARCHITECTURE rtl OF Altera_UP_Flash_Memory_UP_Core_Standalone IS
	COMPONENT Altera_UP_Flash_Memory_Controller IS
		GENERIC (
			FLASH_MEMORY_ADDRESS_WIDTH : INTEGER := 22;
			FLASH_MEMORY_DATA_WIDTH 	: INTEGER := 8
		);
		PORT 
		(
			-- Signals to local circuit 
			i_clock 				: IN 		STD_LOGIC;
			i_reset_n 			: IN 		STD_LOGIC;
			i_address 			: IN 		STD_LOGIC_VECTOR(FLASH_MEMORY_ADDRESS_WIDTH - 1 DOWNTO 0);
			i_data 				: IN 		STD_LOGIC_VECTOR(FLASH_MEMORY_DATA_WIDTH - 1 DOWNTO 0);
			i_read 				: IN 		STD_LOGIC;
			i_write 				: IN 		STD_LOGIC;
			o_data 				: OUT 	STD_LOGIC_VECTOR(FLASH_MEMORY_DATA_WIDTH - 1 DOWNTO 0);
			o_done 				: OUT 	STD_LOGIC;
			
			-- Signals to be connected to Flash chip via proper I/O ports
			o_flash_ce_n 		: OUT 	STD_LOGIC;
			o_flash_oe_n 		: OUT 	STD_LOGIC;
			o_flash_we_n 		: OUT 	STD_LOGIC;
			o_flash_reset_n 	: OUT 	STD_LOGIC;
			o_flash_address 	: OUT 	STD_LOGIC_VECTOR(FLASH_MEMORY_ADDRESS_WIDTH - 1 DOWNTO 0);
			b_flash_data 		: INOUT 	STD_LOGIC_VECTOR(FLASH_MEMORY_DATA_WIDTH - 1 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT Altera_UP_Flash_Memory_User_Interface IS
		GENERIC (
			FLASH_MEMORY_ADDRESS_WIDTH : INTEGER := 22;
			FLASH_MEMORY_DATA_WIDTH 	: INTEGER := 8
		);
		PORT 
		(
			-- Signals to/from user 
			i_clock 					: IN 		STD_LOGIC;
			i_reset_n 				: IN 		STD_LOGIC;
			i_address 				: IN 		STD_LOGIC_VECTOR(FLASH_MEMORY_ADDRESS_WIDTH - 1 DOWNTO 0);
			i_data 					: IN 		STD_LOGIC_VECTOR(FLASH_MEMORY_DATA_WIDTH - 1 DOWNTO 0);
			i_read 					: IN 		STD_LOGIC;
			i_write 					: IN 		STD_LOGIC;
			i_erase 					: IN 		STD_LOGIC;
			o_data 					: OUT 	STD_LOGIC_VECTOR(FLASH_MEMORY_DATA_WIDTH - 1 DOWNTO 0);
			o_done 					: OUT 	STD_LOGIC;
			
			-- Signals to/from Flash Memory Controller
			i_flash_done 			: IN 		STD_LOGIC;
			i_data_from_flash 	: IN 		STD_LOGIC_VECTOR(FLASH_MEMORY_DATA_WIDTH - 1 DOWNTO 0);
			o_address_to_flash 	: OUT 	STD_LOGIC_VECTOR(FLASH_MEMORY_ADDRESS_WIDTH - 1 DOWNTO 0);
			o_data_to_flash 		: OUT 	STD_LOGIC_VECTOR(FLASH_MEMORY_DATA_WIDTH - 1 DOWNTO 0);
			o_read_flash 			: OUT 	STD_LOGIC;
			o_write_flash 			: OUT 	STD_LOGIC
		);
	END COMPONENT;
	
	-- Local signals
	SIGNAL flash_done 			: STD_LOGIC;
	SIGNAL data_from_flash 		: STD_LOGIC_VECTOR(FLASH_MEMORY_DATA_WIDTH - 1 DOWNTO 0);
	SIGNAL address_to_flash 	: STD_LOGIC_VECTOR(FLASH_MEMORY_ADDRESS_WIDTH - 1 DOWNTO 0);
	SIGNAL data_to_flash 		: STD_LOGIC_VECTOR(FLASH_MEMORY_DATA_WIDTH - 1 DOWNTO 0);
	SIGNAL read_flash 			: STD_LOGIC;
	SIGNAL write_flash 			: STD_LOGIC;
	
	-- Local registers.
	SIGNAL data_reg 				: STD_LOGIC_VECTOR(FLASH_MEMORY_DATA_WIDTH - 1 DOWNTO 0);
	SIGNAL address_reg 			: STD_LOGIC_VECTOR(FLASH_MEMORY_ADDRESS_WIDTH - 1 DOWNTO 0);
	SIGNAL read_reg 				: STD_LOGIC;
	SIGNAL write_reg 				: STD_LOGIC;
	SIGNAL erase_reg 				: STD_LOGIC;
		
BEGIN
	-- Instantiate components
	PROCESS(i_clock, i_read, i_write, i_erase, i_data, i_address)
	BEGIN
		IF (RISING_EDGE(i_clock)) THEN
			read_reg 	<= i_read;
			write_reg 	<= i_write;			
			erase_reg 	<= i_erase;
			data_reg 	<= i_data;
			address_reg <= i_address;			
		END IF;
	END PROCESS;
	
	ui: Altera_UP_Flash_Memory_User_Interface
		GENERIC MAP (
			FLASH_MEMORY_ADDRESS_WIDTH => FLASH_MEMORY_ADDRESS_WIDTH,
			FLASH_MEMORY_DATA_WIDTH 	=> FLASH_MEMORY_DATA_WIDTH
		)
		PORT MAP (
			-- Signals to/from user 
			i_clock 					=> i_clock,
			i_reset_n 				=> i_reset_n,
			i_address 				=> address_reg,
			i_data 					=> data_reg,
			i_read 					=> read_reg,
			i_write 					=> write_reg,			
			i_erase 					=> erase_reg,
			o_data 					=> o_data,
			o_done 					=> o_done,
			
			-- Signals to/from Flash Memory Controller
			i_flash_done 			=> flash_done,
			i_data_from_flash 	=> data_from_flash,
			o_address_to_flash 	=> address_to_flash,
			o_data_to_flash 		=> data_to_flash,
			o_read_flash 			=> read_flash,
			o_write_flash 			=> write_flash
		);	
		
	fm: Altera_UP_Flash_Memory_Controller
		GENERIC MAP (
			FLASH_MEMORY_ADDRESS_WIDTH => FLASH_MEMORY_ADDRESS_WIDTH,
			FLASH_MEMORY_DATA_WIDTH 	=> FLASH_MEMORY_DATA_WIDTH
		)
		PORT MAP (
			-- Signals to local circuit 
			i_clock 				=> i_clock,
			i_reset_n 			=> i_reset_n,
			i_address 			=> address_to_flash,
			i_data 				=> data_to_flash,
			i_read 				=> read_flash,
			i_write 				=> write_flash,
			o_data 				=> data_from_flash,
			o_done 				=> flash_done,
			
			-- Signals to be connected to Flash chip via proper I/O ports
			o_flash_ce_n 		=> FL_CE_N,
			o_flash_oe_n 		=> FL_OE_N,
			o_flash_we_n 		=> FL_WE_N,
			o_flash_reset_n	=> FL_RST_N,
			o_flash_address 	=> FL_ADDR,
			b_flash_data 		=> FL_DQ
		);
END rtl;


