library ieee;
use IEEE.STD_LOGIC_1164.ALL;


--- senha 354281

entity forca is
	port    (   G_CLOCK_50: in STD_LOGIC; --clock
	            KEY: in STD_LOGIC_VECTOR(0 downto 0); -- reset
			    SW: in STD_LOGIC_VECTOR(9 downto 0); -- switches de escolha
			    
			LEDG: out STD_LOGIC_VECTOR(2 downto 0); -- leds de vida
			HEX0: out STD_LOGIC_VECTOR(0 to 6); -- display hex do "ganhou / perdeu"
			HEX7,HEX6,HEX5,HEX4,HEX3,HEX2: out STD_LOGIC_VECTOR(0 to 6) -- display da senha"
		    );
end forca;


architecture fsm of forca is
	type state is (     l1t1, l1t2,l1t3,l1t4,l1t5,l1t6,
	                    l2t1,l2t2,l2t3,l2t4,l2t5,l2t6,
					    l3t1,l3t2,l3t3,l3t4,l3t5,l3t6, won, lost); -- 20 estados (6*3) + 2
					    
	type states_type is array(0 to 19) of state;
	signal states : states_type :=(     l1t1, l1t2,l1t3,l1t4,l1t5,l1t6,
	                            l2t1,l2t2,l2t3,l2t4,l2t5,l2t6,
					            l3t1,l3t2,l3t3,l3t4,l3t5,l3t6, won, lost);
	
	signal act_state,nx_state: state;
	
	signal act_load, nx_load: STD_LOGIC_VECTOR(9 downto 0);
	signal rst : std_logic;
	signal clk : std_logic;
	signal brightness, brightness1, brightness2 : std_logic;
	
	
begin
    rst <= KEY(0);
    clk <= G_CLOCK_50;
    
    states <= ( l1t1, l1t2,l1t3,l1t4,l1t5,l1t6,
	            l2t1,l2t2,l2t3,l2t4,l2t5,l2t6,
				l3t1,l3t2,l3t3,l3t4,l3t5,l3t6, won, lost);

    LEDG(2) <= brightness2;
    LEDG(1) <= brightness1;
    LEDG(0) <= brightness;
	
	process(clk,rst,nx_state,nx_load)
	begin
	
        if rst = '0' then
            act_state <= l1t1;
            act_load <= "0000000000";

        
		elsif rising_edge(clk) then 
			act_state <= nx_state;
            act_load <= nx_load;
        
		end if;
	end process;
	
	
    process (act_state,states,SW,act_load)
    begin
    
    --- declaracao dos latches
    brightness <= '0';
    brightness1 <= '0';
    brightness2 <= '0';
    HEX0 <= "1111111";
    HEX2 <= "1111110";
    HEX3 <= "1111110";
    HEX4 <= "1111110";
    HEX5 <= "1111110";
    HEX6 <= "1111110";
    HEX7 <= "1111110";
    nx_state <= act_state;
    nx_load <= act_load;
    
    --- tratamento das vidas
    if act_state = l1t1 or act_state = l1t2 or act_state = l1t3 or act_state = l1t4 or act_state = l1t5 or act_state = l1t6 then
        brightness <= '1';
        brightness1 <= '1';
        brightness2 <= '1';
    
    elsif act_state = l2t1 or act_state = l2t2 or act_state = l2t3 or act_state = l2t4 or act_state = l2t5 or act_state = l2t6 then
        brightness <= '1';
        brightness1 <= '1';
    
    elsif act_state = l3t1 or act_state = l3t2 or act_state = l3t3 or act_state = l3t4 or act_state = l3t5 or act_state = l3t6 then
        brightness <= '1';
    
    --- vitoria / perdeu
    elsif act_state = won then
        HEX0 <= "0100000";
        
    elsif act_state = lost then
        HEX0 <= "0011000";
    end if;
    
    
    --- tratamento dos estados
    
    if act_state /= won and act_state /= lost then
        for i in 0 to 17 loop
            if act_state = states(i) then
                

                ---- acertos
                
    			if SW(1) = '1' then --numero 1
    			    HEX2 <= "1001111";

                    if act_load(1) = '0' then
        			    if act_state = l1t6 or act_state = l2t6 or act_state = l3t6 then
        			        nx_state <= won;
        			    else 
        			        nx_state <= states(i+1);
        			    end if;
        				nx_load(1) <= '1';
        				
        			end if;
        		end if;
    				
    				
    			if SW(2) = '1' then --numero 2
    			    HEX4 <= "0010010";
    			    
    			    if act_load(2) = '0' then
        			    if act_state = l1t6 or act_state = l2t6 or act_state = l3t6 then
        			        nx_state <= won;
        			    else 
        			        nx_state <= states(i+1);
        			    end if;
        				nx_load(2) <= '1';
        			end if;
        		end if;
    				
    				
    			if SW(3) = '1' then --numero 3
    			    HEX7 <= "0000110";
    			    
    			    if act_load(3) = '0' then
        			    if act_state = l1t6 or act_state = l2t6 or act_state = l3t6 then
        			        nx_state <= won;
        			    else 
        			        nx_state <= states(i+1);
        			    end if;
        				nx_load(3) <= '1';
        			end if;
        		end if;
    				
    			if SW(4) = '1' then --numero 4
    			    HEX5 <= "1001100";
    			    
    			    if act_load(4) = '0' then
        			    if act_state = l1t6 or act_state = l2t6 or act_state = l3t6 then
        			        nx_state <= won;
        			    else 
        			        nx_state <= states(i+1);
        			    end if;
        				nx_load(4) <= '1';
        			end if;
        		end if;			
    				
    				
    			if SW(5) = '1' then --numero 5
    			    HEX6 <= "0100100";
    			    
    			    if act_load(5) = '0' then
        			    if act_state = l1t6 or act_state = l2t6 or act_state = l3t6 then
        			        nx_state <= won;
        			    else 
        			        nx_state <= states(i+1);
        			    end if;
        				nx_load(5) <= '1';
        			end if;
        		end if;			
    				
    			
    				
    			if SW(8) = '1' then --numero 8
    			    HEX3 <= "0000000";
    			    
    			    if act_load(8) = '0' then
        			    if act_state = l1t6 or act_state = l2t6 or act_state = l3t6 then
        			        nx_state <= won;
        			    else 
        			        nx_state <= states(i+1);
        			    end if;
        				nx_load(8) <= '1';
        			end if;
        		end if;		


                --- erros
                
    			if (SW(0) = '1' and act_load(0) = '0') then --numero 0
    			    if i > 11 then
    			        nx_state <= lost; --perdeu
    			    else
    			        nx_state <= states(i+6);
    			    end if;
    				nx_load(0) <= '1';

    			elsif (SW(6) = '1' and act_load(6) = '0') then --numero 6
    			    if i > 11 then
    			        nx_state <= lost; --perdeu
    			    else
    			        nx_state <= states(i+6);
    			    end if;
    				nx_load(6) <= '1';
    				
    			elsif (SW(7) = '1' and act_load(7) = '0') then --numero 7
    			    if i > 11 then
    			        nx_state <= lost; --perdeu
    			    else
    			        nx_state <= states(i+6);
    			    end if;
    				nx_load(7) <= '1';
    				
    			elsif (SW(9) = '1' and act_load(9) = '0') then --numero 9
    			    if i > 11 then
    			        nx_state <= lost; --perdeu
    			    else
    			        nx_state <= states(i+6);
    			    end if;
    				nx_load(9) <= '1';
    				
    				
    			end if;
            
            end if;
        
        end loop;
    
    end if;
    
    



        
    end process;
    
    
end fsm;