----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/29/2023 03:24:00 PM
-- Design Name: 
-- Module Name: fixed_to_float16 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
Library IEEE; 

use IEEE.std_logic_1164.all; 

use IEEE.numeric_std.all; 

use IEEE.STD_LOGIC_UNSIGNED.ALL; 

use IEEE.STD_LOGIC_ARITH.ALL; 

library STD;
use STD.textio;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fixed_to_float16 is
  port (
    clk : in std_logic;
    rstn : in std_logic;
    en : in std_logic;
    fixed_in : in std_logic_vector(15 downto 0);
    flout_out : out std_logic_vector(15 downto 0);
    done : out std_logic);
end fixed_to_float16;

architecture Behavioral of fixed_to_float16 is
  signal referance : std_logic_vector(14 downto 0) := "000010000000000";
  signal exp_left_shift_counter : std_logic_vector(4 downto 0) := (others => '0');
  signal exp_right_shift_counter : std_logic_vector(4 downto 0) := (others => '0');
  signal shifted_value : std_logic_vector(15 downto 0) := (others => '0');
  type floating_state is (idle, shifting_state, exp_state);
  signal state : floating_state := idle;

begin
  process (clk) begin
    if clk'event and clk = '1' then
      if rstn = '1' then
        case state is
          when idle =>
            if en = '1' then
              shifted_value <= fixed_in;
              state <= shifting_state;
            else
              state <= idle;
              referance <= "000010000000000";
              exp_left_shift_counter <= (others => '0');
              exp_right_shift_counter <= (others => '0');
              shifted_value <= (others => '0');
            end if;
          when shifting_state =>
            if (shifted_value(14 downto 0) = referance) then
              state <= exp_state;
            elsif (shifted_value(14 downto 0) > referance) then
              exp_right_shift_counter <= exp_right_shift_counter + '1';
              shifted_value(14 downto 0) <= '0' & shifted_value(14 downto 1);
            elsif (shifted_value(14 downto 0) < referance) then
              exp_left_shift_counter <= exp_left_shift_counter + '1';
              shifted_value(14 downto 0) <= shifted_value(14 downto 1) & '1';
            end if;
          when exp_state =>
            state <= idle;
            if (exp_left_shift_counter > 0) then
                flout_out(14 downto 10) <= 15 - std_logic_vector(exp_right_shift_counter(4 downto 0));
                flout_out(9 downto 0) <= shifted_value(9 downto 0);
                flout_out(15) <= shifted_value(15);
                done <= '1';
  
              else
                flout_out(14 downto 10) <= 15 + std_logic_vector(exp_right_shift_counter(4 downto 0));
                flout_out(9 downto 0) <= shifted_value(9 downto 0);
                flout_out(15) <= shifted_value(15);
                done <= '1';
              end if;
        end case;
      else
        state <= idle;
        referance <= "000010000000000";
        exp_left_shift_counter <= (others => '0');
        exp_right_shift_counter <= (others => '0');
        shifted_value <= (others => '0');
      end if;
    end if;
  end process;

end Behavioral;