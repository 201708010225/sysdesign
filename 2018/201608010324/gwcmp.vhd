library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gwcmp is
	end entity;

architecture gwcmp_test of gwcmp is
	component gwcpu is
		port(
			    clk: in std_logic;
			    reset: in std_logic;
			    addrbus: out std_logic_vector(15 downto 0);
			    databus: inout std_logic_vector(7 downto 0);
			    read: out std_logic;
			    write: out std_logic
		    );
	end component;

	component gwmem is
		port(
			    clk: in std_logic;
			    reset: in std_logic;
			    addrbus: in std_logic_vector(15 downto 0);
			    databus: inout std_logic_vector(7 downto 0);
			    read: in std_logic;
			    write: in std_logic
		    );
	end component;

	signal clk: std_logic := '0';
	signal reset: std_logic;
	signal addrbus: std_logic_vector(15 downto 0);
	signal databus: std_logic_vector(15 downto 0);
	signal read: std_logic;
	signal write: std_logic;

begin
	cpu_1: gwcpu
	port map(
			clk => clk,
			reset => reset,
			addrbus => addrbus,  
			databus => databus,
			read => read,
			write => write
		);

	mem_1: gwmem
	port map(
			clk => clk,
			reset => reset,
			addrbus => addrbus,  
			databus => databus,
			read => read,
			write => write
		);

	reset <= '1', '0' after 300 ns;
	clk <= not clk after 50 ns;

end architecture;
