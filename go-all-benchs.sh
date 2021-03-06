#!/bin/bash

FILE='./go_all.json'
PRE_JSON='
{
  "cpu_models": [
    {
      "name": "Cortex-A9",
      "frequency": 1200,
      "dual_issue": true,
      "instruction": {
        "B": 1,
        "BL": 1,
        "BLX": 1,
        "BX": 1,
        "BXJ": 1,
        "ADC": 1,
        "ADD": 1,
        "AND": 1,
        "BIC": 1,
        "CMN": 1,
        "CMP": 1,
        "EOR": 1,
        "MOV": 1,
        "MVN": 1,
        "ORR": 1,
        "RSB": 1,
        "RSC": 1,
        "SBC": 1,
        "SUB": 1,
        "TEQ": 1,
        "TST": 1,
        "MUL": 2,
        "MULS": 2,
        "MLA": 2,
        "MLAS": 2,
        "SMLAXY": 1,
        "SMLAL": 3,
        "SMLALS": 3,
        "SMLALXY": 2,
        "SMLAWY": 1,
        "SMUAD": 1,
        "SMUSD": 1,
        "SMLAD": 1,
        "SMLSD": 1,
        "SMLALD": 2,
        "SMLSLD": 2,
        "SMMLA": 2,
        "SMMLS": 2,
        "SMMUL": 2,
        "SMULXY": 1,
        "SMULL": 3,
        "SMULLS": 3,
        "SMULWY": 1,
        "UMAAL": 3,
        "UMLAL": 3,
        "UMLALS": 3,
        "UMULL": 3,
        "UMULLS": 3,
        "QADD": 2,
        "QDADD": 3,
        "QADD16": 2,
        "QADDSUBX": 1,
        "QSUBADDX": 1,
        "QSUB16": 2,
        "QADD8": 2,
        "QSUB8": 2,
        "QSUB": 2,
        "QDSUB": 3,
        "SADD16": 1,
        "SADDSUBX": 1,
        "SSUBADDX": 1,
        "SSUB16": 1,
        "SADD8": 1,
        "SSUB8": 1,
        "SHADD16": 2,
        "SHADDSUBX": 1,
        "SHSUBADDX": 1,
        "SHSUB16": 2,
        "SHADD8": 2,
        "SHSUB8": 2,
        "UADD16": 1,
        "UADDSUBX": 1,
        "USUBADDX": 1,
        "USUB16": 1,
        "UADD8": 1,
        "USUB8": 1,
        "UHADD16": 2,
        "UHADDSUBX": 1,
        "UHSUBADDX": 1,
        "UHSUB16": 2,
        "UHADD8": 2,
        "UHSUB8": 2,
        "UQADD16": 2,
        "UQADDSUBX": 1,
        "UQSUBADDX": 1,
        "UQSUB16": 2,
        "UQADD8": 2,
        "UQSUB8": 2,
        "SXTAB16": 3,
        "SXTAB": 3,
        "SXTAH": 3,
        "SXTB16": 2,
        "SXTB": 2,
        "SXTH": 2,
        "UXTAB16": 3,
        "UXTAB": 3,
        "UXTAH": 3,
        "UXTB16": 2,
        "UXTB": 2,
        "UXTH": 2,
        "CLZ": 1,
        "USAD8": 1,
        "USADA8": 1,
        "PKH": 1,
        "PKHBT": 1,
        "PKHTB": 1,
        "REV": 1,
        "REV16": 1,
        "REVSH": 1,
        "SEL": 1,
        "SSAT": 1,
        "SSAT16": 1,
        "USAT": 3,
        "USAT16": 1,
        "MRS": 2,
        "MSR": 1,
        "CPS": 1,
        "SETEND": 1,
        "LDR": 1,
        "LDRB": 2,
        "LDRBT": 1,
        "LDRD": 1,
        "LDREX": 1,
        "LDRH": 2,
        "LDRSB": 2,
        "LDRSH": 1,
        "LDRT": 1,
        "STR": 1,
        "STRB": 2,
        "STRBT": 1,
        "STRD": 1,
        "STREX": 1,
        "STRH": 2,
        "STRT": 1,
        "LDM1": 1,
        "LDM2": 1,
        "LDM3": 1,
        "STM1": 1,
        "STM2": 1,
        "SWP": 1,
        "SWPB": 1,
        "BKPT": 1,
        "SWI": 1,
        "CDP": 1,
        "LDC": 1,
        "MCR": 1,
        "MCRR": 1,
        "MRC": 1,
        "MRRC": 1,
        "STC": 1,
        "PLD": 1,
        "RFE": 1,
        "SRS": 1,
        "MCRR2": 1,
        "MRRC2": 1,
        "STC2": 1,
        "LDC2": 1,
        "CDP2": 1,
        "MCR2": 1,
        "MRC2": 1,
        "COPROCESSOR": 1,
        "NEON_DP": 1,
        "NEON_LS": 1,
        "CLREX": 1,
        "DSB": 1,
        "DMB": 1,
        "ISB": 1,
        "MOVW": 1,
        "MOVT": 1,
        "UNKNOWN": 0,
        "NOT_INSTRUMENTED": 0,
        "TOTAL_COUNTS": 0,
        "VFP_COPROCESSOR": 0
      },
      "vfp_instruction_file": {
        "cycle": {
          "FABSD": 1,
          "FABSS": 1,
          "FADDD": 1,
          "FADDS": 1,
          "FCMPD": 1,
          "FCMPS": 1,
          "FCMPED": 1,
          "FCMPES": 1,
          "FCMPEZD": 1,
          "FCMPEZS": 1,
          "FCMPZD": 1,
          "FCMPZS": 1,
          "FCPYD": 1,
          "FCPYS": 1,
          "FCVTDS": 1,
          "FCVTSD": 1,
          "FDIVD": 28,
          "FDIVS": 14,
          "FLDD": 2,
          "FLDS": 1,
          "FLDMD": 2,
          "FLDMS": 1,
          "FLDMX": 2,
          "FMACD": 2,
          "FMACS": 1,
          "FMDHR": 1,
          "FMDLR": 1,
          "FMDRR": 1,
          "FMRDH": 1,
          "FMRDL": 1,
          "FMRRD": 1,
          "FMRRS": 1,
          "FMRS": 1,
          "FMRX": 1,
          "FMSCD": 2,
          "FMSCS": 1,
          "FMSR": 1,
          "FMSRR": 1,
          "FMSTAT": 1,
          "FMULD": 2,
          "FMULS": 1,
          "FMXR": 1,
          "FNEGD": 1,
          "FNEGS": 1,
          "FNMACD": 2,
          "FNMACS": 1,
          "FNMSCD": 2,
          "FNMSCS": 1,
          "FNMULD": 2,
          "FNMULS": 1,
          "FSITOD": 1,
          "FSITOS": 1,
          "FSQRTD": 28,
          "FSQRTS": 14,
          "FSTD": 2,
          "FSTS": 1,
          "FSTMD": 2,
          "FSTMS": 1,
          "FSTMX": 2,
          "FSUBD": 1,
          "FSUBS": 1,
          "FTOSID": 1,
          "FTOSIS": 1,
          "FTOUID": 1,
          "FTOUIS": 1,
          "FTOUIZD": 1,
          "FTOUIZS": 1,
          "FTOUSIZD": 1,
          "FTOUSIZS": 1,
          "FUITOD": 1,
          "FUITOS": 1,
          "UNKNOWN": 0,
          "NOT_INSTRUMENTED": 0,
          "TOTAL_COUNTS": 0
        },
        "latency": {
          "FABSD": 4,
          "FABSS": 4,
          "FADDD": 4,
          "FADDS": 4,
          "FCMPD": 4,
          "FCMPS": 4,
          "FCMPED": 4,
          "FCMPES": 4,
          "FCMPEZD": 4,
          "FCMPEZS": 4,
          "FCMPZD": 4,
          "FCMPZS": 4,
          "FCPYD": 4,
          "FCPYS": 4,
          "FCVTDS": 4,
          "FCVTSD": 4,
          "FDIVD": 31,
          "FDIVS": 17,
          "FLDD": 5,
          "FLDS": 4,
          "FLDMD": 5,
          "FLDMS": 4,
          "FLDMX": 5,
          "FMACD": 5,
          "FMACS": 4,
          "FMDHR": 2,
          "FMDLR": 2,
          "FMDRR": 1,
          "FMRDH": 1,
          "FMRDL": 1,
          "FMRRD": 1,
          "FMRRS": 1,
          "FMRS": 1,
          "FMRX": 1,
          "FMSCD": 5,
          "FMSCS": 4,
          "FMSR": 2,
          "FMSRR": 1,
          "FMSTAT": 2,
          "FMULD": 5,
          "FMULS": 4,
          "FMXR": 2,
          "FNEGD": 4,
          "FNEGS": 4,
          "FNMACD": 5,
          "FNMACS": 4,
          "FNMSCD": 5,
          "FNMSCS": 4,
          "FNMULD": 5,
          "FNMULS": 4,
          "FSITOD": 4,
          "FSITOS": 4,
          "FSQRTD": 31,
          "FSQRTS": 17,
          "FSTD": 4,
          "FSTS": 3,
          "FSTMD": 4,
          "FSTMS": 3,
          "FSTMX": 4,
          "FSUBD": 4,
          "FSUBS": 4,
          "FTOSID": 4,
          "FTOSIS": 4,
          "FTOUID": 4,
          "FTOUIS": 4,
          "FTOUIZD": 4,
          "FTOUIZS": 4,
          "FTOUSIZD": 4,
          "FTOUSIZS": 4,
          "FUITOD": 4,
          "FUITOS": 4,
          "UNKNOWN": 0,
          "NOT_INSTRUMENTED": 0,
          "TOTAL_COUNTS": 0
        }
      }
    }
  ],
  "gpu_models": [
    {
      "name": "Kaveri",
      "frequency": 1000
    }
  ],
  "cache_models": [

'
POST_JSON='
],
  "branch_models": [
    {
      "name": "two bits",
      "miss latency": 11
    },
    {
      "name": "one bit",
      "miss latency": 11
    }
  ],
  "SET": {
    "timing_model": 5
  }
}
'
CACHE_JSON='
{
      "name": "dinero",
      "levels": 2,
      "memory_ns": 110,
      "l1 miss latency": 20,
      "l2 miss latency": 37,
      "topology": [
        {
          "name": "CPU L2",
          "blocksize": 64,
          "subblocksize": 64,
          "size": 1048576,
          "assoc": 4,
          "split_3c_cnt": 0,
          "replacement": "LRU",
          "prefetch": "SUB_BLOCK",
          "prefetch_distance": 1,
          "prefetch_abortpercent": 0,
          "walloc": "ALWAYS",
          "wback": "ALWAYS",
          "next": {
            "d-cache": {
              "processor": "CPU",
              "blocksize": 32,
              "subblocksize": 32,
              "size": 32768,
              "assoc": 4,
              "split_3c_cnt": 0,
              "replacement": "RANDOM",
              "prefetch": "DEMAND_ONLY",
              "prefetch_distance": 32,
              "prefetch_abortpercent": 0,
              "walloc": "NEVER",
              "wback": "ALWAYS"
            },
            "i-cache": {
              "processor": "CPU",
              "blocksize": 32,
              "subblocksize": 32,
              "size": 32768,
              "assoc": 4,
              "split_3c_cnt": 0,
              "replacement": "RANDOM",
              "prefetch": "DEMAND_ONLY",
              "prefetch_distance": 32,
              "prefetch_abortpercent": 0,
              "walloc": "NEVER",
              "wback": "ALWAYS"
            }
          }
        }
      ]
    },
'

EXTRA_FLAGS=

function do_single {
    #Prepare json config file
    echo $PRE_JSON > $FILE
    for (( i=0; i<$1; i++ ));
    do
        echo $CACHE_JSON >> $FILE
    done
    echo $POST_JSON >> $FILE

    #Execute and find average value
    T=$(./do_test.expect "./profile.sh $EXTRA_FLAGS \"$2\" > /dev/null" $3 \
        | grep -e "MIPS *:" \
        | awk '{ sum += $3; n++ } END { if (n > 0) print sum / n; }');

    #return value
    echo "$T";
}

function do_set {
    killall qemu-system-arm -9 2> /dev/null
    killall cache-simulators -9 2> /dev/null
    sleep 1

    LOOP="1 2 4 6 8"
    out=$(make -j8 2>&1)
    echo "Program: $1"
    echo "#Times:  $2"
    echo "Average Execution Time of $LOOP multi-cache(s) in csv format:"
    printf "$(basename ${1}), "
    for i in ${LOOP};
    do
       AVG=$(do_single $i "$1" "$2")
       printf "$AVG, "
    done
    printf "\n"
}

function do_all {
    do_set "./test_set/bench/basicmath/basicmath_small.arm" 5
    sleep 5
    do_set "./test_set/bench/bitcnts/bitcnts.arm 750000" 5
    sleep 5
    do_set "./test_set/bench/dijkstra/dijkstra_large.arm ./test_set/bench/dijkstra/dijkstra_input.dat" 5
    sleep 5
    do_set "./test_set/bench/fft/fft.arm  64 1024" 5
    sleep 5
    do_set "./test_set/bench/patricia/patricia.arm ./test_set/bench/patricia/large.udp" 5
    sleep 5
    do_set "./test_set/bench/qsort/qsort_large.arm ./test_set/bench/qsort/qsort_input_large.dat" 5
    sleep 5
    do_set "./test_set/bench/sha/sha.arm ./test_set/bench/sha/sha_input_large.asc" 5
    sleep 5
    do_set "./test_set/bench/stringsearch/search_large.arm" 5
    sleep 5
    do_set "./test_set/matrix" 5
}


do_all
EXTRA_FLAGS=--jit
do_all

