set terminal pngcairo  background "#ffffff" enhanced fontscale 1.0 size 640, 480  dashlength 2
set output 'strong_scaling_parallel_efficieny.png'
set termoption dash
# Create some linestyles for our data
# pt = point type (triangles, circles, squares, etc.)
# ps = point size
set style line 1 lt 1 lc rgb "red" lw 2 pt 7 ps 2
set style line 2 lt 1 lc rgb "blue" lw 2 pt 11 ps 2
set style line 3 lt 1 lc rgb "orange" lw 2 pt 9 ps 2
set style line 4 lt 1 lc rgb "green" lw 2 pt 8 ps 2
set style line 5 lt 1 dashtype '-' lc rgb "black" lw 1 pt 13 ps 2
#set style line 6 lt 1 dashtype '.-' lc rgb "gold" lw 2 pt 5 ps 2
#set style line 7 lt 1 dashtype '.-' lc rgb "brown" lw 2 pt 12 ps 2
set style line 8 lt 2 lc rgb "pink" lw 2 pt 5 ps 2
set style line 9 lt 2 lc rgb "black" lw 2 pt 5 ps 2
set style line 10 lt 2 lc rgb "violet" lw 2 pt 5 ps 2

# Margins for each row resp. column
# TMARGIN = "set tmargin at screen 0.90; set bmargin at screen 0.55"
# BMARGIN = "set tmargin at screen 0.55; set bmargin at screen 0.20"
# LMARGIN = "set lmargin at screen 0.15; set rmargin at screen 0.55"
# RMARGIN = "set lmargin at screen 0.55; set rmargin at screen 0.95"

### Start multiplot (2x2 layout)
#set multiplot layout 2,2 rowsfirst

# --- GRAPH a
#@TMARGIN; @LMARGIN
set xlabel "Number of Processor Cores"
set ylabel "Efficiency ({/Symbol e})"
set logscale x 10
set logscale y 10
set xrange [1e1:1e3]
set yrange [1e-1:1.5]
#set format y "10^{%T}"; 
#set format x "10^{%T}"; 

#set no key
set key at 900, 0.95

set arrow from 43.3,0.1 to 43.3,1.5 dashtype '.-' lw 2 lc rgb "red" nohead

set arrow from 20,0.1 to 20,1.18 nohead
set label 10 "One Node" at 20, 1.25, 0 centre norotate front nopoint offset character 0, 0, 0
set object 10 rect center 20, 1.25, 0 size character 14, 1, 0
set object 10 front lw 1.0 fc default fillstyle  empty border lt -1

plot "wall_clock_timings.dat" using 1:((595/$2)*(20/$1)) ls 1 with linespoints title "DGBP", \
"wall_clock_timings.dat" using 1:((581/$3)*(20/$1)) ls 2 with linespoints title "PARTICLES", \
"wall_clock_timings.dat" using 1:((499/$4)*(20/$1)) ls 3 with linespoints title "VOF", \
"wall_clock_timings.dat" using 1:((380/$5)*(20/$1)) ls 4 with linespoints title "FEM-EV", \
1.0 ls 5 title "Optimal {/Symbol e}" 



# --- GRAPH b
# @TMARGIN; @RMARGIN
# [...]
# # --- GRAPH c
# @BMARGIN; @LMARGIN
# [...]
# # --- GRAPH d
# @BMARGIN; @RMARGIN
#unset multiplot
