----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:15:46 10/01/2019 
-- Design Name: 
-- Module Name:    mux2x1 - Behavioral 
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

entity mux2x1 is
	generic ( size : integer );
	port (
		e0 : in UNSIGNED ((size-1) downto 0);
		e1 : in UNSIGNED ((size-1) downto 0);
		s : out UNSIGNED ((size-1) downto 0);
		sel : in STD_LOGIC);
end mux2x1;

architecture Behavioral of mux2x1 is

begin

	s <= e0 when sel='0' else
				e1;

end Behavioral;