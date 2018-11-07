# Seismic Analysis Code Example Programs

What follows is a collection of programs that use various portions of the
sacio and sac libraries included with this distribution.  The source code
for each program in Fortran and C should be documented and the programs 
usable once compiled.  They are provided here as reference and a starting
point to create your own programs using the sacio and sac libraries.

The Makefile provided with the examples demonstrates a way to use the 
sac-config helper program to get the location and name of libraries along
with required compile flags.

Programs include:
  * Get SAC Header Variables 
      - [gethvc.c](./io/gethvc.c)
      - [gethvf.f](./io/gethvf.f)
  * Read a Evenly Spaced SAC file
      - [rsac1c.c](./io/rsac1c.c)
      - [rsac1f.f](./io/rsac1f.f)
  * Read an Un-Evenly Spaced SAC file
      - [rsac2c.c](./io/rsac2c.c)
      - [rsac2f.f](./io/rsac2f.f)
  * Write a Evenly Spaced SAC file
      - [wsac1c.c](./io/wsac1c.c)
      - [wsac1f.f](./io/wsac1f.f)
  * Write a Un-Evenly Spaced SAC file
      - [wsac2c.c](./io/wsac2c.c)
      - [wsac2f.f](./io/wsac2f.f)
  * Write Another Evenly Spaced SAC file
      - [wsac3c.c](./io/wsac3c.c)
      - [wsac3f.f](./io/wasc3f.f)
  * Write a 2D SAC file
      - [wsac4c.c](./io/wsac4c.c)
      - [wsac4f.f](./io/wsac4f.f)
  * Write a collection of SAC files
      - [wsac5c.c](./io/wsac5c.c)
      - [wsac5f.f](./io/wsac5f.f)
  * Convolve Two SAC files [ Directory: convolve ]
      - Uses a time domain convolution
      - [convolvec.c](./convolve/convolvec.c)
      - [convolvef.f](./convolve/convolvef.f)
  * Convolve Two SAC files [ Directory: convolve_saclib ]
      - Uses frequency domain in saclib
      - [convolvec.c](convolve_saclib/convolvec.c)
      - [convolvef.f](convolve_saclib/convolvef.f)
  * Correlate Two SAC files [ Directory: correlate ]
      - [correlatec.c](correlate/correlatec.c)
      - [correlatef.f](correlate/correlatef.f)
  * Get the Envelope of a SAC file [ Directory: envelope ]
      - [envelopec.c](envelope/envelopec.c)
      - [envelopef.f](envelope/envelopef.f)
  * Interpolate a SAC file using cubic spline [ Directory: interpolate ]
      - External Command, not in SAC
      - [interpolate.f](interpolate/interpolate.f)
      - [interpolate_subs.f](interpolate/interpolate_subs.f)
  * Filter a SAC file [ Directory: filter ]
      - [filterc.c](./filter/filterc.c)
      - [filterf.f](./filter/filterf.f)
  * Time Shift a SAC file [ Directory: time_shift ]
      - External Command, not in SAC
      - [time_shift.f](./time_shift/time_shift.f)
      - [time_shift_subs.f](./time_shift/time_shift_subs.f)
  * create_input.sh
      Run SAC to create SAC files that are then 
      compared to the output from each standalone program.

Also included are a variety of ways to run the sac program from different scripting languages
including

  * Python
    - sac_script.py
    - sac_script2.py
  * sh/bash Shell
    - sac_script.sh
    - sac_script2.sh
  * csh Shell
    - sac_script.csh
    - sac_script2.csh
  * Perl
    - sac_script.pl
    - sac_script2.pl

  * The first version `sac_script` creates a seismogram and uses lh to get the sac metadata.

  * The second version `sac_script2` reads all sac files in the directory, removes the mean,
    removes the trend, low pass filters the data, then writes new files with a new extension.
