library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RREX is
        port(
            clk: in std_logic;
            WR_EN: in std_logic;
				Reset: in std_logic;
            OP_in: in std_logic_vector(3 downto 0);
            RD_in: in std_logic_vector(2 downto 0);
            RF_D1_in: in std_logic_vector(15 downto 0);
            RF_D2_in: in std_logic_vector( 15 downto 0);
            RF_wr_in: in std_logic;
            ALU_sel_in: in std_logic_vector(1 downto 0);
            Carry_sel_in: in std_logic;
            C_modified_in: in std_logic;
            Z_modified_in: in std_logic;
            Mem_wr_in: in std_logic;
            Imm_in: in std_logic_vector(15 downto 0);
            PC_in: in std_logic_vector(15 downto 0);
            D3_MUX_in: in std_logic_vector(1 downto 0);
            CPL_in: in std_logic;
            R0_WR_in: in std_logic;
            WB_MUX_in: in std_logic;
				ALUA_MUX_in: in std_logic;
				ALUB_MUX_in: in std_logic;
            CZ_in: in std_logic_vector(1 downto 0);
            OP_out: out std_logic_vector(3 downto 0);
            RD_out: out std_logic_vector(2 downto 0);
            RF_D1_out: out std_logic_vector(15 downto 0);
            RF_D2_out: out std_logic_vector( 15 downto 0);
            RF_wr_out: out std_logic;
            ALU_sel_out: out std_logic_vector(1 downto 0);
            Carry_sel_out: out std_logic;
            C_modified_out: out std_logic;
            Z_modified_out: out std_logic;
            Mem_wr_out: out std_logic;
            Imm_out: out std_logic_vector(15 downto 0);
            PC_out: out std_logic_vector(15 downto 0);
            D3_MUX_out: out std_logic_vector(1 downto 0);
            CPL_out: out std_logic;
            R0_WR_out: out std_logic;
            WB_MUX_out: out std_logic;
				ALUA_MUX_out: out std_logic;
				ALUB_MUX_out: out std_logic;
            CZ_out: out std_logic_vector(1 downto 0)
            );
end entity;

architecture RREX_arch of RREX is
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
    OP: Register_4bit port map(OP_in,WR_EN,Reset,clk, OP_out);
    RD: Register_3bit port map(RD_in,WR_EN,Reset,clk, RD_out);
    RF_D1: Register_16bit port map(RF_D1_in,WR_EN,Reset,clk, RF_D1_out);
    RF_D2: Register_16bit port map(RF_D2_in,WR_EN,Reset,clk, RF_D2_out);
    RF_wr: Register_1bit port map(RF_wr_in,WR_EN,Reset,clk, RF_wr_out);
    ALU_sel: Register_2bit port map(ALU_sel_in,WR_EN,Reset,clk, ALU_sel_out);
    Carry_sel: Register_1bit port map(Carry_sel_in,WR_EN,Reset,clk, Carry_sel_out);
    C_modified: Register_1bit port map(C_modified_in,WR_EN,Reset,clk, C_modified_out);
    Z_modified: Register_1bit port map(Z_modified_in,WR_EN,Reset,clk, Z_modified_out);
    Mem_wr: Register_1bit port map(Mem_wr_in,WR_EN,Reset,clk, Mem_wr_out);
    Imm: Register_16bit port map(Imm_in,WR_EN,Reset,clk, Imm_out);
    PC: Register_16bit port map(PC_in,WR_EN,Reset,clk, PC_out);
    D3_MUX: Register_2bit port map(D3_MUX_in,WR_EN,Reset,clk, D3_MUX_out);
    CPL: Register_1bit port map(CPL_in,WR_EN,Reset,clk, CPL_out);
    R0_WR: Register_1bit port map(R0_WR_in,WR_EN,Reset,clk, R0_WR_out);
    WB_MUX: Register_1bit port map(WB_MUX_in,WR_EN,Reset,clk, WB_MUX_out);
	 ALUA_MUX: Register_1bit port map(ALUA_MUX_in,WR_EN,Reset,clk, ALUA_MUX_out);
	 ALUB_MUX: Register_1bit port map(ALUB_MUX_in,WR_EN,Reset,clk, ALUB_MUX_out);
    CZ: Register_2bit port map(CZ_in,WR_EN,Reset,clk, CZ_out);
end RREX_arch;