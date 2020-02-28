----------------------------------------------------------------------------------
-- Company: UFRGS
-- Engineer: Leonardo R. Gobatto, Júlia D. Craide e Heitor Coltro
-- 
-- Create Date:    10:58:58 10/10/2019 
-- Design Name: 
-- Module Name:    plaquita2 - Behavioral 
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
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity plaquita2 is
    Port ( ck : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           botao : in  STD_LOGIC;
           an0 : out  STD_LOGIC;
           an1 : out  STD_LOGIC;
           an2 : out  STD_LOGIC;
           an3 : out  STD_LOGIC;
			  conti : in STD_LOGIC_VECTOR (15 downto 0);
           seg7 : out  STD_LOGIC_VECTOR (7 downto 0));
end plaquita2;


architecture Behavioral of plaquita2 is
signal ck_div : STD_LOGIC_VECTOR (15 downto 0);
signal ck_cont : STD_LOGIC_VECTOR (24 downto 0);
signal cont : STD_LOGIC_VECTOR (15 downto 0);
signal dig3, dig2, dig1, dig0, numeroAtual: STD_LOGIC_VECTOR (3 downto 0);
signal div_display, div_cont : STD_LOGIC;
type T_STATE is (s0,s1,s2,s3);
signal estado, prox_estado : T_STATE ; 

begin

--cont <= conti;
dig3 <= conti(15 downto 12);
dig2 <= conti(11 downto 8);
dig1 <= conti(7 downto 4);
dig0 <= conti(3 downto 0);

--dividir clock pra contador
process(reset, ck)
begin
  if reset = '1' then
    ck_cont <= (others => '0');
  elsif (RISING_EDGE(ck)) then
    ck_cont <= ck_cont +1;
 end if;
 end process; 

div_cont <= ck_cont(24);

--dividir clock pra display
process(reset, ck)
begin
  if reset = '1' then
    ck_div <= (others => '0');
  elsif (RISING_EDGE(ck)) then
    ck_div <= ck_div +1;
 end if;
 end process; 

div_display <= ck_div(15);

--CONTADOR	
--process(div_cont,reset,botao)
--begin
 -- if reset = '1' then
  --  cont <= (others => '0');
  --elsif (RISING_EDGE(div_cont) and botao = '1') then
  --  cont <= cont +1;
 --end if;
 --end process; 

--FSM
Process(estado,dig3,dig2,dig1,dig0)
Begin
	CASE estado is
		When s0 => 
			prox_estado <= s1;
			an0 <= '0';
			an1 <= '1';
			an2 <= '1';
			an3 <= '1';
			numeroAtual <= dig0;
		When s1 => prox_estado <= s2;
			an0 <= '1';
			an1 <= '0';
			an2 <= '1';
			an3 <= '1';
			numeroAtual <= dig1;
		When s2 => prox_estado <= s3;
			an0 <= '1';
			an1 <= '1';
			an2 <= '0';
			an3 <= '1';
			numeroAtual <= dig2;
		When s3 => prox_estado <= s0;
			an0 <= '1';
			an1 <= '1';
			an2 <= '1';
			an3 <= '0';
			numeroAtual <= dig3;
	END CASE;
End process; 

Process(div_display, reset)
Begin
	If reset='1' then
	 estado <= s0;
	Elsif (RISING_EDGE(div_display)) then
	 estado <= prox_estado;
	End if;
End process; 

--cont <= "0000000000000110";

--Display
process(numeroAtual)
begin
	case numeroAtual is
		when "0000" =>  seg7 <= not"10111111";
		when "0001" =>  seg7 <= not"10000110";
		when "0010" =>  seg7 <= not"11011011";
		when "0011" =>  seg7 <= not"11001111";
		when "0100" =>  seg7 <= not"11100110";
		when "0101" =>  seg7 <= not"11101101";
		when "0110" =>  seg7 <= not"11111101";
		when "0111" =>  seg7 <= not"10000111";
		
		when "1000" =>  seg7 <= not"11111111";
		when "1001" =>  seg7 <= not"11101111";
		when "1010" =>  seg7 <= not"11110111";
		when "1011" =>  seg7 <= not"11111100";
		when "1100" =>  seg7 <= not"10111001";
		when "1101" =>  seg7 <= not"11011110";
		when "1110" =>  seg7 <= not"11111001";
		when "1111" =>  seg7 <= not"11110001";
		when others =>  seg7 	<=	not"11111111";
	end case;
end process;

end Behavioral;

