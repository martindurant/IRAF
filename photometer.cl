procedure photometer (image)

string 	image	{prompt="Photometry image"}
int	order	{prompt="psf order",min=-1,mode="q"}
bool	continue {yes, prompt="Continue?", mode="q"}

begin
	int	iteration=0
	int 	dummy=0

	# set image data parameters and save in image.pars before running
	setimpars(image,yes,no)
	del("photo*,temp")

	daofind(image,"photo.coo",verify=no,update=no,verbose=no)
	phot(image,"photo.coo","photo.mag","",verify=no,update=no,verbose=no)
	display(image,1)
	pdump("photo.mag","xcen,ycen","yes",> "temp") 
	tvmark(1,"temp")
	del("temp")
	print("Pick PSF stars with <a>, press <w> then <q> when done")
	psf(image,"photo.mag","","photo.psf","photo.pst","photo.psg",interac=yes,plottyp="radial",varorde=-1,verify=no,update=no)
	allstar(image,"photo.mag","photo.psf","photo.als","photo.arj","photo.res",verify=no,update=no,verbose=no)
	print("allstared")
	substar(image,"photo.als","photo.pst","photo.psf","photo.sub",verify=no,update=no,verbose=no)
	iteration=1
	print("substared")
	display("photo.res",2)
	display("photo.sub",3)
	pdump("photo.als","xcen,ycen","yes", > "temp") 
	tvmark(2,"temp")
	del("temp")
	pdump("photo.pst","xcen,ycen,id","yes", > "temp") 
	tvmark(3,"temp")
	del("temp")
	print("Please examine residuals and delete bad PSF stars from")
	print("photo.pst before continuing. (<q> to continue)")
	imexam("photo.res",2)
	print("### Completed iteration: 1")

		# main psf/allstar iteration loop
while (continue > 0) {
	del("photo.als.int")
	print("Please mark faint stars missed by DAOFIND with <space> on frame #1")
	print("[if done, still mark at least one star]")
	phot(image,"","photo.mag.faint","",interac=yes,calgorithm="none")
	prenumber("photo.mag.faint",idoffset=5000+iteration*100)
	pfmerge("photo.als,photo.mag.faint","photo.als.int")
	del("photo.mag.faint")
	del("photo.psf.fits,photo.psg,photo.pst_out")
	psf("photo.sub","photo.als.int","photo.pst","photo.psf","photo.pst_out","photo.psg",interac=no,varorde=order,verify=no,update=no,verbose=no)
	print("psf-ed")
	del("photo.pst")
	copy("photo.pst_out","photo.pst")
	del("photo.res.fits,photo.als,photo.arj,photo.sub.fits")
	iteration = iteration + 1
	allstar(image,"photo.als.int","photo.psf","photo.als","photo.arj","photo.res",verify=no,update=no,verbose=no)
	print("allstarred")
	substar(image,"photo.als","photo.pst","photo.psf","photo.sub",verify=no,update=no,verbose=no)
	print("substarred")
	display(image,1)
	display("photo.res",2)
	display("photo.sub",3)
	pdump("photo.als","xcen,ycen","yes", > "temp") 
	tvmark(2,"temp")
	del("temp")
	pdump("photo.als","xcen,ycen,mag","yes", > "temp") 
	tvmark(1,"temp")
	del("temp")
	pdump("photo.pst","xcen,ycen,id","yes", > "temp") 
	tvmark(3,"temp")
	del("temp")
	print("Please examine residuals and delete bad PSF stars from")
	print("photo.pst before continuing. (<q> to continue)")
	imexam("photo.res",2)
	print("### Completed iteration: ",iteration)
	}

	del(image//".als")
	del(image//".psf.fits")
	del(image//".pst")
	del(image//".sub.fits")
	copy("photo.als",image//".als")
	imcopy("photo.psf",image//".psf")
	imcopy("photo.res",image//".sub")
	copy("photo.pst",image//".pst")
	del("photo*")
	pdump(image//".als","xcen,ycen,mag","yes", > "temp") 
	tvmark(1,"temp")
	del("temp")
	pdump(image//".als","mag,merr", "yes", > "temp") 
	graph("temp", mark="point")
	del("temp")
end
