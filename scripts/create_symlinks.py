#!/usr/bin/env python

import fnmatch
import os
import shutil
import errno
import argparse


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--no-vim-plugins-please',
                        dest='skip_plugins',
                        action='store_true',
                        help='Skip linking Vim plugins.')
    return parser.parse_args()


def __symlink(source, destination):
        os.symlink(source, destination)
        print('INFO: Linked %s to %s' % (source, destination))


def __backup(destination):
        shutil.move(destination, '%s.orig' % destination)
        print('INFO: Created backup %s.orig' % (destination))


def __create_links(source, destination):
        try:
            __symlink(source, destination)
        except OSError as e:
            if e.errno == errno.EEXIST:
                if os.path.islink(destination) and \
                        os.path.realpath(source) == os.path.realpath(destination):
                    print('INFO: Nothing to do here: %s LGTM.' % destination)
                    return
                __backup(destination)
                __symlink(source, destination)
            else:
                print('ERROR: failed symlinking: %s' % e)


def proccess_dotfiles(dir):
    for file in os.listdir(dir):
        if fnmatch.fnmatch(file, '.*') and not fnmatch.fnmatch(file, '.*.swp'):
            __create_links(os.path.realpath(os.path.join(dir, file)), os.path.expanduser('~/%s' % file))


def proccess_vim_plugins(dir):
    __create_links(os.path.realpath('vim/bundle/%s' % dir), os.path.expanduser('~/.vim/bundle/%s' % dir))


def main():
    options = parse_args()

    repository_root = os.path.dirname(os.path.realpath(os.path.join(__file__, '../')))

    print('Working on dotfiles..')
    [proccess_dotfiles(dir) for dir in os.listdir(repository_root) if os.path.isdir(os.path.join(repository_root, dir))]

    if not options.skip_plugins:
        print('Working on Vim plugins..')
        [proccess_vim_plugins(dir) for dir in os.listdir('vim/bundle') if os.path.isdir(os.path.join('vim/bundle', dir))]


if __name__ == '__main__':
    main()
