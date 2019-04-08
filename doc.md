libsac Documentation
====================

The libsac library contains C / Fortran callable subroutines that utilize the core
funtionality of the SAC (Seismic Analysis Code) program.  The internal routines here
are wrapped in an interface that should be more streamlined to use than previous
versions. Care was taken to make sure the calling routines generate the same output
as what would be gotten from SAC; most functions here include the equivalent SAC
commands.

For exhustive examples, please see doc/examples contained in the SAC distribution.

Contents
========
- [Instrument Removal Deconvolution](doc.md#Instrument-Removal-and-Deconvolution)
- [Remove Mean](doc.md#Remove-Mean)
- [Remove Trend](doc.md#Remove-Trend)
- [Remove Trend - Uneven data](doc.md#Remove-Trend---Unevenly-sampled-data)
- [Rotate](doc.md#Rotate)
- [Filtering](doc.md#Filtering)
- [Cross Correlation](doc.md#Cross-Correlation)
- [Cross Correlation Extras](doc.md#Cross-Correlation-Extras)
- [Envelope](doc.md#Envelope)
- [Differentiate](doc.md#Differentiate)
- [Integrate](doc.md#Integrate)
- [Taper](doc.md#Taper)
- [Cut Data](doc.md#Cut-Data)
- [Convolution](doc.md#Convolution)


Instrument Removal and Deconvolution
----------------------------------

```c
// Remove Evalresp Response 
int remove_evalresp_simple(float *data, int n, float dt, double limits[4]);

// Remove Evalresp Response 
int remove_evalresp(float *data, int n, float dt, double limits[4],
                    char *id, char *when, char *resp_file);

// Remove SAC_PZ Polezero Response
int remove_polezero(float *data, int n, float dt, double limits[4],
                        char *id, char *when, char *pzfile);

// Remove SAC_PZ Polezero Response
int remove_polezero_simple(float *data, int n, float dt, double limits[4]);
```

Remove an evalresp or polezero specified instrument response.  Best to use the `simple` versions unless extra information is required.  `remove_evalresp_simple` and `remove_polezero_simple` will attempt to find the appropriate response file within the same directory before removing.  `remove_evalresp` and `remove_polezero` requires the specification of a response file.

**Arguments**

- `data` - Time series data
- `n` - Length of data
- `dt` - Sampling interval (seconds)
- `limits` - Frequency range over which response is removed (Hz)
   
   - `limits[4] = { 0.002, 0.005, 12.0, 20.0 }`
   - limits[0] - Low  Frequency Edge (Response = 0)
   - limits[1] - Low  Frequency Edge (Response = 1)
   - limits[2] - High Frequency Edge (Response = 1)
   - limits[3] - High Frequency Edge (Response = 0)
- `id` - Intrument Identifier, NET.STA.LOC.CHA

   - `*.*.*.*` wildcards are valid, but unexpected results may occur
   - `*` will try to automatically determine the instrument id using the current sac file
- `when` - Reference time, YYYY,DDD,HH:MM:SS

   - `*` will try to automatically determine the reference time using the current sac file
- `resp_file` - Evalresp Response File
- `pzfile` - Polezero Response File

**Note:** Data is modified in place.

**Examples**

```fortran
    implicit none
    include "sacf.h"
    real*4 y(1999), b, dt
    integer n, nerr, nmax
    real*8 limits(4)

    ! Function Prototypes
    integer remove_evalresp_simple

    nmax = 1999

    ! Frequency Limits (Hz)
    limits(1) = 0.002
    limits(2) = 0.005
    limits(3) = 12.0
    limits(4) = 20.0

    ! Read in Raw Sac file
    call rsac1("raw.sac", y, n, b, dt, nmax, nerr)

    ! Remove Response using Evalresp
    if(remove_evalresp_simple(y, n, dt, limits) .ne. 0) then
       write(*,*) "Error removing instrument with evalresp"
       return
    endif
```

**Effective SAC Commands**

```shell
SAC> read raw.sac
SAC> transfer from evalresp to none freq 0.002 0.005 12 20
```

Remove Mean
-----------

```c
void remove_mean (float *data, int n)
```

Remove the mean of a data series.  The mean of the data series is automatically calculated and removed from the data series. 

**Arguments**

- `data` - Input data series
- `n` - length of data

**Note:** Data is modified in place.

**Examples**

```fortran
    implicit none

    integer,parameter :: nmax = 1776
    integer :: npts, nerr
    real*4 :: data(nmax), beg, dt

    ! Read in the data file
    call rsac1('raw.sac', data, npts, beg, dt, nmax, nerr)

    ! Remove the mean of the data in place
    call remove_mean(data, npts)
```

**Effective SAC Commands**

```shell
SAC> read raw.sac
SAC> rmean
```

Remove Trend
------------

```c
void remove_trend(float *data, int n, float delta, float b)
```
Remove the trend of a data series

**Arguments**

- `data` - Input data series, overwritten on output
- `n` - length of data
- `delta` - Time sampling of the data
- `b` - Initial time value of the data series

**Note:** Data is modified in place.

This calls lifite() and rtrend() internally

Trend is removed as

```c
    y[i] = y[i] - yint - slope * (b + delta * i)
```

where y is the data

**Examples**

```c
#define NMAX 1969

float y[NMAX], b, dt;
int nmax = NMAX;
int n, nerr;

// Read in the data file
rsac1("raw.sac", y, &n, &b, &dt, &nmax, &nerr, -1);

// Remove the trend of the data in place
remove_trend(y, n, dt, b);
```

**Effective SAC Commands**

```shell
SAC> read raw.sac
SAC> rtrend
```

Remove Trend - Unevenly sampled data
------------------------------------

```c
void rtrend2(float *data, int n, float yint, float slope, float *t)
```

Removing the trend from an unevenly sampled data ::

**Arguments**

- `data` - Input data series, overwritten on output
- `n` - Length of data
- `yint` - Y intercept of the trend to remove
- `slope` - Slope of the trend to remove
- `t` - time values for the unevenly sampled data

**Note:** Data is modified in place.

Trend is removed as::

    y[i] = y[i] - yint - slope * t[i]

where y is the data


Rotate
------

```c
void rotate(float *si1, float *si2, int ns, double angle, 
            int lnpi, int lnpo, float *so1, float *so2)
```

To perform a clockwise rotation of a pair of signals.

**Arguments**

- `sil` - First input signal
- `si2` - Second input signal
- `ns` - Number of points in input signals, `sil` and `si2`
- `angle` - Angle of rotateion in degrees clockwise from `si1`
- `lnpi` - True (1) if input signals are normal polarity
- `lnpo` - True (1) if output signals are normal polarity
- `so1` - First output signals
- `so2` - Second output signals 

**Note:** Input and output signals may be the same arrays

**Examples**

Rotation of two signal in Fortran

```fortran
    implicit none

    integer,parameter :: nmax = 1954
    integer :: npts, nerr
    real :: signal1(nmax), signal2(nmax)
    real :: rotated_signal1(nmax), rotated_signal2(nmax)
    real :: beg, dt, baz, cmpaz1
    real*8 :: angle
    logical :: lnpi, lnpo

    integer sac_compare

    ! Read in the first signal to be rotated
    call rsac1('signal1.sac', signal1, npts, beg, dt, nmax, nerr)

    call getfhv("cmpaz", cmpaz1, nerr)
    call getfhv("baz", baz, nerr);

    ! Read in the second signal to be rotated
    call rsac1('signal2.sac', signal2, npts, beg, dt, nmax, nerr)

    ! Set up parameters for rotation
    lnpi = .true.     ! input signals have "normal" polarity
    lnpo = .true.     ! output signals have "normal polarity

    ! Compute angle to rotate to
    angle = baz + 180.0 - cmpaz1;

    call rotate(signal1, signal2, npts, angle, lnpi, lnpo,
                rotated_signal1, rotated_signal2)
```

**Effective SAC Commands**

```shell
SAC> read signal1.sac signal2.sac
SAC> rotate
```

Filtering
---------


```c
void bandpass(float *data, int n, float dt, float low, float high);
void lowpass(float *data, int n, float dt, float corner);
void highpass(float *data, int n, float dt, float corner);

void filter(int prototype,
            int type,
            float *data, int n, float dt,
            float low, float high, int passes, int order,
            float transition,
            float attenuation);
```

Filter data using a Butterworh filter with two pass, four pole filter.  Data is filtered using an Infinite Impulse Repsonse Filter.  For more detailed filter types use the generic `filter` function

**Arguments**

- `data` - Input and output data
- `n` - Length of data
- `dt` - Time sampling of the data (seconds)
- `low` - low frequency corner
- `high` - high frequency corner
- `corner` - corner of the filter for `lowpass` or `highpass`

- `passes` - Number of passes

    - 1 - forward pass only
    - 2 - forward and backward pass
- `order` - Filter Order, not to exceed 10, 4-5 should be sufficient
- `transition` - Transition Bandwidth, only used in Chebyshev Type I and II Filters
- `attenuation` - Attenuation factor, amplitude reached at stopband edge, only used in Chebyshev Type I and II Filters
- `prototype` - Filter Prototype

   - 0 - Butterworth filter
   - 1 - Bessel filter
   - 2 - Chebyshev Type I filter
   - 3 - Chebyshev Type II filter
- `type` - Filter Type

   - 0 - Bandpass
   - 1 - Highpass
   - 2 - Lowpass
   - 3 - Bandreject

**Examples**

Bandpass filter in C

```c
#define NMAX 2015
float y[NMAX], b, dt;
int n, nerr, nmax = NMAX;

// Read in the data file
rsac1("raw.sac", y, &n, &b, &dt, &nmax, &nerr, -1);

// bandpass filter from 0.10 Hz to 1.00 Hz
bandpass(y, n, dt, 0.10, 1.00);
```

Highpass filter in Fortran

```fortran
    implicit none
    integer nmax, n, nerr, sac_compare
    real*4 :: y(2012), b, dt
    nmax = 2012

    ! Read in the data file
    call rsac1("raw.sac", y, n, b, dt, nmax, nerr)

    ! highpass filter at 10.0 Hz
    call highpass(y, n, dt, 10.0)
```

**Effective SAC Commands**

```shell
SAC> read raw.sac
SAC> bp co 0.10 1.0 p 2 n 4

SAC> read raw.sac
SAC> hp co 10.0 p 2 n 4
```

Cross Correlation
-----------------

```c
void correlate(float *f, int nf, float *g, int ng, float *c, int nc);
```

Compute the cross-correlation of two signals

**Arguments**

- `f` - First time series
- `nf` - Length of first time series
- `g` - Second time series
- `ng` - Length of second time series
- `c` - Cross correlation time series
- `nc` - Size of c, must be at least (nf + ng - 1)

**Return:** Cross correlation function, length: nf + ng - 1

If the signals are not the same length, then find the longest
signal, make both signals that length by filling the remainder
with zeros (pad at the end) and then run them through crscor

**Examples**

```fortran

    implicit none
    character(len=*) filea, fileb
    real*4 :: amp_max, t_max
    real*4 :: a(1976), b(1976), ba,bb,dt,bc
    real*4 :: c(10000)
    integer :: nmax, nerr,na, nb, nc, i

    ! Function Prototypes
    real*4 correlate_time_begin
    integer correlate_max

    nmax = 1976

    c(:) = 0.0

    ! Read in files to correlate
    call rsac1("file1.sac", a, na, ba, dt, nmax, nerr)
    call rsac1("file2.saC", b, nb, bb, dt, nmax, nerr)

    ! Compute length of correlation
    nc = na + nb - 1

    ! Correlate
    call correlate(a, na, b, nb, c, nc)

    ! Compute begin time of correlation
    bc = correlate_time_begin(dt, na, nb, ba, bb)

    ! Compute maximum value of correlation
    i = correlate_max(c, nc)
```

**Effective SAC Commands**

```shell
SAC> read file1.sac file2.sac
SAC> correlate
```

Cross Correlation Extras
------------------------

```c
int correlate_max(float *c, int nc)
```

Find the maximum of a correlation

**Arguments**

- `c` - float array (returned from correlate function)
- `nc` - length of c

**Return:** Index of maximum value in array

---------------------------------------------------

```c
float correlate_time(float dt, float b, int i)
```

Compute the time of a data point given dt and begin time

**Arguments**

- `dt` - Time sampling
- `b` - Begin time
- `i` - data sample

**Return:** time value (b + i * dt)

---------------------------------------------------

```c
float * correlate_time_array(float dt, float b, int n)
```

Compute a time array given dt and begin time

**Arguments**

- `dt` - Time sampling
- `b` - Begin time
- `n` - Length of data array

**Return:** time array

***************************************************

```c
float correlate_time_begin(float dt, float n1, float _n2, float b1, float b2)
```

Compute begin time from a corealtion of two time series

**Arguments**

- `dt` - Time sampling
- `n1` - Length of first time series
- `n2` - Length of second time series (unused)
- `b1` - Begin time of first time series
- `b2` - Begin time of second time series

**Return:** `-dt * (n1 - 1) + (b2 - b1)`

This accounts for the possible differences in begin times of two time series


Envelope
--------

```c
void envelope(int n, float *in, float *out)
```

Compute the envelope of a time series using the Hilbert transform

**Arguments**

- `n` - Length of input and output time series
- `in` - Input time series
- `out` - Output time series with envelope applied

The envelope is applied as such where the H(x) is the Hilbert transform::

      out = sqrt( H( in(t) )^2 + in(t)^2 )

**Examples**

```c
#define NMAX 1929
int nlen, nerr, nmax;
float yarray[NMAX], yenv[NMAX];
float beg, delta;

nmax = NMAX;

// Read in data file
rsac1("raw.sac", yarray, &nlen, &beg, &delta, &nmax, &nerr, SAC_STRING_LENGTH);

// Calculate Envelope of data
envelope(nlen, yarray, yenv);
```

**Effective SAC Commands**

```shell
SAC> read raw.sac
SAC> envelope
```

Differentiate
-------------

```c
void dif2(float *array, int n, double delta, float *output)
```

Differentiate a data set using a two point differentiation

**Arguments**

- `array` - Input data to differentiate
- `n` - length of ararry
- `delta` - Time sampling of input data 
- `output` - Output differentiated data, length n-1

This is the default scheme in the SAC program.

The output array will be 1 data point less than the input array.

Since this is not a centered differeniation, there is an implied shift
in the independent variable by half the delta::

    b_new = b_old + 0.5 * delta

Differntiation is performed as::

    out[i] = (1/delta) * (in[i+1] - in[i])

**Examples**

```fortran
    integer,parameter :: nmax = 1000000
    integer :: npts, nerr
    real*4 :: data(nmax), out(nmax)
    real*4 :: beg, dt

    ! Read in the data file
    call rsac1("raw.sac", data, npts, beg, dt, nmax, nerr)

    ! Differentiate the data
    call dif2(data, npts, dble(dt), out)

    bnew = beg + 0.5 * delta
    npts_new = npts - 1
```

**Effective SAC Commands**

```shell
SAC> read raw.sac
SAC> dif
```

Integrate
---------

```c
void int_trap(float *y, int n, double delta)
```

Integrate a data series using the trapezodial method

**Arguments**

- `y` - Input data series, overwritten on output
- `n` - length of y
- `delta` - time sampling of the data series

Integration is performed as::

    out[i] = out[i-1] + (delta/2) * (in[i] + in[i+1])

where the initial out value is 0.0.

The number of points on output should be reduced by 1 ::

     len(out) = len(in) - 1

and the beging value is shifted by 0.5 delta::

     b_out = b_in + 0.5 * delta

**Examples**

```c
#define NMAX 2012
float y[NMAX], b, dt;
int n, nerr, nmax = NMAX;

rsac1("raw.sac", y, &n, &b, &dt, &nmax, &nerr, -1);

int_trap(y, n, (double)dt);
```

**Effective SAC Commands**

```shell
SAC> read raw.sac
SAC> int
```

Taper
-----

```c
// Taper using points
void taper_points(float *data, int n, int taper_type, int ipts);
void taper(float *data, int n, int taper_type, int ipts);

// Taper using a duration in seconds
void taper_seconds(float *data, int n, int taper_type, float sec, float delta);

// Taper using a percent of the data
void taper_width(float *data, int n, int taper_type, float width);
```

**Arguments**

- `data` - Input data series, overwritten on output
- `n` - Length of data
- `taper_type` - Type of Taper

   - 1 - Cosine - SAC_TAPER_COSINE
   - 2 - Hanning - SAC_TAPER_HANNING
   - 3 - Hamming - SAC_TAPER_HAMMING
- `ipts` - Points to use in the taper
- `sec` - Duration of the taper in seconds
- `delta` - Delta of the data 
- `width` - Percent of the data to taper

**Examples**

```c
#define MAX 1984
float data[MAX];
int nmax, npts, nerr, taper_type;
float beg, dt, width;

nmax = MAX;

// Read in the data file
rsac1("raw.sac", data, &npts, &beg, &dt, &nmax, &nerr, -1);

// Set up taper parameters
width = 0.05;    // Width to taper original data
taper_type = 2;  // HANNING taper

taper_width(data, npts, taper_type, width);
```

**Effective SAC Commands**

```shell
    SAC> read raw.sac
    SAC> taper
```

Cut Data
--------

```c
void cut(float *y, int npts, float b, float dt,
         float begin_cut, float end_cut, int cuterr,
         float *out, int *nout)
```

Cut a time series data using a begin and end time

**Arguments**

- `y` - Input data to be cut
- `npts` - Length of y
- `b` - Begin time of data
- `dt` - time sampling (seconds)
- `begin_cut` - Start time of cut
- `end_cut` - End time of cut
- `cuterr` - 

   - 1 - Fatal - SAC_CUT_FATAL
   - 2 - Use B and E Values - SAC_CUT_USEBE
   - 3 - Fill with Zeros - SAC_CUT_FILLZ

- `out` - Cut data on output
- `nout` - Length of out

**Examples**

```fortran
   integer,parameter :: nmax = 1776
   real*4 :: y(nmax), out(nmax), b, dt, cutb, cute
   integer :: nerr, n, nout

   max = nmax
   ! Read in data
   call rsac1("raw.sac", y, n, b, dt, max, nerr)

   nout = max
   cutb = 10.0
   cute = 15.0
   ! Cut data from 10 to 15 or from B to E if window is too big
   call cut(y, n, b, dt, cutb, cute, CUT_USEBE, out, nout)
```

**Effective SAC Commands**

```shell
    SAC> read raw.sac
    SAC> cut 10 15
    SAC> read raw.sac
```


