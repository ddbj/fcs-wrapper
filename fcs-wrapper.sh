#!/bin/bash
set -u


CORES=63
GXDB_LOC=/data1/my_tmpfs

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


TARGETFILEBASENAME=$(basename ${FILEPATH})
TARGETFILEDIRNAME=$(dirname ${FILEPATH} | xargs basename)
OUTPUTBASE=$(dirname ${FILEPATH} | xargs dirname)
OUTDIR=${OUTPUTBASE}/fcs-gx/
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

