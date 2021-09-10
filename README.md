# recruiter-spam
Gmail filter for recruiter domains

Pull requests are more than welcome!

#### [genfilter.sh](genfilter.sh):
```
$─► ./genfilter.sh --help
Usage: genfilter.sh [OPTION]...
Generate a Gmail filter from a list of domains

  -h, --help     Display this help message and exit
  -l, --list     The list of domains/emails to read (default: list.txt)
  -f, --format   The output format (default: xml)
  -o, --outfile  The output file name (default: mailFilters.xml)

```

#### [genfilter.ps1](genfilter.ps1):
```
PS /> Get-Help ./genfilter.ps1

NAME
    ./genfilter.ps1

SYNOPSIS


SYNTAX
    ./genfilter.ps1 [[-list] <String>] [[-format] <String>] [[-outfile] <String>]
    [<CommonParameters>]


DESCRIPTION


RELATED LINKS

REMARKS
    To see the examples, type: "Get-Help ./genfilter.ps1 -Examples"
    For more information, type: "Get-Help ./genfilter.ps1 -Detailed"
    For technical information, type: "Get-Help ./genfilter.ps1 -Full"
```
