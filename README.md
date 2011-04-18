# g5k-graph
A tool to help generate graphs for your Grid'5000 metrics.

## Installation

    gem install g5k-graph

## Usage

    g5k-graph -h
    
    * Description
      g5k-graph - Graph your Grid'5000 metrics.
    * Usage
      g5k-graph [options] < list-of-nodes
    * Options
        -f, --from=                      The timeseries start time, in seconds since EPOCH [default=1303113485]
        -t, --to=                        The timeseries end time, in seconds since EPOCH [default=1303114080]
        -r, --resolution=                The timeseries resolution, in seconds [default=15]
        -m, --metrics=                   The comma-separated list of metrics to fetch [default=mem_free,cpu_idle,bytes_in,bytes_out]
        -o, --output=                    Where to write the timeseries data and graphs [default=/Volumes/backup/dev/g5k-graph/data]
        -h, --help                       Show this message

Example:

      g5k-graph --metrics mem_free,custom_metric -o /tmp -r 360 < $OAR_NODE_FILE

This tools takes a list of nodes on STDIN, and a set of options, and outputs a graph for each metric that you gave.
It fetches the timeseries from the [Grid'5000 API](https://api.grid5000.fr/) with the `cURL` tool, and as such you may need to have a proper `~/.netrc` setup for the authentication to work (see the curl-tutorial at  <http://grid5000.github.com/tutorials/>).

## Authors
* Cyril Rohr <cyril.rohr@inria.fr>
