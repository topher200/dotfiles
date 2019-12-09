import os
import sys

lookup_path = os.path.abspath('/Users/t.brown/dev/wordstream/python_shared/wsframework/src')
sys.path.insert(1, lookup_path)

lookup_path = os.path.abspath('/Users/t.brown/dev/wordstream/server/wordstream/src')
sys.path.insert(1, lookup_path)

try:
    import wordstream
    wordstream.bootstrap_new()
except ImportError:
    print('wordstream not found. not importing')
