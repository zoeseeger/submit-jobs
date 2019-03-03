# USER DEFINED COMMANDS ----------------------

# COMMAND TO CHECK QUEUE
check_queue='qstat -u zls565'

# STRING TO LOOK FOR IN QUEUE TO COUNT JOBS BY
search_queue=hugemem

# COMMAND TO SUBMIT TO QUEUE
sub_command=qsub

# FILES WITH PATH TO JOB
filename=submit.txt

# NUMBER OF JOBS TO HAVE IN QUEUE
num_jobs=50

# CHECK QUEUE EVERY
every=15m

### -------------------------------------------

# SIZE OF filename
filesize=$( stat -c%s $filename )

# WHILE LINES STILL IN filename
while [[ $filesize -ne 0  ]]
do

    # COUNT NUMBER OF JOBS WITH STRING search_queue
    _jobs=$($check_queue | grep $search_queue | wc -l)

    # IF NUMBER OF JOBS LESS THAN num_jobs
    if [[ $_jobs < $num_jobs ]]
    then

        # NUMBER OF JOBS TO SUBMIT
    	nrjobtosub=$(($num_jobs-$_jobs))

        # CURRENT DIR
        whereweare=$(pwd)

        # FOR EACH JOB TO SUBMIT
        for ((i=1;i<=nrjobtosub;i++)); do

            # UPDATE FILESIZE
            filesize=$(stat -c%s $filename)

            # CHECK SIZE OF FILE AFTER EVERY SUBMISSION
            if [[ $filesize -ne 0 ]]
            then

                # GET JOB FROM FILE
                path_job=$(head -n 1 $filename)

                # SPLIT INTO PATH AND JOB NAME
                path=`dirname "$path_job"`
                jobf=`basename "$path_job"`

                # MOVE TO DIRECTORY
                cd $path

                # SUBMIT JOB
                $sub_command $jobf

                # MOVE TO ORIGINAL DIRECTORY
                cd $whereweare

                # SAVE JOBS SUBMITTED TO submitted.txt
                head -n 1 $filename >> submitted-to-queue.txt

                # REMOVE JOB FROM filename
    		    sed -i '1d' $filename

            # FINISH IF STATEMENT
            fi

        # END FOR LOOP
        done

    # FINISH IF STATEMENT
    fi

    # CHECK QUEUE AFTER BREAK
    sleep $every

done
