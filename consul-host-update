#!/usr/bin/env python3.4

import urllib.error
import urllib.request
import json
import socket
import base64
import subprocess

PREFIX = socket.gethostname() + '/'

def gethostcfg():
    """
    Get the configuration for this host from consul
    """
    url = 'http://localhost:8500/v1/kv/' + PREFIX + '?recurse'
    try:
        hostjson = urllib.request.urlopen(url).read().decode('utf-8')
    except urllib.error.HTTPError as exc:
        if exc.code == 404:
            print('Cluster not started')
            return {}
        else:
            raise
    hostkvs = json.loads(hostjson)

    hostcfg = {}
    for kv_detail in hostkvs:
        key = kv_detail['Key']
        val = base64.b64decode(kv_detail['Value']).decode('utf-8')
        assert key.startswith(PREFIX)
        key = key[len(PREFIX):]
        hostcfg[key] = val
    return hostcfg

def handlehostcfg(hostcfg):
    """
    Given host config, applies any necessary changes to the host
    """
    if hostcfg.get('shutdown') == 'true':
        subprocess.check_call(['consul', 'leave'])

handlehostcfg(gethostcfg())
