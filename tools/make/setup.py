import os
import platform

import numpy
import pathlib
from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize
import glob
from shutil import copyfile
import Cython.Compiler.Options
import subprocess

Cython.Compiler.Options.annotate = True

root_path = pathlib.Path(__file__).parent.resolve().__str__() + '/'
print('root path', root_path)

extensions = []
extensions_folder_list = ['tools/py']


def make_extensions_in_folder(path: str):
    e_list = []
    file: str
    mac_extra_args = ['-Xpreprocessor', '-fopenmp', '-lomp']
    args = ['-fopenmp']
    library_dirs = []
    if platform.system() == 'Darwin':
        args = mac_extra_args
        BREW_LLVM_PATH = subprocess.check_output(["brew", "--prefix", "llvm"]).decode().strip()
        library_dirs = [f"{BREW_LLVM_PATH}/lib"]
    for file in glob.glob(path + '/*.pyx'):
        e_list.append(Extension(file.replace('/', '.').replace('.pyx', ''), [file],
                                extra_compile_args=args,
                                extra_link_args=args,
                                library_dirs=library_dirs))
    return e_list


for folder_name in extensions_folder_list:
    extensions.extend(make_extensions_in_folder(folder_name))


folder_name = []
file_name = []
e: Extension

for e in extensions:
    e.cython_directives = {'language_level': "3", "binding": True}
    e.define_macros = [('NPY_NO_DEPRECATED_API', 'NPY_1_7_API_VERSION')]
    folder_name.append('/'.join(e.sources[0].split('/')[0:-1]))
    file_name.append(e.sources[0].split('/')[1].split('.py')[0])
print(folder_name)

setup(
    ext_modules=cythonize(extensions,
                          compiler_directives={'language_level': "3", "binding": True},
                          force=True, annotate=True, build_dir="build/cython"),
    include_dirs=[numpy.get_include()])  # , root_path+'tools/c_algorithms/c-algorithms-1.2.0/'])

# print(folder_name)
# for i, e in enumerate(extensions):
#     print('E: ', e.sources[0])
#     fname = e.sources[0].split('/')[-1].split('.pyx')[0]

#     so = glob.glob('build/cython/lib*/{}/{}*.so'.format(folder_name[i], fname))[0]
#     print('so', so)
#     so_file = so.split('/', 10)[-1]

#     print('sofile', so_file)
#     print('copying', os.path.abspath(so), 'to ', folder_name[i] + '/' + so_file)
#     copyfile(src=os.path.abspath(so), dst=root_path + folder_name[i] + '/' + so_file)

# DELETE C PROJECT FILES
# from pathlib import Path

# c_files = Path(root_path).glob('[!venv!atsd]*/**/*.c')
# print('c files : ', c_files)
# for f in c_files:
#     print('removing ', f)
#     os.remove(f)
