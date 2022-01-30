# DDNS update tool

## Installation

```sh
# clone the repository
sudo git clone https://github.com/varlogerr/toolbox.ddns.git /opt/varlog/toolbox.ddns
# check pathadd.append function is installed
type -t pathadd.append
# in case output is "function" you can make use
# of pathadd-based bash hook. Otherwise add
# '/opt/varlog/toolbox.ddns/bin' directory
# to the PATH manually
echo '. /opt/varlog/toolbox.ddns/hook-pathadd.bash' >> ~/.bashrc
# reload ~/.bashrc
. ~/.bashrc
# explore the tools
ddns.duck.sh -h
ddns.dynu.sh -h
ddns.ydns.sh -h
```

## References

* [`pathadd` tool](https://github.com/varlogerr/toolbox.pathadd)
