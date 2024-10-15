# recruiter-spam
A jsonnet config generator for [gmailctl](https://github.com/mbrt/gmailctl) to create Gmail filters for recruiter domains.

Pull requests are more than welcome!

#### [genconig.sh](genconig.sh):
```
$─► ./genconig.sh --help
Usage: genconig.sh [OPTION]...
Generate a jsonnet config for gmailctl from a list of domains.

  -h, --help     Display this help message and exit
  -l, --list     The list of domains/emails to read (default: list.txt)
  -o, --outfile  The output file name (default: mailFilters.xml)

```
