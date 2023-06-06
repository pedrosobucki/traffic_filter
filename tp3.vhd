--------------------------------------
-- TRABALHO TP3 - MORAES  16/MAIO/23
--------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

--------------------------------------
-- Entidade
--------------------------------------
entity tp3 is 
  port (clock, reset: in std_logic;
        prog: in std_logic_vector (2 downto 0)
        );
end entity; 

--------------------------------------
-- Arquitetura
--------------------------------------
architecture tp3 of tp3 is
  type state is (IDLE, PAD1, PAD2, PAD3, PAD4, BUSCANDO, BLOQUEIO, ZERA);
  signal EA, PE: state;
  signal found: std_logic:='0';
begin  

  begin case( EA, prog ) is
  
    when IDLE =>
      PE <= PAD1 when conv_integer(prog) = 1 else
            PAD2 when conv_integer(prog) = 2 else
            PAD3 when conv_integer(prog) = 3 else
            PAD4 when conv_integer(prog) = 4 else
            BUSCANDO when conv_integer(prog) = 5 else
            IDLE;
  
    when PAD1 =>
      PE <= PAD1 when conv_integer(prog) = 1 else
            PAD2 when conv_integer(prog) = 2 else
            PAD3 when conv_integer(prog) = 3 else
            PAD4 when conv_integer(prog) = 4 else
            BUSCANDO when conv_integer(prog) = 5 else
            IDLE;
  
    when PAD2 =>
      PE <= PAD1 when conv_integer(prog) = 1 else
            PAD2 when conv_integer(prog) = 2 else
            PAD3 when conv_integer(prog) = 3 else
            PAD4 when conv_integer(prog) = 4 else
            BUSCANDO when conv_integer(prog) = 5 else
            IDLE;
  
    when PAD3 =>
      PE <= PAD1 when conv_integer(prog) = 1 else
            PAD2 when conv_integer(prog) = 2 else
            PAD3 when conv_integer(prog) = 3 else
            PAD4 when conv_integer(prog) = 4 else
            BUSCANDO when conv_integer(prog) = 5 else
            IDLE;
  
    when PAD4 =>
      PE <= PAD1 when conv_integer(prog) = 1 else
            PAD2 when conv_integer(prog) = 2 else
            PAD3 when conv_integer(prog) = 3 else
            PAD4 when conv_integer(prog) = 4 else
            BUSCANDO when conv_integer(prog) = 5 else
            IDLE;

    when BUSCANDO =>
      if found = 1 then
        PE <= BLOQUEIO;
      else
        PE <= BUSCANDO;
      end if;

    when BLOQUEIO =>
        PE <= BUSCANDO when conv_integer(prog) = 6 else
              ZERA when conv_integer(prog) = 7 else
              BLOQUEIO;

    when ZERA => 
        PE <= IDLE;
  
    when others =>
        EA <= IDLE;

  end case ;

  -- REGISTRADOR DE DESLOCAMENTO QUE RECEBE O FLUXO DE ENTRADA

  -- 4 PORT MAPS PARA OS ompara_dado  

  found   <=  . . . 

  program(0) <= . . .
  program(1) <= . . .
  program(2) <= . . .
  program(3) <= . . .
  
  --  registradores para ativar as comparações

  --  registrador para o alarme interno

  -- MAQUINA DE ESTADOS (FSM)

  -- SAIDAS
  alarme <= . . . 
  dout   <= . . . 
  numero <=  . . . 

end architecture;