from typing import *

def handler(event: Dict[str, any], context: Dict[str, any] = None):
    return {'status': 200}

if __name__ == '__main__':
    handler({})