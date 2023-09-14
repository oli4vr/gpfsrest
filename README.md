# gpfsrest
JSON/Rest based health sensor for GPFS (IBM Storage Scale)

# Prerequisites
Linux. Make sure gcc, make and git are installed.
Build on a GPFS node or on a host with the same Linux distribution and release level as the GPFS cluster.

# Build the installer package
<pre>git clone https://github.com/oli4vr/gpfsrest.git
cd gpfsrest
bash build_installer.sh</pre>

# Install/Uninstall on gpfs nodes
Follow the instructions provided by the scripts output.