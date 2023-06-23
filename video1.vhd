library ieee;
use ieee.std_logic_1164.all;

entity video1 is
port(	clk50, BTN1		: in	std_logic;
		h_sync, v_sync	: out std_logic;
		r, g, b			: out std_logic_vector(3 downto 0)
		);
end entity video1;

architecture display of video1 is
	signal sync_clk : std_logic;
	
	-- Parameters for a 640x480 display
	constant hfp480p  : integer   := 16;
	constant hsp480p  : integer   := 96;
	constant hbp480p  : integer   := 48;
	constant hva480p  : integer   := 640;
	constant vfp480p  : integer   := 11;
	constant vsp480p  : integer   := 2;
	constant vbp480p  : integer   := 31;
	constant vva480p  : integer   := 480;
	
	signal h_pos, v_pos : integer range 0 to 2047;
begin
	sync_clk_map: work.my_clk(syn) port map(inclk0 => clk50, c0 => sync_clk);
	
	determine_rgb: process(h_pos, v_pos)
		variable h_pix, v_pix : integer range -200 to 2047 := 0;
		constant h_start1 : integer := 50;
		constant h_start2 : integer := 150;
		constant h_end1	: integer := 100;
		constant h_end2	: integer := 250;
		constant v_start1 : integer := 120;
		constant v_start2 : integer := 250;
		constant v_end1	: integer := 300;
		constant v_end2	: integer := 300;
	begin
		h_pix := h_pos - (hfp480p + hsp480p + hbp480p);
		v_pix := v_pos - (vfp480p + vsp480p + vbp480p);
		case BTN1 is
			when '0' =>
				if (h_pix >= h_start1 and h_pix <= h_end1 and v_pix >= v_start1 and v_pix <= v_end1) then
					r <= x"4";
					g <= x"A";
					b <= x"A";
				else
					r <= (others=>'0');
					g <= (others=>'0');
					b <= (others=>'0');
				end if;
			when others =>
				if (h_pix >= h_start2 and h_pix <= h_end2 and v_pix >= v_start2 and v_pix <= v_end2) then
					r <= x"4";
					g <= x"A";
					b <= x"A";
				else
					r <= (others=>'0');
					g <= (others=>'0');
					b <= (others=>'0');
				end if;
		end case;
	end process;
	
	display_things: process(sync_clk)
	begin
		if rising_edge(sync_clk) then
			if h_pos >= (hfp480p + hsp480p + hbp480p + hva480p) then
				h_pos <= 0;
				if v_pos >= (vfp480p + vsp480p + vbp480p + vva480p) then 
					v_pos <= 0;
				else
					v_pos <= v_pos + 1;
				end if;
			else
				h_pos <= h_pos + 1;
			end if;
		end if;
		
		if h_pos >= hfp480p and h_pos < (hfp480p + hsp480p) then
			h_sync <= '0';
		else
			h_sync <= '1';
		end if;
		
		if v_pos >= vfp480p and v_pos < (vfp480p + vsp480p) then
			v_sync <= '0';
		else
			v_sync <= '1';
		end if;
	end process;
end architecture display;