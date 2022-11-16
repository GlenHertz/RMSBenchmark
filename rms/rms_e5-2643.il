procedure( rms(xs, ys)
    prog( (area x1 y1 x2 y2 xstart xend)
        area = 0.0
        xstart = car(xs)
        x1 = xstart
        y1 = car(ys)
        foreach((xcdr ycdr) cdr(xs) cdr(ys)
            x2 = car(xcdr)
            y2 = car(ycdr)
            dx = x2 - x1
            dy = y2 - y1
            area = area + dx * (expt(dy 2)/float(3) + y1 * y2) ; quadratic shape
            x1 = x2
            y1 = y2
        )
        xend = x2
        return(sqrt(1/(xend - xstart) * area))
    ) ; prog
) ; procedure

; More lispy version of the above
procedure( (rms2 xs ys)
    (let (area x1 y1 x2 y2 xstart xend)
        (setq area 0.0)
        (setq xstart car(xs))
        (setq x1 xstart)
        (setq y1 car(ys))
        foreach( (xcdr ycdr) cdr(xs) cdr(ys)
            (setq x2 car(xcdr))
            (setq y2 car(ycdr))
            (setq dx x2-x1)
            (setq dy y2-y1)
            (setq area area+dx*(expt(dy 2)/float(3)+y1*y2)) ; quadratic shape
            (setq x1 x2)
            (setq y1 y2)
        )
        (setq xend x2)
        return(sqrt(1/(xend - xstart) * area))
    ) ; let
) ; procedure

; RMS to that takes in a waveform instead of two lists
procedure( (rms3 wave)
    (let (xs ys)
        (setq xs (drGetWaveformXVec wave))
        (setq ys (drGetWaveformYVec wave))
        (let (area x1 y1 x2 y2 xstart xend)
            area = 0.0
            xstart = car(xs)
            x1 = xstart
            y1 = car(ys)
            foreach((xcdr ycdr) cdr(xs) cdr(ys)
                x2 = car(xcdr)
                y2 = car(ycdr)
                dx = x2 - x1
                dy = y2 - y1
                area = area + dx * (expt(dy 2)/float(3) + y1 * y2) ; quadratic shape
                x1 = x2
                y1 = y2
            )
            xend = x2
            return(sqrt(1/(xend - xstart) * area))
        ) ; let
    ) ; let
) ; procedure

procedure( rms(xs, ys)
    prog( (area x1 y1 x2 y2)
        area = 0.0
        x1 = car(xs)
        y1 = car(ys)
        foreach( (x2 y2), cdr(xs), cdr(ys),
            dx = x2 - x1
            dy = y2 - y1
            area = area + dx * (expt(dy, 2.0) / 3.0 + y1 * y2) ; quadratic shape
            x1 = x2
            y1 = y2
        )
        return(sqrt(area / (car(last(xs)) - car(xs))))
    ) ;prog
) ;procedure
; results:
; num_cpus: 12
; cpu_mhz: 3500.0
; cache_size_mb: 25.0
; model_name: Intel(R) Xeon(R) CPU E5-2643 v2 @ 3.50GHz
; phys_mem_gb: 251.7
; redhat_release: CentOS Linux release 7.7 (Core)
; 20 iterations
; Average wall time: 0.587536
; Smallest wall time: 0.527253
; Average cpu time: 0.585934
; Smallest cpu time: 0.527239


;xs = '(1 2 3)
;ys = '(4 5 6)

xs = nil
for(i 0 1000000 xs = cons(float(i), xs))
xs = reverse(xs)

ys = nil
for(i 0 1000000 ys = cons(float(mod(i, 2)), ys))
ys = reverse(ys)

iterations = 10
sum_wall_time = 0.0
sum_cpu_time = 0.0
for(i 1 iterations
run_time = measureTime(
printf("%f\n", rms(xs, ys))
)
pprint(run_time)
printf("\n")
sum_wall_time = sum_wall_time + nth(2, run_time)
sum_cpu_time = sum_cpu_time + nth(0, run_time)
)

printf("Average wall time: %f\n", sum_wall_time / iterations)
printf("Average cpu time: %f\n", sum_cpu_time / iterations)



; small test
xs = '(0 1 2)
ys = '(0 1 0)'
rms(xs, ys)
printf("%f\n", rms(xs, ys))

; big test
xs = nil
for( i 0 1000000 xs = cons( i xs))
xs = reverse( xs)
ys = nil
for( i 0 1000000 ys = cons( mod(i 2) ys))
rms(xs, ys)
printf("%f\n", rms(xs, ys))

/************************************************************************
* *
* (abWaveToList wave @key transpose) *
* *
* Take a waveform object, and return it as a list of xy pairs. Or *
* if transpose is set, it returns a list of x values followed by a list *
* of y values. *
* *
************************************************************************/


(procedure (abWaveToList wave @key transpose)
    (let (xList yList xyList len
            (xVec (drGetWaveformXVec wave))
            (yVec (drGetWaveformYVec wave))
        )
        (setq len (drVectorLength xVec))
        ;-----------------------------------------------------------------
        ; Return value of this if is the list
        ;-----------------------------------------------------------------
        (if transpose
            (progn (for i 0 (sub1 len)
                    (setq xList (tconc xList (drGetElem xVec i)))
                    (setq yList (tconc yList (drGetElem yVec i)))
                )
                (list (car xList) (car yList))
            )
        ; else
            (progn
                (for i 0 (sub1 len)
                    (setq xyList (tconc xyList (list (drGetElem xVec i)
                    (drGetElem yVec i))))
                )
                (car xyList)
            )
        ) ; if
    ) ; let
) ; procedure