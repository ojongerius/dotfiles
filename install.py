#!/usr/bin/env python

import fnmatch
import os
import shutil
import errno
import argparse
import sys


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--dotfiles',
                        dest='dotfiles',
                        action='store_true',
                        help='Install dotfiles')

    parser.add_argument('--vim-plugins',
                        dest='plugins',
                        action='store_true',
                        help='Linking Vim plugins')

    parser.add_argument('--spectacle',
                        dest='spectacle',
                        action='store_true',
                        help='Link Spectacle preferences')

    parser.add_argument('--brew',
                        dest='brew',
                        action='store_true',
                        help='Install Brew, Brewdle and packages')

    parser.add_argument('--osx',
                        dest='osx',
                        action='store_true',
                        help='Tweak osx')

    if len(sys.argv) == 1:
        parser.print_help()

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
                    return False
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


def install_brew():
    # Install xcode if not there
    if os.system('xcode select -p') is not 0:
        os.system('xcode-select --install')

    # Install Homebrew
    os.system('ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"')

    # Install Brewdle
    os.system('brew tap Homebrew/brewdler')

    # All the apps
    os.system('cd brew && brew bundle')


def main():
    options = parse_args()

    repository_root = os.path.dirname(os.path.realpath(os.path.join(__file__, '.')))

    if options.brew:
        print('Working on Brew and programs..')
        install_brew()

    if options.dotfiles:
        print('Working on dotfiles..')
        [proccess_dotfiles(dir) for dir in os.listdir(repository_root) if os.path.isdir(os.path.join(repository_root, dir))]
        os.system('touch ~/.extra')

    if options.plugins:
        print('Working on Vim plugins..')
        [proccess_vim_plugins(dir) for dir in os.listdir('vim/bundle') if os.path.isdir(os.path.join('vim/bundle', dir))]

    if options.spectacle:
        print('Working on Spectacle..')
        file = 'com.divisiblebyzero.Spectacle.plist'
        if __create_links(os.path.realpath('spectacle/%s' % file), os.path.expanduser('~/Library/Preferences/%s' % file)):
            print("INFO: You'll have to (re)start Spectacle to pick up any changes.")

    if options.osx:
        print('Working on osx customisations..')
        os.system('sh osx/osx.sh')


if __name__ == '__main__':
    main()
