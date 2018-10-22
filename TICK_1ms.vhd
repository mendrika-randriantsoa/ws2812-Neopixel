----------------------------------------------------------------------------------
-- WS2812
-- Create Date: 16.01.2017 09:13:19
-- Author : Mendrika RANDRIANTSOA
-- LICENSE MIT
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;



entity TICK_1ms is
    Port ( enable :  in STD_LOGIC;
            CLK : in STD_LOGIC;
           TICKS : out STD_LOGIC);
end TICK_1ms;

architecture Behavioral of TICK_1ms is
    signal Q: STD_LOGIC_VECTOR(19 downto 0) := (OTHERS => '0');
begin

process(CLK,enable) begin
 -- pour avoir 1ms on divise l'horloge par 100000
     if enable = '0' then
        Q<=conv_std_logic_vector(0,20);
         else
        if rising_edge(clk) then
        if(Q<1000000) then
            Q<= Q+'1';
        else
        Q<=conv_std_logic_vector(0,20);
        end if;
       end if;
     end if;
end process;       
       TICKS <=  '1' when Q=1000000 else '0';
end Behavioral;
