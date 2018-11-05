
program rmean_example
    implicit none

    integer,parameter :: nmax = 1000000
    integer :: npts, nerr
    real*4 :: data(nmax)
    real*4 :: beg, dt

    integer sac_compare

    ! Read in the data file
    call rsac1('raw.sac', data, npts, beg, dt, nmax, nerr)

    call remove_mean(data, npts)

    ! write the seismogram with trend removed back to disk
    call wsac0('rmean.sac', data, data, nerr)

    if(sac_compare('rmean_sac.sac', data, npts, beg, dt) .ne. 1) then
       write(*,*)'data does not match file'
    endif

end program rmean_example
