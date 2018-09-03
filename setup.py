from setuptools import setup, find_packages
from fascolia.core.version import get_version

VERSION = get_version()

f = open('README.md', 'r')
LONG_DESCRIPTION = f.read()
f.close()

setup(
    name='fascolia',
    version=VERSION,
    description='Framework for Asynchronous Command Line Applications',
    long_description=LONG_DESCRIPTION,
    long_description_content_type='text/markdown',
    author='Jesco Freund',
    author_email='daemotron@github.com',
    url='https://github.com/fascolia/fascolia',
    license='MIT',
    packages=find_packages(exclude=['ez_setup', 'tests*']),
    package_data={'fascolia': ['templates/*']},
    include_package_data=True,
    entry_points="""
        [console_scripts]
        fascolia = fascolia:main
    """,
)
