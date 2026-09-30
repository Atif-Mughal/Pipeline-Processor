make xlm_sim
cp trace_core_0* 
cd scripts

rm iss.csv
rm core.csv
rm regr.log

python3 spike_log_to_trace_csv.py --log *.0.log --csv iss.csv
python3 core_log_to_trace_csv.py --log ../trace_core_0* --csv core.csv 


#compare processor and spike trace
python3 instr_trace_compare.py --csv_file_1 iss.csv --csv_file_2 core.csv --csv_name_1 "iss" --csv_name_2 "core" --log regr.log 
cat regr.log

