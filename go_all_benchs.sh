#!/bin/bash

FILE='../vpmu/vpmu_config/default.json'
PRE_JSON='
{
  "SET": {
    "timing_model": 5
  },
  "cpu_model": {
    "name": "Cortex-A9",
    "frequency": 1000,
    "dual_issue": 1
  },
  "gpu_model": {
    "name": "Kaveri",
    "frequency": 1000
  },
  "vfp_instruction_file": "default-vfp-model.json",
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
  "cache": [

'
POST_JSON='

  ],
  "branch": [
    {"name": "two_bits"},
    {"name": "one_bit"}
  ]
}
'
CACHE_JSON='

    {
      "name": "dinero",
      "program_path": "",
      "levels": 2,
      "l1_cache_miss_lat": 30,
      "l2_cache_miss_lat": 110,
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
              "size": 16384,
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
              "size": 16384,
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


git checkout ../vpmu/vpmu_config/default.json
do_all
EXTRA_FLAGS=--jit
git checkout ../vpmu/vpmu_config/default.json
do_all
git checkout ../vpmu/vpmu_config/default.json

#git checkout ../vpmu/vpmu_config/default.json
#git checkout master
#out=$(make clean 2>&1)
#do_all

#git checkout ../vpmu/vpmu_config/default.json
#git checkout test_buffer
#do_all

#git checkout ../vpmu/vpmu_config/default.json
#git checkout test_no_buffer
#do_all

#echo "Direct"
#git checkout ../vpmu/vpmu_config/default.json
#git checkout d140f6f1d14d5ba94cc02f23901dd708a8365986
#out=$(make clean 2>&1)
#do_all

#echo "Local buffer"
#git checkout ../vpmu/vpmu_config/default.json
#git checkout 1c58685d1e9ae58dd955c65f3f626eb3b3d9b9b2
#out=$(make clean 2>&1)
#make clean
#do_all

#git checkout ../vpmu/vpmu_config/default.json

