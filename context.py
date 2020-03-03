from pykd import dbgCommand
from pykd import loadWStr
from pykd import ptrQWord


def get_user():
    base_address = _find_context_base_address()
    return _user_id_from_context(base_address)


def get_data_area():
    base_address = _find_context_base_address()
    return _data_area_id_from_context(base_address)


def get_client():
    base_address = _find_context_base_address()
    return _client_name_from_context(base_address)


def _find_context_base_address():
    tls_slot_int = _get_tls_slot_int(0x1a) or _get_tls_slot_int(0x21)
    return ptrQWord(tls_slot_int + 96)

def _get_tls_slot_int(index):
    tls_command = '!tls {:x}'.format(index)
    hex_value = dbgCommand(tls_command).split()[-1]
    return int(hex_value, 16)

def _user_id_from_context(base_address):
    user_id_addr = base_address + 348
    return loadWStr(user_id_addr)


def _data_area_id_from_context(base_address):
    data_area_id_addr = base_address + 600
    return loadWStr(data_area_id_addr)


def _client_name_from_context(base_address):
    client_name_addr = base_address + 764
    return loadWStr(client_name_addr)
