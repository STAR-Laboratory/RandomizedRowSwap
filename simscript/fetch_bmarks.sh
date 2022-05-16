#!/bin/bash

# Fetch the benchmarks from "https://www.dropbox.com/s/a6cdraqac79fg53/rrs_benchmarks.tar?dl=1"
wget -O rrs_bmarks.tar  "https://www.dropbox.com/s/a6cdraqac79fg53/rrs_benchmarks.tar?dl=1"

# Unpack benchmarks
tar -xvf rrs_bmarks.tar; 

# Clear Older Benchmark Folders
cd ../input ; rm -rf BIOBENCH  COMM  GAP  PARSEC  SPEC2K17  SPEC2K6
cd .. ;

# Move benchmarks to input
cd simscript/rrs_benchmarks; mv BIOBENCH  COMM  GAP  PARSEC  SPEC2K17  SPEC2K6 ../../input/.
cd ..
rm -rf rrs_benchmarks;
