#!/bin/bash -       
#title           :Inspired from "Linux Performance Analysis in 60,000 Milliseconds" http://techblog.netflix.com/2015/11/linux-performance-analysis-in-60s.html
#description     :This script will run a serie of tests
#author          :Aymen El Amri
#github          :
#date            :2015-12-21
#version         :0.1
#usage           :bash ${SCRIPT_NAME} [-b]
#notes           :
#bash_version    :4.3.11(1)-release
#===============================================================================
for i in "$@"
do
case $i in
    -b|--batch)
    BATCH=1
    shift # past argument=value
    ;;

    -e|--explain)
    EXPLAIN=1
    shift # past argument=value
    ;;
    
    *)
    ;;
esac
done

seq(){
    if [ -z "$BATCH" ]; then echo -e "\e[31m type [enter] \e[0m"; read -p ""; fi
}

explain(){
    if [ -z "$EXPLAIN" ]; then echo -e "\e[36m $1 \e[0m"; fi
}

echo -e "\e[31m =============================================\e[0m"
echo -e "\e[31m CPU load/how long the system has been running \e[0m"
echo -e "\e[31m =============================================\e[0m"
uptime

e="THE TRAFFIC ANALOGY: http://blog.scoutapp.com/articles/2009/07/31/understanding-load-averages
0.00 means there's no traffic on the bridge at all\n1.00 means the bridge is exactly at capacity
over 1.00 means there's backup"
explain "$e"
seq
#
echo -e "\e[31m ======================\e[0m"
echo -e "\e[31m the kernel ring buffer  \e[0m"
echo -e "\e[31m ======================\e[0m"
dmesg -T | tail
seq
#
echo -e "\e[31m =============================== \e[0m"
echo -e "\e[31m virtual memory statistics in MB \e[0m"
echo -e "\e[31m =============================== \e[0m"
vmstat -S m 1 4


e="
Procs
    r: The number of processes waiting for run time.
    b: The number of processes in uninterruptible sleep.
Memory
    swpd: the amount of virtual memory used.
    free: the amount of idle memory.
    buff: the amount of memory used as buffers.
    cache: the amount of memory used as cache.
    inact: the amount of inactive memory. (-a option)
    active: the amount of active memory. (-a option)
Swap
    si: Amount of memory swapped in from disk (/s).
    so: Amount of memory swapped to disk (/s).
IO
    bi: Blocks received from a block device (blocks/s).
    bo: Blocks sent to a block device (blocks/s).
System
    in: The number of interrupts per second, including the clock.
    cs: The number of context switches per second.
CPU
    These are percentages of total CPU time.
    us: Time spent running non-kernel code. (user time, including nice time)
    sy: Time spent running kernel code. (system time)
    id: Time spent idle. Prior to Linux 2.5.41, this includes IO-wait time.
    wa: Time spent waiting for IO. Prior to Linux 2.5.41, included in idle.
    st: Time stolen from a virtual machine. Prior to Linux 2.6.11, unknown."
explain "$e"
seq
#
echo -e "\e[31m ============================= \e[0m"
echo -e "\e[31m processors related statistics \e[0m"
echo -e "\e[31m ============================= \e[0m"
mpstat -P ALL 1 1
e="

all: means All CPUs
%usr: show the percentage of CPU utilization that occurred while executing at the user level (application)
%nice: show the percentage of CPU utilization that occurred while executing at the user level with nice priority
%sys: show the percentage of CPU utilization that occurred while executing at the system level (kernel)
%iowait: show the percentage of time that the CPU or CPUs were idle during which the system had an outstanding disk I/O request
%irq: show the percentage of time spent by the CPU or CPUs to service hardware interrupts
%soft: show the percentage of time spent by the CPU or CPUs to service software interrupts
%steal: show the percentage of time spent in involuntary wait by the virtual CPU or CPUs while the hypervisor was servicing another virtual processor
%guest: show the percentage of time spent by the CPU or CPUs to run a virtual processor
%idle: show the percentage of time that the CPU or CPUs were idle and the system did not have an outstanding disk I/O request
"
explain "$e"
seq
#
echo -e "\e[31m ========================== \e[0m"
echo -e "\e[31m statistics for Linux tasks \e[0m"
echo -e "\e[31m ========================== \e[0m"
pidstat 1 1

e="
UID: The real user identification number of the task being monitored.
USER: The real user name of the task being monitored.
PID: The identification number of the task being monitored.

%usr: Percentage of CPU used by the task while executing at the user level (application), with or without nice priority. Note that this field does NOT include time spent running a virtual processor.
%system: Percentage of CPU used by the task while executing at the system level (kernel).
%guest: Percentage of CPU spent by the task in virtual machine (running a virtual processor).
%CPU: Total percentage of CPU time used by the task. In an SMP environment, the task's CPU usage will be divided by the total number of CPU's if option -I has been entered on the command line.

CPU: Processor number to which the task is attached.
Command: The command name of the task."
explain "$e"
seq
#
echo -e "\e[31m ===================================================================== \e[0m"
echo -e "\e[31m CPU statistics and input/output statistics for devices and partitions \e[0m"
echo -e "\e[31m ===================================================================== \e[0m"
iostat -xz 1 1

e="
%user: The percentage of CPU utilization that occurred while executing at the user level (this is the application usage).
%nice: The percentage of CPU utilization that occurred while executing at the user level with nice priority.
%system: The percentage of CPU utilization that occurred while executing at the system level (kernel).
%iowait: The percentage of time that the CPU or CPUs were idle during which the system had an outstanding disk I/O request.
%steal: The percentage of time spent in involuntary wait by the virtual CPU or CPUs while the hypervisor was servicing another virtual processor.
%idle: The percentage of time that the CPU or CPUs were idle and the systems did not have an outstanding disk I/O request.

rrqm/s   The number of read requests merged per second queued to the device.
wrqm/s   The number of write requests merged per second queued to the device.
r/s  The number of read requests issued to the device per second.
w/s  The number of write requests issued to the device per second.
rMB/s    The number of megabytes read from the device per second. (I chose to used MB/s for the output.)
wMB/s    The number of megabytes written to the device per second. (I chose to use MB/s for the output.)
avgrq-sz The average size (in sectors) of the requests issued to the device.
avgqu-sz The average queue length of the requests issued to the device.
await   The average time (milliseconds) for I/O requests issued to the device to be served. This includes the time spent by the requests in queue and the time spent servicing them.
r_await The average time (in milliseconds) for read requests issued to the device to be served. This includes the time spent by the requests in queue and the time spent servicing them.
w_await The average time (in milliseconds) for write requests issued to the device to be served. This includes the time spent by the requests in queue and the time spent servicing them.
svctm   The average service time (in milliseconds) for I/O requests issued to the device. Warning! Do not trust this field; it will be removed in a future version of sysstat.
%util   Percentage of CPU time during which I/O requests were issued to the device (bandwidth utilization for the device). Device saturation occurs when this values is close to 100%."
explain "$e"
seq
#
echo -e "\e[31m ================================== \e[0m"
echo -e "\e[31m free and used memory in the system \e[0m"
echo -e "\e[31m ================================== \e[0m"
free -m

e="
total: Your total (physical) RAM (excluding a small bit that the kernel permanently reserves for itself at startup); that's why it shows ca. 11.7 GiB , and not 12 GiB, which you probably have.
used: memory in use by the OS.
free: memory not in use.
total: used + free
shared / buffers / cached: This shows memory usage for specific purposes, these values are included in the value for used."
explain "$e"
seq
#
echo -e "\e[31m ==================================== \e[0m"
echo -e "\e[31m network devices activity information \e[0m"
echo -e "\e[31m ==================================== \e[0m"
sar -n DEV 1 1
e="
IFACE
       Name of the network interface for which statistics are reported.
rxpck/s
       Total number of packets received per second.
txpck/s
       Total number of packets transmitted per second.
rxkB/s
       Total number of kilobytes received per second.
txkB/s
       Total number of kilobytes transmitted per second.
rxcmp/s
       Number of compressed packets received per second (for cslip etc.).
txcmp/s
       Number of compressed packets transmitted per second.
rxmcst/s
       Number of multicast packets received per second.
%ifutil
       Utilization  percentage  of the network interface. For half-duplex interfaces, utilization is calculated using the sum of rxkB/s
       and txkB/s as a percentage of the interface speed. For full-duplex, this is the greater of rxkB/S or txkB/s."
explain "$e"
seq
#
echo -e "\e[31m ========================== \e[0m"
echo -e "\e[31m TCPv4 activity information \e[0m"
echo -e "\e[31m ========================== \e[0m"
sar -n TCP 1 1

e="
active/s
       The number of times TCP connections have made a direct transition to the  SYN-SENT  state  from  the  CLOSED  state  per  second
       [tcpActiveOpens].
passive/s
       The  number  of times TCP connections have made a direct transition to the SYN-RCVD state from the LISTEN state per second [tcp‐
       PassiveOpens].
iseg/s
       The total number of segments received per second, including those received in error [tcpInSegs].  This count  includes  segments
       received on currently established connections.
oseg/s
       The  total  number  of  segments  sent  per  second,  including those on current connections but excluding those containing only
       retransmitted octets [tcpOutSegs]."
explain "$e"
seq
#
echo -e "\e[31m ========================== \e[0m"
echo -e "\e[31m TCPv4 activity information \e[0m"
echo -e "\e[31m ========================== \e[0m"
sar -n ETCP 1 1

e="
atmptf/s
       The  number of times per second TCP connections have made a direct transition to the CLOSED state from either the SYN-SENT state
       or the SYN-RCVD state, plus the number of times per second TCP connections have made a direct transition  to  the  LISTEN  state
       from the SYN-RCVD state [tcpAttemptFails].
estres/s
       The  number  of  times  per second TCP connections have made a direct transition to the CLOSED state from either the ESTABLISHED
       state or the CLOSE-WAIT state [tcpEstabResets].
retrans/s
       The total number of segments retransmitted per second - that is, the number of TCP segments transmitted containing one  or  more
       previously transmitted octets [tcpRetransSegs].
isegerr/s
       The total number of segments received in error (e.g., bad TCP checksums) per second [tcpInErrs].
orsts/s
       The number of TCP segments sent per second containing the RST flag [tcpOutRsts]."
explain "$e"
seq
#
echo -e "\e[31m ====================== \e[0m"
echo -e "\e[31m Top 20 Linux processes \e[0m"
echo -e "\e[31m ====================== \e[0m"
top -b -n 1|head -n 20
e="
PID    - Process ID - The unique ID of the process (commonly used with the kill command)
USER   - Username which the process is running under
PR     - Priority for the process (ranges from -20 for very important processes to 19 for unimportant processes)
NI     - Nice value modifies the priority of the process (a negative value will increase the priority of the process and a positive value will decrease the priority of the process)
VIRT   - Total amount of virtual memory used by the process
RES    - Resident size (kb) - Non-swapped physical memory which the process has used
SHR    - Shared memory size (kb) - Amount of shared memory which the process has used (shared memory is memory which could be allocated to other processes)
S      - Process status - Possible values:
        R - Running
        D - Sleeping (may not be interrupted)
        S - Sleeping (may be interrupted)
        T - Traced or stopped
        Z - Zombie or \"hung\" process
%CPU    - Percentage of CPU time the process was using at the time top last updated
%MEM    - Percentage of memory (RAM) the process was using at the time top last updated
TIME+   - Cumulative CPU time which the process and children of the process have used
COMMAND - Name of the process or the path to the command used to start the process (press c to toggle between the name of the process and the path to the command used to start the process)"
explain "$e"
