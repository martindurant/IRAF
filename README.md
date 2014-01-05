IRAF
====

IRAF tools for photometry and astrometry.
martin.cl is the package header.

irstack - stack images using a median flat
-------

inputs:
filelist - a <cr> seperated list of image filenames to stack
fileout - output image
flatout - output flat field

You will need to chose several stars on the first of the images (using <A> as in imexam)
and then one reference star on each of the images (using <A>, then <q>).
Dark subtracting is not implemented.

photometer - perform DAOphot photometry
----------

inputs:
image - image to photometer

First you should run daoedit on the image and set all the photometry parameters, saving them
with setimpars to <image>.pars

When psf first runs, you will need to chose psf stars by hand, as many as possible. Choose
using <A>, and then examine the radial/surface/contour plot, <A> to accept, <D> to reject.
You will need to press <w> when done, then <q> to quit.
To add new stars to the starlist, mark them with <space> when phot runs.
To delete psf stars, run emacs or somesuch and delete them by hand.
Press <q> in the image window to quit any or the imexam instances.

raxyconv, xyrarun - convert between x/y coordinates and ra/dec for an image with WCS. 
-----------------
This is an envelope to convert a list in reasonable format, using the stsdas package tools.

reastrometer - apply one astronometric solution to another image by cross-identifying stars
------------

inputs:
refimage - reference image with WCS
newimage - image to astrometer

Pick a set of stars in the first image with <space>, and then the same stars in the same order
in the image to astrometer. This runs ccmap, whose commands should be looked at.
The second part, commented out, is to find a better solution by finding lots of stars in both
images, but does not work, mostly due to lots of false identifications. Feel free to improve!

limiting_magnitude - find limiting magnitude and true daophot errors
------------------

inputs:
image, psf, list of coordinates for inputting stars, .als file and
magnitude range to consider, and it will find the standard deviation at
each test magnitude. 

This can be used to estimate the true error of
isolated stars.
To push this as far as possible, set the flaterr and proferr to zero, so
stars are not rejected.
Note: the mag out is not the mag in, because the choice of dark sky areas
makes these stars untipycally dim by a few tens of counts, which is
important near the magnitude limite.
The 2-sigma limit is where the mag error goes to 0.5, which might require
extrapolating a plot of mag_in/std_dev.

