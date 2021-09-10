$DOMAIN_LIST = if ($env:DOMAIN_LIST) { $env:DOMAIN_LIST } else { ".\list.txt" };
$OUTPUT_FILE = if ($env:OUTPUT_FILE) { $env:OUTPUT_FILE } else { ".\mailFilters.xml" };

$xml = @"
<?xml version='1.0' encoding='UTF-8'?><feed xmlns='http://www.w3.org/2005/Atom' xmlns:apps='http://schemas.google.com/apps/2006'>

"@

foreach($line in Get-Content $DOMAIN_LIST) {
    $xml += @"
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

$xml += @"
</feed>
"@

$xml | Tee-Object -FilePath $OUTPUT_FILE
