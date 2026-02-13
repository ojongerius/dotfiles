#!/usr/bin/env python3

import os
import tempfile
import unittest

from install import _backup, _create_links, proccess_dotfiles


class TestBackup(unittest.TestCase):
    def test_renames_file_with_orig_suffix(self):
        with tempfile.TemporaryDirectory() as tmp:
            path = os.path.join(tmp, 'myfile')
            with open(path, 'w') as f:
                f.write('content')

            _backup(path)

            self.assertFalse(os.path.exists(path))
            self.assertTrue(os.path.exists(f'{path}.orig'))
            with open(f'{path}.orig') as f:
                self.assertEqual(f.read(), 'content')


class TestCreateLinks(unittest.TestCase):
    def test_creates_symlink(self):
        with tempfile.TemporaryDirectory() as tmp:
            source = os.path.join(tmp, 'source')
            dest = os.path.join(tmp, 'dest')
            with open(source, 'w') as f:
                f.write('data')

            _create_links(source, dest)

            self.assertTrue(os.path.islink(dest))
            self.assertEqual(os.readlink(dest), source)

    def test_skips_when_symlink_already_correct(self):
        with tempfile.TemporaryDirectory() as tmp:
            source = os.path.join(tmp, 'source')
            dest = os.path.join(tmp, 'dest')
            with open(source, 'w') as f:
                f.write('data')
            os.symlink(source, dest)

            result = _create_links(source, dest)

            self.assertFalse(result)
            self.assertTrue(os.path.islink(dest))
            self.assertEqual(os.readlink(dest), source)

    def test_backs_up_existing_file_and_creates_symlink(self):
        with tempfile.TemporaryDirectory() as tmp:
            source = os.path.join(tmp, 'source')
            dest = os.path.join(tmp, 'dest')
            with open(source, 'w') as f:
                f.write('new')
            with open(dest, 'w') as f:
                f.write('old')

            _create_links(source, dest)

            self.assertTrue(os.path.islink(dest))
            self.assertEqual(os.readlink(dest), source)
            with open(f'{dest}.orig') as f:
                self.assertEqual(f.read(), 'old')

    def test_backs_up_existing_wrong_symlink_and_creates_correct(self):
        with tempfile.TemporaryDirectory() as tmp:
            source = os.path.join(tmp, 'source')
            wrong = os.path.join(tmp, 'wrong')
            dest = os.path.join(tmp, 'dest')
            with open(source, 'w') as f:
                f.write('right')
            with open(wrong, 'w') as f:
                f.write('wrong')
            os.symlink(wrong, dest)

            _create_links(source, dest)

            self.assertTrue(os.path.islink(dest))
            self.assertEqual(os.readlink(dest), source)
            self.assertTrue(os.path.islink(f'{dest}.orig'))
            self.assertEqual(os.readlink(f'{dest}.orig'), wrong)


class TestProccessDotfiles(unittest.TestCase):
    def test_only_links_dotfiles(self):
        with tempfile.TemporaryDirectory() as tmp:
            src_dir = os.path.join(tmp, 'mydir')
            home_dir = os.path.join(tmp, 'home')
            os.makedirs(src_dir)
            os.makedirs(home_dir)

            # Create a dotfile and a non-dotfile
            dotfile = os.path.join(src_dir, '.config')
            regular = os.path.join(src_dir, 'readme')
            with open(dotfile, 'w') as f:
                f.write('dotfile')
            with open(regular, 'w') as f:
                f.write('regular')

            # Patch expanduser so links go to our temp home
            original_expanduser = os.path.expanduser
            os.path.expanduser = lambda p: p.replace('~', home_dir)
            try:
                proccess_dotfiles(src_dir)
            finally:
                os.path.expanduser = original_expanduser

            self.assertTrue(os.path.islink(os.path.join(home_dir, '.config')))
            self.assertFalse(os.path.exists(os.path.join(home_dir, 'readme')))


if __name__ == '__main__':
    unittest.main()
