library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_packer_tb is
end data_packer_tb;

architecture tb_arch of data_packer_tb is
    constant CLOCK_PERIOD : time := 10 ns; -- Clock period in nanoseconds
    signal clock_tb : std_logic := '0';
    signal reset_tb : std_logic := '0';
    signal count_out_tb : std_logic_vector(7 downto 0) := (others => '0'); -- Changed to std_logic_vector
    signal data_i_tb : std_logic_vector(31 downto 0) := (others => '0');
    signal data_bit_count_i_tb : integer range 0 to 32 := 0;
    signal data_o_tb : std_logic_vector(31 downto 0);
    signal data_valid_o_tb : std_logic;
begin
    -- Component instantiation
    dut: entity work.data_packer
        port map (
            clock_i => clock_tb,
            reset_i => reset_tb,
            count_out => count_out_tb,
            data_i => data_i_tb,
            data_bit_count_i => data_bit_count_i_tb,
            data_o => data_o_tb,
            data_valid_o => data_valid_o_tb
        );

    -- Clock process
    process
    begin
        while now < 1000 ns loop
            clock_tb <= not clock_tb;
            wait for CLOCK_PERIOD / 2;
            clock_tb <= not clock_tb;
            wait for CLOCK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    process
    begin
        -- Reset initialization
        reset_tb <= '1';
        wait for CLOCK_PERIOD * 1;
        reset_tb <= '0';

        -- Test patterns
        wait for CLOCK_PERIOD * 1;
        data_i_tb <= x"0000000d";
        data_bit_count_i_tb <= 4;
        wait for CLOCK_PERIOD * 1;
        data_i_tb <= x"00000002";
        data_bit_count_i_tb <= 4;
        wait for CLOCK_PERIOD * 1;
        data_i_tb <= x"000000cd";
        data_bit_count_i_tb <= 8;
        wait for CLOCK_PERIOD * 1;
        data_i_tb <= x"00001234";
        data_bit_count_i_tb <= 16;
        wait for CLOCK_PERIOD * 1;
        data_i_tb <= x"1234abcd";
        data_bit_count_i_tb <= 1;
        wait for CLOCK_PERIOD * 1;
        data_i_tb <= x"1234abcd";
        data_bit_count_i_tb <= 2;
        wait for CLOCK_PERIOD * 1;
        data_i_tb <= x"1234abcd";
        data_bit_count_i_tb <= 4;
        wait for CLOCK_PERIOD * 1;
        data_i_tb <= x"1234abcd";
        data_bit_count_i_tb <= 8;
        wait for CLOCK_PERIOD * 1;
        data_i_tb <= x"1234abcd";
        data_bit_count_i_tb <= 9;
        wait for CLOCK_PERIOD * 1;
        data_i_tb <= x"1234abcd";
        data_bit_count_i_tb <= 7;
        wait for CLOCK_PERIOD * 1;
        data_i_tb <= x"1234abcd";
        data_bit_count_i_tb <= 32;
        wait for CLOCK_PERIOD * 1;
        data_i_tb <= x"1234abcd";
        data_bit_count_i_tb <= 1;
        wait for CLOCK_PERIOD * 1;
        data_i_tb <= x"1234abcd";
        data_bit_count_i_tb <= 0;
        wait for CLOCK_PERIOD * 1;
        data_i_tb <= x"1234abcd";
        data_bit_count_i_tb <= 0;
        wait for CLOCK_PERIOD * 1;
        data_i_tb <= x"1234abcd";
        data_bit_count_i_tb <= 0;
        wait;

    end process;
    
    monitor_process : process
    begin
        wait until rising_edge(clock_tb);
        loop
            wait until rising_edge(clock_tb);
            report("Clock: " & clock_tb'IMAGE & ",  Counter: " & integer'image(to_integer(unsigned(count_out_tb)))  & ", Data_i: " & data_i_tb'IMAGE & ", Data_bit_count_i: " & integer'image(data_bit_count_i_tb) & ", Data_o: " & data_o_tb'IMAGE & ", Data_valid_o: " & data_valid_o_tb'IMAGE);
        end loop;
    end process;

end tb_arch;
