# Convolve Example


This file is ${SACHOME}/doc/exmples/convolve/README

In that directory, issue the command

    run_convolve.sh

This will do the following:

1.  Create the input files for convolve
    - Some from SAC and one from a Fortran program that creates a Brune pulse.

2.  Compile the Fortran version of convolve

3.  Run convolve first with a triangle pulse and an impulse waveform for
    both discrete and time-series options.

4.  Run convolve for a synthetic waveform and both discrete and time-series
    for a triangle pulse and then with a brune pulse for the time-series
    option.

Eight .sac files are created.  If they all worked, they will be the same
as in ./sample-run.
