#!/bin/bash

##########
## SET FIRE-WIDTH FOR RUNNING WORKLOADS
## (number of processes to run at a time)
firewidth=80
##########
 
## 1. Fetch Input Files
echo "###################"
echo "1. Fetching Input Files"
echo "###################"
echo ""
echo "--> Note: this will download 10GB tar file and occupy 20GB disk-space"
cd simscript 
./fetch_bmarks.sh #  --> fetches the benchmarks from "https://www.dropbox.com/s/a6cdraqac79fg53/rrs_benchmarks.tar?dl=1"
cd .. ;

## 2. Compile the Baseline
echo "---------------------------"
echo ""
echo "#####################"
echo "2. Compiling Baseline"
echo "#####################"
echo ""
cd src_baseline
make clean; make;
cd .. ;

## 3. Compiling RRS
echo "---------------------------"
echo ""
echo "#####################"
echo "3. Compiling RRS"
echo "#####################"
echo ""
cd src_rrs
make clean; make;
cd .. ;

## 4. Running Baseline
echo "---------------------------"
echo ""
echo "#####################"
echo "4. Running Baseline"
echo "#####################"
echo ""
echo "--> Note this fires all baseline sims: ~78 of them --> takes 7-8 hours to complete."
echo ""
cd simscript
./runall_baseline.pl --w 8c_2ch_ALL_78_WL --i ALL_78_WL_name --f $firewidth --d "../output/8c_2ch_baseline" --o "2"
##./runall_baseline.pl   --w 8c_2ch_WL_INTEREST --i WL_INTEREST_name --f $firewidth --d "../output/8c_2ch_baseline" --o "2"
cd ../ ;

## wait for baseline runs to finish
i=0
while [ `ps -aux | grep sim_baseline.bin | grep -v "grep" | wc -l` -gt 0 ] ; do
    num_running=`ps -aux | grep sim_baseline.bin | grep -v "grep" | wc -l`
    mins=$(( 10*i ))
    echo "Time Elapsed: ${mins} minutes. Workloads Running: ${num_running}/78";
    echo "";
    sleep 600s;
    ((i=i+1));
done
echo "Baseline Runs Completed!"


## 5. Running RRS
echo "---------------------------"
echo ""
echo "###################"
echo "5. Running RRS"
echo "###################"
echo ""
"--> Note this fires all RRS sims: ~78 of them --> takes 7-8 hours to complete."
echo ""
cd simscript
./runall_rrs.pl --w 8c_2ch_ALL_78_WL --i ALL_78_WL_name --f $firewidth --d "../output/8c_2ch_rrs" --o "2"
##./runall_rrs.pl --w   8c_2ch_WL_INTEREST --i WL_INTEREST_name --f $firewidth --d "../output/8c_2ch_rrs" --o "2"
cd ../ ;

## wait for RRS runs to finish
i=0
while [ `ps -aux | grep sim_rrs.bin | grep -v "grep" | wc -l` -gt 0 ] ; do
    num_running=`ps -aux | grep sim_rrs.bin | grep -v "grep" | wc -l`
    mins=$(( 10*i ))
    echo "Time Elapsed: ${mins} minutes. Workloads Running: ${num_running}/78";
    echo "";
    sleep 600s;
    ((i=i+1));
done
echo "RRS Runs Completed!"


## 6. Collate Results
echo "---------------------------"
echo ""
echo "###################"
echo "6. Collating Results"
echo "###################"
echo ""

cd simscript

# Normalized Perf. of RRS for Workloads with at least one row having > 800 activations / 64ms            
perl getdata.pl -s ADDED_IPC -w interest_name -n 0 -printmask 0-1  -d ../output/8c_2ch_baseline/ ../output/8c_2ch_rrs/

# Normalized Perf. of RRS (Gmean) for SPEC-2006, SPEC-2017, GAP, PARSEC, BIOBENCH, COMM, MIX, ALL-78     
echo ""       
perl getdata.pl -s ADDED_IPC -w spec2006_name -n 0  -nh -printmask 0-1 -gmean -ns -d ../output/8c_2ch_baseline/ ../output/8c_2ch_rrs/  | sed 's/Gmean/SPEC2K6-29/'  | tail -n1 
perl getdata.pl -s ADDED_IPC -w spec2017_name -n 0  -nh -printmask 0-1 -gmean -ns -d ../output/8c_2ch_baseline/ ../output/8c_2ch_rrs/  | sed 's/Gmean/SPEC2K17-22/' | tail -n1 
perl getdata.pl -s ADDED_IPC -w gap_name -n 0       -nh -printmask 0-1 -gmean -ns -d ../output/8c_2ch_baseline/ ../output/8c_2ch_rrs/  | sed 's/Gmean/GAP-6/'	    | tail -n1 
perl getdata.pl -s ADDED_IPC -w parsec_name -n 0    -nh -printmask 0-1 -gmean -ns -d ../output/8c_2ch_baseline/ ../output/8c_2ch_rrs/  | sed 's/Gmean/PARSEC-5/'    | tail -n1 
perl getdata.pl -s ADDED_IPC -w biobench_name -n 0  -nh -printmask 0-1 -gmean -ns -d ../output/8c_2ch_baseline/ ../output/8c_2ch_rrs/  | sed 's/Gmean/BIOBENCH-2/'  | tail -n1 
perl getdata.pl -s ADDED_IPC -w comm_name -n 0      -nh -printmask 0-1 -gmean -ns -d ../output/8c_2ch_baseline/ ../output/8c_2ch_rrs/  | sed 's/Gmean/COMM-5/'      | tail -n1 
perl getdata.pl -s ADDED_IPC -w mix_name -n 0       -nh -printmask 0-1 -gmean -ns -d ../output/8c_2ch_baseline/ ../output/8c_2ch_rrs/  | sed 's/Gmean/MIX-6/'	    | tail -n1 
perl getdata.pl -s ADDED_IPC -w all78 -n 0          -nh -printmask 0-1 -gmean -ns -d ../output/8c_2ch_baseline/ ../output/8c_2ch_rrs/  | sed 's/Gmean/ALL-78/'      | tail -n1 
