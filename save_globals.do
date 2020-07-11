	******************************************************
	capture program drop save_global
	
	program define save_global, rclass
	
		syntax using/
		preserve
			quie {
				clear
				set obs 1
				gen name = ""
				gen strL content = ""
				local next_obs 1
				local all_globals: all globals "*"
				noi dis as text "Saving globals:"
				foreach a of local all_globals {
					 if substr("`a'",1,2) =="S_" continue
					 noi dis as result " `a'"
					 replace name = `"`a'"' in `next_obs'
					 replace content = `"${`a'}"' in `next_obs'
					 local ++next_obs
					 set obs `next_obs'
				}
				drop if missing(name)
				compress
				save `using', replace
			}
		restore
	end
	
	******************************************************
	capture program drop load_global
		
	program define load_global, rclass
	
		syntax using/,
		preserve
			clear
			use `using'
			local obs = _N
			noi dis as text "Creating `obs' globals:"
			quie forvalues y = 1/`obs' {
				 local thisName  = name in `y'
				 local thisStuff = content in `y'
				 global `thisName' `thisStuff'
				 noi dis as result " `thisName'"
			}
		restore
	end	
	
	

	