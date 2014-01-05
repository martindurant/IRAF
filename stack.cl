procedure stack (filelist, fileout, flatin)

string 	filelist	{prompt="Input raw files"}
string	fileout		{prompt="Output file"}
string	flatin		{prompt="Input (screen) flat"}
bool	darksub
string	darkfile	{prompt="Dark exposure image",mode="q"}
struct	*files

begin
	int 	index	=0
	string	invar	=""
	int 	dummy	=0
	int 	counter	=0
	struct 	line
	int 	xref	=0
	int	yref	=0
	int	x	=0
	int	y	=0
	string 	input	=""

	del("stack*")
	input = filelist

	files = input
	while (fscan(files,invar) != EOF) {
		index=index+1
		print(index//"r",>> "stackr")
		print(index//"s",>> "stacks")
		}
	imdel("@stackr,@stacks")
	imarith("@"//input,"/",flatin,"@stackr")
	display("1r",1)
	print("Pick about 10 stars with <a>, press <q> to exit")
	imexam("1r",1,> "stackcurs")
	!grep -v "#" stackcurs > stackcurs2
	!grep -v " 2.50 " stackcurs2 > stackcurs3
	files = "stackcurs3"
	while (fscan(files,line) != EOF) {
		print(substr(line,2,15),>> "stackstars")
		}
	print("Mark the reference star on each image with <a>, followed by <q>")
	while (counter < index) {
		counter = counter+1
		display(counter//"r",1)
		del("stacktemp*")
		imexam(counter//"r",1,> "stacktemp")
		files="stacktemp"
		dummy=fscan(files,line)
		dummy=fscan(files,line)
		dummy=fscan(files,x,y)
		files=""
		if (counter == 1) {
			xref=x
			yref=y
			}
		print(str(xref-x)//" "//str(yref-y),>> "stackshifts")
		print(str(xref-x)//" "//str(yref-y))
		}
	imalign("@stackr","1r","stackstars","@stacks",shifts="stackshifts")
	imdel(fileout)
	imcomb("@stacks",fileout,combine="average",reject="sigclip",scale="none")
	del("stack*")
	display(fileout,1)
end
