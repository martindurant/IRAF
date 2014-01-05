procedure raxyrun (image, filein, fileout)

string	image	{prompt="Image with known transformation in WCS"}
string	filein	{prompt="Input RA-dec coordinates for stars"}
string	fileout	{prompt="Output X-Y file"}
struct	*inlist


begin
	string coofile=''
	struct line
	real ra=0
	real dec=0

	coofile = filein
	inlist = coofile
	del(fileout)
		#Read coordfile
		while ( fscan (inlist, ra, dec) != EOF)
			rd2xy(image, ra, dec, >> "raxytemp");
		inlist = "raxytemp"
		while ( fscan (inlist, line) != EOF)
			print(substr(line,5,12)//" "//substr(line,21,26), >> fileout);
	del("raxytemp")
end
