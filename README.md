# submit-jobs usage
Periodically check queueing system and submit jobs so that N jobs always in your queue

## In user defined commands the following variables need to be defined:

#### 1. check_queue & search_queue

"$check_queue | grep $search_queue" must return the subset of the
queue that you want want to count and only that. Please check on
the command on your terminal before running.
E.g.

  check_queue=qstat -u zls565
  check_queue=squeue
  search_queue=zls565
  search_queue=express

#### 2. sub_command

E.g.

  sub_command=qsub
  sub_command=sbatch

#### 3. filname

Additionally, $filename must contain a list of path-to-jobs/job
to be submitted, one job per line, with either an absolute path
to file or a relative path starting from the directory this
script is run from. This can be created by:

  find . -name "*job" >> <filename>

#### 4. num_jobs

The number of jobs to have in a queue at a time; an integer.
E.g.

  num_jobs=21

#### 5. every

How often to check the queue.
E.g.

  every=12d
  every=12h
  every=12m
  every=12s


## To run this script in the background


There are other ways to detach a process from your current session
which allow you to reattach the process such as:

  >nohup
  >screen
  >tmux

The reason I chose "disown" is two-fold. 1) Disown is a built-in
function and does not rely on additional programmes being
installed and 2) it is relatively simple to understand and does
not take the user to a different environment during the
execution.

  ./subjobs.sh        # Run script
  [Ctrl+Z]            # Pauses process to give access to command lind
  bg                  # Resumes process in the background (bg)
  jobs                # Lists bg processes and their id
  disown %<id>        # Disowns process <id> from the current shell
                      # Put in the <id> value from jobs command
