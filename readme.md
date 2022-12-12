# DDNS update tool

## Installation

```sh
# clone the repository
sudo git clone https://github.com/varlogerr/toolbox.ddns.git /opt/varlog/toolbox.ddns
# check pathadd.append function is installed
type -t pathadd.append
# to add bin directory to the PATH
echo '. /opt/varlog/toolbox.ddns/source.bash' >> ~/.bashrc
# reload ~/.bashrc
. ~/.bashrc
# explore the tools
ddns.duckdns.sh -h
ddns.dynu.sh -h
ddns.ydns.sh -h
```

## References

* [`pathadd` tool](https://github.com/varlogerr/toolbox.pathadd)
