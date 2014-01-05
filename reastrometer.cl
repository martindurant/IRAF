procedure reastrometer (refimage, newimage, coords, chicut, magcut, fine)

string	refimage	{prompt="Image with WCS"}
string	newimage	{prompt="Image to astrometer"}
string	coords		{prompt=".mag or .als for refimage"}
real	chicut 		{1, prompt="CHI cut",min=0}
real	magcut		{prompt="MAG cut"}
int	fine		{prompt="1 for fine, 0 for simple",min=0,max=1}
struct	*file1
struct	*file2
struct	*file3

begin
	struct	line1
	struct	line2
	int dummy
	string x,y,mag

	del("asttemp.*")

		# Pick some stars for quick atrometry
	display(newimage,2)
	display(refimage,1)
	print("Pick some stars with <space>, then press <q> to continue")
	phot(refimage, "", "asttemp.mag.1", "", interactive=yes, calgorithm='gauss')
	pdump("asttemp.mag.1", "xcen,ycen", "yes", > "asttemp.coo.1")
	xyrarun(refimage, "asttemp.coo.1" , "asttemp.coo.1.radec")	# put into RA/dec

	pdump("asttemp.mag.1", "xcen,ycen,id", "yes", > "asttemp.ids")
	tvmark(1,"asttemp.ids")					# Mark the stars that were
								# selected numbered in order
	print("Find the same stars with <space>, in the same order")
	phot(newimage, "", "asttemp.mag.2", "", interactive=yes, calgorithm='gauss') # Easiest with images tiled

	pdump("asttemp.mag.2", "xcen,ycen", "yes", > "asttemp.coo.2")

		# Find quick solution
	file1 = "asttemp.coo.1.radec"
	file2 = "asttemp.coo.2"
	while (fscan (file1, line1) != EOF) {
			dummy = fscan (file2, line2)
			print (line2//" "//line1, >> "asttemp.coo")
			};
	ccmap("asttemp.coo","asttemp.database",lngunits="hours",images=newimage, interac=yes, update=yes)

		# Get better solution
	if (fine > 0) {
	pdump(coords,"xcen,ycen","CHI < "//chicut//" &&  MAG < "//magcut, > "asttemp.coords")
	xyrarun(refimage ,"asttemp.coords", "asttemp.coords.radec")
	raxyconv(newimage, "asttemp.coords.radec", "asttemp.coords.xy")
	phot(newimage, "asttemp.coords.xy", "asttemp.mag.new", "", calgorithm=centroid,interactive=no,verify=no, verbose=no)
	pdump("asttemp.mag.new", "xcen,ycen,mag", "yes", > "asttemp.coords.xy.1")

	file1 = "asttemp.coords.radec"
	file2 = "asttemp.coords.xy.1"
	while (fscan (file1, line1) != EOF) {
			dummy = fscan (file2, x,y,mag)
			if (mag != "INDEF") {
				print (line1//" "//x//" "//y, >> "asttemp.coo.new")};
			};
	ccmap("asttemp.coo.better","asttemp.database",lngunits = "hours",images=newimage, interac=yes)
	del("asttemp*")};
end
