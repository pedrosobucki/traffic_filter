-------------------------------------------
-- MODLO COMPARA DADO  -  MORAES 16/MAIO/23
-------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity compara_dado is 
  port (clock, reset, prog, habilita: in std_logic;
        dado, pattern: in std_logic_vector(7 downto 0);
        match: out std_logic;
      );
end compara_dado; 

architecture a1 of compara_dado is
    signal padrao: std_logic_vector(7 downto 0);
    signal igual: std_logic;
begin
    if reset = '1' then
        padrao <= others '0';
    elsif rising_edge(clock) then

        if habilita = '1' then

            if prog = '1' then
                padrao <= pattern;
            end if;
            
            igual <=  '1' when dado = padrao else
                      '0';

            match <= igual;
        else
            match <= '0';
        end if;

    end if;
end a1;