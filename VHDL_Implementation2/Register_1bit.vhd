library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY Register_1bit IS PORT(
    Input   : IN STD_LOGIC;
    Write_Enable  : IN STD_LOGIC;
    Reset : IN STD_LOGIC; 
    clk : IN STD_LOGIC; 
    Output   : OUT STD_LOGIC
);
END Register_1bit;

ARCHITECTURE arch OF Register_1bit IS

BEGIN
    process(clk, Reset)
    begin
        if rising_edge(clk) then
            if (reset = '1')  then
                Output <= '0';
            elsif Write_enable = '1' then
                Output <= Input;
            end if; 
        end if;
    end process;
END arch;