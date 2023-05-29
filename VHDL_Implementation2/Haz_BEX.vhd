library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- Detects Harards due to BEX
entity Haz_BEX is
port (
    Instruc_OPCode_EX:in std_logic_vector(3 downto 0);
    ZFlag,CFlag:in std_logic;
	cancel:std_logic;
    H_BEX:out std_logic
);
end entity Haz_BEX;

architecture struct of Haz_BEX is
begin
    process(Instruc_OPCode_EX,ZFlag,CFlag,cancel)

        begin
            H_BEX<= '0';
				if(cancel='0') then
					H_BEX<='0';
            elsif(((Instruc_OPCode_EX  = "1000") and (ZFlag = '1')))    then
                H_BEX<= '1';
            -----BLE
            elsif ((Instruc_OPCode_EX  =  "1010")and (CFlag = '1'))    then
                H_BEX <=  '1'; 
            -----BLT
            elsif ((Instruc_OPCode_EX = "1001") and (CFlag = '1') and (ZFlag = '0'))    then
                H_BEX <=  '1'; 
            else
                H_BEX<='0';
            end if;
        end process;
end struct;