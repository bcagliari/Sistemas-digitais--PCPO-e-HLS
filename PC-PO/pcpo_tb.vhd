LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY pcpo_tb IS
END pcpo_tb;
 
ARCHITECTURE behavior OF pcpo_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT pcpo
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         done : OUT  std_logic;
         media : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal done : std_logic;
   signal media : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: pcpo PORT MAP (
          clk => clk,
          rst => rst,
          done => done,
          media => media
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      rst <= '1';
      wait for 100 ns;	
		rst <= '0';
      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
