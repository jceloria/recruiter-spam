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
PS> get-help .\genfilter.ps1

NAME
    ./genfilter.ps1

SYNOPSIS
    Generate a mail filters file for blocking Evil Recruiter Spam


SYNTAX
    ./genfilter.ps1 [[-list] <String>] [[-format] <String>] [[-outfile] <String>] [<CommonParameters>]


DESCRIPTION
    This PowerShell script will generate either Gmail style mail filters (in XML format)
    or CSV style mail filters (perfect for ZOHO and perhaps other mail providers)

    By default, the "list.txt" file will be consumed and a mailFilters.xml file will
    be generated. This is ideal for Gmail filter imports. You can optionally provide
    a different file name or path, a file format (currently "csv" or "default" which is XML),
    and and output file path/name. The default output file is mailFilter.<file extension here>,
    such as mailFilter.xml or mailFilters.csv


RELATED LINKS
    The GitHub repo for this script can found here: https://github.com/jceloria/recruiter-spam

REMARKS
    To see the examples, type: "get-help F:\Code\recruiter-spam\genfilter.ps1 -examples".
    For more information, type: "get-help F:\Code\recruiter-spam\genfilter.ps1 -detailed".
    For technical information, type: "get-help F:\Code\recruiter-spam\genfilter.ps1 -full".
    For online help, type: "get-help F:\Code\recruiter-spam\genfilter.ps1 -online"
```
