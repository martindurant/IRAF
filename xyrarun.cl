procedure xyrarun (image, filein, fileout)

string	image	{prompt="Image with known transformation in WCS"}
string	filein	{prompt="Input X-Y coordinates for stars"}
string	fileout	{prompt="Output RA-dec file"}
struct	*inlist


begin
	real x=0
	real y=0
	string coofile
	struct line
	coofile = filein
	inlist = coofile
	del(fileout)
		#Read coordfile
		while ( fscan (inlist, x, y) != EOF) 
			xy2rd(image, x, y, hms=yes, >> 'xyratemp');
		inlist = 'xyratemp'
		while ( fscan (inlist, line) != EOF)
			print (substr(line,6,17)//" "//substr(line,26,38), >> fileout);
	del('xyratemp')
end

