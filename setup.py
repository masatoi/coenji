# -*- coding: utf-8 -*-
import sys
import os
from os import path
from setuptools import setup

if sys.version_info < (3, 4):
    sys.exit('coenji requires Python 3.4 or higher')

ROOT_DIR = path.abspath(path.dirname(__file__))
sys.path.insert(0, ROOT_DIR)

LONG_DESCRIPTION = open(path.join(ROOT_DIR, 'README.org')).read()
# version
here = os.path.dirname(os.path.abspath(__file__))
version = next((line.split('=')[1].strip().replace("'", '')
                for line in open(os.path.join(here, 'coenji', '__init__.py'))
                if line.startswith('__version__ = ')), '0.0.dev0')

HYSRC = ['**.hy']

setup(
    name='coenji',
    version=version,
    description='coenji : Utilities for my daily works',
    long_description=LONG_DESCRIPTION,
    url='https://github.com/masatoi/coenji/',
    author='Satoshi Imai',
    author_email='satoshi.imai@gmail.com',
    license='MIT License',
    classifiers=[
        'License :: OSI Approved :: MIT License',
        'Operating System :: OS Independent',
        'Programming Language :: Python :: 3.4',
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: 3.6',
    ],
    keywords='hy lisp common-lisp',
    install_requires=['hy==0.27.0'],
    packages=['coenji'],
    package_data={'coenji': HYSRC},
    platforms='any',
)
