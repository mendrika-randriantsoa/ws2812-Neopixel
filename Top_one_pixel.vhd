----------------------------------------------------------------------------------
-- WS2812
-- Create Date: 28.02.2018 17:33:27
-- Author : Mendrika RANDRIANTSOA
-- LICENSE MIT
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_one_pixel is
    Port ( CLK : in STD_LOGIC;
           in_enable : in STD_LOGIC;
           in_pixels : in STD_LOGIC_VECTOR (23 downto 0);
           out_signal : out STD_LOGIC;
           out_done : out STD_LOGIC);
end Top_one_pixel;

architecture Behavioral of Top_one_pixel is

    signal s_in_ok_next,s_out_enable,s_out_bit : STD_LOGIC;
    
begin

    pixel : entity work.send_one_pixel  
    port map( CLK => CLK, in_enable => in_enable, in_ok_next => s_in_ok_next, in_pixel => in_pixels, out_enable => s_out_enable, out_bit => s_out_bit, out_done =>out_done);
    
    driver_phy : entity work.send_one_bit
    port map( CLK => CLK, in_enable => s_out_enable, in_bit => s_out_bit, out_bit => out_signal, out_done => s_in_ok_next);

end Behavioral;
