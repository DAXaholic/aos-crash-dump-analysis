from pykd import findSymbol
from pykd import getStack
from pykd import isValid
from pykd import loadWStr
from pykd import module
from pykd import ptrByte
from pykd import ptrPtr
from pykd import ptrWord


class NativeFrame:
    def __init__(self, ip):
        self.ip = ip
        self.symbol = findSymbol(ip)


class XppFrame:
    def __init__(self, element_type, element_name, method_name):
        self.element_type = element_type
        self.element_name = element_name
        self.method_name = method_name


class ElementType:
    xpp_table = 'Table'
    xpp_class = 'Class'
    xpp_unknown = 'Unknown'


_code_to_element_type = {
    2: ElementType.xpp_table,
    4: ElementType.xpp_class,
    5: ElementType.xpp_class
}


def get_native_frames_until_first_xpp_frame():
    frames = _get_stack_with_frame_numbers()
    if _xpp_raw_frames():
        first_xpp_frame_number = _xpp_raw_frames()[0].frameNumber
        frames = [f for f in frames if f.frameNumber < first_xpp_frame_number]
    return [NativeFrame(f.instructionOffset) for f in frames]


def get_xpp_frames():
    xpp_frames = []
    for raw_frame in _xpp_raw_frames():
        element_name = _element_name_of_raw_frame(raw_frame)
        element_type = _element_type_of_raw_frame(raw_frame)
        method_name = _method_name_of_raw_frame(raw_frame)
        xpp_frames.append(XppFrame(element_type, element_name, method_name))
    return xpp_frames


def _xpp_raw_frames():
    stack = _get_stack_with_frame_numbers()
    eval_func_caller_frames = []
    for idx, frame in enumerate(stack):
        if 'evalFunc' in findSymbol(frame.instructionOffset):
            eval_func_caller_frames.append(stack[idx+1])
    return eval_func_caller_frames


def _get_stack_with_frame_numbers():
    ret = []
    for idx, frame in enumerate(getStack()):
        frame.frameNumber = idx
        ret.append(frame)
    return ret


def _element_name_of_raw_frame(frame):
    element_id = _element_id_of_raw_frame(frame)
    meta_object_id = _meta_object_id_of_frame(frame)
    if element_id == meta_object_id:
        return _meta_object_name_of_frame(frame)
    else:
        element_type = _element_type_of_raw_frame(frame)
        return "{}[{}]".format(element_type, element_id)


def _element_id_of_raw_frame(frame):
    return ptrWord(frame.stackOffset + 32)


def _element_type_of_raw_frame(frame):
    code = ptrByte(frame.stackOffset + 40)
    if code in _code_to_element_type:
        return _code_to_element_type[code]
    else:
        return ElementType.xpp_unknown


def _meta_object_id_of_frame(frame):
    id_addr = _meta_object_addr_of_frame(frame) + 24
    if isValid(id_addr):
        return ptrWord(id_addr)
    else:
        return 0


def _meta_object_name_of_frame(frame):
    name_addr = ptrPtr(_meta_object_addr_of_frame(frame) + 16)
    if isValid(name_addr):
        return loadWStr(name_addr)
    else:
        return ''


def _meta_object_addr_of_frame(frame):
    ax32serv = module('Ax32Serv')
    element_type = _element_type_of_raw_frame(frame)
    element_id = _element_id_of_raw_frame(frame)
    base_offset = 0
    first_lvl_offset = 72
    second_lvl_offset = 0
    if element_type == ElementType.xpp_table:
        base_offset = ax32serv.offset('tableObj')
        second_lvl_offset = (element_id % 2500) * 8
    elif element_type == ElementType.xpp_class:
        base_offset = ax32serv.offset('classObj')
        second_lvl_offset = (element_id % 2500) * 8
    else:
        return 0
    return ptrPtr(ptrPtr(base_offset + first_lvl_offset) + second_lvl_offset)


def _method_name_of_raw_frame(frame):
    name_addr = ptrPtr(frame.stackOffset + 8)
    return loadWStr(name_addr)
