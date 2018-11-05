fg seismo
add (pi/2)
write raw.sac
rmean
write rmean_sac.sac
read raw.sac rmean_sac.sac
color on inc
p2
save output.pdf
quit
