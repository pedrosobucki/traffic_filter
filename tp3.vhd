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
  port (clock, reset, din, alarme_int: in std_logic;
        prog: in std_logic_vector (2 downto 0);
        padrao: in std_logic_vector (7 downto 0);
        dout, alarm: out std_logic;
        numero: out std_logic_vector (1 downto 0)
        );
end entity; 

--------------------------------------
-- Arquitetura
--------------------------------------
architecture tp3 of tp3 is
  type state is (IDLE, PAD1, PAD2, PAD3, PAD4, BUSCANDO, BLOQUEIO, ZERA);
  signal EA, PE: state;
  signal found: std_logic:='0';
  signal program, sel, match: std_logic_vector (3 downto 0);
  signal data: std_logic_vector(7 downto 0);
begin  

  -- Processo para troca de estados
  process(reset, clock)
  begin
    if reset = '1' then
      EA <= IDLE;
    elsif rising_edge(clock) then
      EA <= PE;
    end if;
  end process;

  -- Processo para definir o proximo estado
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

  -- 4 PORT MAPS PARA OS compara_dado  

  cd1: entity work.compara_dado
    port map (dado => data, pattern => padrao, prog => program(0), habilita => sel(0), match => match(0), clock => clock, reset => reset);

  cd2: entity work.compara_dado
    port map (dado => data, pattern => padrao, prog => program(1), habilita => sel(1), match => match(1), clock => clock, reset => reset);

  cd3: entity work.compara_dado
    port map (dado => data, pattern => padrao, prog => program(2), habilita => sel(2), match => match(2), clock => clock, reset => reset);
    
  cd4: entity work.compara_dado
    port map (dado => data, pattern => padrao, prog => program(3), habilita => sel(3), match => match(3), clock => clock, reset => reset);

  found <= '1' when match /= "0000";

  
  alarme_int <= found when EA = BUSCANDO or EA = BLOQUEIO else
                '0';

  program(0) <= '1' when EA = PAD1 else '0';
  program(1) <= '1' when EA = PAD2 else '0';
  program(2) <= '1' when EA = PAD3 else '0';
  program(3) <= '1' when EA = PAD4 else '0';
  
  --  registradores para ativar as comparações

  --  registrador para o alarme interno

  -- MAQUINA DE ESTADOS (FSM)

  -- SAIDAS
  alarme <= alarme_int;
  
  dout <= din when not alarme_int else
          '0';

  numero <= "11" when match(3) = '1' else
            "10" when match(2) = '1' else
            "01" when match(1) = '1' else
            "00";

end architecture;