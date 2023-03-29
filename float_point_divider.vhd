library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity bolme is
port(
        clk : in std_logic;
        basla : in std_logic;
        sayi1 : in std_logic_vector(15 downto 0) ;
        sayi2 : in std_logic_vector(15 downto 0);
        cikis : out std_logic_vector(15 downto 0);
        bitir : out std_logic
        );
end bolme;

architecture Behavioral of bolme is
begin
process(clk )
--7-> 5
--22->9
--23->10

variable s1, s2, ssonuc : std_logic;
variable e1, e2, esonuc : std_logic_vector(4 downto 0);
variable f1, f2, fsonuc : std_logic_vector(9 downto 0);
variable v1, v2, v_ara: std_logic_vector(10 downto 0);
variable v2_bak, sifir : std_logic_vector(10 downto 0):= (others => '0' );
variable i : integer := 10;

variable fark, kayma : integer;
variable v1_int, v2_int : integer;
variable sayac : integer := 0;

variable bolme_kont: std_logic_vector(2 downto 0) := "000";

begin
    if clk'event and clk = '1' then
       if basla = '0' then
            i := 10;
            bitir <= '0';   
            bolme_kont := "000";
        --  cikis <= sayi1; 
    elsif basla = '1' then
        
           case bolme_kont is
             when "000" =>
            
                s1 := sayi1(15);
                e1 := sayi1(14 downto 10);
                f1 := sayi1(9 downto 0);
                v1 := '1' & f1;

                s2 := sayi2(15);
                e2 := sayi2(14 downto 10);
                f2 := sayi2(9 downto 0);
                v2 := '1' & f2;

                v1_int := conv_integer(v1);
                
                bolme_kont := "001";
                
                i := 10;

            when "001" =>   

                    v2_int := conv_integer(v2);

                    if v1_int < v2_int then

                        v_ara(i) := '0';
                        i := i - 1;
                            
                    else
                        v_ara(i) := '1';
                        v1_int := v1_int - v2_int;
                        i := i-1;

                    end if;
                    v2 := '0' & v2(10 downto 1);

                    if i < 0 then
                        bolme_kont := "010";

    end if;
                    
             when "010" =>
                if v_ara(10) = '1' then
                    kayma := 0;
                    fsonuc := v_ara(9 downto 0);
                else
                    kayma := 1;
                    fsonuc(9 downto 1) := v_ara(8 downto 0);
                    fsonuc(0) := '0';
                    
                end if;
                bolme_kont := "011";
            
            when "011" =>
                esonuc := 31 + e1 - e2 - kayma;
                ssonuc := s1 xor s2;
                bolme_kont := "100";

            when "100" =>
            
                cikis <= ssonuc & esonuc & fsonuc;
                bolme_kont := "101";

            when "101" =>
                bitir <= '1';
                bolme_kont := "000";
            when others => null;    
            end case;

        end if;

    end if; 
end process;

end Behavioral;