#!/bin/bash
set -u


CORES=63
GXDB_LOC=/data1/my_tmpfs

# Parse optional parameters
OUTDIR=""
while [[ "$#" -gt 2 ]]; do
  case $1 in
    --outdir)
      outdir=$2
      shift 2
      ;;
    *)
      echo "Unknown parameter: $1"
      exit 1
      ;;
  esac
done


#
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <fasta_file_path> <taxid>"
  exit 1
fi
FILEPATH=$1
SPECIES_TAXID=$2
if [ ! -f "$FILEPATH" ]; then
  echo "FASTA FILE [$FILE_PATH] does not exist"
  exit 1
fi

if [ ! -d "${GXDB_LOC}" ]; then
  echo "Directory of reference files are missing [${GXDB_LOC}]. Maybe initialized, please place it."
  exit 1
fi


TARGETFILEBASENAME=$(basename ${FILEPATH})
TARGETFILEDIRNAME=$(dirname ${FILEPATH} | xargs basename)
OUTPUTBASE=$(dirname ${FILEPATH} | xargs dirname)

# Set value for OUTDIR if it is empty
if [ -z "${OUTDIR}" ]; then
  OUTDIR=${OUTPUTBASE}/fcs-gx/
fi
STATSDIR=${OUTDIR}


# Copy to data1
DATA1INPUTFILEPATH=/data1/input/fcs-gx/${TARGETFILEDIRNAME}_${TARGETFILEBASENAME}

# Create directory
if [ ! -d "${DATA1INPUTFILEPATH}" ]; then
  mkdir -p ${DATA1INPUTFILEPATH}
fi

# Copy file to /data1
cp ${FILEPATH} ${DATA1INPUTFILEPATH}

# Create output dir
if [ ! -d "${OUTDIR}" ]; then
  mkdir -p ${OUTDIR}
fi
if [ ! -d "${STATSDIR}" ]; then
  mkdir -p ${STATSDIR}
fi


# status file
STATUSFILE=${STATSDIR}/status.txt
echo "-1" > ${STATUSFILE}
# stdout and stderr
STDOUTFILE=${STATSDIR}/stdout.txt
STDERRFILE=${STATSDIR}/stderr.txt

FCS_DEFAULT_IMAGE=fcs-gx.sif GX_NUM_CORES=${CORES} python3 ./fcs.py screen genome --fasta ${FILEPATH} --out-dir ${OUTDIR} --gx-db "$GXDB_LOC/gxdb" --tax-id ${SPECIES_TAXID} > ${STDOUTFILE} 2> ${STDERRFILE}

STATUSCODE=$?
echo ${STATUSCODE} > ${STATUSFILE}
exit ${STATUSCODE}

