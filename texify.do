	capture program drop texify
		
	program define texify, rclass
	
		syntax varlist [using] [if], [digits(integer 2)] [nonames] [commas]
		preserve
		
		/* parse and set up */
		local rest
		local last
		tempvar junk
		if "`commas'"!="" local cms c
		else local cms
		quie foreach x of varlist `varlist' {
			capture confirm numeric variable `x'
			if _rc==0 {
				
				rename `x' `junk'
				
				capture confirm int variable `junk'
				local rc = _rc
				
				capture confirm byte variable `junk'
				if `rc'==0 | _rc == 0 gen `x' =  string(`junk',"%9.0f`cms'") 
				else        gen `x' =  string(`junk',"%9.`digits'f`cms'") 
				drop `junk'
			}
			local rest `rest' `last'
			local last `x'
		}
		quie replace `last' = `last' + "\\"
		
		if "`names'"!="" local nonames nonames
		outsheet `varlist' `using' `if', replace delimit("&") noquote `nonames'
		
		restore
	end

