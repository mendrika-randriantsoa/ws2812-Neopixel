----------------------------------------------------------------------------------
-- WS2812
-- Create Date: 06.03.2018 13:50:55
-- Author : Mendrika RANDRIANTSOA
-- LICENSE MIT
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


entity decoration is
generic (
	PIX_NUMBER : integer := 72); -- generic
	
    Port ( CLK : in STD_LOGIC;
           in_enable : in STD_LOGIC;
           in_wait   : in STD_LOGIC;
           in_pixel_done : in STD_LOGIC;
           out_enable: out STD_LOGIC;
           out_enable_ticks : out STD_LOGIC;
           out_pixels : out STD_LOGIC_VECTOR (23 downto 0));
end decoration;

architecture Behavioral of decoration is

type etats_tp is (Idle,Green_up,Green_down, Red_up,Red_down,Blue_up,Blue_down);
signal etat : etats_tp := Idle;

type etats_tp2 is (Idle2,Set_pix,send,Sended,s_wait_all_pix,wait_counter);
signal etat2 : etats_tp2 := Idle2;

signal s_Green,s_Red: STD_LOGIC_VECTOR(7 downto 0) := (OTHERS => '0');
signal s_Blue : STD_LOGIC_VECTOR(7 downto 0) := conv_std_logic_vector(255,8);
signal s_out_pixels : STD_LOGIC_VECTOR(23 downto 0) := (OTHERS => '0');

 signal pix_count :  integer range 0 to PIX_NUMBER := 0;
signal s_out_enable,s_out_enable_ticks: STD_LOGIC := '0';

begin

process (CLK,in_enable,in_pixel_done) begin
        
    if in_enable = '0' then
            etat <= Idle;
            etat2 <= Idle2; 
            else
            if rising_edge(CLK) then
            
            
            case etat2 is
            
            when Idle2 =>
                etat2 <= Set_pix;
                s_out_enable_ticks <= '0'; 
                
            when Set_pix =>
              
                case etat is
                
                when Idle =>
                     etat <= Green_up;
                     
                when Green_up =>
                    if s_Green < conv_std_logic_vector(255,8) then
                         s_Green <= s_Green +1;
                         etat <= Green_up;
                         else
                         etat <=   Blue_down;
                    end if;

                 when Blue_down =>
                         if s_Blue > conv_std_logic_vector(0,8) then
                              s_Blue <= s_Blue - 1 ;
                              etat <= Blue_down;
                              else
                              etat <=   Red_up;
                         end if;
 
                 when Red_up =>
                         if s_Red < conv_std_logic_vector(255,8) then
                              s_Red <= s_Red + 1;
                              etat <= Red_up;
                              else
                              etat <= Green_down;                    
                          end if;
                                                                                   
                when Green_down => 
                    if s_Green > conv_std_logic_vector(0,8) then
                         s_Green <= s_Green - 1 ;
                         etat <= Green_down;
                         else
                         etat <=   Blue_up;
                    end if;
 
                when Blue_up =>
                         if s_Blue < conv_std_logic_vector(255,8) then
                             s_Blue <= s_Blue + 1 ;
                             etat <= Blue_up;
                             else
                             etat <= Red_down;                    
                         end if; 
                                  
                when Red_down =>
                   if s_Red > conv_std_logic_vector(0,8) then
                      s_Red <= s_Red - 1;
                      etat <= Red_down;
                      else
                      etat <= Green_up;                    
                    end if;                  

                when others =>
                etat <= Idle;
                
                end case;         
            s_out_pixels <=   s_Green & s_Red & s_Blue;
            etat2 <= send;
            
            when send => 
                s_out_enable <= '1';
                etat2 <= sended;
                
            
            when Sended =>
                    if in_pixel_done = '1' then                
                     etat2 <= s_wait_all_pix;
                     else
                     etat2 <= Sended;
                    end if;
                        
              when s_wait_all_pix =>
                            if pix_count< PIX_NUMBER-1 then
                            pix_count<= pix_count + 1;
                            etat2<= Sended;
                            else
                            s_out_enable <= '0';
                            pix_count<=0;
                            etat2 <= wait_counter;
                            s_out_enable_ticks <= '1'; 
                            end if;
            
            when wait_counter =>
                 if in_wait = '1' then                
                 etat2 <= Set_pix;
                 else
                 etat2 <= wait_counter;
                end if;
                
                                
            when others =>
                etat2 <= Idle2; 
            end case;           
                   
            end if;
    end if;
    out_enable_ticks<=s_out_enable_ticks;
    out_pixels <= s_out_pixels;
    out_enable<=s_out_enable;
end process;            
end Behavioral;
