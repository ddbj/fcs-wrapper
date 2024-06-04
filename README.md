# FCS-wrapper

## Prerequisite

Download or put following 2 files from official site to current directory or create symbolic link.

- fcs.py
- fcs-gx.sif

## How to execute

```console
Usage: ./fcs-wrapper.sh [--outdir /path/to/outdirdir] fasta_file_path taxid
          --outdir output directory  Default: same path of fasta file
                                       this script create directory which name is 'fcx-gx'
                                       all output files will be output to 'fcs-gx'

```

- fasta\_file\_path
  - Input FASTA file
- taxid
  - taxid for Input FASTA file

### Output file

#### Default location about output directory

Input file (fasta\_file\_path) is located following

```
$ tree NSUB000020/
NSUB000020/
└── 20240527-105300
    └── GCA_012927515.1_ASM1292751v1_genomic.fna.gz

1 directory, 1 file
```

Execute fcs-wrapper.sh

```
./fcs-wrapper.sh /home/xxx/NSUB000020/20240527-105300/GCA_012927515.1_ASM1292751v1_genomic.fna.gz 40001
```

Result is following

```
$ tree NSUB000020/
NSUB000020/
├── 20240527-105300
│   └── GCA_012927515.1_ASM1292751v1_genomic.fna.gz
└── fcs-gx
    ├── GCA_012927515.1_ASM1292751v1_genomic.fna.40001.fcs_gx_report.txt
    ├── GCA_012927515.1_ASM1292751v1_genomic.fna.40001.taxonomy.rpt
    ├── status.txt
    ├── stderr.txt
    └── stdout.txt

2 directories, 6 files
```

#### Location when an output directory is specified

Input file (fasta\_file\_path) is located following

```
$ tree NSUB000020/
NSUB000020/
└── 20240527-105300
    └── GCA_012927515.1_ASM1292751v1_genomic.fna.gz

1 directory, 1 file
```

Execute fcs-wrapper.sh with `--outdir` option


```
./fcs-wrapper.sh --outdir 40001_outputdir \
  /home/xxx/NSUB000020/20240527-105300/GCA_012927515.1_ASM1292751v1_genomic.fna.gz 40001
```


After execution, no directories and files are created under input directory.

```
manabu@at096:~/work/2023/FCS/benchmark/benchmark202405_data1$ tree NSUB000020/
NSUB000020/
└── 20240527-105300
    └── GCA_012927515.1_ASM1292751v1_genomic.fna.gz

1 directory, 1 file
```

`40001_ouputdir` looks like this.
`fcs-gx` is created and all output files are located there.

```
manabu@at096:~/work/2023/FCS/benchmark/benchmark202405_data1$ tree 40001_outputdir/
40001_outputdir/
└── fcs-gx
    ├── GCA_012927515.1_ASM1292751v1_genomic.fna.40001.fcs_gx_report.txt
    ├── GCA_012927515.1_ASM1292751v1_genomic.fna.40001.taxonomy.rpt
    ├── status.txt
    ├── stderr.txt
    └── stdout.txt

1 directory, 5 files
```

