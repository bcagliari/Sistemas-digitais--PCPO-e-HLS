----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 22:46:18 10/05/2019
-- Design Name:
-- Module Name: counter - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter is
	generic ( size : integer );
	port (
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		enable : in STD_LOGIC;
		load : in STD_LOGIC;
		d : in STD_LOGIC_VECTOR ((size-1) downto 0);
		s : out STD_LOGIC_VECTOR ((size-1) downto 0)
	);
end counter;

architecture Behavioral of counter is

	signal temp : unsigned ((size-1) downto 0);

begin

	process(clk, rst)
	begin
	
	if (rising_edge(clk)) then
		if (rst = '1') then
			temp <= to_unsigned(0, size);
		elsif (enable = '1') then
			temp <= temp + 1;
		elsif (load = '1') then
			temp <= unsigned(d);
		end if;
	end if;
	
	end process;

	s <= std_logic_vector(temp);
	
end Behavioral;