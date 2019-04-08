# Seismic Analysis Code (SAC)

Seismic Analysis Code (SAC) is a general purpose waveform analysis and processing application.  Originally developed at Lawrence Livermore National Laboratory, SAC is now maintained by the [IRIS](https://www.iris.edu/hq/) community and distributed from the [IRIS DMC](https://ds.iris.edu/ds/nodes/dmc/).

Information on [Downloading SAC](https://ds.iris.edu/ds/nodes/dmc/forms/sac/) and the [official SAC Documentation](https://ds.iris.edu/files/sac-manual/manual.html) is available directly from [IRIS](https://www.iris.edu/hq/), who coordinates releases due to licensing restrictions.

## Contents
[Examples Code](./examples/) using the sacio reading/writing library and the sac function library.  These routines **require** the libraries distributed with SAC.


## What is Not Here
Downloadable source code and binary distributions are not available here, sadly.  Please [Request](https://ds.iris.edu/ds/nodes/dmc/forms/sac/) those directly from [IRIS](https://www.iris.edu/hq/).

## Functions (libsac)
  - [FFT](doc.md#FFT) - Compute the forward and inverse Fourier Transfrom
  - [remove_evalresp_simple](doc.md#Instrument-Removal-and-Deconvolution) - Remove an instrument response stored in an evalresp file
  - [remove_evalresp](doc.md#Instrument-Removal-and-Deconvolution) - Remove an instrument response stored in an evalresp file
  - [remove_polezero_simple](doc.md#Instrument-Removal-and-Deconvolution) - Remove an instrument response stored in a polezero file
  - [remove_polezero](doc.md#Instrument-Removal-and-Deconvolution) - Remove an instrument response stored in a polezero file
  - [remove_mean](doc.md#Remove-Mean) - Remove the mean from data
  - [remove_trend](doc.md#Remove-Trend) - Remove the trend from data
  - [rtrend2](doc.md#remove-trend---unevenly-sampled-data) - Remove the trend from unevely spaced data
  - [rotate](doc.md#Rotate) - Perform a clockwise rotation of a pair of signals.
  - [bandpass](doc.md#Filtering) - Filter data using a band-pass filter
  - [lowpass](doc.md#Filtering) - Filter data using a low-pass filter
  - [highpass](doc.md#Filtering) - Fitler data using a high-pass filter
  - [filter](doc.md#Filtering) - Filter data specifying the filter 
  - [correlate](doc.md#Cross-Correlation) - Compute the cross-correlation of two signals
  - [correlate_max](doc.md#Cross-Correlation-Extras) - Find the maximum of a correlation
  - [correlate_time](doc.md#Cross-Correlation-Extras) - Compute the time of a data point given dt and begin time
  - [correlate_time_array](doc.md#Cross-Correlation-Extras) - Compute a time array given dt and begin time
  - [correlate_time_begin](doc.md#Cross-Correlation-Extras) - Compute begin time from a corealtion of two time series
  - [envelope](doc.md#Envelope) - Compute the envelope of a time series using the Hilbert transform
  - [dif2](doc.md#Differentiate) - Differentiate a data set using a two point differentiation
  - [int_trap](doc.md#Integrate) - Integrate a data series using the trapezodial method
  - [taper_points](doc.md#Taper) - Taper using points
  - [taper](doc.md#Taper) - Taper using points
  - [taper_seconds](doc.md#Taper) - Taper using a duration in seconds
  - [taper_width](doc.md#Taper) - Taper using a percentage of the data
  - [cut](doc.md#Cut-Data) - Cut a time series data using a begin and end time

