import os
import os.path
import sys

from pykd import loadDump
from pykd import loadExt
from pykd import setSymbolPath

import context
import callstack


def main():
    init_debugging()
    print("------------> Context <------------")
    show_context()
    print("")
    print("-----------> Call Stack <----------")
    show_call_stack()


def init_debugging():
    loadDump(sys.argv[1])
    load_extensions()
    init_symbols()


def load_extensions():
    windbg_path = os.environ['WIN_DEBUGGING_TOOLS_PATH']
    exts_dll_path = os.path.normpath(os.path.join(windbg_path,
                                                  'winxp/exts.dll'))
    loadExt(exts_dll_path)


def init_symbols():
    cache_path = r'C:\DebugSymbolCache' 
    symbol_server = 'http://msdl.microsoft.com/download/symbols'
    setSymbolPath('srv*{}*{}'.format(cache_path, symbol_server))


def show_context():
    context.gather_data()
    print("User ID:      {}".format(context.user))
    print("Data Area ID: {}".format(context.dataarea))
    print("Client:       {}".format(context.client))


def show_call_stack():
    callstack.gather_data()
    for frame in callstack.xpp_frames:
        print("{}::{}".format(frame.element_name, frame.method_name))


if __name__ == '__main__':
    main()
