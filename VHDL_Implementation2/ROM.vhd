library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ROM is
	port (
		Mem_Add: in std_logic_vector(15 downto 0 );
		Mem_Data_Out:out std_logic_vector(15 downto 0)
	);
end entity ROM;

architecture struct of ROM is
    type mem_word   is array (0 to 99) of std_logic_vector(7 downto 0);
	 constant Data : mem_word:=("00001110","00000110","00001001","00000010","00011111","10101000","01011011","00000001","11010010","10000000",others=>"00000000");

begin
------------------------------------- Read Instruction---------------------------
read_process : process(Mem_Add)
begin
  Mem_Data_Out <= Data(To_integer(unsigned(Mem_Add)) mod 100) & Data(To_integer((unsigned(Mem_Add)) + 1) mod 100);
----------------------------------------------------------------------
end process;
end struct;