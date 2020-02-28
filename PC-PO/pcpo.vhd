library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity pcpo is
	port (
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		done : out STD_LOGIC;
		media : out STD_LOGIC_VECTOR(15 downto 0);
				an0: out STD_LOGIC;
		an1: out STD_LOGIC;
	an2: out STD_LOGIC;
	an3: out STD_LOGIC;	
 botao: in STD_LOGIC;
seg7: out STD_LOGIC_VECTOR(7 downto 0)
	);
end pcpo;

architecture Behavioral of pcpo is

	component reg
		generic ( size : integer );
		port (
			clk : in std_logic;
			rst : in std_logic;
			d : in std_logic_vector((size-1) downto 0);
			load : in std_logic;
			s : out std_logic_vector((size-1) downto 0)
		);
	end component;
	
	component counter
		generic ( size : integer );
		port (
			clk : in std_logic;
			rst : in std_logic;
			enable : in std_logic;
			load : in std_logic;
			d : in std_logic_vector((size-1) downto 0);
			s : out std_logic_vector((size-1) downto 0)
		);
	end component;
	
	component mux2x1
		generic ( size : integer );
		port (
			e0 : in UNSIGNED((size-1) downto 0);
			e1 : in UNSIGNED((size-1) downto 0);
			sel : in std_logic;
			s : out UNSIGNED((size-1) downto 0)
		);
	end component;
	
	component memoria
		port (
			clka : IN std_logic;
			wea : IN std_logic_vector(0 downto 0);
			addra : IN std_logic_vector(5 downto 0);
			dina : IN std_logic_vector(15 downto 0);
			douta : OUT std_logic_vector(15 downto 0);
			clkb : IN std_logic;
			web : IN std_logic_vector(0 downto 0);
			addrb : IN std_logic_vector(5 downto 0);
			dinb : IN std_logic_vector(15 downto 0);
			doutb : OUT std_logic_vector(15 downto 0)
		);
	end component;
	
	component plaquita2 
    Port ( ck : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           botao : in  STD_LOGIC;
           an0 : out  STD_LOGIC;
           an1 : out  STD_LOGIC;
           an2 : out  STD_LOGIC;
           an3 : out  STD_LOGIC;
			  conti : in STD_LOGIC_VECTOR (15 downto 0);
           seg7 : out  STD_LOGIC_VECTOR (7 downto 0));
end component;


	signal rst_cnt, inc_cnt, m1, m2, m3, rst_addra, ld_addra, rst_addrb, ld_addrb, rst_x, ld_x, rst_y, ld_y, 
			 rst_dina, ld_dina, rst_media, ld_media : std_logic;
	signal wea : std_logic_vector (0 downto 0);
	signal douta, doutb, dina, media_aux, x, y, mediaa: std_logic_vector (15 downto 0);
	signal aux_multdina : unsigned (31 downto 0);
	signal aux_dina : std_logic_vector (15 downto 0);
	signal mux_media, sum_media : unsigned (15 downto 0);
	signal div_media_aux : unsigned (31 downto 0);
	signal div_media : std_logic_vector (15 downto 0);
	signal addra, addrb : std_logic_vector (5 downto 0);
	signal mux_addra, mux_addrb, aux_addra, aux_addrb : unsigned (5 downto 0);
	signal cnt : std_logic_vector (3 downto 0);
	signal t1 : boolean;
	
	--constant onebynine : real := 1/to_unsigned(9,16);
	constant NINE : integer := 9;
	
	type state is (IDLE, s0, s1, s2, s3, s4, s5, DELAY, DELAY2);
	signal currentState, nextState : state;

begin

	process (clk, rst)
	begin
		if (rst = '1') then
			currentState <= s0;
		elsif (rising_edge(clk)) then
			currentState <= nextState;
		end if;
	end process;
	
	PC: process (currentState, t1)
	begin
		done <= '0';
		rst_cnt <= '0';
		inc_cnt <= '0';
		m1 <= '0';
		m2 <= '0';
		m3 <= '0';
		rst_addra <= '0';
		ld_addra <= '0';
		rst_addrb <= '0';
		ld_addrb <= '0';
		rst_x <= '0';
		ld_x <= '0';
		rst_y <= '0';
		ld_y <= '0';
		rst_dina <= '0'; 
		ld_dina <= '0'; 
		rst_media <= '0'; 
		ld_media <= '0';
		wea <= "0";
		case currentState is
			when IDLE =>
		done <= '0';
		rst_cnt <= '0';
		inc_cnt <= '0';
		m1 <= '0';
		m2 <= '0';
		m3 <= '0';
		rst_addra <= '0';
		ld_addra <= '0';
		rst_addrb <= '0';
		ld_addrb <= '0';
		rst_x <= '0';
		ld_x <= '0';
		rst_y <= '0';
		ld_y <= '0';
		rst_dina <= '0'; 
		ld_dina <= '0'; 
		rst_media <= '0'; 
		ld_media <= '0';
		wea <= "0";
				nextstate <= IDLE;
			when s0 =>
				done <= '0';
				rst_cnt <= '1';
				inc_cnt <= '0';
				m1 <= '0';
				m2 <= '0';
				m3 <= '0';
				rst_addra <= '1';
				ld_addra <= '0';
				rst_addrb <= '0';
				ld_addrb <= '1';
				rst_x <= '1';
				ld_x <= '1';
				rst_y <= '1';
				ld_y <= '1';
				rst_dina <= '1'; 
				ld_dina <= '0'; 
				rst_media <= '1'; 
				ld_media <= '0';
				wea <= "0";
				nextState <= s1;
			when s1 =>
				rst_addra <= '0';
				rst_dina <= '0';
				rst_cnt <= '0';
				rst_media <= '0';
				rst_x <= '0';
				rst_y <= '0';
				m1 <= '0';
				ld_addra <= '1';
				m2 <= '0';
				ld_addrb <= '1';
				ld_x <= '1';
				ld_y <= '1';
				nextstate <= s2;
			when s2 =>
				m1 <= '1';
				ld_addra <= '1';
				m2 <= '1';
				ld_addrb <= '1';
				nextState <= DELAY2;
			when delay2 =>
				nextState <= s3;
			when s3 =>
				ld_x <= '0';
				ld_y <= '0';
				ld_dina <= '1';
				wea <= "1";
				ld_media <= '1';
				inc_cnt <= '1';
				if t1 then
					nextstate <= s5;
					m3 <= '1';
				else
					nextstate <= s4;
				end if;
			when s4 =>
				wea <= "0";
				ld_dina <= '0';
				ld_media <= '0';
				inc_cnt <= '0';
				m1 <= '0';
				ld_addra <= '1';
				m2 <= '0';
				ld_addrb <= '1';
				nextstate <= DELAY;
				m3 <= '1';
			when DELAY =>
				nextstate <= s1;
			when s5 =>
				ld_media <= '1';
				done <= '1';
				mediaa <= media_aux;
				nextstate <= IDLE;
			when others =>
				nextState <= IDLE;
		end case;
	end process;

	CONTADOR : counter
	generic map (
		size => 4
	)
	port map(
		clk => clk, 
		rst => rst_cnt, 
		enable => inc_cnt, 
		load => '0', 
		d => "0000", 
		s => cnt
	);

	t1 <= (cnt = std_logic_vector(to_unsigned(9,4)));

	MUXA : mux2x1
	generic map (
		size => 6
	)
	port map(
		e0 => to_unsigned(0, 6), 
		e1 => to_unsigned(26, 6), 
		s => mux_addra, 
		sel => m1
	);

	ADDR_A : reg
	generic map (
		size => 6
	)
	port map(
		clk => clk, 
		rst => rst_addra, 
		d => std_logic_vector(aux_addra), 
		load => ld_addra, 
		s => addra
	);
	
	aux_addra <= mux_addra+unsigned(cnt);
	
	MUXB : mux2x1
	generic map (
		size => 6
	)
	port map(
		e0 => to_unsigned(9, 6), 
		e1 => to_unsigned(18, 6), 
		s => mux_addrB, 
		sel => m2
	);
	
	ADDR_B : reg
	generic map (
		size => 6
	)
	port map(
		clk => clk, 
		rst => rst_addrb, 
		d => std_logic_vector(aux_addrb), 
		load => ld_addrb, 
		s => addrb
	);

	aux_addrb <= mux_addrb+unsigned(cnt);
	
	
	REG_X : reg
	generic map (
		size => 16
	)
	port map(
		clk => clk, 
		rst => rst_x, 
		d => doutA, 
		load => ld_x, 
		s => x
	);
	
	REG_Y : reg
	generic map (
		size => 16
	)
	port map(
		clk => clk, 
		rst => rst_y, 
		d => doutB, 
		load => ld_y, 
		s => y
	);
	
	DIN_A : reg
	generic map (
		size => 16
	)
	port map(
		clk => clk, 
		rst => rst_dina, 
		d => aux_dina, 
		load => ld_dina, 
		s => dina
	);
	
	aux_multdina <= unsigned(x)*unsigned(y);
	aux_dina <= std_logic_vector(aux_multdina(15 downto 0)) AND doutB;

	MUXMEDIA : mux2x1
	generic map (
		size => 16
	)
	port map(
		e0 => sum_media(15 downto 0), 
		e1 => unsigned(div_media), 
		s => mux_media, 
		sel => m3
	);
	
	sum_media <= (unsigned(dina)+unsigned(media_aux));
	
	-- divisao como descrito em https://surf-vhdl.com/how-to-divide-an-integer-by-constant-in-vhdl/
	div_media_aux <= unsigned(media_aux)*to_unsigned(3640, 16);
	div_media <= std_logic_vector(div_media_aux(30 downto 15));
	
	REG_MEDIA : reg
	generic map (
		size => 16
	)
	port map(
		clk => clk, 
		rst => rst_media, 
		d => std_logic_vector(mux_media), 
		load => ld_media, 
		s => media_aux
	);
	
	media <= media_aux;
	
	MEMORIA_INST : memoria
	port map (
    clka => clk,
    wea => wea,
    addra => addra,
    dina => dina,
    douta => douta,
    clkb => clk,
    web => "0",
    addrb => addrb,
    dinb => "0000000000000000",
    doutb => doutb
	);

	
		displya: plaquita2
	port map(
			  ck => clk,
           reset => rst,
           botao => botao,
           an0 => an0,
           an1 => an1,
           an2 => an2,
           an3 => an3,
			  conti => mediaa,
           seg7 => seg7);

end Behavioral;