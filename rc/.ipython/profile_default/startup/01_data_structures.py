import datetime
import re
import itertools

print('''  Imported common imports:
import datetime
import re
import itertools
''')

di = {'a': 1, 'b': 2, 'c': 3}
da = datetime.datetime.now()
st = 'This is a str string!'
se = set((1, 2, 3))
u = u'This is a unicode string!'
g = (x for x in range(10))
l = [0, 1, 2, 3, 4, 5]
t = (1, 2, 3)

print('''  Imported basic data structures:
di = {'a': 1, 'b': 2, 'c': 3}
da = datetime.datetime.now()
st = 'This is a str string!'
se = set((1, 2, 3))
u = u'This is a unicode string!'
g = (x for x in range(10))
l = [0, 1, 2, 3, 4, 5]
t = (1, 2, 3)
''')
