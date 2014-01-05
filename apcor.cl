procedure apcor (image, pst, als, radius, maglimit)

string 	image	{prompt="image to apcor"}
string	pst	{prompt="psf star (.pst) file"}
string	als	{prompt="als file"}
real	radius	{prompt="big aperture radius", min=1}
real	maglimit {prompt="magnitude faint limit"}
struct	*coolist
struct	*coolist2
struct	*coolist3

begin
	int	id = 0
	string	imfile
	string	pstfile
	string	alsfile
	real	rad
	real	maglim
	struct	line
	real	dummy = 0
	int	dummi = 0
	real	magap = 0
	real	magals = 0
	real	magdiff = 0

	maglim = maglimit
	alsfile = als
	pstfile = pst
	imfile = image
	rad = radius
	del("apcor*")
	pdump(pstfile,"xcen,ycen,id","mag < "//maglim, > "apcor.coo")
	phot(image,"apcor.coo","apcor.mag","",interactive=no,verify=no,verbose=no,apertur=rad)
	pdump("apcor.mag","mag","yes",> "apcor.mags")
	coolist="apcor.mags"
	coolist2="apcor.coo"
	while ( fscan(coolist,magap) != EOF ) {
		dummi = fscan(coolist2,dummy,dummy,id)
		del("apcor.temp")
		pdump(alsfile,"mag","id = "//id,> "apcor.temp")
		coolist3="apcor.temp"
		dummi = fscan(coolist3,magals)
		coolist3=""
		magdiff = magap - magals
		print(magdiff ,>> "apcor.out")
		}
	del("apertures")
	!grep -v "INDEF" apcor.out > apertures
	average(< "apcor.out")
	phist("apertures",nbins=20,z1=-1,z2=0.5)
	del("apcor*")
end
