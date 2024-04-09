library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_packer is
    port (
        clock_i : in std_logic;
        reset_i : in std_logic;
        count_out : out std_logic_vector(7 downto 0); -- Changed to std_logic_vector
        data_i : in std_logic_vector(31 downto 0);
        data_bit_count_i : in integer range 0 to 32;
        data_o : out std_logic_vector(31 downto 0);
        data_valid_o : out std_logic
    );
end data_packer;

architecture Behavioral of data_packer is
    signal internal_buffer : std_logic_vector(31 downto 0) := (others => '0');
    signal counter : integer := 0;  -- Variable to hold the sum of bits
    signal bit_p : integer := 0;
    signal flag : STD_ULOGIC := '0';
begin
    process(clock_i, reset_i)
    begin
        if reset_i = '1' then
            -- Reset state
            internal_buffer <= (others => '0');
            data_valid_o <= '0';
            counter <= 0;
        elsif rising_edge(clock_i) then
        		if counter < 32 then 
               	 	counter <= counter + data_bit_count_i;
                    flag <= '0';
                elsif counter >= 32 then 
                	counter <= 0;
                    flag <= '1';
                end if; 
                count_out <= std_logic_vector(to_unsigned(counter, count_out'length));
                if counter <= data_bit_count_i then 
                    internal_buffer(data_bit_count_i-1 downto 0) <= data_i(data_bit_count_i-1 downto 0);
                elsif counter > data_bit_count_i then
                    bit_p <= counter - data_bit_count_i;
                    for i in internal_buffer'range loop
                        if i >= bit_p and i < counter then
                            internal_buffer(i) <= data_i(i - bit_p);
                        end if;
                    end loop;
                end if;
                

                if counter = 0 and flag ='1' then
   					 data_valid_o <= '1';
    				 data_o <= internal_buffer;
				elsif counter < 32 and counter /= 0 then 
   					 data_valid_o <= '0';
   					 data_o <= (others => 'U');
				end if;

        end if;
    end process;
end Behavioral;
