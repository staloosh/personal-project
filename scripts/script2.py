#!/usr/bin/python3
## Similar to the bash script, this python script is used to filter the k3s logs based on user's input

logFile= "journal.log"
delimiter = "msg"
output_file= "output_python.txt"

def parse():
  global delimiter, logFile, output_file
  with open(logFile, 'r') as log, open(output_file, 'w') as outfile:
    for line in log:
      if word in line:
        before_delimiter, delimiter, after_delimiter = line.partition(delimiter)
        outfile.write(after_delimiter)
  log.close()


word = str(input(
        'Choose log filter: (*) error | (*) failed  [error/failed]? '))
if word == "error":
    print('You want to search the logs for the following word ' + word)
    parse()
elif word == "failed":
    print('You want to search the logs for the following word ' + word)
    parse()
else:
    print('Please choose between error and failed')


