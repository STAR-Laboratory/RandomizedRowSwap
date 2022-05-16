# Randomized Row Swap (ASPLOS'22)
**Paper**: Randomized Row-Swap: Mitigating Row Hammer by Breaking Spatial Correlation Between Aggressor and Victim Rows  
**Conference**: ASPLOS'22  
**Authors**: Gururaj Saileshwar (Georgia Tech), Bolin Wang (UBC), Moin Qureshi (Georgia Tech), and Prashant Nair (UBC)  

## Dependencies
* **Software**: Perl (for scripts to run experiments and collate results) and gcc (tested to compile successfully with versions: 4.8.5, 6.4.0, 8.4.0).
* **Hardware**: For running all the benchmarks, a CPU with lots of memory (128GB+) and cores (64+).
* **Traces**: Our traces (~10GB) for this simulator are available at this [link](https://www.dropbox.com/s/a6cdraqac79fg53/rrs_benchmarks.tar?dl=0). We generate them using an Intel Pintool (version 2.12), similar to this [link](https://github.com/jingpu/pintools/blob/master/source/tools/SimpleExamples/pinatrace.cpp), although traces extracted in the format mentioned below by any methodology (any Pin version) would be supported. 


## Compiling and Executing RRS and BASELINE

### Clone the artifact and run the code.

* **Fetch the code**: `git clone https://gururaj_saileshwar@bitbucket.org/prashantnair13/rrs.git`  
* **Run the artifact**: `cd rrs; ./run_artifact.sh`. This command runs all the following steps one by one. You may also follow these subsequent steps manually.

### Download Benchmarks

1. Fetch input files

     	    $ cd rrs/simscript 
     	    $ ./fetch_benchmarks.sh
     	    --> fetches the benchmarks from "https://www.dropbox.com/s/a6cdraqac79fg53/rrs_benchmarks.tar?dl=1" 

### Compile

2. Compile baseline with the following steps from the RRS folder
         
     	    $ cd rrs/src_baseline
     	    $ make clean
     	    $ make


3. Compile RRS with the following steps from the RRS folder

     	    $ cd rrs/src_rrs
     	    $ make clean
     	    $ make


### Execute

3. Run baseline with the following command from the RRS folder
         
     	    $ cd rrs/simscript
     	    $ ./runall_baseline.sh
     	    --> Note this command fires all baseline sims: ~78 of them --> takes 7-8 hours to complete.


4. Run RRS with the following command from the RRS folder         

     	    $ cd rrs/simscript
     	    $ ./runall_rrs.sh
     	    --> Note this command fires all RRS sims: ~78 of them --> takes 7-8 hours to complete.


### Collate Results

`ONLY AFTER ALL SIMULATIONS COMPLETE --> typically 15-16 hours later, you may try to collate the results`  

5. Check the performance of RRS normalized to Baseline using the following command (Fig 6).  
  
	    --> Script to collate results is in simscript. Individual results for all workloads and collated results are stored in rrs/output/    
     	    $ cd rrs/simscript

	    --> Normalized performance for workloads in the left half of Fig 6, i.e., workloads with at least one row having > 800 activations / 64ms            
            $ ./getdata.pl -s ADDED_IPC -w interest_name -n 0 -d ../output/8c_2ch_baseline/ ../output/8c_2ch_rrs/
	    
	    --> Normalized performance for workload suites in the right half of Fig 6, i.e. Averages.           
	    --> Gmean value ONLY for SPEC 2006
            $ ./getdata.pl -s ADDED_IPC -w spec2006_name -n 0 -gmean -d ../output/8c_2ch_baseline/ ../output/8c_2ch_rrs/
            
	    --> Gmean value ONLY for SPEC 2017            
            $ ./getdata.pl -s ADDED_IPC -w spec2017_name -n 0 -gmean -d ../output/8c_2ch_baseline/ ../output/8c_2ch_rrs/
            
	    --> Gmean value ONLY for GAP            
            $ ./getdata.pl -s ADDED_IPC -w gap_name -n 0 -gmean -d ../output/8c_2ch_baseline/ ../output/8c_2ch_rrs/

	    --> Gmean value ONLY for PARSEC                     
            $ ./getdata.pl -s ADDED_IPC -w parsec_name -n 0 -gmean -d ../output/8c_2ch_baseline/ ../output/8c_2ch_rrs/
            
	    --> Gmean value ONLY for BIOBENCH                                 
            $ ./getdata.pl -s ADDED_IPC -w biobench_name -n 0 -gmean -d ../output/8c_2ch_baseline/ ../output/8c_2ch_rrs/

	    --> Gmean value ONLY for COMM                              
            $ ./getdata.pl -s ADDED_IPC -w comm_name -n 0 -gmean -d ../output/8c_2ch_baseline/ ../output/8c_2ch_rrs/

	    --> Gmean value ONLY for MIX                              
            $ ./getdata.pl -s ADDED_IPC -w mix_name -n 0 -gmean -d ../output/8c_2ch_baseline/ ../output/8c_2ch_rrs/

	    --> Gmean value for ALL benchmarks                              
            $ ./getdata.pl -s ADDED_IPC -w all78 -n 0 -gmean -d ../output/8c_2ch_baseline/ ../output/8c_2ch_rrs/

	    -- These numbers should be reflective of Figure 6 -- Performance Numbers (deviations of ~1% possible due to different random number generator seed i.e. time)

### Trace Format
Our simulator uses traces of L2-Cache Misses (memory accesses filtered through the L1 and L2 cache). 

Each line in our trace has the following format and has information regarding one L2-Cache Miss:    
`< num_nonmem_ops, R/W, Address, DontCare1-4byte, DontCare2-4byte>`. We describe these fields below:  

   - **num_nonmem_ops**: This is a 4-byte int storing the number of instructions between the current and previous L2-miss. This is useful in IPC calculation.  
   - **R/W**: This is a 1-byte char that encodes whether the L2-miss is a read request ('R') to L3, or a write-back request to L3 ('W').  
   - **Address:** This is am 8-byte long long int, that stores the 64-byte line-address accessed (virtual address).  
   - **DontCare1-4byte**, **DontCare2-4byte**: These fields are ignored by the simulator (can be 0s in the trace).  

#### Information on Trace Generation
We use Intel Pintool to instrument execution of a program and get its memory accesses (similar to the intel starter [pintool](https://github.com/jingpu/pintools/blob/master/source/tools/SimpleExamples/pinatrace.cpp), here is a useful [guide](https://mahmoudhatem.wordpress.com/2016/11/07/tracing-memory-access-of-an-oracle-process-intel-pintools/) to understand this). We obtain the memory accesses for a representative section of the program and filter the memory accesses through a two level non-inclusive cache hierarchy implemented within the pintool, to obtain the L2-Miss Trace. We produce the trace file by writing each line of the trace to a compressed file stream. We generated the traces for SPEC 2k6, 2k17 and GAP using this methodology and reformatted the traces for PARSEC and COMM provided the USIMM distribution ([link](http://utaharch.blogspot.com/2012/02/usimm.html)). Our traces we used for this project are available at: https://www.dropbox.com/s/a6cdraqac79fg53/rrs_benchmarks.tar?dl=0.