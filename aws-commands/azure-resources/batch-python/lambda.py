import sys, json
sys.path.append('/opt')
from typing import *

def handler(event: Dict[str, any], context: Dict[str, any] = None):
    return {'status': 200}

if __name__ == '__main__':
    indexEvent = sys.argv.index('--event')
    event = sys.argv[indexEvent + 1]
    handler(json.loads(event))
