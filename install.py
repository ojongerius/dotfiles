#!/usr/bin/env python3

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
                        help='install dotfiles')

    parser.add_argument('--brew',
                        dest='brew',
                        action='store_true',
                        help='install Brew, Brewdle and packages')

    parser.add_argument('--osx',
                        dest='osx',
                        action='store_true',
                        help='tweak osx')

    parser.add_argument('--oh-my-zsh',
                        dest='zsh',
                        action='store_true',
                        help='install Oh-my-zsh')

    if len(sys.argv) == 1:
        parser.print_help()

    return parser.parse_args()


def __symlink(source, destination):
    os.symlink(source, destination)
    print(f'INFO: Linked {source} to {destination}')


def __backup(destination):
    shutil.move(destination, f'{destination}.orig')
    print(f'INFO: Created backup {destination}.orig')


def __create_links(source, destination):
    try:
        __symlink(source, destination)
    except OSError as e:
        if e.errno == errno.EEXIST:
            if os.path.islink(destination) and \
                    os.path.realpath(source) == os.path.realpath(destination):
                print(f'INFO: Nothing to do here: {destination} LGTM.')
                return False
            __backup(destination)
            __symlink(source, destination)
        else:
            print(f'ERROR: failed symlinking: {e}')


def proccess_dotfiles(dir):
    for file in os.listdir(dir):
        if fnmatch.fnmatch(file, '.*'):
            __create_links(os.path.realpath(os.path.join(dir, file)), os.path.expanduser(f'~/{file}'))


def install_brew():
    # Install xcode if not there
    if os.system('xcode-select -p') != 0:
        os.system('xcode-select --install')

    # Install Homebrew
    os.system('/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"')

    # Install packages from Brewfile
    os.system('cd brew && brew bundle')


def main():
    options = parse_args()

    repository_root = os.path.dirname(os.path.realpath(os.path.join(__file__, '.')))

    if options.zsh:
        print('Working on Oh-my-zsh..')
        os.system('curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh')

    if options.brew:
        print('Working on Brew and programs..')
        install_brew()

    if options.dotfiles:
        print('Working on dotfiles..')
        for dir in os.listdir(repository_root):
            if os.path.isdir(os.path.join(repository_root, dir)):
                proccess_dotfiles(dir)
        os.system('touch ~/.extra')

    if options.osx:
        print('Working on osx customisations..')
        os.system('sh osx/osx.sh')


if __name__ == '__main__':
    main()
