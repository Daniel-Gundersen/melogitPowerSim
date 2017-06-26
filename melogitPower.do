program melogitpow_randab, rclass
	drop _all
	args N ea eb w thetaa0 thetab0 
	set obs `N'
	gen id=_n
	gen ua=rnormal(0,sqrt(`ea'))
	gen ub=rnormal(0,sqrt(`eb'))
	expand `w'
		bysort id: gen waves=_n-1
	gen tobacco = uniform() < invlogit(`thetaa0'+ua+(ln(`thetab0')+ub)*waves)
	melogit tobacco c.waves || id: waves, 
	 return scalar constant=_b[tobacco:_cons]
	 return scalar wave=_b[tobacco:waves]
	 return scalar se_wave=_se[tobacco:waves]
end

simulate constant=_b[tobacco:_cons] wave=_b[tobacco:wave] se_wave=_se[wave] ///
		, reps(10000) seed(1978): melogitpow_randab 832 _pi^2/3 1 6 -2.2 1.3
