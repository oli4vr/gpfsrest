# gpfsrest
JSON/Rest based health sensor for GPFS (IBM Storage Scale)

# Prerequisites
Linux. Make sure gcc, make and git are installed.
Build on a GPFS node or on a host with the same Linux distribution and release level as the GPFS cluster.

# Build the installer package
<pre>git clone https://github.com/oli4vr/gpfsrest.git
cd gpfsrest
bash build_installer.sh</pre>

# Build on host without direct internet access
Download the zip files and upload them to the linux host you want to build it on :<br />
https://github.com/oli4vr/gpfsrest/archive/refs/heads/main.zip<br />
https://github.com/oli4vr/restit/archive/refs/heads/main.zip<br />
<pre>Unpack the gpfsrest zip file. Rename the subdir to gpfsrest.
Then go into this subdir (cd gpfsrest). In gpfsrest unpack the restit zip file and rename the subdir to restit.
Then run the build script :
bash build_installer.sh</pre>

# Install/Uninstall on gpfs nodes
Follow the instructions provided by the scripts output.