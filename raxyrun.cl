procedure raxyrun (image, filein, fileout)

string	image	{prompt="Image with known transformation in WCS"}
string	filein	{prompt="Input RA-dec coordinates for stars"}
string	fileout	{prompt="Output X-Y file"}
struct	*inlist


begin
	string coofile=''
	coofile = filein
	inlist = coofile
	struct line

	del(fileout)
		#Read coordfile
		while ( fscan (inlist, ra, dec) != EOF)
			rd2xy(image, ra, dec, >> "raxytemp");
		inlist = "raxytemp"
		while ( fscan (inlist, line) != EOF)
			print(line, >> fileout);
	del("raxytemp")
end
