#!/usr/bin/python3
## Similar to the bash script, this python script is used to filter the k3s logs based on user's input

## Variable definition
logFile= "journal.log"
delimiter = "msg"
output_file= "output_python.txt"

## Define function filter logs
def parse():
  """
  parse() function opens the log file, searches for a line that contains the word from
  the user input, searches in these lines for a delimiter and then outputs the resulting lines to an output file
  """
  global delimiter, logFile, output_file
  with open(logFile, 'r') as log, open(output_file, 'w') as outfile:
    for line in log:
      if word in line:
        before_delimiter, delimiter, after_delimiter = line.partition(delimiter)
        outfile.write(after_delimiter)
  log.close()

## Get word variable value based on user input
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


