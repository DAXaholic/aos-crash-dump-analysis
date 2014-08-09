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
    print("User ID:      {}".format(context.get_user()))
    print("Data Area ID: {}".format(context.get_data_area()))
    print("Client:       {}".format(context.get_client()))


def show_call_stack():
    for frame in callstack.get_xpp_frames():
        print("{}::{}".format(frame.element_name, frame.method_name))


if __name__ == '__main__':
    main()
