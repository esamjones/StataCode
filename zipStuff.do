***********************************************
* Simple zip / unzip utility for Stata
***********************************************

set trace off

capture program drop zipsave
program define zipsave 
	
	syntax anything(name=id)
	
	quie {
		local endpath = strrpos(`id',"/")
		if `endpath'==0 local endpath = strrpos(`id',"\")
		
		if `endpath'==0 local path==""
		else local path = substr(`id',1,`endpath')
		
		local thisdir : pwd
		
		if strpos(`id',":") != 0 local target = "`path'"
		else local target = "`thisdir'/`path'"
		
		local thisName = substr(`id',1+`endpath',.)
		noi dis as result _n "Zipping file '`thisName'' into directory '`target''."
		
		cd "`target'"
		save `thisName', replace
		zipfile "`thisName'.dta", saving(`thisName', replace)
		rm "`thisName'.dta" 
		cd "`thisdir'"
	}
end

*********************************************************************************************

capture program drop unzip
program define unzip 
	
	syntax anything(name=id)
	
	quie {
		local endpath = strrpos(`id',"/")
		if `endpath'==0 local endpath = strrpos(`id',"\")
		if `endpath'==0 local path=="."
		else local path = substr(`id',1,`endpath')
		
		local thisdir : pwd
		
		if strpos(`id',":") != 0 local target = "`path'"
		else local target = "`thisdir'/`path'"
		
		local thisName = substr(`id',1+`endpath',.)
		local thisName = subinstr("`thisName'",".zip","",.)
		
		noi dis as result _n "Unzipping '`thisName'.zip' from directory '`target''."
		 
		cd "`target'"
		capture confirm file "`thisName'.dta"
		if _rc ==0 local delete = 0
		else local delete = 1
		
		unzipfile "`thisName'.zip", replace
		
		use `thisName'
		if `delete'==1 rm "`thisName'.dta" 
		cd "`thisdir'"
	}
end

