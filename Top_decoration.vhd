----------------------------------------------------------------------------------
-- WS2812
-- Create Date: 06.03.2018 16:14:20
-- Author : Mendrika RANDRIANTSOA
-- LICENSE MIT
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_decoration is
    Port ( CLK : in STD_LOGIC;
           enable : in STD_LOGIC;
           S : out STD_LOGIC);
end Top_decoration;

architecture Behavioral of Top_decoration is

signal TICKS: STD_LOGIC;
signal enable_Ticks: STD_LOGIC;
signal pixel_done: STD_LOGIC;
signal pix_enable :  STD_LOGIC;
signal pixels :  STD_LOGIC_VECTOR (23 downto 0); 

begin

dec1 : entity work.decoration
port map(CLK =>CLK,in_enable=>enable,in_wait => TICKS,in_pixel_done=>pixel_done,out_enable=>pix_enable,out_pixels=>pixels,out_enable_ticks=>enable_Ticks );

pix :entity work.Top_one_pixel
port map(CLK =>CLK,in_enable=>pix_enable,in_pixels => pixels,out_signal=>S,out_done=>pixel_done );

count : entity work.TICK_1ms
port map(CLK =>CLK,enable=>enable_Ticks,TICKS => TICKS);

end Behavioral;
