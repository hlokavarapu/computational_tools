set terminal pngcairo  background "#ffffff" enhanced fontscale 1.0 size 640, 480  dashlength 2
set output 'strong_scaling_with_fit_to_power_law.png'
set termoption dash

set style line 1 lt 1 lc rgb "red" lw 2 pt 7 ps 2
set style line 2 lt 1 lc rgb "blue" lw 2 pt 11 ps 2
set style line 3 lt 1 lc rgb "green" lw 2 pt 8 ps 2
set style line 4 lt 1 lc rgb "orange" lw 2 pt 9 ps 2
set style line 5 lt 1 dashtype '-' lc rgb "black" lw 1 pt 13 ps 2

set xlabel "Number of Processor Cores"
set ylabel "Wall Clock Time (sec/step)"

set key at 9e2, 8  maxrows 5 

# font ",10"
set xrange [1e1:1e3]
set yrange [7e-1:1e1]
set logscale x 10
set logscale y 10


#f1(x)=a1*x**b1
#f2(x)=a2*x**b2
#f3(x)=a3*x**b3
#f4(x)=a4*x**b4

g(x)=(10**2.0)*(x**(-1))


#fit f1(x) "wall_clock_timings.dat" using 1:($2/100) via a1,b1
#fit f2(x) "wall_clock_timings.dat" using 1:($3/100) via a2,b2
#fit f3(x) "wall_clock_timings.dat" using 1:($4/100) via a3,b3
#fit f4(x) "wall_clock_timings.dat" using 1:($5/100) via a4,b4


plot "wall_clock_timings.dat" using 1:($2/100) ls 1 with linespoints title "DGBP", \
"wall_clock_timings.dat" using 1:($3/100) ls 2 with linespoints title "PARTICLES", \
"wall_clock_timings.dat" using 1:($4/100) ls 3 with linespoints title "VOF", \
"wall_clock_timings.dat" using 1:($5/100) ls 4 with linespoints title "FEM-EV", \
g(x) with lines ls 5 title "Optimal Scaling"
#f1(x) with lines ls 1 title "t=5.28e1*N_{core}^{-0.738}", \
#f2(x) with lines ls 2 title "t=2.66e1*N_{core}^{-0.522}", \
#f3(x) with lines ls 3 title "t=3.44e1*N_{core}^{-0.657}", \
#f4(x) with lines ls 4 title "t=2.43e1*N_{core}^{-0.632}"
