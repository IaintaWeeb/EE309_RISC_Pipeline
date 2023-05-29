library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity Datapath is
	port(
        --Inputs
        clock, reset:in std_logic;
		  Reg_sel : in std_logic_vector(3 downto 0);
		  CF_out,ZF_out : out std_logic;
		  output_Reg : out std_logic_vector(7 downto 0) 
		);
end Datapath;

architecture Struct of Datapath is

    --1. ALU
    component ALU is
		port( sel: in std_logic_vector(1 downto 0); 
				ALU_A: in std_logic_vector(15 downto 0);
				ALU_B: in std_logic_vector(15 downto 0);
				C_in: in std_logic;
				Carry_sel: in std_logic;
				ALU_c: out std_logic_vector(15 downto 0);
				C_F: out std_logic;
				Z_F: out std_logic
			);
	 end component;
	 
	 --2. 1 bit 4x1 Mux 
	 component Mux1_4x1 is
    port(A,B,C,D: in std_logic;
         Sel: in std_logic_vector(1 downto 0);
         F:out std_logic);
    end component;
	 
    --3. 16 bit 2x1 Mux
    component Mux16_2x1 is
        port(A0: in std_logic_vector(15 downto 0);
             A1: in std_logic_vector(15 downto 0);
             sel:in std_logic;
             F: out std_logic_vector(15 downto 0));
	 end component;

    --4. 16 bit 4x1 Mux
    component Mux16_4x1 is
        port(A0: in std_logic_vector(15 downto 0);
            A1: in std_logic_vector(15 downto 0);
            A2: in std_logic_vector(15 downto 0);
            A3: in std_logic_vector(15 downto 0);
            sel: in std_logic_vector(1 downto 0);
            F: out std_logic_vector(15 downto 0));
    end component;
    
    --5. IFID
    component IF_ID is
        port (
             Instruc_in,PC_in: in std_logic_vector(15 downto 0 );
				 R0_WR_in: in std_logic;
				 Reset: in std_logic;
				 clk: in std_logic;
				 WR_EN: in std_logic;				 
				 R0_WR_out:out std_logic;
				 Instruc_op,PC_op: out std_logic_vector(15 downto 0 )
        );
    end component;
	 
    --6. Instruction Decoder
    component instr_decode is
        port
		 (
			  Instruction : in std_logic_vector(15 downto 0);
			  Reset:in std_logic;
			  PC_in: in std_logic_vector(15 downto 0);
			  RS1,RS2,RD : out std_logic_vector(2 downto 0);
			  ALU_sel,D3_MUX,CZ: out std_logic_vector(1 downto 0);
			  Imm : out std_logic_vector(15 downto 0);
			  RF_wr, C_modified, Z_modified, Mem_wr,Carry_sel,CPL,WB_MUX,ALUA_MUX,ALUB_MUX : out std_logic;
			  OP : out std_logic_vector(3 downto 0);
			  PC_ID : out std_logic_vector(15 downto 0);
			  LM_SM_hazard : out std_logic;
			  clk: in std_logic
		 );
    end component;
	 
    --7. IDRR
    component IDRR is
        port (
            clk: in std_logic;
            WR_EN: in std_logic;
				Reset: in std_logic;
            OP_in: in std_logic_vector(3 downto 0);
            RS1_in: in std_logic_vector(2 downto 0);
            RS2_in: in std_logic_vector(2 downto 0);
            RD_in: in std_logic_vector(2 downto 0);
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
            RS1_out: out std_logic_vector(2 downto 0);
            RS2_out: out std_logic_vector(2 downto 0);
            RD_out: out std_logic_vector(2 downto 0);
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
            CZ_out: out std_logic_vector(1 downto 0));
        end component;

    --8. RREX
    component RREX is
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
        end component;
		  
    --9. EX_MEM
    component EXMEM is
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
    end component;
        
    --9. MEMWB
    component MEMWB is
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
		end component;
	 
    --10. Register_File
    component Register_file is
        port (
			   A1, A2, A3: in std_logic_vector(2 downto 0 );
				D3:in std_logic_vector(15 downto 0);
				RF_PC_in: in std_logic_vector(15 downto 0);
				Reg_data: out std_logic_vector(7 downto 0);
				clock,Write_Enable,PC_WR:in std_logic;
				Reg_sel: in std_logic_vector(3 downto 0);
				D1, D2:out std_logic_vector(15 downto 0)
		  );
    end component Register_file;
    
    --11. D-flipflop with enable
    component dff_en is
        port(
           clk: in std_logic;
           reset: in std_logic;
           en: in std_logic;
           d: in std_logic;
           q: out std_logic
        );
     end component;
    
    --12. ROM
    component ROM is
        port (
				Mem_Add: in std_logic_vector(15 downto 0 );
            Mem_Data_Out:out std_logic_vector(15 downto 0)
		  );
    end component ROM;

    --13. RAM
    component RAM is
        port (
				Mem_Add: in std_logic_vector(15 downto 0 );
				Mem_Data_In:in std_logic_vector(15 downto 0);
				clock,Write_Enable:in std_logic;
				Mem_Data_Out:out std_logic_vector(15 downto 0)
		  );    
    end component RAM;

    --14. adder
    component adder is
        port( 
            Inp1,Inp2: in std_logic_vector(15 downto 0);
            Outp: out std_logic_vector(15 downto 0)
            );
    end component;
	 
	 --15. complementor
	 component complementor is
		  port( 
		      Cpl: in std_logic; 
			   Inp: in std_logic_vector(15 downto 0);
			   Outp: out std_logic_vector(15 downto 0));
	 end component;
	
    --16. 16 bit Register
	 component Register_16bit is 
		  port(
			  Input   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			  Write_Enable  : IN STD_LOGIC;
			  Reset : IN STD_LOGIC; 
			  clk : IN STD_LOGIC; 
			  Output   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		  );
	 end component;
	
    --17. 1 bit Register
	 component Register_1bit is 
		  port(
			  Input   : IN STD_LOGIC;
			  Write_Enable  : IN STD_LOGIC;
			  Reset : IN STD_LOGIC; 
			  clk : IN STD_LOGIC; 
			  Output   : OUT STD_LOGIC
		  );
	 end component;	
	 
-----Hazard Units: Used To Mitigate Data and Control Hazards(details in report)
-----PC Controller: for control Hazards 

    component Haz_PC_controller is
        port (
            PC_IF,PC_ID,PC_RR,PC_EX,PC_Mem: in std_logic_vector(15 downto 0);
            H_JLR,H_JAL, H_BEX, LMSM_Haz,H_Load_Imm,H_R0: in std_logic;        
            PC_New: out std_logic_vector(15 downto 0);
            PC_WR,IF_ID_flush,ID_RR_flush,RR_EX_flush,EX_Mem_flush, IF_ID_WR,ID_RR_WR,RR_EX_WR, EX_MEM_WR, MEM_WB_WR : out std_logic
            
        );
    end component Haz_PC_controller;

    component Haz_JLR is
        port (
            Instruc_OPCode_RR:in std_logic_vector(3 downto 0);
				cancel:in std_logic;
            H_JLR:out std_logic
        );
    end component Haz_JLR;

    component Haz_JAL is
        port (
            Instruc_OPCode_ID:in std_logic_vector(3 downto 0);
				cancel:in std_logic;
            H_Jal:out std_logic
        );
    end component Haz_JAL;

    component Haz_BEX is
        port (
            Instruc_OPCode_EX:in std_logic_vector(3 downto 0);
            ZFlag,CFlag:in std_logic;
				cancel:in std_logic;        
            H_BEX:out std_logic
        );
    end component Haz_BEX;
	 
	 -- Hazard due to Load Instructions => 1 cycle stall
    component Haz_load is
        port (
            Instruc_OPCode_EX,Instruc_OPCode_RR:in std_logic_vector(3 downto 0);
            Ra_RR,Rb_RR,Rc_Ex: in std_logic_vector(2 downto 0);
				cancel:in std_logic;
            Load_Imm:out std_logic
        );
    end component Haz_load;
	 
	 -- Hazard when Destination is R0
    component Haz_R0 is
        port (
            Rd_Mem:in std_logic_vector(2 downto 0);
				RF_WR_Mem:in std_logic;
				cancel:in std_logic;
            H_R0:out std_logic
        );
    end component Haz_R0;
	 
    ---Forwarding Unit => Data forwarding to mitigated data Hazards
    component Forwarding_Unit is
        port (
            RegC_EX,RegC_Mem,RegC_WB,RegA_RR, RegB_RR: in std_logic_vector(2 downto 0);
            RF_WR_EX, RF_WR_Mem, RF_WR_WB:in std_logic;    
            MuxA,MuxB: out std_logic_vector(1 downto 0);
				Opcode_Ex: in std_logic_vector(3 downto 0)
        );
    end component Forwarding_Unit;
  
    --WR_EN signals
    signal WREN_IFID,WREN_IDRR,WREN_RREX,WREN_EXMEM,WREN_MEMWB : std_logic;

    --Signals required for IF
    signal Instruc, PC_IF : std_logic_vector(15 downto 0);
	 
    --Signals for ID:
    signal PC_1 : std_logic_vector(15 downto 0);
    signal Instruc_ID : std_logic_vector(15 downto 0);
    signal OP_ID: std_logic_vector(3 downto 0);
    signal RS1_ID: std_logic_vector(2 downto 0);
    signal RS2_ID: std_logic_vector(2 downto 0);
    signal RD_ID: std_logic_vector(2 downto 0);
    signal RF_wr_ID: std_logic;
    signal ALU_sel_ID: std_logic_vector(1 downto 0);
    signal Carry_sel_ID: std_logic;
    signal C_modified_ID: std_logic;
    signal Z_modified_ID: std_logic;
    signal Mem_wr_ID: std_logic;
    signal Imm_ID: std_logic_vector(15 downto 0);
    signal PC_ID: std_logic_vector(15 downto 0);
    signal D3_MUX_ID: std_logic_vector(1 downto 0);
    signal CPL_ID,R0_WR_ID: std_logic;
    signal WB_MUX_ID: std_logic;
	 signal ALUA_MUX_ID: std_logic;
	 signal ALUB_MUX_ID: std_logic;
    signal CZ_ID: std_logic_vector(1 downto 0);
	 
    -----Signals for RR
    signal muxA,muxB : std_logic_vector(2 downto 0);
    signal OP_RR: std_logic_vector(3 downto 0);
    signal RS1_RR,RS2_RR:std_logic_vector(2 downto 0);
    signal RD_RR: std_logic_vector(2 downto 0);
    signal RF_wr_RR,MUXRF_D1_sel,MUXRF_D2_sel:std_logic;
    signal ALU_sel_RR: std_logic_vector(1 downto 0);
    signal Carry_sel_RR: std_logic;
    signal C_modified_RR: std_logic;
    signal Z_modified_RR: std_logic;
    signal Mem_wr_RR: std_logic;
    signal Imm_RR,Imm2,rf_d1_RR1,rf_d2_RR1,rf_d1_RR2,rf_d2_RR2,rf_d1_RR3,rf_d2_RR3: std_logic_vector(15 downto 0);
    signal PC_RR1,PC_RR2: std_logic_vector(15 downto 0);
    signal D3_MUX_RR:  std_logic_vector(1 downto 0);
    signal CPL_RR,R0_WR_RR:  std_logic;
    signal WB_MUX_RR:  std_logic;
	 signal ALUA_MUX_RR: std_logic;
	 signal ALUB_MUX_RR: std_logic;
    signal CZ_RR: std_logic_vector(1 downto 0); 
	 
    --Signals for EX
    signal OP_EX: std_logic_vector(3 downto 0);
    signal RD_EX: std_logic_vector(2 downto 0);
    signal RF_wr_EX1,RF_wr_EX:std_logic;
    signal ALU_sel_EX: std_logic_vector(1 downto 0);
    signal Carry_sel_EX: std_logic;
    signal C_modified,C_modified_EX: std_logic;
    signal Z_modified,Z_modified_EX: std_logic;
    signal Mem_wr_EX: std_logic;
    signal Imm_EX,Imm3,rf_d1_EX,rf_d2_EX,rf_d2_CPL,ALUA,ALUB,Alu1C_fw: std_logic_vector(15 downto 0);
    signal PC_EX,PCp2_EX: std_logic_vector(15 downto 0);
    signal D3_MUX_EX:  std_logic_vector(1 downto 0);
    signal CPL_EX,R0_WR_EX:  std_logic;
    signal WB_MUX_EX:  std_logic;
	 signal ALUA_MUX_EX: std_logic;
	 signal ALUB_MUX_EX: std_logic;
    signal CZ_EX: std_logic_vector(1 downto 0);
    signal Alu1C_EX,Alu3C_EX : std_logic_vector(15 downto 0);
    signal carry,zero,CF_MEM,ZF_MEM : std_logic:= '0';  

    --Signals for MEM:
    signal RD_MEM: std_logic_vector(2 downto 0);
    signal RF_wr_MEM,R0_WR_MEM:std_logic;
    signal Mem_wr_MEM: std_logic;
    signal PC_MEM: std_logic_vector(15 downto 0);
    signal WB_MUX_MEM:  std_logic;
    signal CZ_MEM: std_logic_vector(1 downto 0);
    signal Alu1C_MEM: std_logic_vector(15 downto 0);
    signal Data_out,Data_out_MEM,rf_d1_MEM : std_logic_vector(15 downto 0);

    --Signals for WB
    signal RD_WB: std_logic_vector(2 downto 0);
    signal RF_wr_WB:std_logic;
    signal ALU_sel_WB: std_logic_vector(1 downto 0);
    signal Carry_sel_WB: std_logic;
    signal C_modified_WB: std_logic;
    signal Z_modified_WB: std_logic;
    signal WB_wr_WB: std_logic;
    signal rf_d1_WB,rf_d2_WB: std_logic_vector(15 downto 0);
    signal PC_WB: std_logic_vector(15 downto 0);
    signal CPL_WB:  std_logic;
    signal WB_MUX_WB,R0_WR_WB,CF_WB,ZF_WB:  std_logic;
    signal CZ_WB: std_logic_vector(1 downto 0);
    signal Alu1C_WB: std_logic_vector(15 downto 0);
    signal Data_out_WB : std_logic_vector(15 downto 0);
    signal D3 : std_logic_vector(15 downto 0);
    signal rf_d3 : std_logic_vector(15 downto 0);

    --Signals for Branch Predictor
    signal Z_Flag, C_Flag : std_logic;
    signal index_EX: integer;    
    signal Instruc_op_ID,Instruc_op_EX, Instruc_op_RR,PC_New_ID, PC_New_EX: std_logic_vector(15 downto 0 );   
    signal JAL_Haz, JRI_Haz, JLR_Haz, BEQ_Haz, BLT_Haz, BLE_Haz, Load_Imm,H_R0:  std_logic;
        

 
    --Flushing Signals 
	 signal Flush_IFID,Flush_IDRR,Flush_RREX,Flush_EXMEM,Reset_IFID,Reset_IDRR,Reset_RREX,Reset_EXMEM : std_logic;
    --Signals with Haz and Branch Controller
    signal PC_New,PC_next: std_logic_vector(15 downto 0);
    signal LMSM_Haz,H_jal,H_jlr,H_bex,PC_WR,Ram_wr, RegF_wr,CF_WR,ZF_WR, Can_ID,Can_rr:std_logic;
    signal Fwd_Mux_selA,Fwd_Mux_selB:std_logic_vector(1 downto 0);

    
begin
------------------IF component----------------------------
	 PC : Register_16bit port map( Input => PC_next , WRite_Enable => PC_WR , Reset => Reset ,clk => clock, Output => PC_new); 
    MyROM: ROM port map( Mem_Add => PC_New , Mem_Data_Out=>Instruc);
    IF_add: adder port map(PC_new,"0000000000000010",PC_IF);
-------------- IF_ID Pipeline Register--------------------
    IF_ID_Pipepline_Reg : IF_ID port map(
        Instruc_in=>Instruc,
        PC_in=>PC_new,
		  R0_WR_in=>PC_WR,
        clk=>clock,
		  Reset=>Reset_IFID,
        WR_EN=>WREN_IFID,
        Instruc_op=>Instruc_ID,
        PC_op=>PC_1,
		  R0_WR_out=>R0_WR_ID
    );
	 Reset_IFID <= Reset or Flush_IFID;
--------------------Instruc Decode-----------------------------------------------------
    instruc_decode:instr_decode port map(
        Instruction=>Instruc_ID,
		  Reset => Reset,
        PC_in=>PC_1,
        RS1=>RS1_ID,
        RS2=>RS2_ID,
        RD =>RD_ID ,
        ALU_sel=>ALU_sel_ID ,
        D3_MUX=> D3_MUX_ID,
		  CZ=> CZ_ID,
        Imm => Imm_ID,
        RF_wr=>RF_wr_ID,
		  C_modified=>C_modified_ID,
		  Z_modified=>Z_modified_ID ,
        Mem_wr=>Mem_wr_ID,
		  Carry_sel=>Carry_sel_ID,
		  CPL=>CPL_ID,
		  WB_MUX=>WB_MUX_ID,
		  ALUA_MUX=>ALUA_MUX_ID,
		  ALUB_MUX=>ALUB_MUX_ID,
        OP=>OP_ID,
        PC_ID=> PC_ID,
        LM_SM_hazard=>LMSM_Haz,
        clk=>clock
    );
---------------------ID_RR_pipeline----------------------------------------------------
	ID_RR_pipeline : IDRR port map
	(
		 clk => clock,
		 WR_EN=> WREN_IDRR,
		 Reset=>Reset_IDRR,
		 OP_in=>OP_ID,
		 RS1_in=>RS1_ID,
		 RS2_in=>RS2_ID,
		 RD_in=>RD_ID,
		 RF_wr_in=>RF_wr_ID,
		 ALU_sel_in => ALU_sel_ID,
		 Carry_sel_in =>Carry_sel_ID,
		 C_modified_in =>C_modified_ID,
		 Z_modified_in =>Z_modified_ID,
		 Mem_wr_in=>Mem_wr_ID,
		 Imm_in=>Imm_ID,
		 PC_in=>PC_1,
		 D3_MUX_in=>D3_MUX_ID,
		 CPL_in=>CPL_ID,
		 R0_WR_in=>R0_WR_ID,
		 WB_MUX_in=>WB_MUX_ID,
		 ALUA_MUX_in=>ALUA_MUX_ID,
		 ALUB_MUX_in=>ALUB_MUX_ID,
		 CZ_in=>CZ_ID,
		 OP_out => OP_RR,
		 RS1_out=>RS1_RR,
		 RS2_out=>RS2_RR,
		 RD_out=>RD_RR,
		 RF_wr_out=>RF_wr_RR,
		 ALU_sel_out=>ALU_sel_RR,
		 Carry_sel_out=>Carry_sel_RR,
		 C_modified_out=>C_modified_RR,
		 Z_modified_out=> Z_modified_RR,
		 Mem_wr_out=>Mem_wr_RR,
		 Imm_out=>Imm_RR,
		 PC_out =>PC_RR1,
		 D3_MUX_out=>D3_MUX_RR,
		 CPL_out=>CPL_RR,
		 R0_WR_out=>R0_WR_RR,
		 WB_MUX_out=>WB_MUX_RR,
		 ALUA_MUX_out=>ALUA_MUX_RR,
		 ALUB_MUX_out=>ALUB_MUX_RR,
		 CZ_out=>CZ_RR
	);
	Reset_IDRR <= Reset or Flush_IDRR;
	---------------RR-----------------------------------------------------------------------------------
	RF : Register_file port map(
		A1=>RS1_RR,
		A2=>RS2_RR,
		A3=>RD_WB,
	   D3=>rf_d3,
  	   RF_PC_in=> PC_WB,
		clock=>clock,
		Write_Enable =>RF_wr_WB,
		PC_WR=> R0_WR_WB,
		Reg_sel => Reg_sel,
		Reg_data => output_Reg,
		D1=>rf_d1_RR1 , D2=>rf_d2_RR1);
		
	Imm2 <= Imm_RR + Imm_RR;
	MUXRF_D1_sel <= RS1_RR(2) or RS1_RR(1) or RS1_RR(0);
	MUXRF_D2_sel <= RS2_RR(2) or RS2_RR(1) or RS2_RR(0);
	MuxRF_D1 : Mux16_2x1 port map(PC_RR1,rf_d1_RR1,MUXRF_D1_sel,rf_d1_RR2);
	MuxRF_D2 : Mux16_2x1 port map(PC_RR1,rf_d2_RR1,MUXRF_D2_sel,rf_d2_RR2);
	MuxA1: Mux16_4x1 port map(rf_d1_RR2,Alu1C_fw,Data_out_MEM,rf_d3,Fwd_Mux_selA,rf_d1_RR3);
	MuxB1: Mux16_4x1 port map(rf_d2_RR2,Alu1C_fw,Data_out_MEM,rf_d3,Fwd_Mux_selB,rf_d2_RR3);
	Adder_RR : adder port map(Imm2,rf_d1_RR1,PC_RR2);
	--------------RR_EX pipeline------------------------------------------------------------------------
	RR_EX_pipeline : RREX port map(
		 clk => clock,
		 WR_EN => WREN_RREX,
		 Reset=>Reset_RREX,
		 OP_in=>OP_RR,
		 RD_in=>RD_RR,
		 RF_D1_in => rf_d1_RR3,
		 RF_D2_in => rf_d2_RR3,
		 RF_wr_in=>RF_wr_RR,
		 ALU_sel_in => ALU_sel_RR,
		 Carry_sel_in =>Carry_sel_RR,
		 C_modified_in =>C_modified_RR,
		 Z_modified_in =>Z_modified_RR,
		 Mem_wr_in=>Mem_wr_RR,
		 Imm_in=>Imm_RR,
		 PC_in=>PC_RR1,
		 D3_MUX_in=>D3_MUX_RR,
		 CPL_in=>CPL_RR,
		 R0_WR_in=>R0_WR_RR,
		 WB_MUX_in=>WB_MUX_RR,
		 ALUA_MUX_in=>ALUA_MUX_RR,ALUB_MUX_in=>ALUB_MUX_RR,
		 CZ_in=>CZ_RR,
		 OP_out => OP_EX,
		 RD_out=>RD_EX,
		 RF_D1_out => rf_d1_EX,
		 RF_D2_out => rf_d2_EX,
		 RF_wr_out=>RF_wr_EX1,
		 ALU_sel_out=>ALU_sel_EX,
		 Carry_sel_out=>Carry_sel_EX,
		 C_modified_out=>C_modified_EX,
		 Z_modified_out=> Z_modified_EX,
		 Mem_wr_out=>Mem_wr_EX,
		 Imm_out=>Imm_EX,
		 PC_out =>PC_EX,
		 D3_MUX_out=>D3_MUX_EX,
		 CPL_out=>CPL_EX,
		 R0_WR_out=>R0_WR_EX,
		 WB_MUX_out=>WB_MUX_EX,
		 ALUA_MUX_out=>ALUA_MUX_EX,ALUB_MUX_out=>ALUB_MUX_EX,
		 CZ_out=>CZ_EX
	);
	Reset_RREX <= Reset or Flush_RREX;
	---------------Execution---------------------
	Imm3 <= Imm_EX + Imm_EX;
	PCp2_EX<=PC_EX+"0000000000000010";
	EX_MUX : Mux16_4x1 port map(Alu1C_EX,Imm_EX,Alu3C_EX,PCp2_EX,D3_MUX_EX,Alu1C_fw);
	COMPL : complementor port map(CPL_EX,rf_d2_EX,rf_d2_CPL);
	MUX_ALUA : Mux16_2x1 port map(rf_d1_EX,rf_d2_CPL,ALUA_MUX_EX,ALUA);
	MUX_ALUB : Mux16_2x1 port map(rf_d2_CPL,Imm_EX,ALUB_MUX_EX,ALUB);
	ALU1_EX :ALU port map(ALU_sel_EX,ALUA,ALUB,Carry_sel_EX,CF_MEM,Alu1C_EX,carry,zero);
	ALU3_EX : adder port map(PC_EX,Imm3,ALU3C_EX);
	CF_EX : dff_en port map(clock,reset,CF_WR,carry,CF_MEM);
	ZF_EX : dff_en port map(clock,reset,ZF_WR,zero,ZF_MEM);
	MUX_C : Mux1_4x1 port map(C_modified_EX,CF_MEM,ZF_MEM,'0',CZ_EX,CF_WR);
	MUX_Z : Mux1_4x1 port map(Z_modified_EX,ZF_MEM,ZF_MEM,'0',CZ_EX,ZF_WR);
	MUX_RF_WR : Mux1_4x1 port map(RF_wr_EX1,ZF_MEM,CF_MEM,'1',CZ_EX,RF_wr_EX);
	-----------------EX_MEM pipeline----------
	EX_MEM_pipeline : EXMEM port map(
		 clk => clock,
		 WR_EN => WREN_EXMEM,
		 Reset=>Reset_EXMEM,
		 RD_in=>RD_EX,
		 RF_D1_in => rf_d1_EX,
		 RF_wr_in=>RF_wr_EX,
		 Mem_wr_in=>Mem_wr_EX,
		 PC_in=>PC_EX,
		 R0_WR_in=> R0_WR_EX,
		 WB_MUX_in=>WB_MUX_EX,
		 ALU1_C_in => Alu1C_fw,
		 RD_out=>RD_MEM,
		 RF_D1_out => rf_d1_MEM,
		 RF_wr_out=>RF_wr_MEM,
		 Mem_wr_out=>Mem_wr_MEM,
		 PC_out =>PC_MEM,
		 WB_MUX_out=>WB_MUX_MEM,
		 R0_WR_out=>R0_WR_MEM,
		 ALU1_C_out => Alu1C_MEM
	);
	Reset_EXMEM <= Reset or Flush_EXMEM;
	--------------MEM--------------------------
	RAM_MEM : RAM port map(Alu1C_MEM,rf_d1_MEM,clock,MEM_WR_MEM,Data_out);
	WB_MUX_MEM1 : Mux16_2x1 port map(Alu1C_MEM,Data_out,WB_MUX_MEM,Data_out_MEM);
	-----------MEM_WB pipeline-------------------------
	MEM_WB_pipeline : MEMWB port map(
		 clk => clock,
		 WR_EN => WREN_MEMWB,
		 Reset=>Reset,
		 RD_in=>RD_MEM,
		 CF_in=>CF_MEM,
		 ZF_in=>ZF_MEM,
		 RF_wr_in=>RF_wr_MEM,
		 Data_out_WB_in => Data_out_MEM,
		 PC_in=>PC_MEM,
		 R0_WR_in=> R0_WR_MEM,
		 RD_out=>RD_WB,
		 CF_out=>CF_WB,
		 ZF_out=>ZF_WB,
		 RF_wr_out=>RF_wr_WB,
		 Data_out_WB_out => rf_d3,
		 PC_out =>PC_WB,
		 R0_WR_out=>R0_WR_WB
	);

	-----------WB--------------
	Carry_Flag : Register_1bit port map(CF_WB,'1',Reset,clock,CF_out);
	Zero_Flag : Register_1bit port map(ZF_WB,'1',Reset,clock,ZF_out);
	--------------------branch predictor-----------
	--------------------------Forwarding Unit-------------------------------
	MovingFWD: Forwarding_Unit port map (
			  RegC_EX=> RD_EX,
			  RegC_Mem=> RD_MEM,
			  RegC_WB=> RD_WB,
			  RegA_RR=>  RS1_RR, 
			  RegB_RR=> RS2_RR,
			  RF_WR_EX=>RF_wr_EX,
			  RF_WR_Mem=>RF_wr_MEM,
			  RF_WR_WB=>RF_wr_WB,    
			  MuxA=>Fwd_Mux_selA,
			  MuxB=>Fwd_Mux_selB,
			  Opcode_Ex=>OP_EX
		 );
	----------------Hazard detection Units--------------------

	JLR: Haz_JLR port map (
			  Instruc_OPCode_RR=>OP_RR,
			  cancel=>R0_WR_RR,
			  H_JLR=>H_jlr
		 );

	Jal: Haz_JAL port map (
			  Instruc_OPCode_ID=>OP_ID,
			  cancel=>R0_WR_ID,
			  H_Jal=>H_jal
		);

	BEX: Haz_BEX port map (
			  Instruc_OPCode_EX=>OP_EX,
			  ZFlag=>zero,
			  CFlag=>carry,
			  cancel=>R0_WR_EX,
			  H_BEX=>H_bex
		 );
		 
	Load: Haz_load port map(
			  Instruc_OPCode_EX=>OP_EX,
		     Instruc_OPCode_RR=>OP_RR,
			  Ra_RR=>RS1_RR ,
			  Rb_RR=>RS2_RR,
			  Rc_Ex=>RD_EX,
			  cancel=>R0_WR_EX,
			  Load_Imm=>Load_Imm
	   );
		
	R0_Haz_ctrl: Haz_R0 port map (
			  Rd_Mem=>RD_MEM,
			  RF_WR_Mem=>RF_wr_MEM,
			  cancel=>R0_WR_MEM,
			  H_R0=>H_R0
		);
		
	PC_hazard_ctrl:  Haz_PC_controller port map (
			  PC_IF=>PC_IF ,
			  PC_ID => PC_ID ,
			  PC_RR=>PC_RR2 ,
			  PC_EX=>ALU3C_EX ,
			  PC_Mem=>Data_out_MEM  ,
			  H_JLR=>H_jlr,
			  H_JAL => H_jal,
			  H_BEX =>H_bex ,
			  LMSM_Haz=> LMSM_Haz,
			  H_Load_Imm=> Load_Imm,
			  H_R0=>H_R0,
			  PC_New=>PC_Next ,
			  PC_WR=>PC_WR ,
			  IF_ID_flush=>Flush_IFID ,
			  ID_RR_flush=>Flush_IDRR ,
			  RR_EX_flush=>Flush_RREX , 
			  EX_MEM_flush=>Flush_EXMEM,
			  IF_ID_WR=> WREN_IFID,
			  ID_RR_WR=>WREN_IDRR ,
			  RR_EX_WR=> WREN_RREX ,
			  EX_MEM_WR=> WREN_EXMEM , 
			  MEM_WB_WR =>WREN_MEMWB
	);
	end Struct;
		 