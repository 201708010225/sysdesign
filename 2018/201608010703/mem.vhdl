library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rsisa.all;

entity rsmem is
	port(
		    clk: in std_logic;
		    reset: in std_logic;
		    addrbus: in std_logic_vector(15 downto 0);
		    databus: inout std_logic_vector(7 downto 0);
		    en_read: in std_logic;
		    en_write: in std_logic
	    );
end entity;

architecture rsmem_behav of rsmem is
	signal addr: std_logic_vector(15 downto 0);

	type memtype is array(natural range<>) of std_logic_vector(7 downto 0);
	constant total_addr : integer := 29;
	constant i_addr : integer := 30;
	constant n_addr : integer := 31;
	constant loop_addr : integer := 7;

	signal memdata: memtype(4095 downto 0) := (
	0 => RSCLAC,
	1 => RSSTAC,
	2 => std_logic_vector(to_unsigned(total_addr, 8)),
	3 => X"00",
	4 => RSSTAC,
	5 => std_logic_vector(to_unsigned(i_addr, 8)),
	6 => X"00",
	7 => RSLDAC,  -- loop
	8 => std_logic_vector(to_unsigned(i_addr, 8)),
	9 => X"00",
	10 => RSINAC,
	11 => RSSTAC,
	12 => std_logic_vector(to_unsigned(i_addr, 8)),
	13 => X"00",
	14 => RSMVAC,
	15 => RSLDAC,
	16 => std_logic_vector(to_unsigned(total_addr, 8)),
	17 => X"00",
	18 => RSADD,
	19 => RSSTAC,
	20 => std_logic_vector(to_unsigned(total_addr, 8)),
	21 => X"00",
	22 => RSLDAC,
	23 => std_logic_vector(to_unsigned(n_addr, 8)),
	24 => X"00",
	25 => RSSUB,
	26 => RSJPNZ,
	27 => std_logic_vector(to_unsigned(loop_addr, 8)),
	28 => X"00",
	29 => X"00",  -- total
	30 => X"00",  -- i
	31 => X"04",  -- n
	others => RSNOP
);

begin
	-- The process takes addrbus and read/write signals at first,
	-- then at the next clock does the data transmission.
	for_clk : process(clk)
	begin
		if(falling_edge(clk)) then
			if(reset='1') then
				addr <= (others=>'0');
			else
				addr <= addrbus;
			end if;

			if(en_write='1') then
				memdata(to_integer(unsigned(addr))) <= databus;
			end if;
		end if;
	end process;

	databus <= memdata(to_integer(unsigned(addr))) when (en_read='1') else "ZZZZZZZZ";

end architecture;
