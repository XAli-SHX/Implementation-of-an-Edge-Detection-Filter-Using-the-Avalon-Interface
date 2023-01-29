---------------------------------------------------------------------------------------------
-- This is a top level module that functions as an interface between the Flash Memory
-- device AND the Avalon Interconnect fabric. This is a top level module that should be used
-- in an SOPC Builder system-based design.
--
-- Note that the i_avalon_address input uses an additional address bit. This is to facilitate the
-- erase_command_register, located after the END of the Flash Memory space. Although only a 32-bit
-- word is used, the address requires an additional bit position.
--
-- Author: Tomasz Czajkowski
-- Date: February 18th, 2009
-- NOTES/REVISIONS:
---------------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY Altera_UP_Flash_Memory_IP_Core_Avalon_Interface is
	GENERIC (
		FLASH_MEMORY_ADDRESS_WIDTH : INTEGER := 22;
		FLASH_MEMORY_DATA_WIDTH 	: INTEGER := 8
	);
	PORT 
	(
		-- Signals to/from Avalon Interface 
		i_clock 							: IN 		STD_LOGIC;
		i_reset_n 						: IN 		STD_LOGIC;
		
		-- Note that avalon interconnect is 32-bit word addressable, so it requires 2 fewer bits to represent address location.
		i_avalon_chip_select			: IN 		STD_LOGIC;
		i_avalon_write					: IN 		STD_LOGIC;
		i_avalon_read					: IN 		STD_LOGIC;
		i_avalon_address 				: IN 		STD_LOGIC_VECTOR(FLASH_MEMORY_ADDRESS_WIDTH-3 DOWNTO 0);
		i_avalon_byteenable			: IN 		STD_LOGIC_VECTOR(3 DOWNTO 0);
		i_avalon_writedata 			: IN 		STD_LOGIC_VECTOR(31 DOWNTO 0);
		o_avalon_readdata 			: OUT 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		o_avalon_waitrequest			: OUT 	STD_LOGIC;
		
		i_avalon_erase_chip_select	: IN 		STD_LOGIC;
		i_avalon_erase_write			: IN 		STD_LOGIC;
		i_avalon_erase_read			: IN 		STD_LOGIC;
		i_avalon_erase_byteenable	: IN 		STD_LOGIC_VECTOR(3 DOWNTO 0);
		i_avalon_erase_writedata 	: IN 		STD_LOGIC_VECTOR(31 DOWNTO 0);
		o_avalon_erase_readdata 	: OUT 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		o_avalon_erase_waitrequest	: OUT 	STD_LOGIC;		
		
		-- Signals to be connected to Flash chip via proper I/O ports
		FL_ADDR 							: OUT 	STD_LOGIC_VECTOR(FLASH_MEMORY_ADDRESS_WIDTH - 1 DOWNTO 0);
		FL_DQ 							: INOUT	STD_LOGIC_VECTOR(FLASH_MEMORY_DATA_WIDTH - 1 DOWNTO 0);
		FL_CE_N,
		FL_OE_N,
		FL_WE_N,
		FL_RST_N 						: OUT 	STD_LOGIC
	);

END ENTITY;


ARCHITECTURE rtl of Altera_UP_Flash_Memory_IP_Core_Avalon_Interface is
	COMPONENT Altera_UP_Flash_Memory_UP_Core_Standalone is
		GENERIC (
			FLASH_MEMORY_ADDRESS_WIDTH : INTEGER := 22;
			FLASH_MEMORY_DATA_WIDTH 	: INTEGER := 8
		);
		PORT 
		(
			-- Signals to/from user 
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
			FL_DQ 		: INOUT	STD_LOGIC_VECTOR(FLASH_MEMORY_DATA_WIDTH - 1 DOWNTO 0);
			FL_CE_N,
			FL_OE_N,
			FL_WE_N,
			FL_RST_N 	: OUT 	STD_LOGIC
		);
	END COMPONENT;
	
	-- FSM State Declaration
	TYPE state_type IS (s_WAIT, s_CHECK_READ, s_READ, s_READ_NEXT_BYTE, s_CHECK_WRITE, s_WRITE, s_WRITE_NEXT_BYTE, s_ERASE, s_ACKNOWLEDGE);

	-- State registers AND next state variables
	SIGNAL present_state, next_state : state_type;
	
	-- Local signals
	SIGNAL flash_write, flash_read, flash_erase, flash_done : STD_LOGIC;
	SIGNAL flash_out 					: STD_LOGIC_VECTOR(FLASH_MEMORY_DATA_WIDTH-1 DOWNTO 0);
	SIGNAL erase_reg_addr 			: STD_LOGIC;
	
	-- Local Registers
	SIGNAL read_data, write_data 	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL byteenable 				: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL counter 					: STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL erase_register 			: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL address 					: STD_LOGIC_VECTOR(FLASH_MEMORY_ADDRESS_WIDTH-3 DOWNTO 0);
	SIGNAL address_lines 			: STD_LOGIC_VECTOR(FLASH_MEMORY_ADDRESS_WIDTH-1 DOWNTO 0);
BEGIN
	-- State transitions
	PROCESS(i_avalon_write, i_avalon_read, present_state, erase_reg_addr, flash_done, counter, byteenable, i_avalon_erase_chip_select, i_avalon_chip_select, i_avalon_erase_write, i_avalon_erase_read)
	BEGIN
		CASE present_state IS
			WHEN s_WAIT =>
				IF (i_avalon_chip_select = '1') THEN
					-- Check IF the operation is read/write OR erase
					IF (i_avalon_write = '1') THEN
						next_state <= s_CHECK_WRITE;
					ELSIF (i_avalon_read = '1') THEN
						next_state <= s_CHECK_READ;
					ELSE
						next_state <= s_WAIT;
					END IF;
				ELSIF ((i_avalon_erase_chip_select = '1') AND (i_avalon_erase_write = '1')) THEN
					next_state <= s_ERASE;
				ELSE
					next_state <= s_WAIT;
				END IF;
			
			WHEN s_CHECK_READ =>
				IF (byteenable(0) = '1') THEN
					next_state <= s_READ;
				ELSE
					next_state <= s_READ_NEXT_BYTE;
				END IF;
				
			WHEN s_READ =>
				IF (flash_done = '1') THEN
					next_state <= s_READ_NEXT_BYTE;
				ELSE
					next_state <= s_READ;
				END IF;
			
			WHEN s_READ_NEXT_BYTE =>
				IF (counter = "11") THEN
					next_state <= s_ACKNOWLEDGE;
				ELSE
					next_state <= s_CHECK_READ;
				END IF;
			
			WHEN s_CHECK_WRITE => 
				IF (byteenable(0) = '1') THEN
					next_state <= s_WRITE;
				ELSE
					next_state <= s_WRITE_NEXT_BYTE;
				END IF;
							
			WHEN s_WRITE =>
				IF (flash_done = '1') THEN
					next_state <= s_WRITE_NEXT_BYTE;
				ELSE
					next_state <= s_WRITE;
				END IF;
							
			WHEN s_WRITE_NEXT_BYTE =>
				IF (counter = "11") THEN
					next_state <= s_ACKNOWLEDGE;
				ELSE
					next_state <= s_CHECK_WRITE;
				END IF;
				
			WHEN s_ERASE =>
				IF (flash_done = '1') THEN
					next_state <= s_ACKNOWLEDGE;
				ELSE
					next_state <= s_ERASE;
				END IF;			
			
			WHEN s_ACKNOWLEDGE =>
				IF ((i_avalon_write = '1') OR (i_avalon_read = '1') OR (i_avalon_erase_read = '1') OR (i_avalon_erase_write = '1')) THEN
					next_state <= s_ACKNOWLEDGE;
				ELSE
					next_state <= s_WAIT;
				END IF;
				
			WHEN OTHERS =>
				next_state <= s_WAIT;
		END CASE;
	END PROCESS;
	
	-- State Registers
	PROCESS(i_clock, i_reset_n)
	BEGIN
		IF (i_reset_n = '0') THEN
			present_state <= s_WAIT;
		ELSIF (RISING_EDGE(i_clock)) THEN
			present_state <= next_state;
		END IF;
	END PROCESS;
	
	flash_write <= '1' WHEN (present_state = s_WRITE) ELSE '0';
	flash_read 	<= '1' WHEN (present_state = s_READ)  ELSE '0';
	flash_erase <= '1' WHEN (present_state = s_ERASE) ELSE '0';
	
	-- Datapath
	PROCESS(i_clock, i_reset_n, present_state, i_avalon_erase_writedata)
	BEGIN
		IF (i_reset_n = '0') THEN
			read_data 		<= (OTHERS => '0');
			write_data 		<= (OTHERS => '0');
			byteenable 		<= (OTHERS => '0');
			counter 			<= (OTHERS => '0');
			erase_register <= (OTHERS => '0');
			address 			<= (OTHERS => '0');
		ELSIF (rising_edge(i_clock)) THEN
			IF (present_state = s_WAIT) THEN
				address 		<= i_avalon_address(FLASH_MEMORY_ADDRESS_WIDTH-3 DOWNTO 0);
				counter 		<= (OTHERS => '0');
				byteenable 	<= i_avalon_byteenable;
				read_data 	<= (OTHERS => '0');
				write_data 	<= i_avalon_writedata;
				-- Erase register 
				IF ((i_avalon_erase_write = '1') AND (i_avalon_erase_chip_select = '1')) THEN
					IF (i_avalon_erase_byteenable(0) = '1') THEN
						erase_register(7 DOWNTO 0) <= i_avalon_erase_writedata(7 DOWNTO 0);
					END IF;
					IF (i_avalon_erase_byteenable(1) = '1') THEN
						erase_register(15 DOWNTO 8) <= i_avalon_erase_writedata(15 DOWNTO 8);
					END IF;
					IF (i_avalon_erase_byteenable(2) = '1') THEN
						erase_register(23 DOWNTO 16) <= i_avalon_erase_writedata(23 DOWNTO 16);
					END IF;
					IF (i_avalon_erase_byteenable(3) = '1') THEN
						erase_register(31 DOWNTO 24) <= i_avalon_erase_writedata(31 DOWNTO 24);
					END IF;
				END IF;
			END IF;
			IF ((present_state = s_READ_NEXT_BYTE) OR (present_state = s_WRITE_NEXT_BYTE)) THEN
				byteenable(2 DOWNTO 0) <= byteenable(3 DOWNTO 1);
				byteenable(3) <= '0';
				counter <= counter + '1';
				read_data(23 DOWNTO 0) <= read_data(31 DOWNTO 8);
				read_data(31 DOWNTO 24) <= flash_out;
				write_data(23 DOWNTO 0) <= write_data(31 DOWNTO 8);
				write_data(31 DOWNTO 24) <= (OTHERS => '0');
			END IF;
		END IF;
	END PROCESS;
	
	-- FSM Outputs
	o_avalon_waitrequest <= '0' WHEN (	(present_state = s_ACKNOWLEDGE) OR
										((present_state = s_WAIT) AND (i_avalon_erase_chip_select = '1') AND (i_avalon_read = '1')))
							ELSE '1';
							
	o_avalon_erase_waitrequest <= '0' WHEN ((present_state = s_ACKNOWLEDGE) OR
											((present_state = s_WAIT) AND (i_avalon_erase_chip_select = '1') AND (i_avalon_read = '1')))
							ELSE '1';
								
	o_avalon_readdata <= read_data;
	o_avalon_erase_readdata <= erase_register;
	
	address_lines <= 	(address & counter) WHEN (i_avalon_chip_select = '1') ELSE
						erase_register(FLASH_MEMORY_ADDRESS_WIDTH-1 DOWNTO 0);
						
	-- Instantiate components
	flash_mem_interface: Altera_UP_Flash_Memory_UP_Core_Standalone
		GENERIC MAP (
			FLASH_MEMORY_ADDRESS_WIDTH => FLASH_MEMORY_ADDRESS_WIDTH,
			FLASH_MEMORY_DATA_WIDTH => FLASH_MEMORY_DATA_WIDTH
		)
		PORT MAP (
			-- Signals to/from user
			i_clock 		=> i_clock,
			i_reset_n 	=> i_reset_n,
			i_address 	=> address_lines,
			i_data 		=> write_data(FLASH_MEMORY_DATA_WIDTH - 1 DOWNTO 0),
			i_read 		=> flash_read,
			i_write 		=> flash_write,			
			i_erase 		=> flash_erase,
			o_data 		=> flash_out,
			o_done 		=> flash_done, 
			
			-- Signals to be connected to Flash chip via proper I/O ports
			FL_ADDR 		=> FL_ADDR,
			FL_DQ 		=> FL_DQ,
			FL_CE_N 		=> FL_CE_N,
			FL_OE_N 		=> FL_OE_N,
			FL_WE_N 		=> FL_WE_N,
			FL_RST_N	 	=> FL_RST_N
		);	

END rtl;
