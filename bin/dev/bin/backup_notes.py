import os
import shutil
import time


NOTES_FILENAME = '/Users/t.brown/notes.org'
DESTINATION_DIR = '/Users/t.brown/notes-backup'


def main():
    destination = os.path.join(DESTINATION_DIR, 'notes-%s.org' % time.strftime('%Y%m%d'))
    shutil.copyfile(NOTES_FILENAME, destination)


if __name__ == '__main__':
    main()