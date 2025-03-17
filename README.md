# gpfsrest
JSON/Rest based health sensor for GPFS (IBM Storage Scale)

# Prerequisites
Linux. Make sure gcc, make and git are installed.
Build on a GPFS node or on a host with the same Linux distribution and release level as the GPFS cluster.

# Build the installer package
<pre>git clone --recursive https://github.com/oli4vr/gpfsrest.git
cd gpfsrest
bash build_installer.sh</pre>
Before building the package you could edit the main.csv file to remove features you don't want. For instance you could remove fileset monitoring.
Just remove the lines you don't need. The available features in main.csv :
<pre>gpfs:health -> mmhealth monitoring
gpfs:filesets -> monitor fileset inodes used and autoextend (if activated)
gpfs:chfileset -> monitor recent filesets changed (24h) by autoextend
</pre>
Important : Only install the fileset monitoring on 1 GPFS node in the cluster. On remote mount clusters there is no purpose to monitor the inode usage.
If you only need the mmhealth monitoring, remove the last 2 lines from the main.csv file.

# Build on host without direct internet access
Download the zip files and upload them to the linux host you want to build it on :<br />
https://github.com/oli4vr/gpfsrest/archive/refs/heads/main.zip<br />
https://github.com/oli4vr/restit/archive/refs/heads/main.zip<br />
<p>Unpack the gpfsrest zip file. Rename the subdir to gpfsrest. Then go into this subdir (cd gpfsrest). In gpfsrest unpack the restit zip file and rename the subdir to restit.
Then run the build script :</p>
<pre>unzip gpfsrest-main.zip
mv gpfsrest-main gpfsrest
cd gpfsrest
unzip ../restit-main.zip
mv restit-main restit
bash build_installer.sh</pre>

# Install/Uninstall on gpfs nodes
Copy the installer package/script to the hosts you want to install it on. Follow the instructions provided by the scripts output to install/uninstall.

# RPM build
When /usr/bin/rpmbuild exists an rpm package will be generated. You can then use the rpm package to install the sensor instead of the install script.

# Configure fileset autoextending
There is a script that monitors the inode used percentage per fileset and has the ability to autoextend filesets when above a critical level.
This can be configured in the config file /root/.restit/fsetret.cfg
<pre>## Self healing
## If set to Y it will automatically increase the max inodes of a fileset above the THR value to lower the usage to TGT pct
## This can only be executed MAXN nr of times in 24 hours (per fileset)
AUTOEXTEND=Y
THR=95
TGT=93
MAXN=3</pre>
You can also exclude individual filesets from the autoextend cycle by adding the fileset names to the list file /root/.restit/autoextendexcl<br />

# REST API listener
By default the rest api will be listening on port 40480, but this can be adapted in the config file.
You can connect to it using the http protocol.
<br />curl http://127.0.0.1:40480

# JSON formats
The following formats are available :
- Restit JSON format : http://127.0.0.1:40480/json    -> Default format
- Native PRTG format : http://127.0.0.1:40480/prtg    -> PRTG "HTTP Data Advanced"

# Filter/request specific sensors
You can filter a specific category, type or sensor by using it's name in the URL path. Searches work for all formats.
<br />Example : http://127.0.0.1:40480/prtg/NODE_FAILED

# Add (prtg compatible) thresholds to the reply
4 Variables are available :
- crithigh : Critical high threshold
- warnhigh : Warning high threshold
- critlow : Critical low threshold
- warnlow : Warning low threshold
<br />Example : http://127.0.0.1:40480/prtg/filesets?crithigh=90&warnhigh=80

# Check_mk support
Check_mk local scripts are installed in /usr/lib/check_mk_agent/local/ <br/>
They depend on the local http service and require curl to be installed
<pre>sudo yum install curl</pre>
Just install & activate the check_mk agent.