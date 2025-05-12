cscript
clear all
set linesize 80
set scheme sj

sjlog using synth2a, replace
use smoking
xtset state year
sjlog close, replace

sjlog using synth2b, replace
label list
sjlog close, replace

******************************************************************************
* Replicate results in Abadie, Diamond, and Hainmueller (2010)
sjlog using synth2c, replace
synth2 cigsale lnincome age15to24 retprice beer cigsale(1988) cigsale(1980) cigsale(1975), trunit(3) trperiod(1989) xperiod(1980(1)1988) nested allopt
sjlog close, replace

* Implement in-space placebo test using fake treatment units with pre-treatment MSPE 2 times smaller than or equal to that of the treated unit
* For illustration, we drop the "allopt" option to save time. The "allopt" option is recommended for the most accurate results if time permits.
* To assure convergence, we change the default option "sigf(7)" (7 significant figures) to "sigf(6)".
sjlog using synth2d, replace
synth2 cigsale lnincome age15to24 retprice beer cigsale(1988) cigsale(1980) cigsale(1975), trunit(3) trperiod(1989) xperiod(1980(1)1988) nested placebo(unit cut(2)) sigf(6)
sjlog close, replace

* Implement in-time placebo test using the fake treatment time 1985 and dropping the covariate cigsale(1988)
sjlog using synth2e, replace
synth2 cigsale lnincome age15to24 retprice beer cigsale(1980) cigsale(1975), trunit(3) trperiod(1989) xperiod(1980(1)1984) nested placebo(period(1985))
sjlog close, replace

* Implement leave-one-out robustness test, create a Stata frame "california" storing generated variables, and save all produced graphs to the current path
sjlog using synth2f, replace
synth2 cigsale lnincome age15to24 retprice beer cigsale(1988) cigsale(1980) cigsale(1975), trunit(3) trperiod(1989) xperiod(1980(1)1988) nested loo frame(california) savegraph(california, replace)
sjlog close, replace

* Combine all produced graphs
sjlog using synth2g, replace
graph combine `e(graph)', cols(2) altshrink
sjlog close, replace


* Change to the generated Stata frame "california"
sjlog using synth2h, replace
frame change california
sjlog close, replace

* Change back to the default Stata frame
sjlog using synth2i, replace
frame change default
sjlog close, replace

******************************************************************************

