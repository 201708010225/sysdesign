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
		    result: out std_logic_vector(7 downto 0) ;
		    rd: in std_logic;
		    we: in std_logic
	    );
end entity;

architecture mem_behav of rsmem is
	signal addr: std_logic_vector(15 downto 0);
	type memtype is array(natural range<>) of std_logic_vector(7 downto 0);
	constant total_addr : integer := 29;
	constant i_addr : integer := 30;
	constant n_addr : integer := 31;
	constant loop_addr : integer := 7;
	
	signal memdata: memtype(4095 downto 0) := (
	0 => RSCLAC,
	1 => RSSTAC,--m[total_total]<=ac    total=0
	2 => std_logic_vector(to_unsigned(total_addr, 8)),
	3 => X"00",
	4 => RSSTAC,--m[i_addr]<=ac    i=0
	5 => std_logic_vector(to_unsigned(i_addr, 8)),
	6 => X"00",
	7 => RSLDAC,  -- loop    --ac<=m[i_addr]    ac=i
	8 => std_logic_vector(to_unsigned(i_addr, 8)),
	9 => X"00",
	10 => RSINAC, --ac++
	11 => RSSTAC, --i=ac
	12 => std_logic_vector(to_unsigned(i_addr, 8)),
	13 => X"00",
	14 => RSMVAC, --r=ac
	15 => RSLDAC, --ac=total
	16 => std_logic_vector(to_unsigned(total_addr, 8)),
	17 => X"00",
	18 => RSADD, --ac=ac+r
	19 => RSSTAC, --total=ac
	20 => std_logic_vector(to_unsigned(total_addr, 8)),
	21 => X"00",  
	22 => RSLDAC, --ac=n
	23 => std_logic_vector(to_unsigned(n_addr, 8)),
	24 => X"00",
	25 => RSSUB, --ac=ac-r
	26 => RSJPNZ, --
	27 => std_logic_vector(to_unsigned(loop_addr, 8)),
	28 => X"00",
	29 => X"00",  -- total
	30 => X"00",  -- i
	31 => X"09",  -- n
	others => RSNOP
);

begin
	-- The process takes addrbus and rd/we signals at first,
	-- then at the next clock does the data transmission.
	for_clk : process(clk)
	begin
		if(falling_edge(clk)) then
			if(reset='1') then
				addr <= (others=>'0');
			else
				addr <= addrbus;
			end if;

			if(we='1') then
				memdata(to_integer(unsigned(addr))) <= databus;
			end if;
		end if;
	end process;
	
	databus <= memdata(to_integer(unsigned(addr))) when (we='0') else "ZZZZZZZZ";
	result<=memdata(29);
end architecture;