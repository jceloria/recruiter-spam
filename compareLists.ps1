<#
		.SYNOPSIS
		Compares a mail filters file against an exported filters filter

		.Description
		This PowerShell script will compare two CSV files and generate a new one with
		just the differences. This can be helpful for updating a ZOHO blocked domain list.
		
		.INPUTS
		Two CSV files. The first should be the "mailFilters.csv" file. The second should be a comparsion file, like "Blocked_Domains.csv"
		
		.OUTPUTS
		A CSV file with the list of emails formatted for importing into Gmail or other inbox systems and marking them as spam.
		
		.PARAMETER mailFilters
		The current generated mail filters CSV file from the list.txt file in this repo
		
		.PARAMETER blockedDomains
		The exported list of domains from your mail system; ZOHO calls this "Blocked_Domains.csv" by default.
		
		.EXAMPLE
		PS> .\compare_lists.ps1
		-> default options used of 'mailFilter.csv' and 'Blocked_Domains.csv'
		
		.EXAMPLE
		PS> .\genfilter.ps1 "list.txt" "xml" "mailFilters2.xml"
		-> default file input / export file format, but the output file is called "mailFilters2.xml"
		
		.LINK
		The GitHub repo for this script can found here: https://github.com/jceloria/recruiter-spam
		
		.NOTES
		Created by Jason Downing, original PowerShell script/lists by John Celoria
#> 

param (
    [string] $mailFilters = "mailFilters.csv",
    [string] $blockedDomains = "Blocked_Domains.csv",
		[string] $outfile = ".\mailFilters_diffs.csv"
)

function Generate-CSV {
    foreach($line in Get-Content $list) {
        $file += $line + "`n"
    }

    $file.TrimEnd("\n")
}

function compareCSV_Files {
	# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/compare-object?view=powershell-7.1
	
	$file1 = import-csv $mailFilters
	$file2 = import-csv $blockedDomains
	
	$objects = @{
		ReferenceObject = (Get-Content $mailFilters)
		DifferenceObject = (Get-Content $blockedDomains)
	}
	
	# This had some helpful tips in the comments, which is how I finally got the file name extracted.
	# https://stackoverflow.com/questions/36556181/powershell-extract-inputobject-data-from-compare-object-while-comparing-2-csv
	foreach ($line in Compare-Object @objects) {
    $line | Select-Object -ExpandProperty InputObject
	}
	
}

compareCSV_Files | Tee-Object -FilePath $outfile