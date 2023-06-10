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
  port (clock, reset, din: in std_logic;
        prog: in std_logic_vector (2 downto 0);
        padrao: in std_logic_vector (7 downto 0) := "00000000";
        dout, alarme: out std_logic;
        numero: out std_logic_vector (1 downto 0)
        );
end entity; 

--------------------------------------
-- Arquitetura
--------------------------------------
architecture tp3 of tp3 is
  type state is (IDLE, PAD1, PAD2, PAD3, PAD4, BUSCANDO, BLOQUEIO, ZERA);
  signal EA, PE: state;
  signal found, alarme_int: std_logic:='0';
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
  process ( EA, prog )
  begin
      case EA is
      
        when IDLE =>
            if conv_integer(prog) = 1 then
              PE <= PAD1;
            elsif conv_integer(prog) = 2 then
              PE <= PAD2;
            elsif conv_integer(prog) = 3 then
              PE <= PAD3;
            elsif conv_integer(prog) = 4 then
              PE <= PAD4;
            elsif conv_integer(prog) = 5 then
              PE <= BUSCANDO;
            else
              PE <= IDLE;
            end if;
      
        when PAD1 =>
            if conv_integer(prog) = 1 then
              PE <= PAD1;
            elsif conv_integer(prog) = 2 then
              PE <= PAD2;
            elsif conv_integer(prog) = 3 then
              PE <= PAD3;
            elsif conv_integer(prog) = 4 then
              PE <= PAD4;
            elsif conv_integer(prog) = 5 then
              PE <= BUSCANDO;
            else
              PE <= IDLE;
            end if;
      
        when PAD2 =>
            if conv_integer(prog) = 1 then
              PE <= PAD1;
            elsif conv_integer(prog) = 2 then
              PE <= PAD2;
            elsif conv_integer(prog) = 3 then
              PE <= PAD3;
            elsif conv_integer(prog) = 4 then
              PE <= PAD4;
            elsif conv_integer(prog) = 5 then
              PE <= BUSCANDO;
            else
              PE <= IDLE;
            end if;
      
        when PAD3 =>
            if conv_integer(prog) = 1 then
              PE <= PAD1;
            elsif conv_integer(prog) = 2 then
              PE <= PAD2;
            elsif conv_integer(prog) = 3 then
              PE <= PAD3;
            elsif conv_integer(prog) = 4 then
              PE <= PAD4;
            elsif conv_integer(prog) = 5 then
              PE <= BUSCANDO;
            else
              PE <= IDLE;
            end if;
      
        when PAD4 =>
            if conv_integer(prog) = 1 then
              PE <= PAD1;
            elsif conv_integer(prog) = 2 then
              PE <= PAD2;
            elsif conv_integer(prog) = 3 then
              PE <= PAD3;
            elsif conv_integer(prog) = 4 then
              PE <= PAD4;
            elsif conv_integer(prog) = 5 then
              PE <= BUSCANDO;
            else
              PE <= IDLE;
            end if;

        when BUSCANDO =>
            if found = '1' then 
              PE <= BLOQUEIO;
            else
              PE <= BUSCANDO;
            end if;

        when BLOQUEIO =>
            if conv_integer(prog) = 6 then
              PE <= BUSCANDO;
            elsif conv_integer(prog) = 7 then
              PE <= ZERA;
            else
              PE <= BLOQUEIO;
            end if;

        when ZERA => 
            PE <= IDLE;
      
        when others =>
            PE <= IDLE;

      end case ;
  end process;

  process(clock, reset)
  begin
    if reset = '1' then
      data <= "00000000";
    elsif rising_edge(clock) then
      if EA = ZERA then
        data <= "00000000";
      elsif EA /= BLOQUEIO then
        data(7) <= din;
        data(6) <= data(7);
        data(5) <= data(6);
        data(4) <= data(5);
        data(3) <= data(4);
        data(2) <= data(3);
        data(1) <= data(2);
        data(0) <= data(1);
      end if;
    end if;
  end process;

  -- REGISTRADOR DE DESLOCAMENTO QUE RECEBE O FLUXO DE ENTRADA

  -- 4 PORT MAPS PARA OS compara_dado  

  CD0: entity work.compara_dado
    port map (dado => data, pattern => padrao, prog => program(0), habilita => sel(0), match => match(0), clock => clock, reset => reset);

  CD1: entity work.compara_dado
    port map (dado => data, pattern => padrao, prog => program(1), habilita => sel(1), match => match(1), clock => clock, reset => reset);

  CD2: entity work.compara_dado
    port map (dado => data, pattern => padrao, prog => program(2), habilita => sel(2), match => match(2), clock => clock, reset => reset);
    
  CD3: entity work.compara_dado
    port map (dado => data, pattern => padrao, prog => program(3), habilita => sel(3), match => match(3), clock => clock, reset => reset);

  process (clock, reset)
  begin
    if reset = '1' then
      found <= '0';
    elsif rising_edge(clock) then
      if match /= "0000" then
        found <= '1';
      end if;
    end if;
  end process;

  --found <= '1' when match /= "0000" else '0';

  program(0) <= '1' when EA = PAD1 else '0';
  program(1) <= '1' when EA = PAD2 else '0';
  program(2) <= '1' when EA = PAD3 else '0';
  program(3) <= '1' when EA = PAD4 else '0';

  process(clock, reset)
  begin
    if reset = '1' then
      sel <= "0000";
    elsif rising_edge(clock) then
      if EA = ZERA then
        sel <= "0000";
      elsif EA = PAD1 then
        sel(0) <= '1';
      elsif EA = PAD2 then
        sel(1) <= '1';
      elsif EA = PAD3 then
        sel(2) <= '1';
      elsif EA = PAD4 then
        sel(3) <= '1';
      end if;
    end if;
  end process;

  --alarme_int <= found when EA = BUSCANDO or EA = BLOQUEIO else '0';

  process(clock, reset)
  begin
    if reset = '1' then
      alarme_int <= '0';
    elsif rising_edge(clock) then
      if EA = BUSCANDO then
        alarme_int <= found;
      elsif EA = BLOQUEIO then
        alarme_int <= '1';
      elsif EA = ZERA then
        alarme_int <= '0';
      end if;
    end if;
  end process;
  
  --  registradores para ativar as comparações

  --  registrador para o alarme interno

  -- MAQUINA DE ESTADOS (FSM)

  -- SAIDAS
  alarme <= alarme_int;
  
  dout <= din when not alarme_int = '1' else '0';

  --process(clock, reset)
  --begin
  --  if reset = '1' then
  --    alarme_int <= '0';
  --  elsif rising_edge(clock) then
  --    if match(3) = '1' then
  --      numero <= 3;
  --    elsif match(2) = '1' then
  --      numero <= 2;
  --    elsif match(1) = '1' then
  --        numero <= 1;
  --    else
  --        numero <= 0;
  --    end if;
  --  end if;
  --end process;

  numero <= "11" when match(3) = '1' else
            "10" when match(2) = '1' else
            "01" when match(1) = '1' else
            "00" when match(0) = '1';

end architecture;