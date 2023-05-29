library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- write the Flipflops packege declaration
entity IF_ID is
port (
             Instruc_in,PC_in: in std_logic_vector(15 downto 0 );
				 R0_WR_in: in std_logic;
				 Reset: in std_logic;
				 clk: in std_logic;
				 WR_EN: in std_logic;				 
				 R0_WR_out:out std_logic;
				 Instruc_op,PC_op: out std_logic_vector(15 downto 0 )
        );
end entity IF_ID;

architecture struct of IF_ID is
--------16 bit Register---------------

	component Register_16bit is 
		port(
			Input   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			Write_Enable  : IN STD_LOGIC;
			Reset : IN STD_LOGIC; 
			clk : IN STD_LOGIC; 
			Output   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	end Component;
	 
----------1 bit register-----------------

	component Register_1bit is 
		port(
			Input   : IN STD_LOGIC;
			Write_Enable  : IN STD_LOGIC;
			Reset : IN STD_LOGIC; 
			clk : IN STD_LOGIC; 
			Output   : OUT STD_LOGIC
		);
	end component;


    
begin
Instruction: Register_16bit port map(Instruc_in,WR_EN,Reset,clk,Instruc_op);
PC         : Register_16bit port map(PC_in,WR_EN,Reset,clk,PC_op);
R0_WR      : Register_1bit port map(R0_WR_in,WR_EN,Reset,clk,R0_WR_out);


end struct;