<# .SYNOPSIS #>
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
