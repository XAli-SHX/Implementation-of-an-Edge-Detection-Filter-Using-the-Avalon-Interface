---------------------------------------------------------------------------------------------
-- This module is a user interface to the Flash Memory controller. It allows read/write/erase
-- operations on the flash memory, by sending commands to the Flash Memory Controller.
--
-- Author: Tomasz Czajkowski
-- Date: February 17th, 2009
-- NOTES/REVISIONS:
-- February 17th, 2009 - Added protection to prevent writes to used memory locations.
---------------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY Altera_UP_Flash_Memory_User_Interface IS
	GENERIC (
		FLASH_MEMORY_ADDRESS_WIDTH 	: INTEGER := 22;
		FLASH_MEMORY_DATA_WIDTH 		: INTEGER := 8
	);
	PORT 
	(
		-- Signals to/from user 
		i_clock 			 		: IN STD_LOGIC;
		i_reset_n 		 		: IN STD_LOGIC;
		i_address	 		 	: IN STD_LOGIC_VECTOR(FLASH_MEMORY_ADDRESS_WIDTH - 1 DOWNTO 0);
		i_data 			 		: IN STD_LOGIC_VECTOR(FLASH_MEMORY_DATA_WIDTH - 1 DOWNTO 0);
		i_read	 		 		: IN STD_LOGIC;
		i_write 			 		: IN STD_LOGIC;
		i_erase	 		 		: IN STD_LOGIC;
		o_data			 		: OUT STD_LOGIC_VECTOR(FLASH_MEMORY_DATA_WIDTH - 1 DOWNTO 0);
		o_done 					: OUT STD_LOGIC;
		
		-- Signals to/from Flash Memory Controller
		i_flash_done 			: IN STD_LOGIC;
		i_data_from_flash 	: IN STD_LOGIC_VECTOR(FLASH_MEMORY_DATA_WIDTH - 1 DOWNTO 0);
		o_address_to_flash 	: OUT STD_LOGIC_VECTOR(FLASH_MEMORY_ADDRESS_WIDTH - 1 DOWNTO 0);
		o_data_to_flash 		: OUT STD_LOGIC_VECTOR(FLASH_MEMORY_DATA_WIDTH - 1 DOWNTO 0);
		o_read_flash 			: OUT STD_LOGIC;
		o_write_flash 			: OUT STD_LOGIC
	);

END ENTITY;


architecture rtl OF Altera_UP_Flash_Memory_User_Interface IS

	-- Build an enumerated type for the state machine
	TYPE state_type IS (s_WAIT_COMMAND, s_READ,
						s_READ_BEFORE_WRITE, s_CHECK_MEMORY_CONTENTS,
						s_WRITE_CYCLE, s_WRITE_CYCLE_DELAY,
						s_WAIT_UNTIL_WRITTEN, s_CHECK_WRITE_COMPLETE,
						s_ERASE_SECTOR, s_ERASE_CHIP,
						s_ERASE_CYCLE, s_ERASE_CYCLE_DELAY,
						s_ERASE_WAIT_COMPLETED, s_CHECK_ERASE_DONE,
						s_ACKNOWLEDGE);

	-- Register to hold the current state
	SIGNAL present_state   		: state_type;
	SIGNAL next_state   			: state_type;
	
	-- REGISTERED SIGNALS
	SIGNAL address_reg 			: STD_LOGIC_VECTOR(FLASH_MEMORY_ADDRESS_WIDTH - 1 DOWNTO 0);
	SIGNAL data_reg 				: STD_LOGIC_VECTOR(FLASH_MEMORY_DATA_WIDTH - 1 DOWNTO 0);
	SIGNAL command_cycle 		: STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL last_erase_byte	 	: STD_LOGIC_VECTOR (7 DOWNTO 0 );
	SIGNAL last_erase_address 	: STD_LOGIC_VECTOR(FLASH_MEMORY_ADDRESS_WIDTH - 1 DOWNTO 0);
	
BEGIN
	-- Define state transitions
	PROCESS(i_read, i_write, i_erase, i_address, present_state, i_flash_done, command_cycle, i_data_from_flash, data_reg)
	BEGIN
		CASE present_state IS
			WHEN s_WAIT_COMMAND =>
				IF (i_read = '1') THEN
					next_state <= s_READ;
				ELSIF (i_write = '1') THEN
					next_state <= s_READ_BEFORE_WRITE;
				ELSIF (i_erase = '1') THEN
					IF (i_address = CONV_STD_LOGIC_VECTOR(-1, FLASH_MEMORY_ADDRESS_WIDTH)) THEN
						next_state <= s_ERASE_CHIP;
					ELSE
						next_state <= s_ERASE_SECTOR;
					END IF;
				ELSE
					next_state <= s_WAIT_COMMAND;
				END IF;
			
			-- Read operation - read a byte from memory
			WHEN s_READ =>
				IF (i_flash_done = '1') THEN
					next_state <= s_ACKNOWLEDGE;
				ELSE
					next_state <= s_READ;
				END IF;
			
			-- Memory protection
			WHEN s_READ_BEFORE_WRITE =>
				IF (i_flash_done = '1') THEN
					next_state <= s_CHECK_MEMORY_CONTENTS;
				ELSE
					next_state <= s_READ_BEFORE_WRITE;
				END IF;
			
			WHEN s_CHECK_MEMORY_CONTENTS =>
				IF ((i_data_from_flash = "11111111") AND (NOT (data_reg = "11111111"))) THEN
					next_state <= s_WRITE_CYCLE;
				ELSE
					next_state <= s_ACKNOWLEDGE;
				END IF;
				
			-- Program operation - store a byte into memory
			WHEN s_WRITE_CYCLE =>
				IF (i_flash_done = '1') THEN
					next_state <= s_WRITE_CYCLE_DELAY;
				ELSE
					next_state <= s_WRITE_CYCLE;
				END IF;
			
			WHEN s_WRITE_CYCLE_DELAY =>
				IF (command_cycle = "011") THEN
					next_state <= s_WAIT_UNTIL_WRITTEN;
				ELSE
					next_state <= s_WRITE_CYCLE;
				END IF;				
			
			-- Keep reading data from the same address until the most significant bits match.
			WHEN s_WAIT_UNTIL_WRITTEN =>
				IF (i_flash_done = '1') THEN
					next_state <= s_CHECK_WRITE_COMPLETE;
				ELSE
					next_state <= s_WAIT_UNTIL_WRITTEN;
				END IF;
				
			WHEN s_CHECK_WRITE_COMPLETE =>
				IF (i_data_from_flash(7) = data_reg(7)) THEN
					next_state <= s_ACKNOWLEDGE;
				ELSE
					next_state <= s_WAIT_UNTIL_WRITTEN;
				END IF;	
						
			-- Erase chip procedure. Set last byte to 0x10. Erase address is set to 0x000AAA.
			WHEN s_ERASE_CHIP =>
				next_state <= s_ERASE_CYCLE;
				
			-- Erase sector procedure. Set last byte to 0x30. Also, erase address is taken from the user.
			WHEN s_ERASE_SECTOR =>
				next_state <= s_ERASE_CYCLE;
				
			-- Erase procedure - common steps.
			WHEN s_ERASE_CYCLE =>
				IF (i_flash_done = '1') THEN
					IF (command_cycle = "101") THEN
						next_state <= s_ERASE_WAIT_COMPLETED;
					ELSE
						next_state <= s_ERASE_CYCLE_DELAY;
					END IF;
				ELSE
					next_state <= s_ERASE_CYCLE;
				END IF;
							
			WHEN s_ERASE_CYCLE_DELAY =>
				next_state <= s_ERASE_CYCLE;
			 
			-- Keep reading data from a valid sector until the erase operation completes. This means, address originally
			-- supplied by the user since that is the sector being erased. In case of chip erase, any address is valid.
			WHEN s_ERASE_WAIT_COMPLETED =>
				IF (i_flash_done = '1') THEN
					next_state <= s_CHECK_ERASE_DONE;
				ELSE
					next_state <= s_ERASE_WAIT_COMPLETED;
				END IF;			
			
			WHEN s_CHECK_ERASE_DONE =>
				IF (i_data_from_flash(7) = '1') THEN
					next_state <= s_ACKNOWLEDGE;
				ELSE
					next_state <= s_ERASE_WAIT_COMPLETED;
				END IF;
				
			-- Wait for user to deassert request after every operation.
			WHEN s_ACKNOWLEDGE =>
				IF ((i_write = '1') OR (i_read = '1') OR (i_erase = '1')) THEN
					next_state <= s_ACKNOWLEDGE;		
				ELSE
					next_state <= s_WAIT_COMMAND;		
				END IF;
			
			-- Go to WAIT_COMMAND state if you ever lose your way.	
			WHEN OTHERS =>
				next_state <= s_WAIT_COMMAND;
				
		END CASE;
	END PROCESS;
	
	-- Define state assignment
	PROCESS(i_clock, i_reset_n)
	BEGIN
		IF (i_reset_n = '0') THEN
			present_state <= s_WAIT_COMMAND;
		ELSIF (RISING_EDGE(i_clock)) THEN
			present_state <= next_state;
		END IF;
	END PROCESS;
	
	-- Define Datapath
	PROCESS(i_clock, i_reset_n)
	BEGIN
		IF (i_reset_n = '0') THEN
			address_reg <= (OTHERS => '0');
			data_reg <= (OTHERS => '0');
			command_cycle <= (OTHERS => '0');
			last_erase_byte <= (OTHERS => '0');
			last_erase_address <= (OTHERS => '0');
		ELSIF (RISING_EDGE(i_clock)) THEN
			-- Store data and address in their respective registers.
			IF (present_state = s_WAIT_COMMAND) THEN
				address_reg <= i_address;
				data_reg <= i_data;
			END IF;
			
			-- Store last byte to send and last address to send during the erase cycle.
			IF (present_state = s_ERASE_CHIP) THEN
				last_erase_byte <= "00010000";
				last_erase_address(FLASH_MEMORY_ADDRESS_WIDTH - 1 DOWNTO 12) <= (OTHERS => '0');
				last_erase_address(11 DOWNTO 0) <= "101010101010";
			ELSIF (present_state = s_ERASE_SECTOR) THEN
				last_erase_byte <= "00110000";
				last_erase_address <= address_reg;
			END IF;			
			
			-- Command cycle determines which step in a given procedure is under way.
			IF (present_state = s_WAIT_COMMAND) THEN
				command_cycle <= (OTHERS => '0');
			ELSIF ((present_state = s_ERASE_CYCLE_DELAY) OR (present_state = s_WRITE_CYCLE_DELAY)) THEN
				command_cycle <= command_cycle + '1';
			END IF;
			
		END IF;
	END PROCESS;

	-- Circuit outputs
	o_done <= '1' WHEN (present_state = s_ACKNOWLEDGE) ELSE '0';
	o_data <= i_data_from_flash;
	
	o_address_to_flash(FLASH_MEMORY_ADDRESS_WIDTH - 1 DOWNTO 12) <=
			address_reg(FLASH_MEMORY_ADDRESS_WIDTH - 1 DOWNTO 12) WHEN (((present_state = s_WRITE_CYCLE) AND (command_cycle = "011")) OR (present_state = s_READ) OR
																		(present_state = s_WAIT_UNTIL_WRITTEN) OR (present_state = s_ERASE_WAIT_COMPLETED) OR (present_state = s_READ_BEFORE_WRITE)) ELSE
			last_erase_address(FLASH_MEMORY_ADDRESS_WIDTH - 1 DOWNTO 12) WHEN ((present_state = s_ERASE_CYCLE) AND (command_cycle = "101")) ELSE
			(OTHERS => '0');
										
	o_address_to_flash(11 DOWNTO 0) <= 
			"101010101010"	WHEN ((present_state = s_WRITE_CYCLE) AND ((command_cycle = "000") OR (command_cycle = "010"))) ELSE
			"010101010101"	WHEN ((present_state = s_WRITE_CYCLE) AND (command_cycle = "001")) ELSE
			address_reg(11 DOWNTO 0) WHEN (((present_state = s_WRITE_CYCLE) AND (command_cycle = "011")) OR (present_state = s_READ) OR (present_state = s_WAIT_UNTIL_WRITTEN) OR (present_state = s_ERASE_WAIT_COMPLETED) OR (present_state = s_READ_BEFORE_WRITE)) ELSE
			-- Erase cycle addresses
			"101010101010"	WHEN ((present_state = s_ERASE_CYCLE) AND ((command_cycle = "000") OR (command_cycle = "010") OR (command_cycle = "011"))) ELSE
			"010101010101"	WHEN ((present_state = s_ERASE_CYCLE) AND ((command_cycle = "001") OR (command_cycle = "100"))) ELSE
			last_erase_address(11 DOWNTO 0)	WHEN ((present_state = s_ERASE_CYCLE) AND (command_cycle = "101")) ELSE
			(OTHERS => '0');
										
	o_data_to_flash <= 
			"10101010"	WHEN ((present_state = s_ERASE_CYCLE) AND ((command_cycle = "000") OR (command_cycle = "011"))) ELSE
			"01010101"	WHEN ((present_state = s_ERASE_CYCLE) AND ((command_cycle = "001") OR (command_cycle = "100"))) ELSE
			"10000000"	WHEN ((present_state = s_ERASE_CYCLE) AND (command_cycle = "010")) ELSE
			last_erase_byte	WHEN ((present_state = s_ERASE_CYCLE) AND (command_cycle = "101")) ELSE
			"10101010"	WHEN ((present_state = s_WRITE_CYCLE) AND (command_cycle = "000")) ELSE
			"01010101"	WHEN ((present_state = s_WRITE_CYCLE) AND (command_cycle = "001")) ELSE
			"10100000"	WHEN ((present_state = s_WRITE_CYCLE) AND (command_cycle = "010")) ELSE
			data_reg;
						
	o_write_flash <= '1' WHEN ((present_state = s_WRITE_CYCLE) OR (present_state = s_ERASE_CYCLE)) ELSE
					 '0';
					 
	o_read_flash <= '1' WHEN ((present_state = s_READ) OR (present_state = s_WAIT_UNTIL_WRITTEN) OR
							  (present_state = s_ERASE_WAIT_COMPLETED) OR
							  (present_state = s_READ_BEFORE_WRITE)) ELSE '0';
	
END rtl;


