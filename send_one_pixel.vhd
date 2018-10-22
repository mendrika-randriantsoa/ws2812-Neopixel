----------------------------------------------------------------------------------
-- WS2812
-- Create Date: 28.02.2018 15:56:45
-- Author : Mendrika RANDRIANTSOA
-- LICENSE MIT
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity send_one_pixel is
    generic (Bits_number : integer := 24);
    
    Port ( CLK : in STD_LOGIC;
           in_enable : in STD_LOGIC;
           in_ok_next : in STD_LOGIC;
           in_pixel : in STD_LOGIC_VECTOR (23 downto 0);
           out_enable : out STD_LOGIC;
           out_bit : out STD_LOGIC;
           out_done : out STD_LOGIC);
end send_one_pixel;

architecture Behavioral of send_one_pixel is

   type etat_tp is (Idle, Put_bit,Sending, Sended, Cleanup);
   signal etat : etat_tp := Idle;
   
   signal Bit_Index : integer range 0 to 23 := 23;  --  24bits for a pixel
   signal s_out_bit,s_out_enable,s_out_done : std_logic := '0';

begin
    process (CLK,in_enable,in_ok_next,in_pixel) begin
        
            if in_enable = '0' then
                    Bit_Index <= Bits_number -1;
                    s_out_done<='0';
                    s_out_bit <= '0';
                    s_out_enable <= '0';
		            etat <= Idle;
            else
            if rising_edge(CLK) then
            
            case etat is
                          
                when Idle =>
                	etat<= Put_bit;
			s_out_done <= '0';
                 
                when Put_bit =>  
                                                
                    s_out_bit <= in_pixel(Bit_Index);                        
                    etat <= Sending;

                when Sending =>
                
                    s_out_enable <= '1'; 
                    if in_ok_next = '1' then
                        s_out_enable <= '0';                
                        etat <= Sended;
                    else
                        etat <= Sending;
                    end if;
                    
                when Sended =>
 
                    if Bit_Index > 0 then
                         Bit_Index <= Bit_Index - 1;
                         s_out_enable <= '0';
                         etat <= Put_bit; 
                    else
                        s_out_enable <= '0'; 
                        etat <= Cleanup;
                    end if;  
 
                
                when Cleanup =>

                    Bit_Index <= Bits_number -1;
                    s_out_done <= '1';
                    etat <= Idle;
                            
                 when others =>
                    etat <= Idle;   
            end case;
            
            

        end if;
	    end if;
	    out_enable <= s_out_enable;
            out_bit <= s_out_bit;
            out_done <= s_out_done;

    end process;

end Behavioral;
