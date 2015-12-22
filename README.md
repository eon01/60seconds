# 60seconds
A simple bash script to analyze Linux performance inspired from [Netflix Linux Performance Analysis in 60,000 Milliseconds blog post](http://techblog.netflix.com/2015/11/linux-performance-analysis-in-60s.html)

# Dependencies
- systat

# Usage

Install dependencies, download the script and run it: 
``` bash
wget https://raw.githubusercontent.com/eon01/60seconds/master/60seconds.sh 

chmod +x 60seconds.sh

./60seconds.sh -b -e
```
Parameters:

	-b|--batch: Run the script in batch mode
	-e|--explain: Run the script without explanation

Run it in one command:
``` bash 

wget https://raw.githubusercontent.com/eon01/60seconds/master/60seconds.sh -v -O 60seconds.sh; chmod +x ./60seconds.sh; ./60seconds; rm -rf 60seconds.sh

```
