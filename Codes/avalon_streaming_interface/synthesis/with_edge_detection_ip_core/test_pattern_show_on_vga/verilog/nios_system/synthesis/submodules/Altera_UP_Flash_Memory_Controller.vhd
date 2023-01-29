---------------------------------------------------------------------------------------------
-- This module is a control circuit that sends and receives data from the Flash Memory circuit.
-- It directly connects to the Flash Memory device. To store and retrieve data from Flash memory,
-- utilize this module to send command sequences to exchange data between the circuit and the
-- flash memory. Please note that while a data read is a single transaction operation, programming data
-- into the Flash memory requires a sequence of commands to be executed prior to writing the
-- data into the memory. Erasing data from flash memory also requires a set of commands to be
-- written to the Flash memory IN order.
--
-- IMPORTANT: Flash memory devices only guarantee safe data storage if target memory location
-- is erased prior to writing data to it. Thus, the most effective way of writing data to flash
-- memory is in sector writes. Simply put, select a 64Kbyte sector to write to, erase it and then
-- sequentially fill all memory locations in the sector.
--
-- IMPORTANT: Flash memory devices have a limited lifetime (also called endurance). They can only be
-- written and erased a fixed number of times. The endurance of Flash Memory module on the DE2 board is listed to
-- be 1 million cycles (erase/write operations). Although the number is very high for flash
-- memory technology, improper use of flash memory can lead to its rapid degradation. For example,
-- if the flash memory is used to store intermediate data for an application, and the data changes
-- 1000 times over a single run of the program, this will effectively make the flash memory usable\
-- only 1000 times. Thus, limit the use of this memory to permanent data, that will be stored in
-- the flash memory for prolonged periods of time.
--
-- Author: Tomasz Czajkowski
-- Date: February 4th, 2009
-- NOTES/REVISIONS:
-- February 17, 2009 - This module assumes it is clocked by a 50MHz clock.
---------------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY Altera_UP_Flash_Memory_Controller IS
	GENERIC (
		FLASH_MEMORY_ADDRESS_WIDTH 	: INTEGER := 22;
		FLASH_MEMORY_DATA_WIDTH 		: INTEGER := 8
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
		o_flash_address	: OUT 	STD_LOGIC_VECTOR(FLASH_MEMORY_ADDRESS_WIDTH - 1 DOWNTO 0);
		b_flash_data 		: INOUT 	STD_LOGIC_VECTOR(FLASH_MEMORY_DATA_WIDTH - 1 DOWNTO 0)
	);

END ENTITY;


ARCHITECTURE rtl OF Altera_UP_Flash_Memory_Controller IS

	-- Build an enumerated type for the state machine
	TYPE state_type IS (s_RESET, s_WAIT_COMMAND, s_READ, s_WRITE, s_ACKNOWLEDGE);

	-- Register to hold the current state
	SIGNAL present_state   	: state_type;
	SIGNAL next_state   		: state_type;
	
	-- REGISTERED SIGNALS
	SIGNAL data_from_flash 	: STD_LOGIC_VECTOR(FLASH_MEMORY_DATA_WIDTH - 1 DOWNTO 0);
	SIGNAL data_to_flash		: STD_LOGIC_VECTOR(FLASH_MEMORY_DATA_WIDTH - 1 DOWNTO 0);
	SIGNAL cycle_counter 	: STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL flash_ce_n, flash_oe_n, flash_we_n, flash_reset_n 	: STD_LOGIC;
	SIGNAL flash_address 	: STD_LOGIC_VECTOR(FLASH_MEMORY_ADDRESS_WIDTH - 1 DOWNTO 0);
	
begin
	-- Define state transitions
	PROCESS(i_read, i_write, cycle_counter, i_address, present_state)
	BEGIN
		CASE present_state IS
			WHEN s_RESET =>
				IF (cycle_counter = "11011") THEN
					next_state <= s_WAIT_COMMAND;
				ELSE
					next_state <= s_RESET;
				END IF;
				
			WHEN s_WAIT_COMMAND => 
				IF (i_write = '1') THEN
					next_state <= s_WRITE;
				ELSIF (i_read = '1') THEN
					next_state <= s_READ;
				ELSE
					next_state <= s_WAIT_COMMAND;
				END IF;
			
			WHEN s_READ =>
				IF (cycle_counter = "100") THEN
					next_state <= s_ACKNOWLEDGE;
				ELSE
					next_state <= s_READ;
				END IF;
			
			WHEN s_WRITE =>
				IF (cycle_counter = "100") THEN
					next_state <= s_ACKNOWLEDGE;
				ELSE
					next_state <= s_WRITE;
				END IF;
			
			WHEN s_ACKNOWLEDGE =>
				IF ((i_write = '1') OR (i_read = '1')) THEN
					next_state <= s_ACKNOWLEDGE;		
				ELSE
					next_state <= s_WAIT_COMMAND;		
				END IF;
				
			WHEN OTHERS =>
				next_state <= s_RESET;
				
		END CASE;
	END PROCESS;
	
	-- Define state assignment
	PROCESS(i_clock, i_reset_n)
	BEGIN
		IF (i_reset_n = '0') THEN
			present_state <= s_RESET;
		ELSIF (RISING_EDGE(i_clock)) THEN
			present_state <= next_state;
		END IF;
	END PROCESS;
	
	-- Define Datapath
	PROCESS(i_clock, i_reset_n)
	BEGIN
		IF (i_reset_n = '0') THEN
			cycle_counter <= (OTHERS => '0');
			flash_ce_n <= '1';
			flash_oe_n <= '1';
			flash_we_n <= '1';
			flash_reset_n <= '0';
			data_to_flash <= (OTHERS => '1');
			flash_address <= (OTHERS => '1');
		ELSIF (RISING_EDGE(i_clock)) THEN
			-- Reset signal.
			IF ((present_state = s_RESET) AND (cycle_counter < "11001")) THEN
				flash_reset_n <= '0';
			ELSE
				flash_reset_n <= '1';
			END IF;
			
			-- Chip enable
			IF ((present_state = s_RESET) OR (present_state = s_WAIT_COMMAND) OR (present_state = s_ACKNOWLEDGE)) THEN
				flash_ce_n <= '1';
			ELSE
				flash_ce_n <= '0';
			END IF;
			
			-- Cycle counter
			IF (present_state = next_state) THEN
				cycle_counter <= cycle_counter + '1';
			ELSE
				cycle_counter <= (OTHERS => '0');
			END IF;
			
			-- Output enable, only after a read cycle.
			IF ((present_state = s_READ) AND (cycle_counter > "00000")) THEN
				flash_oe_n <= '0';
			ELSE
				flash_oe_n <= '1';
			END IF;
			
			-- Write enable for write operations
			IF ((present_state = s_WRITE) AND (cycle_counter > "00001")) THEN
				flash_we_n <= '0';
			ELSE
				flash_we_n <= '1';
			END IF;
			
			-- Store output data
			IF (present_state = s_READ) THEN
				data_from_flash <= b_flash_data;
			END IF;
			
			-- Store data to write into data_to_flash register.
			IF (present_state = s_WAIT_COMMAND) THEN
				data_to_flash <= i_data;
			END IF;
			
			-- Flash address assignment
			flash_address <= i_address;
		END IF;
	END PROCESS;

	-- Circuit outputs
	o_done 				<= '1' WHEN (present_state = s_ACKNOWLEDGE) ELSE '0';
	o_data 				<= data_from_flash;
	o_flash_ce_n 		<= flash_ce_n;
	o_flash_oe_n 		<= flash_oe_n;
	o_flash_we_n 		<= flash_we_n;
	o_flash_reset_n 	<= flash_reset_n;
	o_flash_address 	<= flash_address;	
	b_flash_data 		<= data_to_flash WHEN (present_state = s_WRITE) ELSE (OTHERS => 'Z');
END rtl;


