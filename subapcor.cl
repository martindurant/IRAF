procedure subapcor (image, psffile, pstfile, alsfile, radius)

string	image	{prompt="image to apcor"}
string	psffile	{prompt="psf image for substar"}
string	pstfile	{prompt="pst file for substar"}
string	alsfile	{prompt="als file for substar"}
real	radius	{prompt="aperture to correct to",min=1}
bool	continue {yes,prompt="Continue?",mode="q"}

begin
	string  im,psf,pst,als
	real	rad
	int	iter=1

	im = image
	psf = psffile
	pst = pstfile
	als = alsfile
	rad = radius

	del("subap*")
	substar(im,als,pst,psf,"subap",verbose=no,verify=no)
	display("subap",1)
	pdump(pst, "xcen,ycen,id", "yes", > "subaptemp")
	tvmark(1,"subaptemp")	
	copy(pst,"subapcoo")
	print("Running iteration #1")
	apcor("subap",pst,als,rad,25)
		{
		iter=iter+1
		print("Mark small stars within aperture of psf stars")
		print("with <space>, <q> to finish. You can delete")
		print("hopeless ones diectly from subapcoo")
		phot(im,"","subapmag","",inter=yes,calgorithm="none",datamin=INDEF,datamax=INDEF)
		prenumber("subapmag",idoffset=10000)
		pfmerge(als//",subapmag","subapals")
		allstar(im,"subapals",psf,"subapalsout","subaparj","subaptemp",verbose=no,verify=no, update=no)
		del("subap.fits")
		substar(im,"subapalsout","subapcoo",psf,"subap",verbose=no,verify=no)
		print("Running iteration #"//iter)
		apcor("subap","subapcoo","subapalsout",rad,25)
		display("subap",1)
		del("subaptemp")
		pdump("subapcoo", "xcen,ycen,id", "yes", > "subaptemp")
		tvmark(1,"subaptemp")
		}
	del("subap*")
end
