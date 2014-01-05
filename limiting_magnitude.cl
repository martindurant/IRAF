procedure limiting_magnitude (image, psf, als, min_mag, max_mag, steps, coords)

string 	image	{prompt="Photometry image"}
string	psf	{prompt="DAOPHOT psf image"}
string	als	{prompt="DAOPHOT .als file"}
real	min_mag	{prompt="Brightest mag to try"}
real	max_mag	{prompt="Faintest mag to try"}
int	steps	{min=0, prompt="Number of magnitude intervals"}
string	coords	{prompt="X-Y coordinates for stars"}
struct	*coolist

begin
	int	i, n
	real	x, y, minmag, maxmag, mag, stepsize
	string	imfile, psffile, coofile, alsfile
	struct	line

	# Only runs within daophot package
	if (! defpac ("daophot")) {
		print("This task requires daophot package to be loaded")
		bye
		};
	if ( max_mag < min_mag) {
		print("Magnitude limits wrong way around?")
		bye
		};

	# Set variable
	i = 0
	n = steps
	imfile = image
	psffile = psf
	coofile = coords
	alsfile = als
	stepsize = (max_mag-min_mag)/n
	mag = min_mag
	coofile = coords
	del("lm*")
	print ("##Magout  StdDev  Stars", >"lm_out")

	# Outer loop: set magnitude for addstar, for photometry
	while ( i <= n ) {
		coolist = coofile
		
		#Read coordfile, and format output for addstar
		while ( fscan (coolist, line) != EOF) 
			print (line//" "//str(mag), >> "lm.coo")
		coolist = coofile
		print ("Mag = "//str(mag))

		#Add stars, making temporary files
		addstar(imfile, "lm.coo", psffile, "lm_temp.fits", mag, mag, 1, simple_=yes, verify=no, update=no, verbose=no)

		#Photometer temporary image
		phot("lm_temp.fits", coofile, "lm.mag", "", interactive=no, verify=no, calgorithm="none", verbose=no)

		prenumber("lm.mag", idoffset=50000)
		pfmerge(alsfile//",lm.mag", "lm.als", verbose=no)

		#allstar
		allstar("lm_temp", "lm.als", psffile, "lm_out.als", "lm.arj", "lm.sub", recenter=no, verify=no, update=no, verbose=no)
		pdump("lm_out.als", "MAG", "ID > 49999", > "lm.mags")
		average(< "lm.mags",>> "lm_out")
		average(< "lm.mags")

		mag = mag + stepsize
		i=i+1
		print (str(i)//" of "//str(n+1))

		#clean up
		del("lm_out.als,lm.arj,lm.sub.fits,lm.mags")
		del("lm.als,lm.mag,*.art,lm_temp.fits,lm.coo")
		}
	graph("lm_out")
end
