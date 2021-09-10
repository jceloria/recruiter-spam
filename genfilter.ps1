# Docs on how to add to the Get-Help menu:
# https://docs.microsoft.com/en-us/powershell/scripting/developer/help/examples-of-comment-based-help?view=powershell-7.1

<#
		.SYNOPSIS
		Generate a mail filters file for blocking Evil Recruiter Spam

		.Description
		This PowerShell script will generate either Gmail style mail filters (in XML format)
		or CSV style mail filters (perfect for ZOHO and perhaps other mail providers)
		
		By default, the "list.txt" file will be consumed and a mailFilters.xml file will
		be generated. This is ideal for Gmail filter imports. You can optionally provide
		a different file name or path, a file format (currently "csv" or "default" which is XML),
		and and output file path/name. The default output file is mailFilter.<file extension here>,
		such as mailFilter.xml or mailFilters.csv
		
		.INPUTS
		Text file containing a list of emails to mark as spam. This file should be newline separated.
		
		.OUTPUTS
		Either an XML file (default option) or a CSV file with the list of emails formatted for importing into Gmail or other inbox systems and marking them as spam.
		
		.PARAMETER list
		Specifices the email list of spammers for this script to consume
		
		.PARAMETER format
		Specifices the file format to generate; currently 'default' is XML, 'csv' is CSV
		
		.PARAMETER outfile
		Specifics the output file path/name. By default the file is named ".\mailFilters.$format"
		
		.EXAMPLE
		PS> .\genfilter.ps1
		-> default options used of 'list.txt', 'xml' and 'mailFilter.xml'
		
		.EXAMPLE
		PS> .\genfilter.ps1 "list.txt" "xml" "mailFilters2.xml"
		-> default file input / export file format, but the output file is called "mailFilters2.xml"
		
		.EXAMPLE
		PS> .\genfilter.ps1 "list.txt" "csv" "mailFilters.csv"
		-> generates a CSV file called mailFilters.csv in the same directory
		
		.LINK
		The GitHub repo for this script can found here: https://github.com/jceloria/recruiter-spam
		
		.NOTES
		Created by John Celoria; this help added by Jason Downing
#> 

param (
    [string] $list = ".\list.txt",
    [string] $format = "xml",
    [string] $outfile = ".\mailFilters.$format"
)

function Generate-XML {
    $file = @"
<?xml version='1.0' encoding='UTF-8'?><feed xmlns='http://www.w3.org/2005/Atom' xmlns:apps='http://schemas.google.com/apps/2006'>

"@

    foreach($line in Get-Content $list) {
        $file += @"
    <entry>
        <category term='filter'></category>
        <title>Mail Filter</title>
        <apps:property name='from' value='$line'/>
        <apps:property name='shouldTrash' value='true'/>
        <apps:property name='sizeOperator' value='s_sl'/>
        <apps:property name='sizeUnit' value='s_smb'/>
    </entry>

"@
    }

    $file += @"
</feed>
"@

    $file
}

function Generate-CSV {
    foreach($line in Get-Content $list) {
        $file += $line + ","
    }

    $file.TrimEnd(",")
}

switch ($format) {
    "csv"   { Generate-CSV | Tee-Object -FilePath $outfile; break }
    default { Generate-XML | Tee-Object -FilePath $outfile; break }
}
