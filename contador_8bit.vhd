library ieee;
use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;

entity Contador8 is
    port (
        DINL: in STD_LOGIC_VECTOR (7 downto 0);
        DINH: in STD_LOGIC_VECTOR (15 downto 8);
        DOUTL: out STD_LOGIC_VECTOR (7 downto 0);
        DOUTH: out STD_LOGIC_VECTOR (15 downto 8);
        A: in STD_LOGIC_VECTOR (9 downto 0);
        BHE: in STD_LOGIC;
        IOW: in STD_LOGIC;
        IOR: in STD_LOGIC;
        EN_DL: out STD_LOGIC;
        EN_DH: out STD_LOGIC;
        CLK8M: in STD_LOGIC;
        CH: in STD_LOGIC_VECTOR (3 downto 0);
        AEN: in STD_LOGIC;
        IRQ5: out STD_LOGIC;
        CLK_AD: out STD_LOGIC;
        OE_AD: out STD_LOGIC;
        EOC_AD: in STD_LOGIC;
        SOC_AD: out STD_LOGIC;
        ADR_AD: out STD_LOGIC_VECTOR (2 downto 0);
        CLK_DA: out STD_LOGIC;
        P51: out STD_LOGIC;
        P56: out STD_LOGIC;
        P57: out STD_LOGIC;
        IOCS16: out STD_LOGIC;
        IOCHRDY: out STD_LOGIC
    );
end Contador8;


architecture comportamento of Contador8 is
    --signal BASE, EN_BUF: std_logic;
    signal UP, LOAD, CLR, EN: std_logic;
    signal Q: std_logic_vector (7 downto 0);
begin
  -- XXX: Não apagar apartir daqui.
  OE_AD <= '0';
  IOCHRDY <= '1';
  CLK_DA <= '0';
  ADR_AD <= "000";
  SOC_AD <= '0';
  CLK_AD <= '0';
  IRQ5 <= '0';
  P57 <= '0';
  -- XXX: pode apagar abaixo.
  EN_DL <= '1';

  -- endereços:
  -- 0x300 (up)
  -- 0x301 (down)
  -- 0x302 (load)
  -- 0x304 (clear)
  UP <= (not A(0));
  LOAD <= A(1);
  CLR <= A(2);
  EN <= (not A(3)) and (not A(4)) and (not A(5)) and (not A(6)) and (not A(7)) and A(8) and A(9);

  process (CLK8M)
  begin
      if (CLK8M'event and CLK8M = '1' and EN = '1') then
          if (LOAD = '0') then Q <= DINL;
          elsif (CLR = '0') then Q <= "00000000";
          elsif (UP = '1') then Q <= Q + "00000001";
          elsif (UP = '0') then Q <= Q - "00000001";
          end if;
      end if;
  end process;

  DOUTL <= Q;
  EN_DL <= '0';

  -- o seguinte serviria para castacear contadores
  --RCO_UP <= Q(3) and Q(2) and Q(1) and Q(0) and UP;
  --RCO_DOWN <= (not Q(3)) and (not Q(2)) and (not Q(1)) and (not Q(0)) and (not UP);
  --RCO <= RCO_UP nor RCO_DOWN;

  --EN_DH <= '0';
  --EN_DL <= '0';
end comportamento;

-- vim: et sw=4 ts=4 sts=4
