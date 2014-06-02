library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity BarramentoISA is
    -- Barramento ISA:
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
        P56: in STD_LOGIC;
        P57: in STD_LOGIC;
        IOCS16: out STD_LOGIC;
        IOCHRDY: out STD_LOGIC
    );
end BarramentoISA;

architecture MouseWii of BarramentoISA is
    signal BASE, ENX, CLOCK_CONT: std_logic;
    signal CONTX, CONTY: std_logic_vector(16 downto 0);
    signal REGX, REGY: std_logic_vector(7 downto 0);
begin
    IRQ5 <= P56;

    EN_DL <= not IOR and BASE;

    -- endereços:
    -- 0x300 (mousex)
    -- 0x301 (mousey)
    ENX <= (not A(0));
    BASE <= (not AEN) and ((not A(1)) and (not A(2)) and (not A(3)) and (not A(4)) and (not A(5)) and (not A(6)) and (not A(7)) and A(8) and A(9));
    CLOCK_CONT <= (BASE and not IOR) or (BASE and not IOW);

    -- pulso de leitura em borda de descida
    process (CLOCK_CONT)
    begin
        if (CLOCK_CONT'event and CLOCK_CONT = '0') then
            if (ENX = '1') then
                DOUTL <= REGX;
            else
                DOUTL <= REGY;
            end if;
        end if;
    end process;

    -- borda de subida do clock de 8MHZ
    process(CLK8M)
    begin
        if (CLK8M'event and CLK8M = '1')
        then
            if (P56 = '1') then CONTX <= CONTX + "00000000000000001"; else CONTX <= "00000000000000000"; end if;
            if (P57 = '1') then CONTY <= CONTY + "00000000000000001"; else CONTY <= "00000000000000000"; end if;
        end if;
    end process;

    -- borda de descida de X
    process (P56)
    begin
        if (P56'event and P56 = '0') then
            REGX <= CONTX (16 downto 9);
        end if;
    end process;

    -- borda de descida de Y
    process (P57)
    begin
        if (P57'event and P57 = '0') then
            REGY <= CONTY (16 downto 9);
        end if;
    end process;

end MouseWii;

-- vim: et sw=4 ts=4 sts=4
