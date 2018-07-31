import datetime
import re
import itertools

print('''  Imported common imports:
import datetime
import itertools
import six
import re
''')

di = {'a': 1, 'b': 2, 'c': 3}
da = datetime.datetime.now()
st = 'This is a str string!'
se = set((1, 2, 3))
un = u'This is a unicode string!'
ge = (x for x in range(10))
li = [0, 1, 2, 3, 4, 5]
tu = (1, 2, 3)

print('''  Imported basic data structures:
di = {'a': 1, 'b': 2, 'c': 3}
da = datetime.datetime.now()
st = 'This is a str string!'
se = set((1, 2, 3))
un = u'This is a unicode string!'
ge = (x for x in range(10))
li = [0, 1, 2, 3, 4, 5]
tu = (1, 2, 3)
''')
