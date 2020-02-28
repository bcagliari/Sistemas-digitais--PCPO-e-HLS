----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 22:49:39 12/18/2019
-- Design Name:
-- Module Name: hls_sem - Behavioral
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

entity main is
	port (
		clk : in std_logic;
		rst : in std_logic;
		start : in std_logic;
		done : out std_logic;
		media : out std_logic_vector(15 downto 0)
	);
end main;

architecture Behavioral of main is

	component matrixmul
		port (
			ap_clk : IN STD_LOGIC;
			ap_rst : IN STD_LOGIC;
			ap_start : IN STD_LOGIC;
			ap_done : OUT STD_LOGIC;
			ap_idle : OUT STD_LOGIC;
			ap_ready : OUT STD_LOGIC;
			 
		    input_r_address0 : OUT STD_LOGIC_VECTOR (3 downto 0);
		    input_r_ce0 : OUT STD_LOGIC;
   		 input_r_q0 : IN STD_LOGIC_VECTOR (7 downto 0);
   		 
			 peso_address0 : OUT STD_LOGIC_VECTOR (3 downto 0);
   		 peso_ce0 : OUT STD_LOGIC;
   		 peso_q0 : IN STD_LOGIC_VECTOR (15 downto 0);
    
			 res_address0 : OUT STD_LOGIC_VECTOR (3 downto 0);
   		 res_ce0 : OUT STD_LOGIC;
   		 res_we0 : OUT STD_LOGIC;
   		 res_d0 : OUT STD_LOGIC_VECTOR (15 downto 0);
    
			 masc_address0 : OUT STD_LOGIC_VECTOR (3 downto 0);
		    masc_ce0 : OUT STD_LOGIC;
   		 masc_q0 : IN STD_LOGIC_VECTOR (15 downto 0);
    
   		 ap_return : OUT STD_LOGIC_VECTOR (15 downto 0) );
	end component;

	component mem_input
		port (
			clka : IN STD_LOGIC;
			ena : IN STD_LOGIC;
			wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
			addra : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	end component;

	component mem_peso
		port (
			clka : IN STD_LOGIC;
			ena : IN STD_LOGIC;
			wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
			addra : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	end component;

	component mem_mascara
		port (
			clka : IN STD_LOGIC;
			ena : IN STD_LOGIC;
			wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
			addra : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	end component;

	component mem_resultado
		port (
			clka : IN STD_LOGIC;
			ena : IN STD_LOGIC;
			wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
			addra : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	end component;
	signal add_input : STD_LOGIC_VECTOR (3 downto 0);
	signal en_input : STD_LOGIC;
	signal out_input : STD_LOGIC_VECTOR (7 downto 0);
 
	signal add_peso : STD_LOGIC_VECTOR (3 downto 0);
	signal en_peso : STD_LOGIC;
	signal out_peso : STD_LOGIC_VECTOR (15 downto 0);
 
	signal add_mascara : STD_LOGIC_VECTOR (3 downto 0);
	signal en_mascara : STD_LOGIC;
	signal out_mascara : STD_LOGIC_VECTOR (15 downto 0);
 
	signal add_res : STD_LOGIC_VECTOR (3 downto 0);
	signal en_res, wea_res : STD_LOGIC;
	signal in_res : STD_LOGIC_VECTOR (15 downto 0);
 
	signal signal_media: std_logic_vector (15 downto 0);

begin
	
	media <= signal_media(15 downto 0);

	main : matrixmul
	port map(
		ap_clk => clk, 
		ap_rst => rst, 
		ap_start => start, 
		ap_done => done, 
 
		input_r_address0 => add_input, 
		input_r_ce0 => en_input, 
		input_r_q0 => out_input, 
 
		peso_address0 => add_peso, 
		peso_ce0 => en_peso, 
		peso_q0 => out_peso, 
 
		masc_address0 => add_mascara, 
		masc_ce0 => en_mascara, 
		masc_q0 => out_mascara, 
		ap_return => signal_media,
 
		res_address0 => add_res, 
		res_ce0 => en_res, 
		res_we0 => wea_res, 
		res_d0 => in_res
	);
	
	m_input : mem_input
	port map(
		clka => clk, 
		ena => en_input, 
		addra => add_input, 
		wea => "0",
		dina => "00000000",
		douta => out_input
	);
 
	m_peso : mem_peso
	port map(
		clka => clk, 
		ena => en_peso, 
		addra => add_peso, 
		wea => "0",
		dina => "0000000000000000",
		douta => out_peso
	);
 
	m_masc : mem_mascara
	port map(
		clka => clk, 
		ena => en_mascara, 
		addra => add_mascara, 
		wea => "0",
		dina => "0000000000000000",
		douta => out_mascara
	);
 
	m_res : mem_resultado
	port map(
		clka => clk, 
		ena => en_res, 
		wea(0) => wea_res, 
		addra => add_res, 
		dina => in_res
	);

end Behavioral;