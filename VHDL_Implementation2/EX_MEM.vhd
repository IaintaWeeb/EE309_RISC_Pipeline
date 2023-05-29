library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- write the Flipflops packege declaration
entity EXMEM is
        port (
			 clk: in std_logic;
			 WR_EN: in std_logic;
			 Reset: in std_logic;
			 RD_in: in std_logic_vector(2 downto 0);
			 RF_D1_in: in std_logic_vector(15 downto 0);
			 RF_wr_in: in std_logic;
			 Mem_wr_in: in std_logic;
			 PC_in: in std_logic_vector(15 downto 0);
			 ALU1_C_in: in std_logic_vector(15 downto 0);
			 WB_MUX_in: in std_logic;	 
			 R0_WR_in: in std_logic;
			 RD_out: out std_logic_vector(2 downto 0);
			 RF_D1_out: out std_logic_vector(15 downto 0);
			 RF_wr_out: out std_logic;
			 Mem_wr_out: out std_logic;
			 PC_out: out std_logic_vector(15 downto 0);
			 R0_WR_out: out std_logic;
			 ALU1_C_out: out std_logic_vector(15 downto 0);
			 WB_MUX_out: out std_logic
		);
end entity;

architecture EXMEM_arch of EXMEM is
----------16 bit Register---------------

	component Register_16bit is 
		port(
			Input   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			Write_Enable  : IN STD_LOGIC;
			Reset : IN STD_LOGIC; 
			clk : IN STD_LOGIC; 
			Output   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	end component;
	 
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
	
----------4 bit register-----------------

	component Register_4bit is 
		port(
			Input   : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			Write_Enable  : IN STD_LOGIC;
			Reset : IN STD_LOGIC; 
			clk : IN STD_LOGIC; 
			Output   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	end component;
	
----------3 bit register-----------------

	component Register_3bit is 
		port(
			Input   : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			Write_Enable  : IN STD_LOGIC;
			Reset : IN STD_LOGIC; 
			clk : IN STD_LOGIC; 
			Output   : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
		);
	end component;
	
----------2 bit register-----------------

	component Register_2bit is 
		port(
			Input   : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			Write_Enable  : IN STD_LOGIC;
			Reset : IN STD_LOGIC; 
			clk : IN STD_LOGIC; 
			Output   : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
		);
	end component;
    
begin
    RD: Register_3bit port map(RD_in,WR_EN,Reset,clk,RD_out);
	 RF_D1: Register_16bit port map(RF_D1_in,WR_EN,Reset,clk,RF_D1_out);
    RF_wr: Register_1bit port map(RF_wr_in,WR_EN,Reset,clk,RF_wr_out);
    Mem_wr: Register_1bit port map(Mem_wr_in,WR_EN,Reset,clk,Mem_wr_out);
    PC: Register_16bit port map(PC_in,WR_EN,Reset,clk,PC_out);
    R0_WR: Register_1bit port map(R0_WR_in,WR_EN,Reset,clk,R0_WR_out);
    ALU1_C: Register_16bit port map(ALU1_C_in,WR_EN,Reset,clk,ALU1_C_out);
    WB_MUX: Register_1bit port map(WB_MUX_in,WR_EN,Reset,clk,WB_MUX_out);
end EXMEM_arch;
