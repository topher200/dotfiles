import json
import os
import pprint
import sys


if __name__ == '__main__':
    sys.path.append(os.path.join(os.getenv('WS_REPO'), 'python_shared/wsframework/src'))
    sys.path.append(os.path.join(os.getenv('WS_REPO'), 'server/wordstream/src'))

    import wordstream
    wordstream.bootstrap_new()

    from wsf1.io.serializers.PickleSerializer import PickleSerializer

    payload = json.loads(sys.stdin.read())

    content = payload['body']

    data = PickleSerializer().deserialize(str(content))

    pprint.pprint(data, indent=4)
