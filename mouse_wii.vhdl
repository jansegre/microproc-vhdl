library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity CXPRETA is
    port (
             CLK : in std_logic;
             EOC : in std_logic;
             BD : in std_logic_vector(7 downto 0); 
             CHAVES : in std_logic_vector(3 downto 0);
             CLKAD : out std_logic;
             ADR : out std_logic_vector(2 downto 0);
             OEAD : out std_logic;
             SOC : out std_logic;
             SEGMENTOS : out std_logic_vector(6 downto 0);
             LEDS : out std_logic_vector(3 downto 0);
             ANODOS : out std_logic_vector(3 downto 0)
         );
end CXPRETA;

architecture CXPRETA_arch of CXPRETA is

    signal aux: std_logic_vector(3 downto 0);
    signal aux2: std_logic_vector(15 downto 0);
    signal aux_ADR: std_logic_vector(2 downto 0);
    signal aux_BD: std_logic_vector(7 downto 0);
    signal aux3: std_logic_vector(7 downto 0);
    signal count: std_logic_vector(25 downto 0);
    signal CLK2 : std_logic;
    signal atual, prox: std_logic_vector(2 downto 0);



begin

    process(CLK)
    begin
        if (CLK'event and CLK = '1') then
            if (count = "11111111111111111111111111") 
            then count <= "00000000000000000000000000";
        else count <= count + "00000000000000000000000001";
        end if;
    end if;
end process;


ANODOS <= "1000" when count(17 downto 16) = "00" else
          "0100" when count(17 downto 16) = "01" else
          "0010" when count(17 downto 16) = "10" else
          "0001";


aux3 <= BD - "00111101" when atual = "101" else aux3;

aux_BD <= (aux3(5 downto 0) & "00") + ('0' & aux3(7 downto 1));


aux2(15 downto 12) <= "0000";
aux2(11 downto 8) <= aux_BD(7 downto 4) when aux_ADR = "000" else
aux2(11 downto 8);
aux2(7 downto 4) <= aux_BD(7 downto 4) when aux_ADR = "001" else
aux2(7 downto 4);
aux2(3 downto 0) <= aux_BD(7 downto 4) when aux_ADR = "010" else
aux2(3 downto 0);						 

aux <= aux2(15 downto 12) when count(17 downto 16) = "00" else
       aux2(11 downto 8) when count(17 downto 16) = "01" else
       aux2(7 downto 4) when count(17 downto 16) = "10" else
       aux2(3 downto 0);

SEGMENTOS <= "0000001" when aux = "0000" else --0
             "1001111" when aux = "0001" else --1
             "0010010" when aux = "0010" else --2
             "0000110" when aux = "0011" else --3
             "1001100" when aux = "0100" else --4
             "0100100" when aux = "0101" else --5
             "0100000" when aux = "0110" else --6
             "0001111" when aux = "0111" else --7
             "0000000" when aux = "1000" else --8
             "0000100" when aux = "1001" else --9
             "0001000" when aux = "1010" else --A
             "1100000" when aux = "1011" else --b
             "0110001" when aux = "1100" else --c
             "1000010" when aux = "1101" else --d
             "0110000" when aux = "1110" else --e
             "0111000"; --  f


CLK2 <= count(4);
CLKAD <= CLK2;

process(CLK2)
begin
    if (CLK2'event and CLK2 = '1') then
        atual <= prox;
    end if;
end process;

prox <= "001" when atual = "000" else
        "001" when (atual = "001" and EOC = '1') else
        "011" when (atual = "001" and EOC = '0') else
        "011" when (atual = "011" and EOC = '0') else
        "111" when (atual = "011" and EOC = '1') else
        "101" when atual = "111" else
        "100" when atual = "101" else
        "000";

aux_ADR <= aux_ADR + "001" when prox = "000" else
               --"000" when aux_ADR = "011" else 
           aux_ADR;	   


SOC <= '1' when atual = "000" else '0';

OEAD <= '1' when (atual = "111" or atual = "101") else '0';

ADR <= "000" when aux_ADR = "000" or aux_ADR = "011" or aux_ADR = "110" else
       "001" when aux_ADR = "001" or aux_ADR = "100" or aux_ADR = "111" else
       "010";

LEDS <= '0' & atual;

end CXPRETA_arch;

-- vim: et sw=4 ts=4 sts=4
