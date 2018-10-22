----------------------------------------------------------------------------------
-- WS2812
-- Create Date: 19.02.2018 21:12:20
-- Author : Mendrika RANDRIANTSOA
-- LICENSE MIT
----------------------------------------------------------------------------------
-- CLk : 100 Mhz -> 0.01 ?S

-- sent 1 bit -> 1.25 +-(600 nS) ?S
-- periode bit CLKS_PER_BIT  125

--periode T0H 0.4 ?S +- 150 nS
-- CLKS_PER_TOH -> 40 
--periode T1H 0.8 ?S +- 150 nS

--periode T0L 0.85 ?S +- 150 nS
-- CLKS_PER_TOL -> 85 
--periode T1L 0.45 ?S +- 150 nS


----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity send_one_bit is
    generic (
    CLKS_PER_BIT : integer := 62;  -- GENERIC 
    CLKS_PER_TOH : integer := 20;
    CLKS_PER_T1H : integer := 40
    );
    
    Port ( CLK : in STD_LOGIC;
           in_enable : in STD_LOGIC;
           in_bit : in STD_LOGIC;
           out_bit : out STD_LOGIC;
           out_done : out STD_LOGIC);
end send_one_bit;

architecture Behavioral of send_one_bit is

    type etats_tp is (s_Idle, s_Check, s_Bit1, s_Bit0, s_Wait, s_Cleanup);
    signal etat : etats_tp := s_Idle;
    
    signal s_clk_count : integer range 0 to CLKS_PER_BIT-1 := 0;
    signal s_done   : std_logic := '0';
    signal s_out_bit  : std_logic := '0';

begin
process (CLK,in_enable,in_bit) begin
	
   
        if in_enable = '0' then

             s_done <= '0';
             s_out_bit <= '0';
             s_clk_count <= 0;
	     etat <= s_Idle;
         else
     if rising_edge(CLK) then
	 
    case etat is
    	
        when s_Idle =>
		etat <= s_check;
             
        when s_Check =>
            if in_bit = '1' then
                etat <= s_Bit1;
            else
                etat <= s_Bit0;
            end if;
                         
        when s_Bit1 =>                  
            if s_clk_count < CLKS_PER_BIT-1 then
                 if s_clk_count < CLKS_PER_T1H then 
                     s_out_bit <= '1';                     
                     s_clk_count <= s_Clk_count + 1;
                     etat   <= s_Bit1;
                     else
                     s_out_bit <= '0';
                     s_clk_count <= s_clk_count + 1;
                     etat   <= s_Bit1;
                 end if;                
            else
                s_done <= '1';               
                etat <= s_Wait;
            end if;
            
        when s_Bit0 =>
            if s_clk_count < CLKS_PER_BIT-1 then
                if s_clk_count < CLKS_PER_TOH then 
                     s_out_bit <= '1';    
                     s_clk_count <= s_clk_count + 1;                 
                     etat   <= s_Bit0;
                else
                    s_out_bit <= '0';
                    s_clk_count <= s_clk_count + 1;
                    etat   <= s_Bit0;
                end if;                  
            else
                s_done <= '1';
                etat <= s_Wait;
            end if;
            
        when s_wait =>
            s_done <= '0';
            etat <= s_Cleanup;
        
        when s_Cleanup =>
            s_clk_Count <= 0;                       
            etat <= s_Idle;
            
        when others =>
            etat <= s_Idle;    
        end case;
          
   
   end if;
   end if;
out_done <= s_done;
   out_bit <= s_out_bit;
end process;

end Behavioral;
