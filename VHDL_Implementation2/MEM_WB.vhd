library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- write the Flipflops packege declaration
entity MEMWB is
port (
    clk: in std_logic;
    WR_EN: in std_logic;
	 Reset: in std_logic;
	 CF_in: in std_logic;
	 ZF_in: in std_logic;
    RD_in: in std_logic_vector(2 downto 0);
    RF_wr_in,R0_WR_in: in std_logic;
    Data_out_WB_in: in std_logic_vector(15 downto 0);
    PC_in: in std_logic_vector(15 downto 0);
	 CF_out: out std_logic;
	 ZF_out: out std_logic;
    RD_out: out std_logic_vector(2 downto 0);
    RF_wr_out,R0_WR_out: out std_logic;
    Data_out_WB_out: out std_logic_vector(15 downto 0);
    PC_out: out std_logic_vector(15 downto 0)
);
end entity;

architecture MEMWB_arch of MEMWB is
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
    RF_wr: Register_1bit port map(RF_wr_in,WR_EN,Reset,clk,RF_wr_out);
	 CF: Register_1bit port map(CF_in,WR_EN,Reset,clk,CF_out);
	 ZF: Register_1bit port map(ZF_in,WR_EN,Reset,clk,ZF_out);
    Data_out_WB: Register_16bit port map(Data_out_WB_in,WR_EN,Reset,clk,Data_out_WB_out);
    PC: Register_16bit port map(PC_in,WR_EN,Reset,clk,PC_out);
    R0_WR: Register_1bit port map(R0_WR_in,WR_EN,Reset,clk,R0_WR_out);
end MEMWB_arch;
