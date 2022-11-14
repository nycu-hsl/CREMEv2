#!/bin/bash
if [ $# != 3 ]; then
    echo "Usage: ./auto_accounting_process.sh atop_path atop.raw code_path"
    exit 1
fi

# location = Logs/Mirai/Original/Accounting_1/
location=$1

code_path=$3

filename=$(basename $2 .raw)
raw_disk_file="${filename}_disk.txt"
raw_memory_file="${filename}_memory.txt"
raw_process_file="${filename}_process.txt"
csv_disk_file="${location}/${filename}_disk.csv"
csv_memory_file="${location}/${filename}_memory.csv"
csv_process_file="${location}/${filename}_process.csv"
csv_merge="${location}/${filename}_merge.csv"

# atop.raw -> .txt
atop -d -r "${location}/${2}" > "${location}/${raw_disk_file}"
atop -m -r "${location}/${2}" > "${location}/${raw_memory_file}"
atop -s -r "${location}/${2}" > "${location}/${raw_process_file}"

# .txt -> .csv
python3 ${code_path}/extract_atop.py "${location}/${raw_disk_file}" $csv_disk_file 1
python3 ${code_path}/extract_atop.py "${location}/${raw_memory_file}" $csv_memory_file 1
python3 ${code_path}/extract_atop.py "${location}/${raw_process_file}" $csv_process_file 1

# merge .csv
python3 ${code_path}/merge_atop.py $csv_disk_file $csv_memory_file $csv_process_file $csv_merge

# remove intermediate result
rm "${location}/${raw_disk_file}" "${location}/${raw_memory_file}" "${location}/${raw_process_file}" $csv_disk_file $csv_memory_file $csv_process_file