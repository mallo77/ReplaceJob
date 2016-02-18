Manual
======
1. unzip jobs.zip into any directory
	$ unzip jobs.zip

2. ensure replaceTokens.sh under ./jobs/scripts directory is given proper permission
	$ cd jobs/scripts
	$ chmod 755 replaceTokens.sh

3. run the script with the below command under ./jobs/scripts directory
	$ ./replaceTokens.sh ../input/index.html ../conf/test.properties ../ouput/index.html

4. verify the out
	$ cat ../output/index.html	 	
